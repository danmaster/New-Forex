/**
 * @file
 * Implements Oscillator Cross strategy.
 */

// Enums.

enum ENUM_STG_OSCILLATOR_CROSS_TYPE {
  STG_OSCILLATOR_CROSS_TYPE_0_NONE = 0,  // (None)
  STG_OSCILLATOR_CROSS_TYPE_ADX,         // ADX
  STG_OSCILLATOR_CROSS_TYPE_ADXW,        // ADXW
  STG_OSCILLATOR_CROSS_TYPE_MACD,        // MACD
  STG_OSCILLATOR_CROSS_TYPE_RVI,         // RVI: Relative Vigor Index
};

// User input params.
INPUT_GROUP("Oscillator Cross strategy: main strategy params");
INPUT ENUM_STG_OSCILLATOR_CROSS_TYPE Oscillator_Cross_Type = STG_OSCILLATOR_CROSS_TYPE_ADXW;  // Oscillator type
INPUT_GROUP("Oscillator Cross strategy: strategy params");
INPUT float Oscillator_Cross_LotSize = 0;                // Lot size
INPUT int Oscillator_Cross_SignalOpenMethod = 2;         // Signal open method
INPUT float Oscillator_Cross_SignalOpenLevel = 10.0f;    // Signal open level
INPUT int Oscillator_Cross_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int Oscillator_Cross_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT int Oscillator_Cross_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int Oscillator_Cross_SignalCloseMethod = 0;        // Signal close method
INPUT int Oscillator_Cross_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float Oscillator_Cross_SignalCloseLevel = 10.0f;   // Signal close level
INPUT int Oscillator_Cross_PriceStopMethod = 0;          // Price limit method
INPUT float Oscillator_Cross_PriceStopLevel = 2;         // Price limit level
INPUT int Oscillator_Cross_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT float Oscillator_Cross_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short Oscillator_Cross_Shift = 0;                  // Shift
INPUT float Oscillator_Cross_OrderCloseLoss = 80;        // Order close loss
INPUT float Oscillator_Cross_OrderCloseProfit = 80;      // Order close profit
INPUT int Oscillator_Cross_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Oscillator Cross strategy: ADX indicator params");
INPUT ENUM_INDI_ADX_LINE Oscillator_Cross_Indi_ADX_Fast_Line = LINE_PLUSDI;         // Fast line
INPUT ENUM_INDI_ADX_LINE Oscillator_Cross_Indi_ADX_Slow_Line = LINE_MINUSDI;        // Slow line to cross
INPUT int Oscillator_Cross_Indi_ADX_Period = 16;                                    // Averaging period
INPUT ENUM_APPLIED_PRICE Oscillator_Cross_Indi_ADX_AppliedPrice = PRICE_TYPICAL;    // Applied price
INPUT int Oscillator_Cross_Indi_ADX_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Cross_Indi_ADX_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator Cross strategy: ADXW indicator params");
INPUT ENUM_INDI_ADX_LINE Oscillator_Cross_Indi_ADXW_Fast_Line = LINE_PLUSDI;         // Fast line
INPUT ENUM_INDI_ADX_LINE Oscillator_Cross_Indi_ADXW_Slow_Line = LINE_MINUSDI;        // Slow line to cross
INPUT int Oscillator_Cross_Indi_ADXW_Period = 16;                                    // Averaging period
INPUT ENUM_APPLIED_PRICE Oscillator_Cross_Indi_ADXW_AppliedPrice = PRICE_TYPICAL;    // Applied price
INPUT int Oscillator_Cross_Indi_ADXW_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Cross_Indi_ADXW_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: MACD indicator params");
INPUT ENUM_SIGNAL_LINE Oscillator_Cross_Indi_MACD_Fast_Line = LINE_SIGNAL;       // Fast line
INPUT ENUM_SIGNAL_LINE Oscillator_Cross_Indi_MACD_Slow_Line = LINE_MAIN;         // Slow line
INPUT int Oscillator_Cross_Indi_MACD_Period_Fast = 6;                            // Period Fast
INPUT int Oscillator_Cross_Indi_MACD_Period_Slow = 34;                           // Period Slow
INPUT int Oscillator_Cross_Indi_MACD_Period_Signal = 10;                         // Period Signal
INPUT ENUM_APPLIED_PRICE Oscillator_Cross_Indi_MACD_Applied_Price = PRICE_OPEN;  // Applied Price
INPUT int Oscillator_Cross_Indi_MACD_Shift = 0;                                  // Shift
INPUT_GROUP("Oscillator strategy: RVI indicator params");
INPUT ENUM_SIGNAL_LINE Oscillator_Cross_Indi_RVI_Fast_Line = LINE_SIGNAL;           // Fast line
INPUT ENUM_SIGNAL_LINE Oscillator_Cross_Indi_RVI_Slow_Line = LINE_MAIN;             // Slow line
INPUT unsigned int Oscillator_Cross_Indi_RVI_Period = 12;                           // Averaging period
INPUT int Oscillator_Cross_Indi_RVI_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Cross_Indi_RVI_SourceType = IDATA_BUILTIN;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_Oscillator_Cross_Params_Defaults : StgParams {
  uint line_fast, line_slow;
  Stg_Oscillator_Cross_Params_Defaults()
      : StgParams(::Oscillator_Cross_SignalOpenMethod, ::Oscillator_Cross_SignalOpenFilterMethod,
                  ::Oscillator_Cross_SignalOpenLevel, ::Oscillator_Cross_SignalOpenBoostMethod,
                  ::Oscillator_Cross_SignalCloseMethod, ::Oscillator_Cross_SignalCloseFilter,
                  ::Oscillator_Cross_SignalCloseLevel, ::Oscillator_Cross_PriceStopMethod,
                  ::Oscillator_Cross_PriceStopLevel, ::Oscillator_Cross_TickFilterMethod, ::Oscillator_Cross_MaxSpread,
                  ::Oscillator_Cross_Shift),
        line_fast(0),
        line_slow(0) {
    Set(STRAT_PARAM_LS, ::Oscillator_Cross_LotSize);
    Set(STRAT_PARAM_OCL, ::Oscillator_Cross_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, ::Oscillator_Cross_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, ::Oscillator_Cross_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, ::Oscillator_Cross_SignalOpenFilterTime);
  }
  // Getters.
  uint GetLineFast() { return line_fast; }
  uint GetLineSlow() { return line_slow; }
  // Setters.
  void SetLineFast(uint _value) { line_fast = _value; }
  void SetLineSlow(uint _value) { line_slow = _value; }
};

