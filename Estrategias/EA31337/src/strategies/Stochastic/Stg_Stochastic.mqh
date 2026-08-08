/**
 * @file
 * Implements Stochastic strategy based on the Stochastic Oscillator.
 */

// User input params.
INPUT_GROUP("Stochastic strategy: strategy params");
INPUT float Stochastic_LotSize = 0;               // Lot size
INPUT int Stochastic_SignalOpenMethod = 0;        // Signal open method
INPUT int Stochastic_SignalOpenLevel = 24.0f;     // Signal open level
INPUT int Stochastic_SignalOpenFilterMethod = 0;  // Signal open filter method
INPUT int Stochastic_SignalOpenFilterTime = 3;    // Signal open filter time
INPUT int Stochastic_SignalOpenBoostMethod = 0;   // Signal open boost method
INPUT int Stochastic_SignalCloseMethod = 0;       // Signal close method
INPUT int Stochastic_SignalCloseFilter = 0;       // Signal close filter (-127-127)
INPUT int Stochastic_SignalCloseLevel = 24.0f;    // Signal close level
INPUT int Stochastic_PriceStopMethod = 1;         // Price stop method (0-127)
INPUT float Stochastic_PriceStopLevel = 2;        // Price stop level
INPUT int Stochastic_TickFilterMethod = 32;       // Tick filter method
INPUT float Stochastic_MaxSpread = 4.0;           // Max spread to trade (pips)
INPUT short Stochastic_Shift = 0;                 // Shift
INPUT float Stochastic_OrderCloseLoss = 80;       // Order close loss
INPUT float Stochastic_OrderCloseProfit = 80;     // Order close profit
INPUT int Stochastic_OrderCloseTime = -30;        // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Stochastic strategy: Stochastic indicator params");
INPUT int Stochastic_Indi_Stochastic_KPeriod = 8;                      // K line period
INPUT int Stochastic_Indi_Stochastic_DPeriod = 12;                     // D line period
INPUT int Stochastic_Indi_Stochastic_Slowing = 12;                     // Slowing
INPUT ENUM_MA_METHOD Stochastic_Indi_Stochastic_MA_Method = MODE_EMA;  // Moving Average method
INPUT ENUM_STO_PRICE Stochastic_Indi_Stochastic_Price_Field = 0;       // Price (0 - Low/High or 1 - Close/Close)
INPUT int Stochastic_Indi_Stochastic_Shift = 0;                        // Shift

// Structs.

// Defines struct with default user strategy values.
struct Stg_Stochastic_Params_Defaults : StgParams {
  Stg_Stochastic_Params_Defaults()
      : StgParams(::Stochastic_SignalOpenMethod, ::Stochastic_SignalOpenFilterMethod, ::Stochastic_SignalOpenLevel,
                  ::Stochastic_SignalOpenBoostMethod, ::Stochastic_SignalCloseMethod, ::Stochastic_SignalCloseFilter,
                  ::Stochastic_SignalCloseLevel, ::Stochastic_PriceStopMethod, ::Stochastic_PriceStopLevel,
                  ::Stochastic_TickFilterMethod, ::Stochastic_MaxSpread, ::Stochastic_Shift) {
    Set(STRAT_PARAM_LS, Stochastic_LotSize);
    Set(STRAT_PARAM_OCL, Stochastic_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Stochastic_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Stochastic_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Stochastic_SignalOpenFilterTime);
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

class Stg_Stochastic : public Strategy {
 public:
  Stg_Stochastic(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Stochastic *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_Stochastic_Params_Defaults stg_stoch_defaults;
    StgParams _stg_params(stg_stoch_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_stoch_m1, stg_stoch_m5, stg_stoch_m15, stg_stoch_m30, stg_stoch_h1,
                             stg_stoch_h4, stg_stoch_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Stochastic(_stg_params, _tparams, _cparams, "Stochastic");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiStochParams _indi_params(::Stochastic_Indi_Stochastic_KPeriod, ::Stochastic_Indi_Stochastic_DPeriod,
                                 ::Stochastic_Indi_Stochastic_Slowing, ::Stochastic_Indi_Stochastic_MA_Method,
                                 ::Stochastic_Indi_Stochastic_Price_Field, ::Stochastic_Indi_Stochastic_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_Stochastic(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_Stochastic *_indi = GetIndicator();
    bool _result =
        _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) && _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 3);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift, LINE_MAIN, LINE_SIGNAL);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy: main line falls below level and goes above the signal line.
        _result &= _indi.GetMin<double>(_shift, 4) < 50 - _level;
        _result &= _indi[_shift][(int)LINE_SIGNAL] < _indi[_shift][(int)LINE_MAIN];
        _result &= _indi.IsIncreasing(1, LINE_MAIN, _shift);
        _result &= _indi.IsIncreasing(1, LINE_SIGNAL, _shift);
        _result &= _indi.IsIncByPct(_level / 10, LINE_SIGNAL, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell: main line rises above level and main line above the signal line.
        _result &= _indi.GetMax<double>(_shift, 4) > 50 + _level;
        _result &= _indi[_shift][(int)LINE_SIGNAL] > _indi[_shift][(int)LINE_MAIN];
        _result &= _indi.IsDecreasing(1, LINE_MAIN, _shift);
        _result &= _indi.IsDecreasing(1, LINE_SIGNAL, _shift);
        _result &= _indi.IsDecByPct(_level / 10, LINE_SIGNAL, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
