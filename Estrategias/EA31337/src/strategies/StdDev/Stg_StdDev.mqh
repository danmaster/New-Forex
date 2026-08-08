/**
 * @file
 * Implements StdDev strategy the Standard Deviation indicator.
 */

// User input params.
INPUT_GROUP("StdDev strategy: strategy params");
INPUT float StdDev_LotSize = 0;                // Lot size
INPUT int StdDev_SignalOpenMethod = 10;        // Signal open method (-127-127)
INPUT float StdDev_SignalOpenLevel = 28.0f;    // Signal open level
INPUT int StdDev_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int StdDev_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int StdDev_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int StdDev_SignalCloseMethod = 0;        // Signal close method (-127-127)
INPUT int StdDev_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float StdDev_SignalCloseLevel = 28.0f;   // Signal close level
INPUT int StdDev_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float StdDev_PriceStopLevel = 2;         // Price stop level
INPUT int StdDev_TickFilterMethod = 32;        // Tick filter method
INPUT float StdDev_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short StdDev_Shift = 0;                  // Shift
INPUT float StdDev_OrderCloseLoss = 80;        // Order close loss
INPUT float StdDev_OrderCloseProfit = 80;      // Order close profit
INPUT int StdDev_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("StdDev strategy: StdDev indicator params");
INPUT int StdDev_Indi_StdDev_MA_Period = 24;                                 // Period
INPUT int StdDev_Indi_StdDev_MA_Shift = 0;                                   // MA Shift
INPUT ENUM_MA_METHOD StdDev_Indi_StdDev_MA_Method = (ENUM_MA_METHOD)3;       // MA Method
INPUT ENUM_APPLIED_PRICE StdDev_Indi_StdDev_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int StdDev_Indi_StdDev_Shift = 0;                                      // Shift

// Structs.

// Defines struct with default user strategy values.
struct Stg_StdDev_Params_Defaults : StgParams {
  Stg_StdDev_Params_Defaults()
      : StgParams(::StdDev_SignalOpenMethod, ::StdDev_SignalOpenFilterMethod, ::StdDev_SignalOpenLevel,
                  ::StdDev_SignalOpenBoostMethod, ::StdDev_SignalCloseMethod, ::StdDev_SignalCloseFilter,
                  ::StdDev_SignalCloseLevel, ::StdDev_PriceStopMethod, ::StdDev_PriceStopLevel,
                  ::StdDev_TickFilterMethod, ::StdDev_MaxSpread, ::StdDev_Shift) {
    Set(STRAT_PARAM_LS, StdDev_LotSize);
    Set(STRAT_PARAM_OCL, StdDev_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, StdDev_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, StdDev_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, StdDev_SignalOpenFilterTime);
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

class Stg_StdDev : public Strategy {
 public:
  Stg_StdDev(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_StdDev *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_StdDev_Params_Defaults stg_stddev_defaults;
    StgParams _stg_params(stg_stddev_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_stddev_m1, stg_stddev_m5, stg_stddev_m15, stg_stddev_m30,
                             stg_stddev_h1, stg_stddev_h4, stg_stddev_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_StdDev(_stg_params, _tparams, _cparams, "StdDev");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiStdDevParams _indi_params(::StdDev_Indi_StdDev_MA_Period, ::StdDev_Indi_StdDev_MA_Shift,
                                  ::StdDev_Indi_StdDev_MA_Method, ::StdDev_Indi_StdDev_Applied_Price,
                                  ::StdDev_Indi_StdDev_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_StdDev(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_StdDev *_indi = GetIndicator();
    bool _result =
        _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) && _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 2);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    // Note: It doesn't give independent signals. Is used to define volatility (trend strength).
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result &= _indi.IsIncreasing(2, 0, _shift);
        _result &= _indi.IsIncByPct(_level, 0, _shift, 2);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        _result &= _indi.IsDecreasing(2, 0, _shift);
        _result &= _indi.IsDecByPct(-_level, 0, _shift, 2);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