class Stg_Oscillator_Cross : public Strategy {
 protected:
  Stg_Oscillator_Cross_Params_Defaults ssparams;

 public:
  Stg_Oscillator_Cross(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Oscillator_Cross *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_Oscillator_Cross_Params_Defaults stg_oscillator_cross_defaults;
    StgParams _stg_params(stg_oscillator_cross_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Stg_Oscillator_Cross *_strat = new Stg_Oscillator_Cross(_stg_params, _tparams, _cparams, "Oscillator Cross");
    _strat.ssparams = stg_oscillator_cross_defaults;
    return _strat;
  }

  /**
   * Validate oscillator's entry.
   */
  bool IsValidEntry(IndicatorBase *_indi, int _shift = 0) {
    bool _result = true;
    switch (::Oscillator_Cross_Type) {
      case STG_OSCILLATOR_CROSS_TYPE_ADX:
        _result &= dynamic_cast<Indi_ADX *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_ADX *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_CROSS_TYPE_ADXW:
        _result &= dynamic_cast<Indi_ADXW *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_ADXW *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_CROSS_TYPE_MACD:
        _result &= dynamic_cast<Indi_MACD *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_MACD *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_CROSS_TYPE_RVI:
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
    switch (Oscillator_Cross_Type) {
      case STG_OSCILLATOR_CROSS_TYPE_ADX:  // ADX
      {
        IndiADXParams _adx_params(::Oscillator_Cross_Indi_ADX_Period, ::Oscillator_Cross_Indi_ADX_AppliedPrice,
                                  ::Oscillator_Cross_Indi_ADX_Shift);
        _adx_params.SetDataSourceType(::Oscillator_Cross_Indi_ADX_SourceType);
        _adx_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_ADX(_adx_params), ::Oscillator_Cross_Type);
        // sparams.SetLineFast(0); // @todo: Fix Strategy to allow custom params stored in sparam.
        ssparams.SetLineFast((uint)Oscillator_Cross_Indi_ADX_Fast_Line);
        ssparams.SetLineSlow((uint)Oscillator_Cross_Indi_ADX_Slow_Line);
        break;
      }
      case STG_OSCILLATOR_CROSS_TYPE_ADXW:  // ADXW
      {
        IndiADXWParams _adxw_params(::Oscillator_Cross_Indi_ADXW_Period, ::Oscillator_Cross_Indi_ADXW_AppliedPrice,
                                    ::Oscillator_Cross_Indi_ADXW_Shift);
        _adxw_params.SetDataSourceType(::Oscillator_Cross_Indi_ADXW_SourceType);
        _adxw_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_ADXW(_adxw_params), ::Oscillator_Cross_Type);
        // sparams.SetLineFast(0); // @todo: Fix Strategy to allow custom params stored in sparam.
        ssparams.SetLineFast((uint)Oscillator_Cross_Indi_ADXW_Fast_Line);
        ssparams.SetLineSlow((uint)Oscillator_Cross_Indi_ADXW_Slow_Line);
        break;
      }
      case STG_OSCILLATOR_CROSS_TYPE_MACD:  // MACD
      {
        IndiMACDParams _indi_params(::Oscillator_Cross_Indi_MACD_Period_Fast, ::Oscillator_Cross_Indi_MACD_Period_Slow,
                                    ::Oscillator_Cross_Indi_MACD_Period_Signal,
                                    ::Oscillator_Cross_Indi_MACD_Applied_Price, ::Oscillator_Cross_Indi_MACD_Shift);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_MACD(_indi_params), ::Oscillator_Cross_Type);
        ssparams.SetLineFast((uint)Oscillator_Cross_Indi_MACD_Fast_Line);
        ssparams.SetLineSlow((uint)Oscillator_Cross_Indi_MACD_Slow_Line);
        break;
      }
      case STG_OSCILLATOR_CROSS_TYPE_RVI:  // RVI
      {
        IndiRVIParams _indi_params(::Oscillator_Cross_Indi_RVI_Period, ::Oscillator_Cross_Indi_RVI_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Cross_Indi_RVI_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_RVI(_indi_params), ::Oscillator_Cross_Type);
        ssparams.SetLineFast((uint)Oscillator_Cross_Indi_RVI_Fast_Line);
        ssparams.SetLineSlow((uint)Oscillator_Cross_Indi_RVI_Slow_Line);
        break;
      }
      case STG_OSCILLATOR_CROSS_TYPE_0_NONE:  // (None)
      default:
        break;
    }
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    IndicatorBase *_indi = GetIndicator(::Oscillator_Cross_Type);
    // uint _ishift = _indi.GetShift(); // @todo
    bool _result = Oscillator_Cross_Type != STG_OSCILLATOR_CROSS_TYPE_0_NONE && IsValidEntry(_indi, _shift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    int _line_fast = (int)ssparams.GetLineFast();
    int _line_slow = (int)ssparams.GetLineSlow();
    double _value1 = _indi[_shift][_line_fast];
    double _value2 = _indi[_shift][_line_slow];
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _indi.IsIncreasing(1, _line_fast, _shift);
        _result &= _indi[_shift][_line_fast] > _indi[_shift][_line_slow];
        _result &= _indi[_shift + 1][_line_fast] < _indi[_shift + 1][_line_slow];
        _result &= Math::ChangeInPct(_indi[_shift + 1][_line_fast], _indi[_shift][_line_fast], true) > _level;
        if (_result && _method != 0) {
          _result &= _indi[_shift + 3][_line_fast] < _indi[_shift + 3][_line_slow];
          if (METHOD(_method, 1))
            _result &= fmax4(_indi[_shift][_line_fast], _indi[_shift + 1][_line_fast], _indi[_shift + 2][_line_fast],
                             _indi[_shift + 3][_line_fast]) == _indi[_shift][_line_fast];
        }
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _indi.IsDecreasing(1, _line_fast, _shift);
        _result &= _indi[_shift][_line_fast] < _indi[_shift][_line_slow];
        _result &= _indi[_shift + 1][_line_fast] > _indi[_shift + 1][_line_slow];
        _result &= Math::ChangeInPct(_indi[_shift + 1][_line_fast], _indi[_shift][_line_fast], true) < _level;
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi[_shift + 3][_line_fast] > _indi[_shift + 3][_line_slow];
          if (METHOD(_method, 1))
            _result &= fmin4(_indi[_shift][_line_fast], _indi[_shift + 1][_line_fast], _indi[_shift + 2][_line_fast],
                             _indi[_shift + 3][_line_fast]) == _indi[_shift][_line_fast];
        }
        break;
    }
    return _result;
  }
};
