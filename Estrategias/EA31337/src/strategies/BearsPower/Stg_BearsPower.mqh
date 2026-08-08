/**
 * @file
 * Implements BearsPower strategy based on the Bears Power indicator.
 */

// User input params.
INPUT_GROUP("BearsPower strategy: strategy params");
INPUT float BearsPower_LotSize = 0;                // Lot size
INPUT int BearsPower_SignalOpenMethod = 0;         // Signal open method (-127-127)
INPUT float BearsPower_SignalOpenLevel = 300.0f;   // Signal open level
INPUT int BearsPower_SignalOpenFilterMethod = 32;  // Signal filter method
INPUT int BearsPower_SignalOpenFilterTime = 3;     // Signal filter time
INPUT int BearsPower_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int BearsPower_SignalCloseMethod = 0;        // Signal close method
INPUT int BearsPower_SignalCloseFilter = 0;        // Signal close filter (-127-127)
INPUT float BearsPower_SignalCloseLevel = 900.0f;  // Signal close level
INPUT int BearsPower_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float BearsPower_PriceStopLevel = 2;         // Price stop level
INPUT int BearsPower_TickFilterMethod = 32;        // Tick filter method
INPUT float BearsPower_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short BearsPower_Shift = 0;                  // Shift (relative to the current bar, 0 - default)
INPUT float BearsPower_OrderCloseLoss = 80;        // Order close loss
INPUT float BearsPower_OrderCloseProfit = 80;      // Order close profit
INPUT int BearsPower_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("BearsPower strategy: BearsPower indicator params");
INPUT int BearsPower_Indi_BearsPower_Period = 30;                                 // Period
INPUT ENUM_APPLIED_PRICE BearsPower_Indi_BearsPower_Applied_Price = PRICE_CLOSE;  // Applied Price
INPUT int BearsPower_Indi_BearsPower_Shift = 0;                                   // Shift

// Structs.

// Defines struct with default user strategy values.
struct Stg_BearsPower_Params_Defaults : StgParams {
  Stg_BearsPower_Params_Defaults()
      : StgParams(::BearsPower_SignalOpenMethod, ::BearsPower_SignalOpenFilterMethod, ::BearsPower_SignalOpenLevel,
                  ::BearsPower_SignalOpenBoostMethod, ::BearsPower_SignalCloseMethod, ::BearsPower_SignalCloseFilter,
                  ::BearsPower_SignalCloseLevel, ::BearsPower_PriceStopMethod, ::BearsPower_PriceStopLevel,
                  ::BearsPower_TickFilterMethod, ::BearsPower_MaxSpread, ::BearsPower_Shift) {
    Set(STRAT_PARAM_LS, BearsPower_LotSize);
    Set(STRAT_PARAM_OCL, BearsPower_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, BearsPower_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, BearsPower_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, BearsPower_SignalOpenFilterTime);
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

class Stg_BearsPower : public Strategy {
 public:
  Stg_BearsPower(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_BearsPower *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_BearsPower_Params_Defaults stg_bears_defaults;
    StgParams _stg_params(stg_bears_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_bears_m1, stg_bears_m5, stg_bears_m15, stg_bears_m30, stg_bears_h1,
                             stg_bears_h4, stg_bears_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_BearsPower(_stg_params, _tparams, _cparams, "BearsPower");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiBearsPowerParams _indi_params(::BearsPower_Indi_BearsPower_Period, ::BearsPower_Indi_BearsPower_Applied_Price,
                                      ::BearsPower_Indi_BearsPower_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_BearsPower(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_BearsPower *_indi = GetIndicator();
    Chart *_chart = (Chart *)_indi;
    bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // The histogram is above zero level.
        // Fall of histogram, which is above zero, indicates that while the bulls prevail on the market,
        // their strength begins to weaken and the bears gradually increase their pressure.
        _result &= _indi[CURR][0] > 0;
        _result &= _indi.IsIncreasing(2, 0, _shift);
        _result &= _indi.IsIncByPct(_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        // @todo: Signal: Changing from negative values to positive.
        // When histogram passes through zero level from bottom up,
        // bears have lost control over the market and bulls increase pressure.
        break;
      case ORDER_TYPE_SELL:
        // Strong bearish trend - the histogram is located below the central line.
        _result &= _indi[CURR][0] < 0;
        _result &= _indi.IsDecreasing(2, 0, _shift);
        _result &= _indi.IsDecByPct(-_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        // @todo
        // When histogram is below zero level, but with the rays pointing upwards (upward trend),
        // then we can assume that, in spite of still bearish sentiment in the market, their strength begins to
        // weaken.
        break;
    }
    return _result;
  }

  /**
   * Gets price stop value for profit take or stop loss.
   */
  float PriceStop(ENUM_ORDER_TYPE _cmd, ENUM_ORDER_TYPE_VALUE _mode, int _method = 0, float _level = 0.0) {
    Indi_BearsPower *_indi = GetIndicator();
    double _trail = _level * Market().GetPipSize();
    int _direction = Order::OrderDirection(_cmd, _mode);
    double _default_value = Market().GetCloseOffer(_cmd) + _trail * _method * _direction;
    double _result = _default_value;
    switch (_method) {
      case 1: {
        int _bar_count0 = (int)_level * (int)_indi.GetPeriod();
        _result = _direction > 0 ? _indi.GetPrice(PRICE_HIGH, _indi.GetHighest<double>(_bar_count0))
                                 : _indi.GetPrice(PRICE_LOW, _indi.GetLowest<double>(_bar_count0));
        break;
      }
      case 2: {
        int _bar_count1 = (int)_level * (int)_indi.GetPeriod();
        _result = _direction < 0 ? _indi.GetPrice(PRICE_HIGH, _indi.GetHighest<double>(_bar_count1))
                                 : _indi.GetPrice(PRICE_LOW, _indi.GetLowest<double>(_bar_count1));
        break;
      }
    }
    return (float)_result;
  }
};
