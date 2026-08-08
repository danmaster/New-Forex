/**
 * @file
 * Implements Chaikin strategy based on the Chaikin indicator.
 */

// User input params.
INPUT_GROUP("Chaikin strategy: strategy params");
INPUT float Chaikin_LotSize = 0;                // Lot size
INPUT int Chaikin_SignalOpenMethod = 0;         // Signal open method
INPUT float Chaikin_SignalOpenLevel = 50.0f;    // Signal open level
INPUT int Chaikin_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int Chaikin_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT int Chaikin_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int Chaikin_SignalCloseMethod = 0;        // Signal close method
INPUT int Chaikin_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float Chaikin_SignalCloseLevel = 50.0f;   // Signal close level
INPUT int Chaikin_PriceStopMethod = 29;         // Price limit method
INPUT float Chaikin_PriceStopLevel = 2;         // Price limit level
INPUT int Chaikin_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT float Chaikin_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short Chaikin_Shift = 0;                  // Shift
INPUT float Chaikin_OrderCloseLoss = 80;        // Order close loss
INPUT float Chaikin_OrderCloseProfit = 80;      // Order close profit
INPUT int Chaikin_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Chaikin strategy: Chaikin indicator params");
INPUT int Chaikin_Indi_Chaikin_InpFastMA = 10;                                 // Fast EMA period
INPUT int Chaikin_Indi_Chaikin_InpSlowMA = 30;                                 // Slow MA period
INPUT ENUM_MA_METHOD Chaikin_Indi_Chaikin_InpSmoothMethod = MODE_SMMA;         // MA method
INPUT ENUM_APPLIED_VOLUME Chaikin_Indi_Chaikin_InpVolumeType = VOLUME_TICK;    // Volumes
INPUT int Chaikin_Indi_Chaikin_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Chaikin_Indi_Chaikin_SourceType = IDATA_BUILTIN;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_Chaikin_Params_Defaults : StgParams {
  Stg_Chaikin_Params_Defaults()
      : StgParams(::Chaikin_SignalOpenMethod, ::Chaikin_SignalOpenFilterMethod, ::Chaikin_SignalOpenLevel,
                  ::Chaikin_SignalOpenBoostMethod, ::Chaikin_SignalCloseMethod, ::Chaikin_SignalCloseFilter,
                  ::Chaikin_SignalCloseLevel, ::Chaikin_PriceStopMethod, ::Chaikin_PriceStopLevel,
                  ::Chaikin_TickFilterMethod, ::Chaikin_MaxSpread, ::Chaikin_Shift) {
    Set(STRAT_PARAM_LS, Chaikin_LotSize);
    Set(STRAT_PARAM_OCL, Chaikin_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Chaikin_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Chaikin_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Chaikin_SignalOpenFilterTime);
  }
} stg_chaikin_defaults;

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

class Stg_Chaikin : public Strategy {
 public:
  Stg_Chaikin(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Chaikin *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    StgParams _stg_params(stg_chaikin_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_chaikin_m1, stg_chaikin_m5, stg_chaikin_m15, stg_chaikin_m30,
                             stg_chaikin_h1, stg_chaikin_h4, stg_chaikin_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Chaikin(_stg_params, _tparams, _cparams, "Chaikin");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiCHOParams _indi_params(::Chaikin_Indi_Chaikin_InpFastMA, ::Chaikin_Indi_Chaikin_InpSlowMA,
                               ::Chaikin_Indi_Chaikin_InpSmoothMethod, ::Chaikin_Indi_Chaikin_InpVolumeType,
                               ::Chaikin_Indi_Chaikin_Shift);
    _indi_params.SetDataSourceType(::Chaikin_Indi_Chaikin_SourceType);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_CHO(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    Indi_CHO *_indi = GetIndicator();
    bool _result =
        _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) && _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 3);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _indi[_shift][0] < -(_level * _level);
        _result &= _indi.IsIncreasing(1, 0, _shift);
        _result &= _indi.IsIncByPct(_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _indi[_shift][0] > (_level * _level);
        _result &= _indi.IsDecreasing(1, 0, _shift);
        _result &= _indi.IsDecByPct(_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
