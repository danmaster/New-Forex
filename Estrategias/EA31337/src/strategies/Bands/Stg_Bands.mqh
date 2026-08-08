/**
 * @file
 * Implements Bands strategy based on the price range indicators.
 */

enum ENUM_STG_BANDS_TYPE {
  STG_BANDS_TYPE_0_NONE = 0,  // (None)
  STG_BANDS_TYPE_BBANDS,      // Bollinger Bands
  STG_BANDS_TYPE_ENVELOPES,   // Envelopes
};

// User input params.
INPUT_GROUP("Bands strategy: main strategy params");
INPUT ENUM_STG_BANDS_TYPE Bands_Type = STG_BANDS_TYPE_BBANDS;  // Indicator type
INPUT_GROUP("Bands strategy: strategy params");
INPUT float Bands_LotSize = 0;                // Lot size
INPUT int Bands_SignalOpenMethod = 115;       // Signal open method (-255-255)
INPUT float Bands_SignalOpenLevel = 2.0f;     // Signal open level
INPUT int Bands_SignalOpenFilterMethod = 32;  // Signal open filter method (-49-49)
INPUT int Bands_SignalOpenFilterTime = 3;     // Signal open filter time (-49-49)
INPUT int Bands_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int Bands_SignalCloseMethod = 1;        // Signal close method (-255-255)
INPUT int Bands_SignalCloseFilter = 0;        // Signal close filter (-127-127)
INPUT float Bands_SignalCloseLevel = 2.0f;    // Signal close level
INPUT int Bands_PriceStopMethod = 1;          // Price stop method (0-6)
INPUT float Bands_PriceStopLevel = 2;         // Price stop level
INPUT int Bands_TickFilterMethod = 32;        // Tick filter method
INPUT float Bands_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short Bands_Shift = 0;                  // Shift (relative to the current bar, 0 - default)
INPUT float Bands_OrderCloseLoss = 80;        // Order close loss
INPUT float Bands_OrderCloseProfit = 80;      // Order close profit
INPUT int Bands_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Bands strategy: Bollinger Bands indicator params");
INPUT int Bands_Indi_Bands_Period = 24;                                // Period
INPUT float Bands_Indi_Bands_Deviation = 1.0f;                         // Deviation
INPUT int Bands_Indi_Bands_HShift = 0;                                 // Horizontal shift
INPUT ENUM_APPLIED_PRICE Bands_Indi_Bands_Applied_Price = PRICE_OPEN;  // Applied Price
INPUT int Bands_Indi_Bands_Shift = 0;                                  // Shift
INPUT ENUM_BANDS_LINE Bands_Indi_Bands_Mode_Base = BAND_BASE;          // Mode for base band
INPUT ENUM_BANDS_LINE Bands_Indi_Bands_Mode_Lower = BAND_LOWER;        // Mode for lower band
INPUT ENUM_BANDS_LINE Bands_Indi_Bands_Mode_Upper = BAND_UPPER;        // Mode for upper band
INPUT_GROUP("Bands strategy: Envelopes indicator params");
INPUT int Bands_Indi_Envelopes_MA_Period = 20;                             // Period
INPUT int Bands_Indi_Envelopes_MA_Shift = 0;                               // MA Shift
INPUT ENUM_MA_METHOD Bands_Indi_Envelopes_MA_Method = (ENUM_MA_METHOD)1;   // MA Method
INPUT ENUM_APPLIED_PRICE Bands_Indi_Envelopes_Applied_Price = PRICE_OPEN;  // Applied Price
INPUT float Bands_Indi_Envelopes_Deviation = 0.1f;                         // Deviation
INPUT int Bands_Indi_Envelopes_Shift = 0;                                  // Shift
INPUT ENUM_SIGNAL_LINE Bands_Indi_Envelopes_Mode_Base = LINE_MAIN;         // Mode for base band
INPUT ENUM_LO_UP_LINE Bands_Indi_Envelopes_Mode_Lower = LINE_LOWER;        // Mode for lower band
INPUT ENUM_LO_UP_LINE Bands_Indi_Envelopes_Mode_Upper = LINE_UPPER;        // Mode for upper band

