/**
 * @file
 * Implements DEMA strategy based the Double Exponential Moving Average indicator.
 */

// User params.
INPUT_GROUP("DEMA strategy: strategy params");
INPUT float DEMA_LotSize = 0;                // Lot size
INPUT int DEMA_SignalOpenMethod = 0;         // Signal open method (-127-127)
INPUT float DEMA_SignalOpenLevel = 0.07f;    // Signal open level
INPUT int DEMA_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int DEMA_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int DEMA_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int DEMA_SignalCloseMethod = 0;        // Signal close method (-127-127)
INPUT int DEMA_SignalCloseFilter = 0;        // Signal close filter (-127-127)
INPUT float DEMA_SignalCloseLevel = 0.07f;   // Signal close level
INPUT int DEMA_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float DEMA_PriceStopLevel = 2;         // Price stop level
INPUT int DEMA_TickFilterMethod = 32;        // Tick filter method
INPUT float DEMA_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short DEMA_Shift = 0;                  // Shift
INPUT float DEMA_OrderCloseLoss = 80;        // Order close loss
INPUT float DEMA_OrderCloseProfit = 80;      // Order close profit
INPUT int DEMA_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("DEMA strategy: DEMA indicator params");
INPUT int DEMA_Indi_DEMA_Period = 25;                                    // Period
INPUT int DEMA_Indi_DEMA_MA_Shift = 6;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE DEMA_Indi_DEMA_Applied_Price = PRICE_TYPICAL;   // Applied Price
INPUT int DEMA_Indi_DEMA_Shift = 0;                                      // DEMA Shift
INPUT ENUM_IDATA_SOURCE_TYPE DEMA_Indi_DEMA_SourceType = IDATA_BUILTIN;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_DEMA_Params_Defaults : StgParams {
  Stg_DEMA_Params_Defaults()
      : StgParams(::DEMA_SignalOpenMethod, ::DEMA_SignalOpenFilterMethod, ::DEMA_SignalOpenLevel,
                  ::DEMA_SignalOpenBoostMethod, ::DEMA_SignalCloseMethod, ::DEMA_SignalCloseFilter,
                  ::DEMA_SignalCloseLevel, ::DEMA_PriceStopMethod, ::DEMA_PriceStopLevel, ::DEMA_TickFilterMethod,
                  ::DEMA_MaxSpread, ::DEMA_Shift) {
    Set(STRAT_PARAM_LS, DEMA_LotSize);
    Set(STRAT_PARAM_OCL, DEMA_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, DEMA_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, DEMA_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, DEMA_SignalOpenFilterTime);
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

class Stg_DEMA : public Strategy {
 public:
  Stg_DEMA(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_DEMA *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_DEMA_Params_Defaults stg_dema_defaults;
    StgParams _stg_params(stg_dema_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_dema_m1, stg_dema_m5, stg_dema_m15, stg_dema_m30, stg_dema_h1,
                             stg_dema_h4, stg_dema_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_DEMA(_stg_params, _tparams, _cparams, "DEMA");
    _stg_params.SetStops(_strat, _strat);
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiDEIndiMAParams _indi_params(::DEMA_Indi_DEMA_Period, ::DEMA_Indi_DEMA_MA_Shift, ::DEMA_Indi_DEMA_Applied_Price,
                                    ::DEMA_Indi_DEMA_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_DEMA(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_DEMA *_indi = GetIndicator();
    bool _result =
        _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) && _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 3);
    double _level_pips = _level * Chart().GetPipSize();
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result &= _indi.IsIncreasing(1, 0, _shift);
        _result &= _indi.IsIncByPct(_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        _result &= _indi.IsDecreasing(1, 0, _shift);
        _result &= _indi.IsDecByPct(-_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
