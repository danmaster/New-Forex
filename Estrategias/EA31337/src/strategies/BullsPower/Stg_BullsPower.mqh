/**
 * @file
 * Implements BullsPower strategy based on the Bulls Power indicator.
 */

// User input params.
INPUT_GROUP("BullsPower strategy: strategy params");
INPUT float BullsPower_LotSize = 0;                // Lot size
INPUT int BullsPower_SignalOpenMethod = 0;         // Signal open method (-127-127)
INPUT float BullsPower_SignalOpenLevel = 300.0f;   // Signal open level
INPUT int BullsPower_SignalOpenFilterMethod = 32;  // Signal filter method
INPUT int BullsPower_SignalOpenFilterTime = 3;     // Signal filter time
INPUT int BullsPower_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int BullsPower_SignalCloseMethod = 0;        // Signal close method
INPUT int BullsPower_SignalCloseFilter = 0;        // Signal close filter (-127-127)
INPUT float BullsPower_SignalCloseLevel = 900.0f;  // Signal close level
INPUT int BullsPower_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float BullsPower_PriceStopLevel = 2;         // Price stop level
INPUT int BullsPower_TickFilterMethod = 32;        // Tick filter method
INPUT float BullsPower_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short BullsPower_Shift = 0;                  // Shift (relative to the current bar, 0 - default)
INPUT float BullsPower_OrderCloseLoss = 80;        // Order close loss
INPUT float BullsPower_OrderCloseProfit = 80;      // Order close profit
INPUT int BullsPower_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("BullsPower strategy: BullsPower indicator params");
INPUT int BullsPower_Indi_BullsPower_Period = 30;                                 // Period
INPUT ENUM_APPLIED_PRICE BullsPower_Indi_BullsPower_Applied_Price = PRICE_CLOSE;  // Applied Price
INPUT int BullsPower_Indi_BullsPower_Shift = 0;                                   // Shift

// Structs.

// Defines struct with default user strategy values.
struct Stg_BullsPower_Params_Defaults : StgParams {
  Stg_BullsPower_Params_Defaults()
      : StgParams(::BullsPower_SignalOpenMethod, ::BullsPower_SignalOpenFilterMethod, ::BullsPower_SignalOpenLevel,
                  ::BullsPower_SignalOpenBoostMethod, ::BullsPower_SignalCloseMethod, ::BullsPower_SignalCloseFilter,
                  ::BullsPower_SignalCloseLevel, ::BullsPower_PriceStopMethod, ::BullsPower_PriceStopLevel,
                  ::BullsPower_TickFilterMethod, ::BullsPower_MaxSpread, ::BullsPower_Shift) {
    Set(STRAT_PARAM_LS, BullsPower_LotSize);
    Set(STRAT_PARAM_OCL, BullsPower_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, BullsPower_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, BullsPower_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, BullsPower_SignalOpenFilterTime);
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

class Stg_BullsPower : public Strategy {
 public:
  Stg_BullsPower(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_BullsPower *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_BullsPower_Params_Defaults stg_bulls_defaults;
    StgParams _stg_params(stg_bulls_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_bulls_m1, stg_bulls_m5, stg_bulls_m15, stg_bulls_m30, stg_bulls_h1,
                             stg_bulls_h4, stg_bulls_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_BullsPower(_stg_params, _tparams, _cparams, "BullsPower");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiBullsPowerParams _indi_params(::BullsPower_Indi_BullsPower_Period, ::BullsPower_Indi_BullsPower_Applied_Price,
                                      ::BullsPower_Indi_BullsPower_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_BullsPower(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_BullsPower *_indi = GetIndicator();
    Chart *_chart = (Chart *)_indi;
    bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Strong uptrend - the histogram is located above balance line.
        // When the histogram is above zero level, but the beams are directed downwards (the tendency to decrease),
        // then we can assume that, despite the still bullish sentiments on the market, their strength is weakening.
        _result &= _indi[CURR][0] > 0;
        _result &= _indi.IsIncreasing(2, 0, _shift);
        _result &= _indi.IsIncByPct(_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        // @todo
        // The growth of histogram, which is below zero, suggests that,
        // while sellers dominate the market, their strength begins to weaken and buyers gradually increase their
        // interest.
        // @todo: Divergence situations between the price schedule and Bulls Power histogram - a traditionally strong
        // reversal signal.
        break;
      case ORDER_TYPE_SELL:
        // Histogram is below zero level.
        // When the histogram passes through the zero level from top down,
        // bulls lost control of the market and bears increase pressure; waiting for price to turn down.
        _result &= _indi[CURR][0] < 0;
        _result &= _indi.IsDecreasing(2, 0, _shift);
        _result &= _indi.IsDecByPct(-_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        // @todo
        // When histogram is below zero level, but with the rays pointing upwards (upward trend),
        // then we can assume that, in spite of still bearish sentiment in the market, their strength begins to
        // weaken.
        // @todo
        // If the histogram is above zero level, but the beams are directed downwards (the tendency to decrease),
        // then we can assume that, despite the still bullish sentiments on the market, their strength is weakening
        // @todo: Divergence situations between the price schedule and Bulls Power histogram - a traditionally strong
        // reversal signal.
        break;
    }
    return _result;
  }
};
