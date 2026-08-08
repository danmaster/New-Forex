/**
 * @file
 * Implements strategy based on the SVE Bollinger Bands indicator.
 */

// User input params.
INPUT_GROUP("SVE Bollinger Bands strategy: strategy params");
INPUT float SVE_Bollinger_Bands_LotSize = 0;                // Lot size
INPUT int SVE_Bollinger_Bands_SignalOpenMethod = 0;         // Signal open method
INPUT int SVE_Bollinger_Bands_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int SVE_Bollinger_Bands_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT float SVE_Bollinger_Bands_SignalOpenLevel = 1.0f;     // Signal open level
INPUT int SVE_Bollinger_Bands_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int SVE_Bollinger_Bands_SignalCloseMethod = 0;        // Signal close method
INPUT int SVE_Bollinger_Bands_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float SVE_Bollinger_Bands_SignalCloseLevel = 1.0f;    // Signal close level
INPUT int SVE_Bollinger_Bands_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float SVE_Bollinger_Bands_PriceStopLevel = 2;         // Price stop level
INPUT int SVE_Bollinger_Bands_TickFilterMethod = 32;        // Tick filter method
INPUT float SVE_Bollinger_Bands_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short SVE_Bollinger_Bands_Shift = 0;                  // Strategy Shift (relative to the current bar, 0 - default)
INPUT float SVE_Bollinger_Bands_OrderCloseLoss = 80;        // Order close loss
INPUT float SVE_Bollinger_Bands_OrderCloseProfit = 80;      // Order close profit
INPUT int SVE_Bollinger_Bands_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("SVE Bollinger Bands indicator params");
INPUT int Indi_SVE_Bollinger_Band_TEMAPeriod = 8;           // TEMA Period
INPUT int Indi_SVE_Bollinger_Band_SvePeriod = 18;           // SVE Period
INPUT double Indi_SVE_Bollinger_Band_BBUpDeviations = 1.6;  // BB Up Deviation
INPUT double Indi_SVE_Bollinger_Band_BBDnDeviations = 1.6;  // BB Down Deviation
INPUT int Indi_SVE_Bollinger_Band_DeviationsPeriod = 63;    // Deviations Period
INPUT int Indi_SVE_Bollinger_Band_Shift = 0;                // Indicator Shift

// Includes indicator file.
#include "Indi_SVE_Bollinger_Bands.mqh"

// Structs.

// Defines struct with default user strategy values.
struct Stg_SVE_Bollinger_Bands_Params_Defaults : StgParams {
  Stg_SVE_Bollinger_Bands_Params_Defaults()
      : StgParams(::SVE_Bollinger_Bands_SignalOpenMethod, ::SVE_Bollinger_Bands_SignalOpenFilterMethod,
                  ::SVE_Bollinger_Bands_SignalOpenLevel, ::SVE_Bollinger_Bands_SignalOpenBoostMethod,
                  ::SVE_Bollinger_Bands_SignalCloseMethod, ::SVE_Bollinger_Bands_SignalCloseFilter,
                  ::SVE_Bollinger_Bands_SignalCloseLevel, ::SVE_Bollinger_Bands_PriceStopMethod,
                  ::SVE_Bollinger_Bands_PriceStopLevel, ::SVE_Bollinger_Bands_TickFilterMethod,
                  ::SVE_Bollinger_Bands_MaxSpread, ::SVE_Bollinger_Bands_Shift) {
    Set(STRAT_PARAM_LS, SVE_Bollinger_Bands_LotSize);
    Set(STRAT_PARAM_OCL, SVE_Bollinger_Bands_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, SVE_Bollinger_Bands_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, SVE_Bollinger_Bands_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, SVE_Bollinger_Bands_SignalOpenFilterTime);
  }
};

#ifdef __config__
// Loads pair specific param values.
#include "config/H1.h"
#include "config/H4.h"
#include "config/M1.h"
#include "config/M15.h"
#include "config/M30.h"
#include "config/M5.h"
#endif

class Stg_SVE_Bollinger_Bands : public Strategy {
 public:
  Stg_SVE_Bollinger_Bands(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_SVE_Bollinger_Bands *Init(ENUM_TIMEFRAMES _tf = NULL, EA* _ea = NULL) {
    // Initialize strategy initial values.
    Stg_SVE_Bollinger_Bands_Params_Defaults stg_svebbands_defaults;
    StgParams _stg_params(stg_svebbands_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_svebbands_m1, stg_svebbands_m5, stg_svebbands_m15, stg_svebbands_m30,
                             stg_svebbands_h1, stg_svebbands_h4, stg_svebbands_h4);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_SVE_Bollinger_Bands(_stg_params, _tparams, _cparams, "SVE BB");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    IndiSVEBBParams _indi_params(::Indi_SVE_Bollinger_Band_TEMAPeriod, ::Indi_SVE_Bollinger_Band_SvePeriod,
                                 ::Indi_SVE_Bollinger_Band_BBUpDeviations, ::Indi_SVE_Bollinger_Band_BBDnDeviations,
                                 ::Indi_SVE_Bollinger_Band_DeviationsPeriod, ::Indi_SVE_Bollinger_Band_Shift);
    _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
    SetIndicator(new Indi_SVE_Bollinger_Bands(_indi_params));
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Indi_SVE_Bollinger_Bands *_indi = GetIndicator();
    int _ishift = ::Indi_SVE_Bollinger_Band_Shift;
    bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _ishift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    double level = _level * Chart().GetPipSize();
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result &= _indi[_ishift][(int)SVE_BAND_MAIN] < _indi[_ishift][(int)SVE_BAND_LOWER];
        _result &= _indi.IsIncreasing(1, SVE_BAND_MAIN, _ishift);
        _result &= _indi.IsIncByPct(_level, SVE_BAND_MAIN, _ishift, 1);
        break;
      case ORDER_TYPE_SELL:
        _result &= _indi[_ishift][(int)SVE_BAND_MAIN] > _indi[_ishift][(int)SVE_BAND_UPPER];
        _result &= _indi.IsDecreasing(1, SVE_BAND_MAIN, _ishift);
        _result &= _indi.IsDecByPct(_level, SVE_BAND_MAIN, _ishift, 1);
        break;
    }
    return _result;
  }
};
