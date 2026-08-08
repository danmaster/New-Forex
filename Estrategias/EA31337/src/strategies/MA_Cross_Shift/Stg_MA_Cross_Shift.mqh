/**
 * @file
 * Strategy based on the moving average price indicators implementing shifted cross signal.
 */

enum ENUM_STG_MA_CROSS_SHIFT_TYPE {
  STG_MA_CROSS_SHIFT_TYPE_0_NONE = 0,     // (None)
  STG_MA_CROSS_SHIFT_TYPE_AMA,            // AMA: Adaptive Moving Average
  STG_MA_CROSS_SHIFT_TYPE_DEMA,           // DEMA: Double Exponential Moving Average
  STG_MA_CROSS_SHIFT_TYPE_FRAMA,          // FrAMA: Fractal Adaptive Moving Average
  STG_MA_CROSS_SHIFT_TYPE_ICHIMOKU,       // Ichimoku
  STG_MA_CROSS_SHIFT_TYPE_MA,             // MA: Moving Average
  STG_MA_CROSS_SHIFT_TYPE_PRICE_CHANNEL,  // Price Channel
  STG_MA_CROSS_SHIFT_TYPE_SAR,            // SAR: Parabolic Stop and Reverse
  STG_MA_CROSS_SHIFT_TYPE_TEMA,           // TEMA: Triple Exponential Moving Average
  STG_MA_CROSS_SHIFT_TYPE_VIDYA,          // VIDYA: Variable Index Dynamic Average
};

