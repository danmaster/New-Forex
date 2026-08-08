/**
 * @file
 * Implements Arrows strategy based on the price-arrow-type indicators.
 */

enum ENUM_STG_ARROWS_TYPE {
  STG_ARROWS_TYPE_0_NONE = 0,  // (None)
  // STG_ARROWS_TYPE_ATR_MA_SLOPE,  // ATR MA Slope
  STG_ARROWS_TYPE_FRACTALS,  // Fractals
};

// Includes.
#include "Indi_ATR_MA_Slope.mqh"

// User input params.
INPUT_GROUP("Arrows strategy: main strategy params");
INPUT ENUM_STG_ARROWS_TYPE Arrows_Type = STG_ARROWS_TYPE_FRACTALS;  // Indicator type
INPUT_GROUP("Arrows strategy: strategy params");
INPUT float Arrows_LotSize = 0;                // Lot size
INPUT int Arrows_SignalOpenMethod = 0;         // Signal open method
INPUT float Arrows_SignalOpenLevel = 0;        // Signal open level
INPUT int Arrows_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int Arrows_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT int Arrows_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int Arrows_SignalCloseMethod = 0;        // Signal close method
INPUT int Arrows_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float Arrows_SignalCloseLevel = 0;       // Signal close level
INPUT int Arrows_PriceStopMethod = 0;          // Price limit method
INPUT float Arrows_PriceStopLevel = 2;         // Price limit level
INPUT int Arrows_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT float Arrows_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short Arrows_Shift = 0;                  // Shift
INPUT float Arrows_OrderCloseLoss = 80;        // Order close loss
INPUT float Arrows_OrderCloseProfit = 80;      // Order close profit
INPUT int Arrows_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
/*
INPUT_GROUP("Arrows strategy: ATR_MA_Slope indicator params");
INPUT int Arrows_Indi_ATR_MA_Slope_NumberOfBars = 100;                                  // Number of bars to process
INPUT double Arrows_Indi_ATR_MA_Slope_SlopeThreshold = 2.0;                             // Slope threshold
INPUT int Arrows_Indi_ATR_MA_Slope_SlopeMAPeriod = 7;                                   // MA Period
INPUT int Arrows_Indi_ATR_MA_Slope_SlopeATRPeriod = 50;                                 // ATR Period
INPUT int Arrows_Indi_ATR_MA_Slope_Shift = 0;                                           // Shift
INPUT ENUM_ATR_MA_SLOPE_MODE Arrows_Indi_ATR_MA_Slope_Mode_Long = ATR_MA_SLOPE_LONG;    // Mode for long
INPUT ENUM_ATR_MA_SLOPE_MODE Arrows_Indi_ATR_MA_Slope_Mode_Short = ATR_MA_SLOPE_SHORT;  // Mode for short
*/
INPUT_GROUP("Arrows strategy: Fractals indicator params");
INPUT int Arrows_Indi_Fractals_Shift = 2;                            // Shift
INPUT ENUM_LO_UP_LINE Arrows_Indi_Fractals_Mode_Long = LINE_LOWER;   // Mode for long
INPUT ENUM_LO_UP_LINE Arrows_Indi_Fractals_Mode_Short = LINE_UPPER;  // Mode for short

// Structs.

// Defines struct with default user strategy values.
struct Stg_Arrows_Params_Defaults : StgParams {
  uint mode_long, mode_short;
  Stg_Arrows_Params_Defaults()
      : StgParams(::Arrows_SignalOpenMethod, ::Arrows_SignalOpenFilterMethod, ::Arrows_SignalOpenLevel,
                  ::Arrows_SignalOpenBoostMethod, ::Arrows_SignalCloseMethod, ::Arrows_SignalCloseFilter,
                  ::Arrows_SignalCloseLevel, ::Arrows_PriceStopMethod, ::Arrows_PriceStopLevel,
                  ::Arrows_TickFilterMethod, ::Arrows_MaxSpread, ::Arrows_Shift) {
    Set(STRAT_PARAM_LS, Arrows_LotSize);
    Set(STRAT_PARAM_OCL, Arrows_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Arrows_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Arrows_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Arrows_SignalOpenFilterTime);
  }
  // Getters.
  uint GetModeLong() { return mode_long; }
  uint GetModeShort() { return mode_short; }
  // Setters.
  void SetModeLong(uint _value) { mode_long = _value; }
  void SetModeShort(uint _value) { mode_short = _value; }
};

