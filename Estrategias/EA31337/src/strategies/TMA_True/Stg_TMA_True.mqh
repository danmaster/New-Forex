/**
 * @file
 * Implements TMA_True strategy based on the TMA_True indicator.
 */

// Includes.
#include "Indi_TMA_True.mqh"

// User input params.
INPUT_GROUP("TMA True strategy: strategy params");
INPUT float TMA_True_LotSize = 0;                // Lot size
INPUT int TMA_True_SignalOpenMethod = 0;         // Signal open method
INPUT int TMA_True_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int TMA_True_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT float TMA_True_SignalOpenLevel = 0.0f;     // Signal open level
INPUT int TMA_True_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int TMA_True_SignalCloseMethod = 0;        // Signal close method
INPUT int TMA_True_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float TMA_True_SignalCloseLevel = 0.0f;    // Signal close level
INPUT int TMA_True_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float TMA_True_PriceStopLevel = 2;         // Price stop level
INPUT int TMA_True_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT float TMA_True_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short TMA_True_Shift = 0;                  // Shift (relative to the current bar, 0 - default)
INPUT int TMA_True_OrderCloseLoss = 80;          // Order close loss
INPUT int TMA_True_OrderCloseProfit = 80;        // Order close profit
INPUT int TMA_True_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("TMA True: TMA True indicator params");
INPUT int TMA_True_Indi_TMA_True_Timeframe = 0;           // Timeframe
INPUT int TMA_True_Indi_TMA_True_HalfLength = 3;          // Half length
INPUT double TMA_True_Indi_TMA_True_AtrMultiplier = 1.5;  // ATR multiplier
INPUT int TMA_True_Indi_TMA_True_AtrPeriod = 6;           // ATR period
INPUT int TMA_True_Indi_TMA_True_BarsToProcess = 0;       // Bars to process
INPUT int TMA_True_Indi_TMA_True_Shift = 0;               // Indicator Shift

// Structs.

// Defines struct with default user strategy values.
struct Stg_TMA_True_Params_Defaults : StgParams {
  Stg_TMA_True_Params_Defaults()
      : StgParams(::TMA_True_SignalOpenMethod, ::TMA_True_SignalOpenFilterMethod, ::TMA_True_SignalOpenLevel,
                  ::TMA_True_SignalOpenBoostMethod, ::TMA_True_SignalCloseMethod, ::TMA_True_SignalCloseFilter,
                  ::TMA_True_SignalCloseLevel, ::TMA_True_PriceStopMethod, ::TMA_True_PriceStopLevel,
                  ::TMA_True_TickFilterMethod, ::TMA_True_MaxSpread, ::TMA_True_Shift) {
    Set(STRAT_PARAM_LS, TMA_True_LotSize);
    Set(STRAT_PARAM_OCL, TMA_True_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, TMA_True_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, TMA_True_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, TMA_True_SignalOpenFilterTime);
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

class Stg_TMA_True : public Strategy {
 public:
  Stg_TMA_True(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_TMA_True *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_TMA_True_Params_Defaults stg_tmat_defaults;
    StgParams _stg_params(stg_tmat_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_tmat_m1, stg_tmat_m5, stg_tmat_m15, stg_tmat_m30, stg_tmat_h1,
                             stg_tmat_h4, stg_tmat_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_TMA_True(_stg_params, _tparams, _cparams, "TMA True");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiTMATrueParams _indi_params(::TMA_True_Indi_TMA_True_Timeframe, ::TMA_True_Indi_TMA_True_HalfLength,
                                   ::TMA_True_Indi_TMA_True_AtrMultiplier, ::TMA_True_Indi_TMA_True_AtrPeriod,
                                   ::TMA_True_Indi_TMA_True_BarsToProcess, ::TMA_True_Indi_TMA_True_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_TMA_True(_indi_params), INDI_TMA_TRUE);
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_TMA_True *_indi = GetIndicator(INDI_TMA_TRUE);
    int _ishift = _shift + ::TMA_True_Indi_TMA_True_Shift;
    bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _ishift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    Chart *_chart = (Chart *)_indi;
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // TMA True
        _result &= _chart.GetLow(_ishift + 1) <= _indi[_ishift][(int)TMA_TRUE_LOWER];
        _result &= _indi.IsIncreasing(1, TMA_TRUE_MAIN, _ishift);
        _result &= _indi.IsIncByPct(_level, TMA_TRUE_MAIN, _ishift, 3);
        break;
      case ORDER_TYPE_SELL:
        _result &= _chart.GetHigh(_ishift + 1) >= _indi[_ishift][(int)TMA_TRUE_UPPER];
        _result &= _indi.IsDecreasing(1, TMA_TRUE_MAIN, _ishift);
        _result &= _indi.IsDecByPct(-_level, TMA_TRUE_MAIN, _ishift, 3);
        break;
    }
    return _result;
  }
};
