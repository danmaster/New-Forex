/**
 * @file
 * Implements Force strategy for the Force Index indicator.
 */

// User input params.
INPUT_GROUP("Force strategy: strategy params");
INPUT float Force_LotSize = 0;                // Lot size
INPUT int Force_SignalOpenMethod = 2;         // Signal open method (-127-127)
INPUT float Force_SignalOpenLevel = 0.0f;     // Signal open level
INPUT int Force_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int Force_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int Force_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int Force_SignalCloseMethod = 2;        // Signal close method (-127-127)
INPUT int Force_SignalCloseFilter = 0;        // Signal close filter (-127-127)
INPUT float Force_SignalCloseLevel = 0.0f;    // Signal close level
INPUT int Force_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float Force_PriceStopLevel = 2;         // Price stop level
INPUT int Force_TickFilterMethod = 32;        // Tick filter method
INPUT float Force_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short Force_Shift = 1;                  // Shift (relative to the current bar, 0 - default)
INPUT float Force_OrderCloseLoss = 80;        // Order close loss
INPUT float Force_OrderCloseProfit = 80;      // Order close profit
INPUT int Force_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Force strategy: Force indicator params");
INPUT int Force_Indi_Force_Period = 35;                                           // Period
INPUT ENUM_MA_METHOD Force_Indi_Force_MA_Method = (ENUM_MA_METHOD)0;              // MA Method
INPUT ENUM_APPLIED_PRICE Force_Indi_Force_Applied_Price = (ENUM_APPLIED_PRICE)2;  // Applied Price
INPUT int Force_Indi_Force_Shift = 0;                                             // Shift

// Structs.

// Defines struct with default user strategy values.
struct Stg_Force_Params_Defaults : StgParams {
  Stg_Force_Params_Defaults()
      : StgParams(::Force_SignalOpenMethod, ::Force_SignalOpenFilterMethod, ::Force_SignalOpenLevel,
                  ::Force_SignalOpenBoostMethod, ::Force_SignalCloseMethod, ::Force_SignalCloseFilter,
                  ::Force_SignalCloseLevel, ::Force_PriceStopMethod, ::Force_PriceStopLevel, ::Force_TickFilterMethod,
                  ::Force_MaxSpread, ::Force_Shift) {
    Set(STRAT_PARAM_LS, Force_LotSize);
    Set(STRAT_PARAM_OCL, Force_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Force_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Force_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Force_SignalOpenFilterTime);
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

class Stg_Force : public Strategy {
 public:
  Stg_Force(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Force *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_Force_Params_Defaults stg_force_defaults;
    StgParams _stg_params(stg_force_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_force_m1, stg_force_m5, stg_force_m15, stg_force_m30, stg_force_h1,
                             stg_force_h4, stg_force_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Force(_stg_params, _tparams, _cparams, "Force");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiForceParams _indi_params(::Force_Indi_Force_Period, ::Force_Indi_Force_MA_Method,
                                 ::Force_Indi_Force_Applied_Price, ::Force_Indi_Force_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_Force(_indi_params));
  }

  /**
   * Check if Force Index indicator is on buy or sell.
   *
   * Note: To use the indicator it should be correlated with another trend indicator.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_Force *_indi = GetIndicator();
    bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // FI recommends to buy (i.e. FI<0).
        _result = _indi[CURR][0] < 0 && _indi.IsIncreasing(2, 0, _shift);
        _result &= _indi.IsIncByPct(_level, 0, _shift, 2);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        // Signal: Changing from negative values to positive.
        // @todo
        // When histogram passes through zero level from bottom up,
        // bears have lost control over the market and bulls increase pressure.
        // if (METHOD(_method, 2)) _result &= _indi[PPREV][0] > 0;
        break;
      case ORDER_TYPE_SELL:
        // FI recommends to sell (i.e. FI>0).
        _result = _indi[CURR][0] > 0 && _indi.IsDecreasing(2, 0, _shift);
        _result &= _indi.IsDecByPct(-_level, 0, _shift, 2);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        // @todo
        // When histogram is below zero level, but with the rays pointing upwards (upward trend),
        // then we can assume that, in spite of still bearish sentiment in the market, their strength begins to
        // weaken.
        // if (METHOD(_method, 2)) _result &= _indi[PPREV][0] < 0;
        break;
    }
    return _result;
  }
};