class Stg_Arrows : public Strategy {
 protected:
  Stg_Arrows_Params_Defaults ssparams;

 public:
  Stg_Arrows(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Arrows *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_Arrows_Params_Defaults stg_arrows_defaults;
    StgParams _stg_params(stg_arrows_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Arrows(_stg_params, _tparams, _cparams, "Arrows");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    // Initialize indicators.
    switch (Arrows_Type) {
        /*
          case STG_ARROWS_TYPE_ATR_MA_SLOPE:  // ATR MA Slope
          {
            IndiAtrMaSlopeParams _indi_params(::Arrows_Indi_ATR_MA_Slope_NumberOfBars,
                                              ::Arrows_Indi_ATR_MA_Slope_SlopeThreshold,
                                              ::Arrows_Indi_ATR_MA_Slope_SlopeMAPeriod,
                                              ::Arrows_Indi_ATR_MA_Slope_SlopeATRPeriod,
          ::Arrows_Indi_ATR_MA_Slope_Shift); _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF)); SetIndicator(new
          Indi_ATR_MA_Slope(_indi_params), ::Arrows_Type); ssparams.SetModeLong(::Arrows_Indi_ATR_MA_Slope_Mode_Long);
            ssparams.SetModeShort(::Arrows_Indi_ATR_MA_Slope_Mode_Short);
            break;
          }
          */
      case STG_ARROWS_TYPE_FRACTALS:  // Fractals
      {
        IndiFractalsParams _indi_params(::Arrows_Indi_Fractals_Shift);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_Fractals(_indi_params), ::Arrows_Type);
        ssparams.SetModeLong(::Arrows_Indi_Fractals_Mode_Long);
        ssparams.SetModeShort(::Arrows_Indi_Fractals_Mode_Short);
        break;
      }
      case STG_ARROWS_TYPE_0_NONE:  // (None)
      default:
        break;
    }
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    IndicatorBase *_indi = GetIndicator(::Arrows_Type);
    uint _ishift = _shift + ::Arrows_Indi_Fractals_Shift;  // @todo: _indi.GetShift();
    // bool _result =
    // _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _ishift) && _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _ishift + 1);
    bool _result = true;
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    // IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    int _mode_long = (int)ssparams.GetModeLong();
    int _mode_short = (int)ssparams.GetModeShort();
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _indi[_ishift][_mode_long] != 0.0 && _indi[_ishift][_mode_long] != DBL_MAX;
        // @fixme
        // _result &= _indi[_ishift][(int)ATR_MA_SLOPE_LONG] > 0 && !_indi[_ishift][(int)ATR_MA_SLOPE_LONG] != DBL_MAX;
        // _result &= _indi.IsIncreasing(1, ATR_MA_SLOPE_SLOPE, _ishift);
        //_result &= _indi.IsIncByPct(_level / 10, 0, _shift, 2);
        //_result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _indi[_ishift][_mode_short] != 0.0 && _indi[_ishift][_mode_short] != DBL_MAX;
        // @fixme
        // _result &= _indi[_ishift][(int)ATR_MA_SLOPE_SHORT] > 0 && !_indi[_ishift][(int)ATR_MA_SLOPE_SHORT] !=
        // DBL_MAX; _result &= _indi.IsDecreasing(1, ATR_MA_SLOPE_SLOPE, _ishift);
        //_result &= _indi.IsDecByPct(_level / 10, 0, _shift, 2);
        //_result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }
};
