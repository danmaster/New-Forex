/**
 * @file
 * Implements MA Cross Timeframe strategy.
 */

enum ENUM_STG_MA_CROSS_TIMEFRAME_TYPE {
  STG_MA_CROSS_TIMEFRAME_TYPE_0_NONE = 0,     // (None)
  STG_MA_CROSS_TIMEFRAME_TYPE_AMA,            // AMA: Adaptive Moving Average
  STG_MA_CROSS_TIMEFRAME_TYPE_DEMA,           // DEMA: Double Exponential Moving Average
  STG_MA_CROSS_TIMEFRAME_TYPE_FRAMA,          // FrAMA: Fractal Adaptive Moving Average
  STG_MA_CROSS_TIMEFRAME_TYPE_ICHIMOKU,       // Ichimoku
  STG_MA_CROSS_TIMEFRAME_TYPE_MA,             // MA: Moving Average
  STG_MA_CROSS_TIMEFRAME_TYPE_PRICE_CHANNEL,  // Price Channel
  STG_MA_CROSS_TIMEFRAME_TYPE_SAR,            // SAR: Parabolic Stop and Reverse
  STG_MA_CROSS_TIMEFRAME_TYPE_TEMA,           // TEMA: Triple Exponential Moving Average
  STG_MA_CROSS_TIMEFRAME_TYPE_VIDYA,          // VIDYA: Variable Index Dynamic Average
};