// User params.
INPUT_GROUP("MA Cross Shift strategy: main strategy params");
INPUT ENUM_STG_MA_CROSS_SHIFT_TYPE MA_Cross_Shift_Type = STG_MA_CROSS_SHIFT_TYPE_MA;  // Indicator MA type
INPUT_GROUP("MA Cross Shift strategy: strategy params");
INPUT float MA_Cross_Shift_LotSize = 0;                // Lot size
INPUT int MA_Cross_Shift_SignalOpenMethod = 0;         // Signal open method (-127-127)
INPUT float MA_Cross_Shift_SignalOpenLevel = 0.0f;     // Signal open level
INPUT int MA_Cross_Shift_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int MA_Cross_Shift_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int MA_Cross_Shift_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int MA_Cross_Shift_SignalCloseMethod = 0;        // Signal close method (-127-127)
INPUT int MA_Cross_Shift_SignalCloseFilter = 0;        // Signal close filter (-127-127)
INPUT float MA_Cross_Shift_SignalCloseLevel = 0.0f;    // Signal close level
INPUT int MA_Cross_Shift_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float MA_Cross_Shift_PriceStopLevel = 2;         // Price stop level
INPUT int MA_Cross_Shift_TickFilterMethod = 32;        // Tick filter method
INPUT float MA_Cross_Shift_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short MA_Cross_Shift_Shift = 0;                  // Shift
INPUT float MA_Cross_Shift_OrderCloseLoss = 80;        // Order close loss
INPUT float MA_Cross_Shift_OrderCloseProfit = 80;      // Order close profit
INPUT int MA_Cross_Shift_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("MA Cross Shift strategy: AMA indicator params");
INPUT int MA_Cross_Shift_Indi_AMA_InpPeriodAMA = 20;                              // AMA period
INPUT int MA_Cross_Shift_Indi_AMA_InpFastPeriodEMA = 4;                           // Fast EMA period
INPUT int MA_Cross_Shift_Indi_AMA_InpSlowPeriodEMA = 30;                          // Slow EMA period
INPUT int MA_Cross_Shift_Indi_AMA_InpShiftAMA = 4;                                // AMA shift
INPUT int MA_Cross_Shift_Indi_AMA_Shift = 0;                                      // Shift
INPUT int MA_Cross_Shift_Indi_AMA_Shift2 = 10;                                    // Shift 2
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Shift_Indi_AMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Shift strategy: DEMA indicator params");
INPUT int MA_Cross_Shift_Indi_DEMA_Period = 25;                                    // Period
INPUT int MA_Cross_Shift_Indi_DEMA_MA_Shift = 6;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE MA_Cross_Shift_Indi_DEMA_Applied_Price = PRICE_TYPICAL;   // Applied Price
INPUT int MA_Cross_Shift_Indi_DEMA_Shift = 0;                                      // Shift
INPUT int MA_Cross_Shift_Indi_DEMA_Shift2 = 10;                                    // Shift 2
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Shift_Indi_DEMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Shift strategy: FrAMA indicator params");
INPUT int MA_Cross_Shift_Indi_FrAMA_Period = 10;                                    // Period
INPUT ENUM_APPLIED_PRICE MA_Cross_Shift_Indi_FrAMA_Applied_Price = PRICE_MEDIAN;    // Applied Price
INPUT int MA_Cross_Shift_Indi_FrAMA_MA_Shift = 0;                                   // MA Shift
INPUT int MA_Cross_Shift_Indi_FrAMA_Shift = 0;                                      // Shift
INPUT int MA_Cross_Shift_Indi_FrAMA_Shift2 = 10;                                    // Shift 2
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Shift_Indi_FrAMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Shift strategy: Ichimoku indicator params");
// INPUT ENUM_ICHIMOKU_LINE MA_Cross_Shift_Indi_Ichimoku_MA_Line = LINE_TENKANSEN; // Ichimoku line for MA
INPUT int MA_Cross_Shift_Indi_Ichimoku_Period_Tenkan_Sen = 30;                         // Period Tenkan Sen
INPUT int MA_Cross_Shift_Indi_Ichimoku_Period_Kijun_Sen = 10;                          // Period Kijun Sen
INPUT int MA_Cross_Shift_Indi_Ichimoku_Period_Senkou_Span_B = 30;                      // Period Senkou Span B
INPUT int MA_Cross_Shift_Indi_Ichimoku_Shift = 1;                                      // Shift
INPUT int MA_Cross_Shift_Indi_Ichimoku_Shift2 = 1;                                     // Shift 2
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Shift_Indi_Ichimoku_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Shift strategy: MA indicator params");
INPUT int MA_Cross_Shift_Indi_MA_Period = 26;                                    // Period
INPUT int MA_Cross_Shift_Indi_MA_MA_Shift = 0;                                   // MA Shift
INPUT ENUM_MA_METHOD MA_Cross_Shift_Indi_MA_Method = MODE_LWMA;                  // MA Method
INPUT ENUM_APPLIED_PRICE MA_Cross_Shift_Indi_MA_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int MA_Cross_Shift_Indi_MA_Shift = 0;                                      // Shift
INPUT int MA_Cross_Shift_Indi_MA_Shift2 = 10;                                    // Shift 2
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Shift_Indi_MA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Shift strategy: Price Channel indicator params");
INPUT int MA_Cross_Shift_Indi_PriceChannel_Period = 26;                                    // Period
INPUT int MA_Cross_Shift_Indi_PriceChannel_Shift = 0;                                      // Shift
INPUT int MA_Cross_Shift_Indi_PriceChannel_Shift2 = 10;                                    // Shift 2
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Shift_Indi_PriceChannel_SourceType = IDATA_ICUSTOM;  // Source type
INPUT_GROUP("MA Cross Shift strategy: SAR indicator params");
INPUT float MA_Cross_Shift_Indi_SAR_Step = 0.04f;                                 // Step
INPUT float MA_Cross_Shift_Indi_SAR_Maximum_Stop = 0.4f;                          // Maximum stop
INPUT int MA_Cross_Shift_Indi_SAR_Shift = 0;                                      // Shift
INPUT int MA_Cross_Shift_Indi_SAR_Shift2 = 10;                                    // Shift 2
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Shift_Indi_SAR_SourceType = IDATA_ICUSTOM;  // Source type
INPUT_GROUP("MA Cross Shift strategy: TEMA indicator params");
INPUT int MA_Cross_Shift_Indi_TEMA_Period = 10;                                    // Period
INPUT int MA_Cross_Shift_Indi_TEMA_MA_Shift = 0;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE MA_Cross_Shift_Indi_TEMA_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int MA_Cross_Shift_Indi_TEMA_Shift = 0;                                      // Shift
INPUT int MA_Cross_Shift_Indi_TEMA_Shift2 = 10;                                    // Shift 2
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Shift_Indi_TEMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Shift strategy: VIDYA indicator params");
INPUT int MA_Cross_Shift_Indi_VIDYA_Period = 30;                                    // Period
INPUT int MA_Cross_Shift_Indi_VIDYA_MA_Period = 20;                                 // MA Period
INPUT int MA_Cross_Shift_Indi_VIDYA_MA_Shift = 1;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE MA_Cross_Shift_Indi_VIDYA_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int MA_Cross_Shift_Indi_VIDYA_Shift = 0;                                      // Shift
INPUT int MA_Cross_Shift_Indi_VIDYA_Shift2 = 10;                                    // Shift 2
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Shift_Indi_VIDYA_SourceType = IDATA_BUILTIN;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_MA_Cross_Shift_Params_Defaults : StgParams {
  uint shift1, shift2;
  Stg_MA_Cross_Shift_Params_Defaults()
      : StgParams(::MA_Cross_Shift_SignalOpenMethod, ::MA_Cross_Shift_SignalOpenFilterMethod,
                  ::MA_Cross_Shift_SignalOpenLevel, ::MA_Cross_Shift_SignalOpenBoostMethod,
                  ::MA_Cross_Shift_SignalCloseMethod, ::MA_Cross_Shift_SignalCloseFilter,
                  ::MA_Cross_Shift_SignalCloseLevel, ::MA_Cross_Shift_PriceStopMethod, ::MA_Cross_Shift_PriceStopLevel,
                  ::MA_Cross_Shift_TickFilterMethod, ::MA_Cross_Shift_MaxSpread, ::MA_Cross_Shift_Shift) {
    Set(STRAT_PARAM_LS, MA_Cross_Shift_LotSize);
    Set(STRAT_PARAM_OCL, MA_Cross_Shift_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, MA_Cross_Shift_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, MA_Cross_Shift_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, MA_Cross_Shift_SignalOpenFilterTime);
  }
  // Getters.
  uint GetShift1() { return shift1; }
  uint GetShift2() { return shift2; }
  // Setters.
  void SetShift1(uint _value) { shift1 = _value; }
  void SetShift2(uint _value) { shift2 = _value; }
};

