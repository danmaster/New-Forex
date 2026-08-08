/**
 * @file
 * Implements ASI strategy based on the ASI indicator.
 */

// User input params.
INPUT_GROUP("ASI strategy: strategy params");
INPUT float ASI_LotSize = 0;                // Lot size
INPUT int ASI_SignalOpenMethod = 0;         // Signal open method
INPUT float ASI_SignalOpenLevel = 100.0f;   // Signal open level
INPUT int ASI_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int ASI_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT int ASI_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int ASI_SignalCloseMethod = 0;        // Signal close method
INPUT int ASI_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float ASI_SignalCloseLevel = 100.0f;  // Signal close level
INPUT int ASI_PriceStopMethod = 0;          // Price limit method
INPUT float ASI_PriceStopLevel = 2;         // Price limit level
INPUT int ASI_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT float ASI_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short ASI_Shift = 0;                  // Shift
INPUT float ASI_OrderCloseLoss = 80;        // Order close loss
INPUT float ASI_OrderCloseProfit = 80;      // Order close profit
INPUT int ASI_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("ASI strategy: ASI indicator params");
INPUT int ASI_Indi_ASI_MPC = 300.0f;                                       // Maximum price changing
INPUT int ASI_Indi_ASI_Shift = 0;                                          // Shift
INPUT ENUM_IDATA_SOURCE_TYPE ASI_Indi_ASI_SourceType = IDATA_ONCALCULATE;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_ASI_Params_Defaults : StgParams {
  Stg_ASI_Params_Defaults()
      : StgParams(::ASI_SignalOpenMethod, ::ASI_SignalOpenFilterMethod, ::ASI_SignalOpenLevel,
                  ::ASI_SignalOpenBoostMethod, ::ASI_SignalCloseMethod, ::ASI_SignalCloseFilter, ::ASI_SignalCloseLevel,
                  ::ASI_PriceStopMethod, ::ASI_PriceStopLevel, ::ASI_TickFilterMethod, ::ASI_MaxSpread, ::ASI_Shift) {
    Set(STRAT_PARAM_LS, ASI_LotSize);
    Set(STRAT_PARAM_OCL, ASI_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, ASI_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, ASI_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, ASI_SignalOpenFilterTime);
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

class Stg_ASI : public Strategy {
 public:
  Stg_ASI(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_ASI *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_ASI_Params_Defaults stg_asi_defaults;
    StgParams _stg_params(stg_asi_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_asi_m1, stg_asi_m5, stg_asi_m15, stg_asi_m30, stg_asi_h1, stg_asi_h4,
                             stg_asi_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_ASI(_stg_params, _tparams, _cparams, "ASI");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiASIParams _indi_params(::ASI_Indi_ASI_MPC, ::ASI_Indi_ASI_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_ASI(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    Indi_ASI *_indi = GetIndicator();
    bool _result =
        _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) && _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _indi.IsIncreasing(2, 0, _shift);
        _result &= _indi.IsIncByPct(_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _indi.IsDecreasing(2, 0, _shift);
        _result &= _indi.IsDecByPct(_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
