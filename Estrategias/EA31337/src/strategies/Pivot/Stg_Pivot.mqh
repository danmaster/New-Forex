/**
 * @file
 * Implements Pivot strategy based on the Pivot indicator.
 */

// User input params.
INPUT_GROUP("Pivot strategy: strategy params");
INPUT float Pivot_LotSize = 0;                // Lot size
INPUT int Pivot_SignalOpenMethod = 0;         // Signal open method
INPUT float Pivot_SignalOpenLevel = 0.00f;    // Signal open level
INPUT int Pivot_SignalOpenFilterMethod = 40;  // Signal open filter method
INPUT int Pivot_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT int Pivot_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int Pivot_SignalCloseMethod = 0;        // Signal close method
INPUT int Pivot_SignalCloseFilter = 3;        // Signal close filter (-127-127)
INPUT float Pivot_SignalCloseLevel = 0.00f;   // Signal close level
INPUT int Pivot_PriceStopMethod = 0;          // Price limit method
INPUT float Pivot_PriceStopLevel = 2;         // Price limit level
INPUT int Pivot_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT float Pivot_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short Pivot_Shift = 1;                  // Shift
INPUT float Pivot_OrderCloseLoss = 80;        // Order close loss
INPUT float Pivot_OrderCloseProfit = 80;      // Order close profit
INPUT int Pivot_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Pivot strategy: Pivot indicator params");
INPUT ENUM_PP_TYPE Pivot_Indi_Pivot_Type = PP_CAMARILLA;                   // Calculation method
INPUT int Pivot_Indi_Pivot_Shift = 1;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Pivot_Indi_Pivot_SourceType = IDATA_BUILTIN;  // Source type

// Enums.
enum INDI_PIVOT_MODE {
  INDI_PIVOT_PP = 0,
  INDI_PIVOT_R1,
  INDI_PIVOT_R2,
  INDI_PIVOT_R3,
  INDI_PIVOT_R4,
  INDI_PIVOT_S1,
  INDI_PIVOT_S2,
  INDI_PIVOT_S3,
  INDI_PIVOT_S4,
};

// Structs.

// Defines struct with default user strategy values.
struct Stg_Pivot_Params_Defaults : StgParams {
  Stg_Pivot_Params_Defaults()
      : StgParams(::Pivot_SignalOpenMethod, ::Pivot_SignalOpenFilterMethod, ::Pivot_SignalOpenLevel,
                  ::Pivot_SignalOpenBoostMethod, ::Pivot_SignalCloseMethod, ::Pivot_SignalCloseFilter,
                  ::Pivot_SignalCloseLevel, ::Pivot_PriceStopMethod, ::Pivot_PriceStopLevel, ::Pivot_TickFilterMethod,
                  ::Pivot_MaxSpread, ::Pivot_Shift) {
    Set(STRAT_PARAM_LS, Pivot_LotSize);
    Set(STRAT_PARAM_OCL, Pivot_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Pivot_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Pivot_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Pivot_SignalOpenFilterTime);
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

class Stg_Pivot : public Strategy {
 public:
  Stg_Pivot(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Pivot *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_Pivot_Params_Defaults stg_pivot_defaults;
    StgParams _stg_params(stg_pivot_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_pivot_m1, stg_pivot_m5, stg_pivot_m15, stg_pivot_m30, stg_pivot_h1,
                             stg_pivot_h4, stg_pivot_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Pivot(_stg_params, _tparams, _cparams, "Pivot");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiPivotParams _indi_params(::Pivot_Indi_Pivot_Type, ::Pivot_Indi_Pivot_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_Pivot(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    Indi_Pivot *_indi = GetIndicator();
    Chart *_chart = (Chart *)_indi;
    int _pp_shift = ::Pivot_Shift;  // @fixme
    bool _result =
        _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _pp_shift) && _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _pp_shift + 3);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    // IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    IndicatorDataEntry _entry = _indi[_pp_shift + 1];
    float _curr_price = (float)_chart.GetPrice(PRICE_TYPICAL, _pp_shift);
    float _pp = _entry.GetValue<float>((int)INDI_PIVOT_PP);
    float _r1 = _entry.GetValue<float>((int)INDI_PIVOT_R1);
    float _r2 = _entry.GetValue<float>((int)INDI_PIVOT_R2);
    float _r3 = _entry.GetValue<float>((int)INDI_PIVOT_R3);
    float _r4 = _entry.GetValue<float>((int)INDI_PIVOT_R4);
    float _s1 = _entry.GetValue<float>((int)INDI_PIVOT_S1);
    float _s2 = _entry.GetValue<float>((int)INDI_PIVOT_S2);
    float _s3 = _entry.GetValue<float>((int)INDI_PIVOT_S3);
    float _s4 = _entry.GetValue<float>((int)INDI_PIVOT_S4);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= (_curr_price < _s1 - ((_s1 - _s2) / 2) && _curr_price > _s2) ||
                   (_curr_price < _s2 - ((_s2 - _s3) / 2) && _curr_price > _s3) ||
                   (_curr_price < _s3 - ((_s3 - _s4) / 2) && _curr_price > _s4);
        _result &= _indi.IsDecByPct(-_level, (int)INDI_PIVOT_S1, _pp_shift, 4);
        //_result &= _indi.IsIncreasing(1, (int)INDI_PIVOT_PP, _pp_shift);
        //_result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= (_curr_price > _r1 + ((_r2 - _r1) / 2) && _curr_price < _r2) ||
                   (_curr_price > _r2 + ((_r3 - _r2) / 2) && _curr_price < _r3) ||
                   (_curr_price > _r3 + ((_r4 - _r3) / 2) && _curr_price < _r4);
        _result &= _indi.IsIncByPct(_level, (int)INDI_PIVOT_R1, _pp_shift, 4);
        //_result &= _indi.IsDecreasing(1, (int)INDI_PIVOT_PP, _pp_shift);
        //_result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