// Structs.

// Defines struct with default user strategy values.
struct Stg_Bands_Params_Defaults : StgParams {
  int mode_base, mode_lower, mode_upper;
  Stg_Bands_Params_Defaults()
      : StgParams(::Bands_SignalOpenMethod, ::Bands_SignalOpenFilterMethod, ::Bands_SignalOpenLevel,
                  ::Bands_SignalOpenBoostMethod, ::Bands_SignalCloseMethod, ::Bands_SignalCloseFilter,
                  ::Bands_SignalCloseLevel, ::Bands_PriceStopMethod, ::Bands_PriceStopLevel, ::Bands_TickFilterMethod,
                  ::Bands_MaxSpread, ::Bands_Shift) {
    Set(STRAT_PARAM_LS, Bands_LotSize);
    Set(STRAT_PARAM_OCL, Bands_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Bands_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Bands_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Bands_SignalOpenFilterTime);
  }
  // Getters.
  int GetModeBase() { return mode_base; }
  int GetModeLower() { return mode_lower; }
  int GetModeUpper() { return mode_upper; }
  // Setters.
  void SetModeBase(int _value) { mode_base = _value; }
  void SetModeLower(int _value) { mode_lower = _value; }
  void SetModeUpper(int _value) { mode_upper = _value; }
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

class Stg_Bands : public Strategy {
 protected:
  Stg_Bands_Params_Defaults ssparams;

