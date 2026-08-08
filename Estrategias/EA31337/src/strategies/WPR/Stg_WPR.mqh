/**
 * @file
 * Implements WPR strategy based on the Larry Williams' Percent Range indicator.
 */

// User input params.
INPUT_GROUP("WPR strategy: strategy params");
INPUT float WPR_LotSize = 0;                // Lot size
INPUT int WPR_SignalOpenMethod = 0;         // Signal open method (-127-127)
INPUT float WPR_SignalOpenLevel = 40;       // Signal open level
INPUT int WPR_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int WPR_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int WPR_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int WPR_SignalCloseMethod = 0;        // Signal close method (-127-127)
INPUT int WPR_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float WPR_SignalCloseLevel = 40;      // Signal close level
INPUT int WPR_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float WPR_PriceStopLevel = 2;         // Price stop level
INPUT int WPR_TickFilterMethod = 32;        // Tick filter method
INPUT float WPR_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short WPR_Shift = 0;                  // Shift
INPUT float WPR_OrderCloseLoss = 80;        // Order close loss
INPUT float WPR_OrderCloseProfit = 80;      // Order close profit
INPUT int WPR_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("WPR strategy: WPR indicator params");
INPUT int WPR_Indi_WPR_Period = 18;  // Period
INPUT int WPR_Indi_WPR_Shift = 0;    // Shift

// Structs.

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

// Structs.
// Defines struct with default user strategy values.
struct Stg_WPR_Params_Defaults : StgParams {
  Stg_WPR_Params_Defaults()
      : StgParams(::WPR_SignalOpenMethod, ::WPR_SignalOpenFilterMethod, ::WPR_SignalOpenLevel,
                  ::WPR_SignalOpenBoostMethod, ::WPR_SignalCloseMethod, ::WPR_SignalCloseFilter, ::WPR_SignalCloseLevel,
                  ::WPR_PriceStopMethod, ::WPR_PriceStopLevel, ::WPR_TickFilterMethod, ::WPR_MaxSpread, ::WPR_Shift) {
    Set(STRAT_PARAM_LS, WPR_LotSize);
    Set(STRAT_PARAM_OCL, WPR_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, WPR_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, WPR_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, WPR_SignalOpenFilterTime);
  }
};

class Stg_WPR : public Strategy {
 public:
  Stg_WPR(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_WPR *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_WPR_Params_Defaults stg_wpr_defaults;
    StgParams _stg_params(stg_wpr_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_wpr_m1, stg_wpr_m5, stg_wpr_m15, stg_wpr_m30, stg_wpr_h1, stg_wpr_h4,
                             stg_wpr_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_WPR(_stg_params, _tparams, _cparams, "WPR");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiWPRParams _indi_params(::WPR_Indi_WPR_Period, ::WPR_Indi_WPR_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_WPR(_indi_params));
  }

  /**
   * Check if WPR indicator is on buy or sell.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_WPR *_indi = GetIndicator();
    bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy: Value below level.
        // Buy: crossing level upwards.
        _result &= _indi[_shift][0] > -50 - _level && _indi.GetMin<double>(_shift, 4) < -50 - _level;
        _result &= _indi.IsIncreasing(1, 0, _shift);
        _result &= _indi.IsIncByPct(fabs(_level / 10), 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell: Value above level.
        // Sell: crossing level downwards.
        _result &= _indi[_shift][0] < -50 + _level && _indi.GetMax<double>(_shift, 4) > -50 + _level;
        _result &= _indi.IsDecreasing(1, 0, _shift);
        _result &= _indi.IsDecByPct(fabs(_level / 10), 0, _shift, 3);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
