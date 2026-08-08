/**
 * @file
 * Implements BWMFI strategy based on the Market Facilitation Index indicator
 */

// User input params.
INPUT_GROUP("BWMFI strategy: strategy params");
INPUT float BWMFI_LotSize = 0;                // Lot size
INPUT int BWMFI_SignalOpenMethod = 0;         // Signal open method
INPUT float BWMFI_SignalOpenLevel = 1.0f;     // Signal open level
INPUT int BWMFI_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int BWMFI_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int BWMFI_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int BWMFI_SignalCloseMethod = 0;        // Signal close method
INPUT int BWMFI_SignalCloseFilter = 0;        // Signal close filter (-127-127)
INPUT float BWMFI_SignalCloseLevel = 1.0f;    // Signal close level
INPUT int BWMFI_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float BWMFI_PriceStopLevel = 2;         // Price stop level
INPUT int BWMFI_TickFilterMethod = 32;        // Tick filter method
INPUT float BWMFI_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short BWMFI_Shift = 0;                  // Shift (relative to the current bar, 0 - default)
INPUT float BWMFI_OrderCloseLoss = 80;        // Order close loss
INPUT float BWMFI_OrderCloseProfit = 80;      // Order close profit
INPUT int BWMFI_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("BWMFI strategy: BWMFI indicator params");
INPUT int BWMFI_Indi_BWMFI_Shift = 1;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE BWMFI_Indi_BWMFI_SourceType = IDATA_BUILTIN;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_BWMFI_Params_Defaults : StgParams {
  Stg_BWMFI_Params_Defaults()
      : StgParams(::BWMFI_SignalOpenMethod, ::BWMFI_SignalOpenFilterMethod, ::BWMFI_SignalOpenLevel,
                  ::BWMFI_SignalOpenBoostMethod, ::BWMFI_SignalCloseMethod, ::BWMFI_SignalCloseFilter,
                  ::BWMFI_SignalCloseLevel, ::BWMFI_PriceStopMethod, ::BWMFI_PriceStopLevel, ::BWMFI_TickFilterMethod,
                  ::BWMFI_MaxSpread, ::BWMFI_Shift) {
    Set(STRAT_PARAM_LS, BWMFI_LotSize);
    Set(STRAT_PARAM_OCL, BWMFI_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, BWMFI_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, BWMFI_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, BWMFI_SignalOpenFilterTime);
  }
};

#ifdef __config__
// Loads pair specific param values.
#include "config/H1.h"
#include "config/H4.h"
#include "config/H8.h"
#include "config/M1.h"
#include "config/M15.h"
#include "config/M30.h"
#include "config/M5.h"
#endif

class Stg_BWMFI : public Strategy {
 public:
  Stg_BWMFI(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_BWMFI *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_BWMFI_Params_Defaults stg_bwmfi_defaults;
    StgParams _stg_params(stg_bwmfi_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_bwmfi_m1, stg_bwmfi_m5, stg_bwmfi_m15, stg_bwmfi_m30, stg_bwmfi_h1,
                             stg_bwmfi_h4, stg_bwmfi_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_BWMFI(_stg_params, _tparams, _cparams, "BWMFI");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiBWIndiMFIParams _indi_params(::BWMFI_Indi_BWMFI_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_BWMFI(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_BWMFI *_indi = GetIndicator();
    int _ishift = ::BWMFI_Indi_BWMFI_Shift;
    bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _ishift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    // Green bar: MFI value and volume grow synchronously.
    // Brown bar: occurs when the volume and indicator values fall simultaneously.
    // Blue (false) bar: appears during the decrease in trading volume against the backdrop of the rising prices.
    // Pink (squatting) bar: It appears most often at the end of a protracted trend.
    IndicatorSignal _signals = _indi.GetSignals(4, _ishift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy: The appearance of three green bars in a row
        // means that the market is overbought or oversold.
        _result &= _indi.IsIncreasing(1, BWMFI_BUFFER, _ishift);
        _result &= int(_indi[_ishift][(int)BWMFI_HISTCOLOR]) == MFI_HISTCOLOR_GREEN;
        _result &= int(_indi[_ishift + 1][(int)BWMFI_HISTCOLOR]) == MFI_HISTCOLOR_GREEN;
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell: The appearance of three green bars in a row
        // means that the market is overbought or oversold.
        _result &= _indi.IsDecreasing(1, BWMFI_BUFFER, _ishift);
        _result &= int(_indi[_ishift][(int)BWMFI_HISTCOLOR]) == MFI_HISTCOLOR_GREEN;
        _result &= int(_indi[_ishift + 1][(int)BWMFI_HISTCOLOR]) == MFI_HISTCOLOR_GREEN;
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
