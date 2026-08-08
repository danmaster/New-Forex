/**
 * @file
 * Implements Awesome strategy based on for the Awesome oscillator.
 */

// User input params.
INPUT_GROUP("Awesome strategy: strategy params");
INPUT float Awesome_LotSize = 0;                // Lot size
INPUT int Awesome_SignalOpenMethod = 2;         // Signal open method (-127-127)
INPUT float Awesome_SignalOpenLevel = 0.0f;     // Signal open level (>0.0001)
INPUT int Awesome_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int Awesome_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int Awesome_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT float Awesome_SignalCloseLevel = 0.0f;    // Signal close level (>0.0001)
INPUT int Awesome_SignalCloseMethod = 2;        // Signal close method (-127-127)
INPUT int Awesome_SignalCloseFilter = 16;       // Signal close filter (-127-127)
INPUT int Awesome_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float Awesome_PriceStopLevel = 2;         // Price stop level
INPUT int Awesome_TickFilterMethod = 32;        // Tick filter method
INPUT float Awesome_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short Awesome_Shift = 0;                  // Shift (relative to the current bar, 0 - default)
INPUT float Awesome_OrderCloseLoss = 80;        // Order close loss
INPUT float Awesome_OrderCloseProfit = 80;      // Order close profit
INPUT int Awesome_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Awesome strategy: Awesome indicator params");
INPUT int Awesome_Indi_Awesome_Shift = 0;  // Shift

// Structs.
// Defines struct with default user strategy values.
struct Stg_Awesome_Params_Defaults : StgParams {
  Stg_Awesome_Params_Defaults()
      : StgParams(::Awesome_SignalOpenMethod, ::Awesome_SignalOpenFilterMethod, ::Awesome_SignalOpenLevel,
                  ::Awesome_SignalOpenBoostMethod, ::Awesome_SignalCloseMethod, ::Awesome_SignalCloseFilter,
                  ::Awesome_SignalCloseLevel, ::Awesome_PriceStopMethod, ::Awesome_PriceStopLevel,
                  ::Awesome_TickFilterMethod, ::Awesome_MaxSpread, ::Awesome_Shift) {
    Set(STRAT_PARAM_LS, Awesome_LotSize);
    Set(STRAT_PARAM_OCL, Awesome_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Awesome_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Awesome_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Awesome_SignalOpenFilterTime);
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

class Stg_Awesome : public Strategy {
 public:
  Stg_Awesome(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Awesome *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_Awesome_Params_Defaults stg_awesome_defaults;
    StgParams _stg_params(stg_awesome_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_awesome_m1, stg_awesome_m5, stg_awesome_m15, stg_awesome_m30,
                             stg_awesome_h1, stg_awesome_h4, stg_awesome_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Awesome(_stg_params, _tparams, _cparams, "Awesome");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiAOParams _indi_params(::Awesome_Indi_Awesome_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_AO(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_AO *_indi = GetIndicator();
    bool _result =
        _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) && _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 4);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Signal "saucer": 3 positive columns, medium column is smaller than 2 others.
        _result = _indi[_shift][0] < 0 && _indi.IsIncreasing(2, 0, _shift);
        _result &= _indi.IsIncByPct(_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        // @todo: Signal: Changing from negative values to positive.
        break;
      case ORDER_TYPE_SELL:
        // Signal "saucer": 3 negative columns, medium column is larger than 2 others.
        _result = _indi[_shift][0] > 0 && _indi.IsDecreasing(2, 0, _shift);
        _result &= _indi.IsDecByPct(-_level, 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        // @todo: Signal: Changing from positive values to negative.
        break;
    }
    return _result;
  }
};
