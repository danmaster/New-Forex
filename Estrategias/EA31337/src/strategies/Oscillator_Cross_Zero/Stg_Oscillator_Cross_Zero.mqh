/**
 * @file
 * Implements Oscillator Cross Zero strategy based on selected oscillator-type zero-crossable indicators.
 */

// Enums.

enum ENUM_STG_OSCILLATOR_CROSS_ZERO_TYPE {
  STG_OSCILLATOR_CROSS_ZERO_TYPE_0_NONE = 0,  // (None)
  STG_OSCILLATOR_CROSS_ZERO_TYPE_MACD,        // MACD
  STG_OSCILLATOR_CROSS_ZERO_TYPE_RVI,         // RVI: Relative Vigor Index
};

// User input params.
INPUT_GROUP("Oscillator Cross Zero strategy: main strategy params");
INPUT ENUM_STG_OSCILLATOR_CROSS_ZERO_TYPE Oscillator_Cross_Zero_Type =
    STG_OSCILLATOR_CROSS_ZERO_TYPE_RVI;  // Oscillator type
INPUT_GROUP("Oscillator Cross Zero strategy: strategy params");
INPUT float Oscillator_Cross_Zero_LotSize = 0;                // Lot size
INPUT int Oscillator_Cross_Zero_SignalOpenMethod = 0;         // Signal open method
INPUT float Oscillator_Cross_Zero_SignalOpenLevel = 0.1f;     // Signal open level
INPUT int Oscillator_Cross_Zero_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int Oscillator_Cross_Zero_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT int Oscillator_Cross_Zero_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int Oscillator_Cross_Zero_SignalCloseMethod = 0;        // Signal close method
INPUT int Oscillator_Cross_Zero_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float Oscillator_Cross_Zero_SignalCloseLevel = 0.1f;    // Signal close level
INPUT int Oscillator_Cross_Zero_PriceStopMethod = 0;          // Price limit method
INPUT float Oscillator_Cross_Zero_PriceStopLevel = 2;         // Price limit level
INPUT int Oscillator_Cross_Zero_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT float Oscillator_Cross_Zero_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short Oscillator_Cross_Zero_Shift = 0;                  // Shift
INPUT float Oscillator_Cross_Zero_OrderCloseLoss = 80;        // Order close loss
INPUT float Oscillator_Cross_Zero_OrderCloseProfit = 80;      // Order close profit
INPUT int Oscillator_Cross_Zero_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Oscillator strategy: MACD indicator params");
INPUT ENUM_SIGNAL_LINE Oscillator_Cross_Zero_Indi_MACD_Line_Signal = LINE_SIGNAL;     // Signal line
INPUT int Oscillator_Cross_Zero_Indi_MACD_Period_Fast = 6;                            // Period Fast
INPUT int Oscillator_Cross_Zero_Indi_MACD_Period_Slow = 34;                           // Period Slow
INPUT int Oscillator_Cross_Zero_Indi_MACD_Period_Signal = 10;                         // Period Signal
INPUT ENUM_APPLIED_PRICE Oscillator_Cross_Zero_Indi_MACD_Applied_Price = PRICE_OPEN;  // Applied Price
INPUT int Oscillator_Cross_Zero_Indi_MACD_Shift = 0;                                  // Shift
INPUT_GROUP("Oscillator strategy: RVI indicator params");
INPUT ENUM_SIGNAL_LINE Oscillator_Cross_Zero_Indi_RVI_Line_Signal = LINE_SIGNAL;         // Fast line
INPUT unsigned int Oscillator_Cross_Zero_Indi_RVI_Period = 12;                           // Averaging period
INPUT int Oscillator_Cross_Zero_Indi_RVI_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Cross_Zero_Indi_RVI_SourceType = IDATA_BUILTIN;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_Oscillator_Cross_Zero_Params_Defaults : StgParams {
  uint line_signal;
  Stg_Oscillator_Cross_Zero_Params_Defaults()
      : StgParams(::Oscillator_Cross_Zero_SignalOpenMethod, ::Oscillator_Cross_Zero_SignalOpenFilterMethod,
                  ::Oscillator_Cross_Zero_SignalOpenLevel, ::Oscillator_Cross_Zero_SignalOpenBoostMethod,
                  ::Oscillator_Cross_Zero_SignalCloseMethod, ::Oscillator_Cross_Zero_SignalCloseFilter,
                  ::Oscillator_Cross_Zero_SignalCloseLevel, ::Oscillator_Cross_Zero_PriceStopMethod,
                  ::Oscillator_Cross_Zero_PriceStopLevel, ::Oscillator_Cross_Zero_TickFilterMethod,
                  ::Oscillator_Cross_Zero_MaxSpread, ::Oscillator_Cross_Zero_Shift),
        line_signal(0) {
    Set(STRAT_PARAM_LS, ::Oscillator_Cross_Zero_LotSize);
    Set(STRAT_PARAM_OCL, ::Oscillator_Cross_Zero_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, ::Oscillator_Cross_Zero_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, ::Oscillator_Cross_Zero_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, ::Oscillator_Cross_Zero_SignalOpenFilterTime);
  }
  // Getters.
  uint GetLineSignal() { return line_signal; }
  // Setters.
  void SetLineSignal(uint _value) { line_signal = _value; }
};