class Stg_MA_Cross_Shift : public Strategy {
 protected:
  Stg_MA_Cross_Shift_Params_Defaults ssparams;

 public:
  Stg_MA_Cross_Shift(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_MA_Cross_Shift *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_MA_Cross_Shift_Params_Defaults stg_ma_cross_shift_defaults;
    StgParams _stg_params(stg_ma_cross_shift_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_MA_Cross_Shift(_stg_params, _tparams, _cparams, "MA Cross Shift");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    // Initialize indicators.
    switch (MA_Cross_Shift_Type) {
      case STG_MA_CROSS_SHIFT_TYPE_AMA:  // AMA
      {
        IndiAMAParams _indi_params(::MA_Cross_Shift_Indi_AMA_InpPeriodAMA, ::MA_Cross_Shift_Indi_AMA_InpFastPeriodEMA,
                                   ::MA_Cross_Shift_Indi_AMA_InpSlowPeriodEMA, ::MA_Cross_Shift_Indi_AMA_InpShiftAMA,
                                   PRICE_TYPICAL, ::MA_Cross_Shift_Indi_AMA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Shift_Indi_AMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_AMA(_indi_params), ::MA_Cross_Shift_Type);
        _indi_params.SetShift(::MA_Cross_Shift_Indi_AMA_Shift2);
        SetIndicator(new Indi_AMA(_indi_params), ::MA_Cross_Shift_Type + 1);
        ssparams.SetShift1(MA_Cross_Shift_Indi_AMA_Shift);
        ssparams.SetShift2(MA_Cross_Shift_Indi_AMA_Shift2);
        break;
      }
      case STG_MA_CROSS_SHIFT_TYPE_DEMA:  // DEMA
      {
        IndiDEIndiMAParams _indi_params(::MA_Cross_Shift_Indi_DEMA_Period, ::MA_Cross_Shift_Indi_DEMA_MA_Shift,
                                        ::MA_Cross_Shift_Indi_DEMA_Applied_Price, ::MA_Cross_Shift_Indi_DEMA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Shift_Indi_DEMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_DEMA(_indi_params), ::MA_Cross_Shift_Type);
        _indi_params.SetShift(::MA_Cross_Shift_Indi_DEMA_Shift2);
        SetIndicator(new Indi_DEMA(_indi_params), ::MA_Cross_Shift_Type + 1);
        ssparams.SetShift1(MA_Cross_Shift_Indi_DEMA_Shift);
        ssparams.SetShift2(MA_Cross_Shift_Indi_DEMA_Shift2);
        break;
      }
      case STG_MA_CROSS_SHIFT_TYPE_FRAMA:  // FrAMA
      {
        IndiFrAIndiMAParams _indi_params(::MA_Cross_Shift_Indi_FrAMA_Period, ::MA_Cross_Shift_Indi_FrAMA_MA_Shift,
                                         ::MA_Cross_Shift_Indi_FrAMA_Applied_Price, ::MA_Cross_Shift_Indi_FrAMA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Shift_Indi_FrAMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_FrAMA(_indi_params), ::MA_Cross_Shift_Type);
        _indi_params.SetShift(::MA_Cross_Shift_Indi_FrAMA_Shift2);
        SetIndicator(new Indi_FrAMA(_indi_params), ::MA_Cross_Shift_Type + 1);
        ssparams.SetShift1(MA_Cross_Shift_Indi_FrAMA_Shift);
        ssparams.SetShift2(MA_Cross_Shift_Indi_FrAMA_Shift2);
        break;
      }
      case STG_MA_CROSS_SHIFT_TYPE_ICHIMOKU:  // Ichimoku
      {
        IndiIchimokuParams _indi_params(
            ::MA_Cross_Shift_Indi_Ichimoku_Period_Tenkan_Sen, ::MA_Cross_Shift_Indi_Ichimoku_Period_Kijun_Sen,
            ::MA_Cross_Shift_Indi_Ichimoku_Period_Senkou_Span_B, ::MA_Cross_Shift_Indi_Ichimoku_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Shift_Indi_Ichimoku_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_Ichimoku(_indi_params), ::MA_Cross_Shift_Type);
        _indi_params.SetShift(::MA_Cross_Shift_Indi_Ichimoku_Shift2);
        SetIndicator(new Indi_Ichimoku(_indi_params), ::MA_Cross_Shift_Type + 1);
        ssparams.SetShift1(MA_Cross_Shift_Indi_Ichimoku_Shift);
        ssparams.SetShift2(MA_Cross_Shift_Indi_Ichimoku_Shift2);
        break;
      }
      case STG_MA_CROSS_SHIFT_TYPE_MA:  // MA
      {
        IndiMAParams _indi_params(::MA_Cross_Shift_Indi_MA_Period, ::MA_Cross_Shift_Indi_MA_MA_Shift,
                                  ::MA_Cross_Shift_Indi_MA_Method, ::MA_Cross_Shift_Indi_MA_Applied_Price,
                                  ::MA_Cross_Shift_Indi_MA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Shift_Indi_MA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_MA(_indi_params), ::MA_Cross_Shift_Type);
        _indi_params.SetShift(::MA_Cross_Shift_Indi_MA_Shift2);
        SetIndicator(new Indi_MA(_indi_params), ::MA_Cross_Shift_Type + 1);
        ssparams.SetShift1(MA_Cross_Shift_Indi_MA_Shift);
        ssparams.SetShift2(MA_Cross_Shift_Indi_MA_Shift2);
        break;
      }
      case STG_MA_CROSS_SHIFT_TYPE_PRICE_CHANNEL:  // Price Channel
      {
        IndiPriceChannelParams _indi_params(::MA_Cross_Shift_Indi_PriceChannel_Period,
                                            ::MA_Cross_Shift_Indi_PriceChannel_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Shift_Indi_PriceChannel_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_PriceChannel(_indi_params), ::MA_Cross_Shift_Type);
        _indi_params.SetShift(::MA_Cross_Shift_Indi_PriceChannel_Shift2);
        SetIndicator(new Indi_PriceChannel(_indi_params), ::MA_Cross_Shift_Type + 1);
        ssparams.SetShift1(MA_Cross_Shift_Indi_PriceChannel_Shift);
        ssparams.SetShift2(MA_Cross_Shift_Indi_PriceChannel_Shift2);
        break;
      }
      case STG_MA_CROSS_SHIFT_TYPE_SAR:  // SAR
      {
        IndiSARParams _indi_params(::MA_Cross_Shift_Indi_SAR_Step, ::MA_Cross_Shift_Indi_SAR_Maximum_Stop,
                                   ::MA_Cross_Shift_Indi_SAR_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Shift_Indi_SAR_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_SAR(_indi_params), ::MA_Cross_Shift_Type);
        _indi_params.SetShift(::MA_Cross_Shift_Indi_SAR_Shift2);
        SetIndicator(new Indi_SAR(_indi_params), ::MA_Cross_Shift_Type + 1);
        ssparams.SetShift1(MA_Cross_Shift_Indi_SAR_Shift);
        ssparams.SetShift2(MA_Cross_Shift_Indi_SAR_Shift2);
        break;
      }
      case STG_MA_CROSS_SHIFT_TYPE_TEMA:  // TEMA
      {
        IndiTEMAParams _indi_params(::MA_Cross_Shift_Indi_TEMA_Period, ::MA_Cross_Shift_Indi_TEMA_MA_Shift,
                                    ::MA_Cross_Shift_Indi_TEMA_Applied_Price, ::MA_Cross_Shift_Indi_TEMA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Shift_Indi_TEMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_TEMA(_indi_params), ::MA_Cross_Shift_Type);
        _indi_params.SetShift(::MA_Cross_Shift_Indi_TEMA_Shift2);
        SetIndicator(new Indi_TEMA(_indi_params), ::MA_Cross_Shift_Type + 1);
        ssparams.SetShift1(MA_Cross_Shift_Indi_TEMA_Shift);
        ssparams.SetShift2(MA_Cross_Shift_Indi_TEMA_Shift2);
        break;
      }
      case STG_MA_CROSS_SHIFT_TYPE_VIDYA:  // VIDYA
      {
        IndiVIDYAParams _indi_params(::MA_Cross_Shift_Indi_VIDYA_Period, ::MA_Cross_Shift_Indi_VIDYA_MA_Period,
                                     ::MA_Cross_Shift_Indi_VIDYA_MA_Shift, ::MA_Cross_Shift_Indi_VIDYA_Applied_Price,
                                     ::MA_Cross_Shift_Indi_VIDYA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Shift_Indi_VIDYA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_VIDYA(_indi_params), ::MA_Cross_Shift_Type);
        _indi_params.SetShift(::MA_Cross_Shift_Indi_VIDYA_Shift2);
        SetIndicator(new Indi_VIDYA(_indi_params), ::MA_Cross_Shift_Type + 1);
        ssparams.SetShift1(MA_Cross_Shift_Indi_VIDYA_Shift);
        ssparams.SetShift2(MA_Cross_Shift_Indi_VIDYA_Shift2);
        break;
      }
      case STG_MA_CROSS_SHIFT_TYPE_0_NONE:  // (None)
      default:
        break;
    }
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    IndicatorBase *_indi1 = GetIndicator(::MA_Cross_Shift_Type);
    IndicatorBase *_indi2 = GetIndicator(::MA_Cross_Shift_Type + 1);
    // uint _ishift1 = _indi1.GetParams().GetShift(); // @todo: Convert into Get().
    // uint _ishift2 = _indi2.GetParams().GetShift(); // @todo: Convert into Get().
    uint _ishift1 = ssparams.GetShift1();
    uint _ishift2 = ssparams.GetShift2();
    // bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift); // @fixme
    bool _result = true;
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    // float _level_pips = (float)(_level * _chart.GetPipSize());
    double _value1 = _indi1[_ishift1][0];
    double _value2 = _indi2[_ishift2][0];
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _indi1.IsIncreasing(1, 0, _ishift1);
        _result &= _indi1[_ishift1][0] > _indi2[_ishift2][0];
        _result &= _indi1[_ishift1 + 1][0] < _indi2[_ishift2 + 1][0];
        //_result &= Math::ChangeInPct(_indi1[_ishift1 + 1][0], _indi1[_ishift1][0], true) > _level;
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi1[_ishift1][0] < _indi1[_ishift1 + 3][0];
          if (METHOD(_method, 1)) _result &= _indi2[_ishift2][0] < _indi2[_ishift2 + 3][0];
          if (METHOD(_method, 2))
            _result &= fmax4(_indi1[_ishift1][0], _indi1[_ishift1 + 1][0], _indi1[_ishift1 + 2][0],
                             _indi1[_ishift1 + 3][0]) == _indi1[_ishift1][0];
          if (METHOD(_method, 3))
            _result &= fmax4(_indi2[_ishift2][0], _indi2[_ishift2 + 1][0], _indi2[_ishift2 + 2][0],
                             _indi2[_ishift2 + 3][0]) == _indi2[_ishift2][0];
        }
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _indi1.IsDecreasing(1, 0, _ishift1);
        _result &= _indi1[_ishift1][0] < _indi2[_ishift2][0];
        _result &= _indi1[_ishift1 + 1][0] > _indi2[_ishift2 + 1][0];
        //_result &= Math::ChangeInPct(_indi1[_ishift1 + 1][0], _indi1[_ishift1][0], true) < _level;
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi1[_ishift1][0] > _indi1[_ishift1 + 3][0];
          if (METHOD(_method, 1)) _result &= _indi2[_ishift2][0] > _indi2[_ishift2 + 3][0];
          if (METHOD(_method, 2))
            _result &= fmin4(_indi1[_ishift1][0], _indi1[_ishift1 + 1][0], _indi1[_ishift1 + 2][0],
                             _indi1[_ishift1 + 3][0]) == _indi1[_ishift1][0];
          if (METHOD(_method, 3))
            _result &= fmin4(_indi2[_ishift2][0], _indi2[_ishift2 + 1][0], _indi2[_ishift2 + 2][0],
                             _indi2[_ishift2 + 3][0]) == _indi2[_ishift2][0];
        }
        break;
    }
    return _result;
  }
};
