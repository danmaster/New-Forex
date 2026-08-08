/**
 * @file
 * Implements CCI strategy based on the Commodity Channel Index indicator.
 */

// User input params.
INPUT_GROUP("CCI strategy: strategy params");
INPUT float CCI_LotSize = 0;                // Lot size
INPUT int CCI_SignalOpenMethod = 10;        // Signal open method (-127-127)
INPUT float CCI_SignalOpenLevel = 90.0;     // Signal open level (-100-100)
INPUT int CCI_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int CCI_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int CCI_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int CCI_SignalCloseMethod = 10;       // Signal close method (-127-127)
INPUT int CCI_SignalCloseFilter = 0;        // Signal close filter (-127-127)
INPUT float CCI_SignalCloseLevel = 90.0;    // Signal close level (-100-100)
INPUT int CCI_PriceStopMethod = 1;          // Price stop method (0-6)
INPUT float CCI_PriceStopLevel = 2;         // Price stop level
INPUT int CCI_TickFilterMethod = 32;        // Tick filter method
INPUT float CCI_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short CCI_Shift = 1;                  // Shift (0 for default)
INPUT float CCI_OrderCloseLoss = 80;        // Order close loss
INPUT float CCI_OrderCloseProfit = 80;      // Order close profit
INPUT int CCI_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("CCI strategy: CCI indicator params");
INPUT int CCI_Indi_CCI_Period = 20;                                   // Period
INPUT ENUM_APPLIED_PRICE CCI_Indi_CCI_Applied_Price = PRICE_TYPICAL;  // Applied Price
INPUT int CCI_Indi_CCI_Shift = 0;                                     // Shift

// Structs.

// Defines struct with default user strategy values.
struct Stg_CCI_Params_Defaults : StgParams {
  Stg_CCI_Params_Defaults()
      : StgParams(::CCI_SignalOpenMethod, ::CCI_SignalOpenFilterMethod, ::CCI_SignalOpenLevel,
                  ::CCI_SignalOpenBoostMethod, ::CCI_SignalCloseMethod, ::CCI_SignalCloseFilter, ::CCI_SignalCloseLevel,
                  ::CCI_PriceStopMethod, ::CCI_PriceStopLevel, ::CCI_TickFilterMethod, ::CCI_MaxSpread, ::CCI_Shift) {
    Set(STRAT_PARAM_LS, CCI_LotSize);
    Set(STRAT_PARAM_OCL, CCI_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, CCI_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, CCI_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, CCI_SignalOpenFilterTime);
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

class Stg_CCI : public Strategy {
 public:
  Stg_CCI(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_CCI *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_CCI_Params_Defaults stg_cci_defaults;
    StgParams _stg_params(stg_cci_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_cci_m1, stg_cci_m5, stg_cci_m15, stg_cci_m30, stg_cci_h1, stg_cci_h4,
                             stg_cci_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_CCI(_stg_params, _tparams, _cparams, "CCI");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiCCIParams _indi_params(::CCI_Indi_CCI_Period, ::CCI_Indi_CCI_Applied_Price, ::CCI_Indi_CCI_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_CCI(_indi_params));
  }

  /**
   * Check if CCI indicator is on buy or sell.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_CCI *_indi = GetIndicator();
    Chart *_chart = (Chart *)_indi;
    bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result = _indi[CURR][0] < -_level;
        _result &= _indi.IsIncreasing(2, 0, _shift);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        _result = _indi[CURR][0] > _level;
        _result &= _indi.IsDecreasing(2, 0, _shift);
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
