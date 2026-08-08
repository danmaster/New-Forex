/**
 * @file
 * Implements AMA strategy based on the AMA indicator.
 */

// User input params.
INPUT_GROUP("AMA strategy: strategy params");
INPUT float AMA_LotSize = 0;                // Lot size
INPUT int AMA_SignalOpenMethod = 0;         // Signal open method
INPUT float AMA_SignalOpenLevel = 0.001f;   // Signal open level
INPUT int AMA_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int AMA_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT int AMA_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int AMA_SignalCloseMethod = 0;        // Signal close method
INPUT int AMA_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float AMA_SignalCloseLevel = 0.001f;  // Signal close level
INPUT int AMA_PriceStopMethod = 29;         // Price limit method
INPUT float AMA_PriceStopLevel = 2;         // Price limit level
INPUT int AMA_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT float AMA_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short AMA_Shift = 0;                  // Shift
INPUT float AMA_OrderCloseLoss = 80;        // Order close loss
INPUT float AMA_OrderCloseProfit = 80;      // Order close profit
INPUT int AMA_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("AMA strategy: AMA indicator params");
INPUT int AMA_Indi_AMA_InpPeriodAMA = 20;                              // AMA period
INPUT int AMA_Indi_AMA_InpFastPeriodEMA = 4;                           // Fast EMA period
INPUT int AMA_Indi_AMA_InpSlowPeriodEMA = 30;                          // Slow EMA period
INPUT int AMA_Indi_AMA_InpShiftAMA = 4;                                // AMA shift
INPUT int AMA_Indi_AMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE AMA_Indi_AMA_SourceType = IDATA_BUILTIN;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_AMA_Params_Defaults : StgParams {
  Stg_AMA_Params_Defaults()
      : StgParams(::AMA_SignalOpenMethod, ::AMA_SignalOpenFilterMethod, ::AMA_SignalOpenLevel,
                  ::AMA_SignalOpenBoostMethod, ::AMA_SignalCloseMethod, ::AMA_SignalCloseFilter, ::AMA_SignalCloseLevel,
                  ::AMA_PriceStopMethod, ::AMA_PriceStopLevel, ::AMA_TickFilterMethod, ::AMA_MaxSpread, ::AMA_Shift) {
    Set(STRAT_PARAM_LS, AMA_LotSize);
    Set(STRAT_PARAM_OCL, AMA_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, AMA_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, AMA_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, AMA_SignalOpenFilterTime);
  }
} stg_ama_defaults;

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

class Stg_AMA : public Strategy {
 public:
  Stg_AMA(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_AMA *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    StgParams _stg_params(stg_ama_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_ama_m1, stg_ama_m5, stg_ama_m15, stg_ama_m30, stg_ama_h1, stg_ama_h4,
                             stg_ama_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_AMA(_stg_params, _tparams, _cparams, "AMA");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiAMAParams ama_params(::AMA_Indi_AMA_InpPeriodAMA, ::AMA_Indi_AMA_InpFastPeriodEMA,
                             ::AMA_Indi_AMA_InpSlowPeriodEMA, ::AMA_Indi_AMA_InpShiftAMA, PRICE_TYPICAL,
                             ::AMA_Indi_AMA_Shift);
    ama_params.SetDataSourceType(::AMA_Indi_AMA_SourceType);
    ama_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_AMA(ama_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    Indi_AMA *_indi = GetIndicator();
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
        _result &= Low[_shift] < _indi[_shift][0];
        _result &= _indi.IsIncreasing(2, 0, _shift);
        _result &= _indi.IsIncByPct(_level, 0, _shift, 2);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= High[_shift] > _indi[_shift][0];
        _result &= _indi.IsDecreasing(2, 0, _shift);
        _result &= _indi.IsDecByPct(_level, 0, _shift, 2);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
