/**
 * @file
 * Implements OsMA strategy based on the Moving Average of Oscillator indicator.
 */

// User input params.
INPUT_GROUP("OsMA strategy: strategy params");
INPUT float OsMA_LotSize = 0;                // Lot size
INPUT int OsMA_SignalOpenMethod = 2;         // Signal open method (-127-127)
INPUT float OsMA_SignalOpenLevel = 100.0f;   // Signal open level
INPUT int OsMA_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int OsMA_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int OsMA_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int OsMA_SignalCloseMethod = 2;        // Signal close method (-127-127)
INPUT int OsMA_SignalCloseFilter = 2;        // Signal close filter (-127-127)
INPUT float OsMA_SignalCloseLevel = 100.0f;  // Signal close level
INPUT int OsMA_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float OsMA_PriceStopLevel = 2;         // Price stop level
INPUT int OsMA_TickFilterMethod = 32;        // Tick filter method
INPUT float OsMA_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short OsMA_Shift = 0;                  // Shift
INPUT float OsMA_OrderCloseLoss = 80;        // Order close loss
INPUT float OsMA_OrderCloseProfit = 80;      // Order close profit
INPUT int OsMA_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("OsMA strategy: OsMA indicator params");
INPUT int OsMA_Indi_OsMA_Period_Fast = 14;                           // Period fast
INPUT int OsMA_Indi_OsMA_Period_Slow = 30;                           // Period slow
INPUT int OsMA_Indi_OsMA_Period_Signal = 12;                         // Period signal
INPUT ENUM_APPLIED_PRICE OsMA_Indi_OsMA_Applied_Price = PRICE_OPEN;  // Applied price
INPUT int OsMA_Indi_OsMA_Shift = 0;                                  // Shift

// Structs.

// Defines struct with default user strategy values.
struct Stg_OsMA_Params_Defaults : StgParams {
  Stg_OsMA_Params_Defaults()
      : StgParams(::OsMA_SignalOpenMethod, ::OsMA_SignalOpenFilterMethod, ::OsMA_SignalOpenLevel,
                  ::OsMA_SignalOpenBoostMethod, ::OsMA_SignalCloseMethod, ::OsMA_SignalCloseFilter,
                  ::OsMA_SignalCloseLevel, ::OsMA_PriceStopMethod, ::OsMA_PriceStopLevel, ::OsMA_TickFilterMethod,
                  ::OsMA_MaxSpread, ::OsMA_Shift) {
    Set(STRAT_PARAM_LS, OsMA_LotSize);
    Set(STRAT_PARAM_OCL, OsMA_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, OsMA_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, OsMA_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, OsMA_SignalOpenFilterTime);
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

class Stg_OsMA : public Strategy {
 public:
  Stg_OsMA(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_OsMA *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_OsMA_Params_Defaults stg_osma_defaults;
    StgParams _stg_params(stg_osma_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_osma_m1, stg_osma_m5, stg_osma_m15, stg_osma_m30, stg_osma_h1,
                             stg_osma_h4, stg_osma_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_OsMA(_stg_params, _tparams, _cparams, "OsMA");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiOsMAParams _indi_params(::OsMA_Indi_OsMA_Period_Fast, ::OsMA_Indi_OsMA_Period_Slow,
                                ::OsMA_Indi_OsMA_Period_Signal, ::OsMA_Indi_OsMA_Applied_Price, ::OsMA_Indi_OsMA_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_OsMA(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_OsMA *_indi = GetIndicator();
    bool _result =
        _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) && _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy: histogram is below zero and changes falling direction into rising (5 columns are taken).
        _result &= _indi[_shift + 2][0] < 0;
        _result &= _indi.IsIncreasing(2, 0, _shift);
        _result &= _indi.IsIncByPct(_level, 0, _shift, 2);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell: histogram is above zero and changes its rising direction into falling (5 columns are taken).
        _result &= _indi[_shift + 2][0] > 0;
        _result &= _indi.IsDecreasing(2, 0, _shift);
        _result &= _indi.IsDecByPct(-_level, 0, _shift, 2);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