 public:
  Stg_Bands(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Bands *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_Bands_Params_Defaults stg_bands_defaults;
    StgParams _stg_params(stg_bands_defaults);
#ifdef __config__
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_bands_m1, stg_bands_m5, stg_bands_m15, stg_bands_m30, stg_bands_h1,
                             stg_bands_h4, stg_bands_h8);
#endif
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Bands(_stg_params, _tparams, _cparams, "Bands");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    // Initialize indicators.
    switch (Bands_Type) {
      case STG_BANDS_TYPE_BBANDS:  // Bollinger Bands
      {
        IndiBandsParams _indi_params(::Bands_Indi_Bands_Period, ::Bands_Indi_Bands_Deviation, ::Bands_Indi_Bands_HShift,
                                     ::Bands_Indi_Bands_Applied_Price, ::Bands_Indi_Bands_Shift);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_Bands(_indi_params), ::Bands_Type);
        ssparams.SetModeBase(::Bands_Indi_Bands_Mode_Base);
        ssparams.SetModeLower(::Bands_Indi_Bands_Mode_Lower);
        ssparams.SetModeUpper(::Bands_Indi_Bands_Mode_Upper);
        break;
      }
      case STG_BANDS_TYPE_ENVELOPES:  // Envelopes
      {
        IndiEnvelopesParams _indi_params(::Bands_Indi_Envelopes_MA_Period, ::Bands_Indi_Envelopes_MA_Shift,
                                         ::Bands_Indi_Envelopes_MA_Method, ::Bands_Indi_Envelopes_Applied_Price,
                                         ::Bands_Indi_Envelopes_Deviation, ::Bands_Indi_Envelopes_Shift);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_Envelopes(_indi_params), ::Bands_Type);
        ssparams.SetModeBase(::Bands_Indi_Envelopes_Mode_Base);
        ssparams.SetModeLower(::Bands_Indi_Envelopes_Mode_Lower);
        ssparams.SetModeUpper(::Bands_Indi_Envelopes_Mode_Upper);
        break;
      }
      case STG_BANDS_TYPE_0_NONE:  // (None)
      default:
        break;
    }
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    IndicatorBase *_indi = GetIndicator(Bands_Type);
    Chart *_chart = (Chart *)_indi;
    // bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, 0) && _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, 1); //
    // @fixme
    bool _result = true;
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    int _ishift = _shift;
    int _mode_base = ssparams.GetModeBase();
    int _mode_lower = ssparams.GetModeLower();
    int _mode_upper = ssparams.GetModeUpper();
    double _change_pc = Math::ChangeInPct(_indi[1][(int)_mode_base], _indi[0][(int)_mode_base], true);
    float _level_pips = (float)(_level * _chart.GetPipSize());
    switch (_cmd) {
      // Buy: price crossed lower line upwards (returned to it from below).
      case ORDER_TYPE_BUY: {
        // Price value was lower than the lower band.
        double lowest_price = fmin3(_chart.GetLow(_ishift), _chart.GetLow(_ishift + 1), _chart.GetLow(_ishift + 2));
        _result =
            (lowest_price + _level_pips < fmax3(_indi[_ishift][(int)_mode_lower], _indi[_ishift + 1][(int)_mode_lower],
                                                _indi[_ishift + 2][(int)_mode_lower]));
        // _result &= _change_pc > _level;
        if (_result && _method != 0) {
          if (METHOD(_method, 0))
            _result &= fmax4(_indi[_ishift][(int)_mode_base], _indi[_ishift + 1][(int)_mode_base],
                             _indi[_ishift + 2][(int)_mode_base],
                             _indi[_ishift + 3][(int)_mode_base]) == _indi[_ishift][(int)_mode_base];
          if (METHOD(_method, 1))
            _result &= fmin(Close[_ishift + 1], Close[_ishift + 2]) < _indi[_ishift][(int)_mode_lower];
          if (METHOD(_method, 2)) _result &= (_indi[_ishift][(int)_mode_lower] > _indi[_ishift + 2][(int)_mode_lower]);
          if (METHOD(_method, 3)) _result &= (_indi[_ishift][(int)_mode_base] > _indi[_ishift + 2][(int)_mode_base]);
          if (METHOD(_method, 4)) _result &= (_indi[_ishift][(int)_mode_upper] > _indi[_ishift + 2][(int)_mode_upper]);
          if (METHOD(_method, 5)) _result &= lowest_price < _indi[_ishift][(int)_mode_base];
          if (METHOD(_method, 6)) _result &= Open[_ishift] < _indi[_ishift][(int)_mode_base];
          if (METHOD(_method, 7))
            _result &= fmin(Close[_ishift + 1], Close[_ishift + 2]) > _indi[_ishift][(int)_mode_base];
        }
        break;
      }
      // Sell: price crossed upper line downwards (returned to it from above).
      case ORDER_TYPE_SELL: {
        // Price value was higher than the upper band.
        double highest_price = fmax3(_chart.GetHigh(_ishift), _chart.GetHigh(_ishift + 1), _chart.GetHigh(_ishift + 2));
        _result =
            (highest_price - _level_pips > fmin3(_indi[_ishift][(int)_mode_upper], _indi[_ishift + 1][(int)_mode_upper],
                                                 _indi[_ishift + 2][(int)_mode_upper]));
        // _result &= _change_pc < -_level;
        if (_result && _method != 0) {
          if (METHOD(_method, 0))
            _result &= fmin4(_indi[_ishift][(int)_mode_base], _indi[_ishift + 1][(int)_mode_base],
                             _indi[_ishift + 2][(int)_mode_base],
                             _indi[_ishift + 3][(int)_mode_base]) == _indi[_ishift][(int)_mode_base];
          if (METHOD(_method, 1))
            _result &= fmin(Close[_ishift + 1], Close[_ishift + 2]) > _indi[_ishift][(int)_mode_upper];
          if (METHOD(_method, 2)) _result &= (_indi[_ishift][(int)_mode_lower] < _indi[_ishift + 2][(int)_mode_lower]);
          if (METHOD(_method, 3)) _result &= (_indi[_ishift][(int)_mode_base] < _indi[_ishift + 2][(int)_mode_base]);
          if (METHOD(_method, 4)) _result &= (_indi[_ishift][(int)_mode_upper] < _indi[_ishift + 2][(int)_mode_upper]);
          if (METHOD(_method, 5)) _result &= highest_price > _indi[_ishift][(int)_mode_base];
          if (METHOD(_method, 6)) _result &= Open[_ishift] > _indi[_ishift][(int)_mode_base];
          if (METHOD(_method, 7))
            _result &= fmin(Close[_ishift + 1], Close[_ishift + 2]) < _indi[_ishift][(int)_mode_base];
        }
        break;
      }
    }
    return _result;
  }
};