class Stg_Oscillator_Cross_Zero : public Strategy {
 protected:
  Stg_Oscillator_Cross_Zero_Params_Defaults ssparams;

 public:
  Stg_Oscillator_Cross_Zero(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Oscillator_Cross_Zero *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_Oscillator_Cross_Zero_Params_Defaults stg_oscillator_cross_zero_defaults;
    StgParams _stg_params(stg_oscillator_cross_zero_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Stg_Oscillator_Cross_Zero *_strat =
        new Stg_Oscillator_Cross_Zero(_stg_params, _tparams, _cparams, "Oscillator Cross Zero");
    _strat.ssparams = stg_oscillator_cross_zero_defaults;
    return _strat;
  }

  /**
   * Validate oscillator's entry.
   */
  bool IsValidEntry(IndicatorBase *_indi, int _shift = 0) {
    bool _result = true;
    switch (::Oscillator_Cross_Zero_Type) {
      case STG_OSCILLATOR_CROSS_ZERO_TYPE_MACD:
        _result &= dynamic_cast<Indi_MACD *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_MACD *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_CROSS_ZERO_TYPE_RVI:
        _result &= dynamic_cast<Indi_RVI *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_RVI *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      default:
        break;
    }
    return _result;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    // Initialize indicators.
    switch (Oscillator_Cross_Zero_Type) {
      case STG_OSCILLATOR_CROSS_ZERO_TYPE_MACD:  // MACD
      {
        IndiMACDParams _indi_params(
            ::Oscillator_Cross_Zero_Indi_MACD_Period_Fast, ::Oscillator_Cross_Zero_Indi_MACD_Period_Slow,
            ::Oscillator_Cross_Zero_Indi_MACD_Period_Signal, ::Oscillator_Cross_Zero_Indi_MACD_Applied_Price,
            ::Oscillator_Cross_Zero_Indi_MACD_Shift);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_MACD(_indi_params), ::Oscillator_Cross_Zero_Type);
        ssparams.SetLineSignal((uint)Oscillator_Cross_Zero_Indi_MACD_Line_Signal);
        break;
      }
      case STG_OSCILLATOR_CROSS_ZERO_TYPE_RVI:  // RVI
      {
        IndiRVIParams _indi_params(::Oscillator_Cross_Zero_Indi_RVI_Period, ::Oscillator_Cross_Zero_Indi_RVI_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Cross_Zero_Indi_RVI_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_RVI(_indi_params), ::Oscillator_Cross_Zero_Type);
        ssparams.SetLineSignal((uint)Oscillator_Cross_Zero_Indi_RVI_Line_Signal);
        break;
      }
      case STG_OSCILLATOR_CROSS_ZERO_TYPE_0_NONE:  // (None)
      default:
        break;
    }
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    IndicatorBase *_indi = GetIndicator(::Oscillator_Cross_Zero_Type);
    // uint _ishift = _indi.GetShift(); // @todo
    bool _result = Oscillator_Cross_Zero_Type != STG_OSCILLATOR_CROSS_ZERO_TYPE_0_NONE && IsValidEntry(_indi, _shift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    int _mode_signal = (int)ssparams.GetLineSignal();
    double _value1 = _indi[_shift][_mode_signal];
    double _value2 = _indi[_shift + 1][_mode_signal] < 0;
    ;
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _indi[_shift][_mode_signal] > 0;
        _result &= _indi[_shift + 1][_mode_signal] < 0;
        _result &= _indi.IsIncreasing(1, _mode_signal, _shift);
        _result &= Math::ChangeInPct(_indi[_shift + 1][_mode_signal], _indi[_shift][_mode_signal], true) > _level;
        if (_result && _method != 0) {
          _result &= _indi[_shift + 3][_mode_signal] < 0;
          if (METHOD(_method, 1))
            _result &=
                fmax4(_indi[_shift][_mode_signal], _indi[_shift + 1][_mode_signal], _indi[_shift + 2][_mode_signal],
                      _indi[_shift + 3][_mode_signal]) == _indi[_shift][_mode_signal];
        }
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _indi[_shift][_mode_signal] < 0;
        _result &= _indi[_shift + 1][_mode_signal] > 0;
        _result &= _indi.IsDecreasing(1, _mode_signal, _shift);
        _result &= Math::ChangeInPct(_indi[_shift + 1][_mode_signal], _indi[_shift][_mode_signal], true) < _level;
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi[_shift + 3][_mode_signal] > 0;
          if (METHOD(_method, 1))
            _result &=
                fmin4(_indi[_shift][_mode_signal], _indi[_shift + 1][_mode_signal], _indi[_shift + 2][_mode_signal],
                      _indi[_shift + 3][_mode_signal]) == _indi[_shift][_mode_signal];
        }
        break;
    }
    return _result;
  }
};
