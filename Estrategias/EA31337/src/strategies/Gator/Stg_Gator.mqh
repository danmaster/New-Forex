/**
 * @file
 * Implements Gator strategy based on the Gator oscillator.
 */

// User input params.
INPUT_GROUP("Gator strategy: strategy params");
INPUT float Gator_LotSize = 0;                // Lot size
INPUT int Gator_SignalOpenMethod = 0;         // Signal open method (-127-127)
INPUT float Gator_SignalOpenLevel = 0.0f;     // Signal open level
INPUT int Gator_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int Gator_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int Gator_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int Gator_SignalCloseMethod = 0;        // Signal close method (-127-127)
INPUT int Gator_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float Gator_SignalCloseLevel = 0.0f;    // Signal close level
INPUT int Gator_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float Gator_PriceStopLevel = 2;         // Price stop level
INPUT int Gator_TickFilterMethod = 32;        // Tick filter method
INPUT float Gator_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short Gator_Shift = 0;                  // Shift
INPUT float Gator_OrderCloseLoss = 80;        // Order close loss
INPUT float Gator_OrderCloseProfit = 80;      // Order close profit
INPUT int Gator_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Gator strategy: Gator indicator params");
INPUT int Gator_Indi_Gator_Period_Jaw = 30;                            // Jaw Period
INPUT int Gator_Indi_Gator_Period_Teeth = 14;                          // Teeth Period
INPUT int Gator_Indi_Gator_Period_Lips = 6;                            // Lips Period
INPUT int Gator_Indi_Gator_Shift_Jaw = 2;                              // Jaw Shift
INPUT int Gator_Indi_Gator_Shift_Teeth = 2;                            // Teeth Shift
INPUT int Gator_Indi_Gator_Shift_Lips = 4;                             // Lips Shift
INPUT ENUM_MA_METHOD Gator_Indi_Gator_MA_Method = (ENUM_MA_METHOD)1;   // MA Method
INPUT ENUM_APPLIED_PRICE Gator_Indi_Gator_Applied_Price = PRICE_OPEN;  // Applied Price
INPUT int Gator_Indi_Gator_Shift = 0;                                  // Shift

// Structs.

// Defines struct with default user strategy values.
struct Stg_Gator_Params_Defaults : StgParams {
  Stg_Gator_Params_Defaults()
      : StgParams(::Gator_SignalOpenMethod, ::Gator_SignalOpenFilterMethod, ::Gator_SignalOpenLevel,
                  ::Gator_SignalOpenBoostMethod, ::Gator_SignalCloseMethod, ::Gator_SignalCloseFilter,
                  ::Gator_SignalCloseLevel, ::Gator_PriceStopMethod, ::Gator_PriceStopLevel, ::Gator_TickFilterMethod,
                  ::Gator_MaxSpread, ::Gator_Shift) {
    Set(STRAT_PARAM_LS, Gator_LotSize);
    Set(STRAT_PARAM_OCL, Gator_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Gator_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Gator_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Gator_SignalOpenFilterTime);
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

class Stg_Gator : public Strategy {
 public:
  Stg_Gator(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Gator *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_Gator_Params_Defaults stg_gator_defaults;
    StgParams _stg_params(stg_gator_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_gator_m1, stg_gator_m5, stg_gator_m15, stg_gator_m30, stg_gator_h1,
                             stg_gator_h4, stg_gator_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Gator(_stg_params, _tparams, _cparams, "Gator");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiGatorParams _indi_params(
        ::Gator_Indi_Gator_Period_Jaw, ::Gator_Indi_Gator_Shift_Jaw, ::Gator_Indi_Gator_Period_Teeth,
        ::Gator_Indi_Gator_Shift_Teeth, ::Gator_Indi_Gator_Period_Lips, ::Gator_Indi_Gator_Shift_Lips,
        ::Gator_Indi_Gator_MA_Method, ::Gator_Indi_Gator_Applied_Price, ::Gator_Indi_Gator_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_Gator(_indi_params));
  }

  /**
   * Check if Gator Oscillator is on buy or sell.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_Gator *_indi = GetIndicator();
    bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy: if the indicator is increasing.
        _result &= _indi.IsIncreasing(2, LINE_UPPER_HISTOGRAM, _shift);
        _result &= _indi.IsDecreasing(2, LINE_LOWER_HISTOGRAM, _shift);
        _result &= _indi.IsIncByPct(_level, LINE_UPPER_HISTOGRAM, _shift, 2);
        _result &= _indi.IsDecByPct(-_level, LINE_LOWER_HISTOGRAM, _shift, 2);
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi.IsIncreasing(2, LINE_LOWER_HISTOGRAM, _shift + 3);
          if (METHOD(_method, 1)) _result &= _indi.IsIncreasing(2, LINE_LOWER_HISTOGRAM, _shift + 5);
        }
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell: if the indicator is decreasing.
        _result &= _indi.IsDecreasing(2, LINE_UPPER_HISTOGRAM, _shift);
        _result &= _indi.IsIncreasing(2, LINE_LOWER_HISTOGRAM, _shift);
        _result &= _indi.IsDecByPct(-_level, LINE_UPPER_HISTOGRAM, _shift, 2);
        _result &= _indi.IsIncByPct(_level, LINE_LOWER_HISTOGRAM, _shift, 2);
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi.IsDecreasing(2, LINE_UPPER_HISTOGRAM, _shift + 3);
          if (METHOD(_method, 1)) _result &= _indi.IsDecreasing(2, LINE_UPPER_HISTOGRAM, _shift + 5);
        }
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