// User params.
INPUT_GROUP("MA Cross Timeframe strategy: main strategy params");
INPUT ENUM_STG_MA_CROSS_TIMEFRAME_TYPE MA_Cross_Timeframe_Type = STG_MA_CROSS_TIMEFRAME_TYPE_MA;  // Indicator MA type
INPUT ENUM_TIMEFRAMES MA_Cross_Timeframe_Timeframe = PERIOD_H6;  // MA timeframe to cross
INPUT_GROUP("MA Cross Timeframe strategy: strategy params");
INPUT float MA_Cross_Timeframe_LotSize = 0;                // Lot size
INPUT int MA_Cross_Timeframe_SignalOpenMethod = 0;         // Signal open method (-127-127)
INPUT float MA_Cross_Timeframe_SignalOpenLevel = 0.0f;     // Signal open level
INPUT int MA_Cross_Timeframe_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int MA_Cross_Timeframe_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int MA_Cross_Timeframe_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int MA_Cross_Timeframe_SignalCloseMethod = 0;        // Signal close method (-127-127)
INPUT int MA_Cross_Timeframe_SignalCloseFilter = 0;        // Signal close filter (-127-127)
INPUT float MA_Cross_Timeframe_SignalCloseLevel = 0.0f;    // Signal close level
INPUT int MA_Cross_Timeframe_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float MA_Cross_Timeframe_PriceStopLevel = 2;         // Price stop level
INPUT int MA_Cross_Timeframe_TickFilterMethod = 32;        // Tick filter method
INPUT float MA_Cross_Timeframe_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short MA_Cross_Timeframe_Shift = 0;                  // Shift
INPUT float MA_Cross_Timeframe_OrderCloseLoss = 80;        // Order close loss
INPUT float MA_Cross_Timeframe_OrderCloseProfit = 80;      // Order close profit
INPUT int MA_Cross_Timeframe_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("MA Cross Timeframe strategy: AMA indicator params");
INPUT int MA_Cross_Timeframe_Indi_AMA_InpPeriodAMA = 20;                              // AMA period
INPUT int MA_Cross_Timeframe_Indi_AMA_InpFastPeriodEMA = 4;                           // Fast EMA period
INPUT int MA_Cross_Timeframe_Indi_AMA_InpSlowPeriodEMA = 30;                          // Slow EMA period
INPUT int MA_Cross_Timeframe_Indi_AMA_InpShiftAMA = 4;                                // AMA shift
INPUT int MA_Cross_Timeframe_Indi_AMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Timeframe_Indi_AMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Timeframe strategy: DEMA indicator params");
INPUT int MA_Cross_Timeframe_Indi_DEMA_Period = 25;                                    // Period
INPUT int MA_Cross_Timeframe_Indi_DEMA_MA_Shift = 6;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE MA_Cross_Timeframe_Indi_DEMA_Applied_Price = PRICE_TYPICAL;   // Applied Price
INPUT int MA_Cross_Timeframe_Indi_DEMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Timeframe_Indi_DEMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Timeframe strategy: FrAMA indicator params");
INPUT int MA_Cross_Timeframe_Indi_FrAMA_Period = 10;                                    // Period
INPUT ENUM_APPLIED_PRICE MA_Cross_Timeframe_Indi_FrAMA_Applied_Price = PRICE_MEDIAN;    // Applied Price
INPUT int MA_Cross_Timeframe_Indi_FrAMA_MA_Shift = 0;                                   // MA Shift
INPUT int MA_Cross_Timeframe_Indi_FrAMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Timeframe_Indi_FrAMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Timeframe strategy: Ichimoku indicator params");
// INPUT ENUM_ICHIMOKU_LINE MA_Cross_Timeframe_Indi_Ichimoku_MA_Line = LINE_TENKANSEN; // Ichimoku line for MA
INPUT int MA_Cross_Timeframe_Indi_Ichimoku_Period_Tenkan_Sen = 30;                         // Period Tenkan Sen
INPUT int MA_Cross_Timeframe_Indi_Ichimoku_Period_Kijun_Sen = 10;                          // Period Kijun Sen
INPUT int MA_Cross_Timeframe_Indi_Ichimoku_Period_Senkou_Span_B = 30;                      // Period Senkou Span B
INPUT int MA_Cross_Timeframe_Indi_Ichimoku_Shift = 1;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Timeframe_Indi_Ichimoku_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Timeframe strategy: MA indicator params");
INPUT int MA_Cross_Timeframe_Indi_MA_Period = 26;                                    // Period
INPUT int MA_Cross_Timeframe_Indi_MA_MA_Shift = 0;                                   // MA Shift
INPUT ENUM_MA_METHOD MA_Cross_Timeframe_Indi_MA_Method = MODE_LWMA;                  // MA Method
INPUT ENUM_APPLIED_PRICE MA_Cross_Timeframe_Indi_MA_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int MA_Cross_Timeframe_Indi_MA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Timeframe_Indi_MA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Timeframe strategy: Price Channel indicator params");
INPUT int MA_Cross_Timeframe_Indi_PriceChannel_Period = 26;                                    // Period
INPUT int MA_Cross_Timeframe_Indi_PriceChannel_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Timeframe_Indi_PriceChannel_SourceType = IDATA_ICUSTOM;  // Source type
INPUT_GROUP("MA Cross Timeframe strategy: SAR indicator params");
INPUT float MA_Cross_Timeframe_Indi_SAR_Step = 0.04f;                                 // Step
INPUT float MA_Cross_Timeframe_Indi_SAR_Maximum_Stop = 0.4f;                          // Maximum stop
INPUT int MA_Cross_Timeframe_Indi_SAR_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Timeframe_Indi_SAR_SourceType = IDATA_ICUSTOM;  // Source type
INPUT_GROUP("MA Cross Timeframe strategy: TEMA indicator params");
INPUT int MA_Cross_Timeframe_Indi_TEMA_Period = 10;                                    // Period
INPUT int MA_Cross_Timeframe_Indi_TEMA_MA_Shift = 0;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE MA_Cross_Timeframe_Indi_TEMA_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int MA_Cross_Timeframe_Indi_TEMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Timeframe_Indi_TEMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Cross Timeframe strategy: VIDYA indicator params");
INPUT int MA_Cross_Timeframe_Indi_VIDYA_Period = 30;                                    // Period
INPUT int MA_Cross_Timeframe_Indi_VIDYA_MA_Period = 20;                                 // MA Period
INPUT int MA_Cross_Timeframe_Indi_VIDYA_MA_Shift = 1;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE MA_Cross_Timeframe_Indi_VIDYA_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int MA_Cross_Timeframe_Indi_VIDYA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Cross_Timeframe_Indi_VIDYA_SourceType = IDATA_BUILTIN;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_MA_Cross_Timeframe_Params_Defaults : StgParams {
  Stg_MA_Cross_Timeframe_Params_Defaults()
      : StgParams(::MA_Cross_Timeframe_SignalOpenMethod, ::MA_Cross_Timeframe_SignalOpenFilterMethod,
                  ::MA_Cross_Timeframe_SignalOpenLevel, ::MA_Cross_Timeframe_SignalOpenBoostMethod,
                  ::MA_Cross_Timeframe_SignalCloseMethod, ::MA_Cross_Timeframe_SignalCloseFilter,
                  ::MA_Cross_Timeframe_SignalCloseLevel, ::MA_Cross_Timeframe_PriceStopMethod,
                  ::MA_Cross_Timeframe_PriceStopLevel, ::MA_Cross_Timeframe_TickFilterMethod,
                  ::MA_Cross_Timeframe_MaxSpread, ::MA_Cross_Timeframe_Shift) {
    Set(STRAT_PARAM_LS, MA_Cross_Timeframe_LotSize);
    Set(STRAT_PARAM_OCL, MA_Cross_Timeframe_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, MA_Cross_Timeframe_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, MA_Cross_Timeframe_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, MA_Cross_Timeframe_SignalOpenFilterTime);
  }
};

class Stg_MA_Cross_Timeframe : public Strategy {
 protected:
  Stg_MA_Cross_Timeframe_Params_Defaults ssparams;

 public:
  Stg_MA_Cross_Timeframe(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_MA_Cross_Timeframe *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_MA_Cross_Timeframe_Params_Defaults stg_ma_cross_timeframe_defaults;
    StgParams _stg_params(stg_ma_cross_timeframe_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_MA_Cross_Timeframe(_stg_params, _tparams, _cparams, "MA Cross Timeframe");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    // Initialize indicators.
    switch (MA_Cross_Timeframe_Type) {
      case STG_MA_CROSS_TIMEFRAME_TYPE_AMA:  // AMA
      {
        IndiAMAParams _indi_params(
            ::MA_Cross_Timeframe_Indi_AMA_InpPeriodAMA, ::MA_Cross_Timeframe_Indi_AMA_InpFastPeriodEMA,
            ::MA_Cross_Timeframe_Indi_AMA_InpSlowPeriodEMA, ::MA_Cross_Timeframe_Indi_AMA_InpShiftAMA, PRICE_TYPICAL,
            ::MA_Cross_Timeframe_Indi_AMA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Timeframe_Indi_AMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_AMA(_indi_params), ::MA_Cross_Timeframe_Type);
        _indi_params.SetTf(::MA_Cross_Timeframe_Timeframe);
        SetIndicator(new Indi_AMA(_indi_params), ::MA_Cross_Timeframe_Type + 1);
        break;
      }
      case STG_MA_CROSS_TIMEFRAME_TYPE_DEMA:  // DEMA
      {
        IndiDEIndiMAParams _indi_params(::MA_Cross_Timeframe_Indi_DEMA_Period, ::MA_Cross_Timeframe_Indi_DEMA_MA_Shift,
                                        ::MA_Cross_Timeframe_Indi_DEMA_Applied_Price,
                                        ::MA_Cross_Timeframe_Indi_DEMA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Timeframe_Indi_DEMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_DEMA(_indi_params), ::MA_Cross_Timeframe_Type);
        _indi_params.SetTf(::MA_Cross_Timeframe_Timeframe);
        SetIndicator(new Indi_DEMA(_indi_params), ::MA_Cross_Timeframe_Type + 1);
        break;
      }
      case STG_MA_CROSS_TIMEFRAME_TYPE_FRAMA:  // FrAMA
      {
        IndiFrAIndiMAParams _indi_params(
            ::MA_Cross_Timeframe_Indi_FrAMA_Period, ::MA_Cross_Timeframe_Indi_FrAMA_MA_Shift,
            ::MA_Cross_Timeframe_Indi_FrAMA_Applied_Price, ::MA_Cross_Timeframe_Indi_FrAMA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Timeframe_Indi_FrAMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_FrAMA(_indi_params), ::MA_Cross_Timeframe_Type);
        _indi_params.SetTf(::MA_Cross_Timeframe_Timeframe);
        SetIndicator(new Indi_FrAMA(_indi_params), ::MA_Cross_Timeframe_Type + 1);
        break;
      }
      case STG_MA_CROSS_TIMEFRAME_TYPE_ICHIMOKU:  // Ichimoku
      {
        IndiIchimokuParams _indi_params(
            ::MA_Cross_Timeframe_Indi_Ichimoku_Period_Tenkan_Sen, ::MA_Cross_Timeframe_Indi_Ichimoku_Period_Kijun_Sen,
            ::MA_Cross_Timeframe_Indi_Ichimoku_Period_Senkou_Span_B, ::MA_Cross_Timeframe_Indi_Ichimoku_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Timeframe_Indi_Ichimoku_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_Ichimoku(_indi_params), ::MA_Cross_Timeframe_Type);
        _indi_params.SetTf(::MA_Cross_Timeframe_Timeframe);
        SetIndicator(new Indi_Ichimoku(_indi_params), ::MA_Cross_Timeframe_Type + 1);
        break;
      }
      case STG_MA_CROSS_TIMEFRAME_TYPE_MA:  // MA
      {
        IndiMAParams _indi_params(::MA_Cross_Timeframe_Indi_MA_Period, ::MA_Cross_Timeframe_Indi_MA_MA_Shift,
                                  ::MA_Cross_Timeframe_Indi_MA_Method, ::MA_Cross_Timeframe_Indi_MA_Applied_Price,
                                  ::MA_Cross_Timeframe_Indi_MA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Timeframe_Indi_MA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_MA(_indi_params), ::MA_Cross_Timeframe_Type);
        _indi_params.SetTf(::MA_Cross_Timeframe_Timeframe);
        SetIndicator(new Indi_MA(_indi_params), ::MA_Cross_Timeframe_Type + 1);
        break;
      }
      case STG_MA_CROSS_TIMEFRAME_TYPE_PRICE_CHANNEL:  // Price Channel
      {
        IndiPriceChannelParams _indi_params(::MA_Cross_Timeframe_Indi_PriceChannel_Period,
                                            ::MA_Cross_Timeframe_Indi_PriceChannel_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Timeframe_Indi_PriceChannel_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_PriceChannel(_indi_params), ::MA_Cross_Timeframe_Type);
        _indi_params.SetTf(::MA_Cross_Timeframe_Timeframe);
        SetIndicator(new Indi_PriceChannel(_indi_params), ::MA_Cross_Timeframe_Type + 1);
        break;
      }
      case STG_MA_CROSS_TIMEFRAME_TYPE_SAR:  // SAR
      {
        IndiSARParams _indi_params(::MA_Cross_Timeframe_Indi_SAR_Step, ::MA_Cross_Timeframe_Indi_SAR_Maximum_Stop,
                                   ::MA_Cross_Timeframe_Indi_SAR_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Timeframe_Indi_SAR_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_SAR(_indi_params), ::MA_Cross_Timeframe_Type);
        _indi_params.SetTf(::MA_Cross_Timeframe_Timeframe);
        SetIndicator(new Indi_SAR(_indi_params), ::MA_Cross_Timeframe_Type + 1);
        break;
      }
      case STG_MA_CROSS_TIMEFRAME_TYPE_TEMA:  // TEMA
      {
        IndiTEMAParams _indi_params(::MA_Cross_Timeframe_Indi_TEMA_Period, ::MA_Cross_Timeframe_Indi_TEMA_MA_Shift,
                                    ::MA_Cross_Timeframe_Indi_TEMA_Applied_Price, ::MA_Cross_Timeframe_Indi_TEMA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Timeframe_Indi_TEMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_TEMA(_indi_params), ::MA_Cross_Timeframe_Type);
        _indi_params.SetTf(::MA_Cross_Timeframe_Timeframe);
        SetIndicator(new Indi_TEMA(_indi_params), ::MA_Cross_Timeframe_Type + 1);
        break;
      }
      case STG_MA_CROSS_TIMEFRAME_TYPE_VIDYA:  // VIDYA
      {
        IndiVIDYAParams _indi_params(::MA_Cross_Timeframe_Indi_VIDYA_Period, ::MA_Cross_Timeframe_Indi_VIDYA_MA_Period,
                                     ::MA_Cross_Timeframe_Indi_VIDYA_MA_Shift,
                                     ::MA_Cross_Timeframe_Indi_VIDYA_Applied_Price,
                                     ::MA_Cross_Timeframe_Indi_VIDYA_Shift);
        _indi_params.SetDataSourceType(::MA_Cross_Timeframe_Indi_VIDYA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_VIDYA(_indi_params), ::MA_Cross_Timeframe_Type);
        _indi_params.SetTf(::MA_Cross_Timeframe_Timeframe);
        SetIndicator(new Indi_VIDYA(_indi_params), ::MA_Cross_Timeframe_Type + 1);
        break;
      }
      case STG_MA_CROSS_TIMEFRAME_TYPE_0_NONE:  // (None)
      default:
        break;
    }
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    IndicatorBase *_indi1 = GetIndicator(::MA_Cross_Timeframe_Type);
    IndicatorBase *_indi2 = GetIndicator(::MA_Cross_Timeframe_Type + 1);
    // uint _ishift = _indi1.GetParams().GetShift(); // @todo: Convert into Get().
    // uint _ishift = _indi2.GetParams().GetShift(); // @todo: Convert into Get().
    // bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift); // @fixme
    bool _result = true;
    uint _ishift = _shift;
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    // float _level_pips = (float)(_level * _chart.GetPipSize());
    double _value1 = _indi1[_shift][0];
    double _value2 = _indi2[_shift][0];
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _indi1.IsIncreasing(1, 0, _shift);
        _result &= _indi1[_ishift][0] > _indi2[_ishift][0];
        _result &= _indi1[_ishift + 1][0] < _indi2[_ishift + 1][0];
        //_result &= Math::ChangeInPct(_indi1[_ishift + 1][0], _indi1[_ishift][0], true) > _level;
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi1[_ishift][0] < _indi1[_ishift + 3][0];
          if (METHOD(_method, 1)) _result &= _indi2[_ishift][0] < _indi2[_ishift + 3][0];
          if (METHOD(_method, 2))
            _result &= fmax4(_indi1[_ishift][0], _indi1[_ishift + 1][0], _indi1[_ishift + 2][0],
                             _indi1[_ishift + 3][0]) == _indi1[_ishift][0];
          if (METHOD(_method, 3))
            _result &= fmax4(_indi2[_ishift][0], _indi2[_ishift + 1][0], _indi2[_ishift + 2][0],
                             _indi2[_ishift + 3][0]) == _indi2[_ishift][0];
        }
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _indi1.IsDecreasing(1, 0, _ishift);
        _result &= _indi1[_ishift][0] < _indi2[_ishift][0];
        _result &= _indi1[_ishift + 1][0] > _indi2[_ishift + 1][0];
        //_result &= Math::ChangeInPct(_indi1[_ishift + 1][0], _indi1[_ishift][0], true) < _level;
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi1[_ishift][0] > _indi1[_ishift + 3][0];
          if (METHOD(_method, 1)) _result &= _indi2[_ishift][0] > _indi2[_ishift + 3][0];
          if (METHOD(_method, 2))
            _result &= fmin4(_indi1[_ishift][0], _indi1[_ishift + 1][0], _indi1[_ishift + 2][0],
                             _indi1[_ishift + 3][0]) == _indi1[_ishift][0];
          if (METHOD(_method, 3))
            _result &= fmin4(_indi2[_ishift][0], _indi2[_ishift + 1][0], _indi2[_ishift + 2][0],
                             _indi2[_ishift + 3][0]) == _indi2[_ishift][0];
        }
        break;
    }
    return _result;
  }
};
