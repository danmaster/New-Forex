/**
 * @file
 * Implements MA Trend strategy based the moving average price indicators.
 */

enum ENUM_STG_MA_TREND_TYPE {
  STG_MA_TREND_TYPE_0_NONE = 0,     // (None)
  STG_MA_TREND_TYPE_AMA,            // AMA: Adaptive Moving Average
  STG_MA_TREND_TYPE_DEMA,           // DEMA: Double Exponential Moving Average
  STG_MA_TREND_TYPE_FRAMA,          // FrAMA: Fractal Adaptive Moving Average
  STG_MA_TREND_TYPE_ICHIMOKU,       // Ichimoku
  STG_MA_TREND_TYPE_MA,             // MA: Moving Average
  STG_MA_TREND_TYPE_PRICE_CHANNEL,  // Price Channel
  STG_MA_TREND_TYPE_SAR,            // SAR: Parabolic Stop and Reverse
  STG_MA_TREND_TYPE_TEMA,           // TEMA: Triple Exponential Moving Average
  STG_MA_TREND_TYPE_VIDYA,          // VIDYA: Variable Index Dynamic Average
};

// User params.
INPUT_GROUP("MA Trend strategy: main strategy params");
INPUT ENUM_STG_MA_TREND_TYPE MA_Trend_Type = STG_MA_TREND_TYPE_MA;  // Indicator MA type
INPUT_GROUP("MA Trend strategy: strategy params");
INPUT float MA_Trend_LotSize = 0;                // Lot size
INPUT int MA_Trend_SignalOpenMethod = 8;         // Signal open method (-127-127)
INPUT float MA_Trend_SignalOpenLevel = 7.0f;     // Signal open level
INPUT int MA_Trend_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int MA_Trend_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int MA_Trend_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int MA_Trend_SignalCloseMethod = 8;        // Signal close method (-127-127)
INPUT int MA_Trend_SignalCloseFilter = 0;        // Signal close filter (-127-127)
INPUT float MA_Trend_SignalCloseLevel = 7.0f;    // Signal close level
INPUT int MA_Trend_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float MA_Trend_PriceStopLevel = 2;         // Price stop level
INPUT int MA_Trend_TickFilterMethod = 32;        // Tick filter method
INPUT float MA_Trend_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short MA_Trend_Shift = 0;                  // Shift
INPUT float MA_Trend_OrderCloseLoss = 200;       // Order close loss
INPUT float MA_Trend_OrderCloseProfit = 200;     // Order close profit
INPUT int MA_Trend_OrderCloseTime = 2880;        // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("MA Trend strategy: AMA indicator params");
INPUT int MA_Trend_Indi_AMA_InpPeriodAMA = 20;                              // AMA period
INPUT int MA_Trend_Indi_AMA_InpFastPeriodEMA = 4;                           // Fast EMA period
INPUT int MA_Trend_Indi_AMA_InpSlowPeriodEMA = 30;                          // Slow EMA period
INPUT int MA_Trend_Indi_AMA_InpShiftAMA = 4;                                // AMA shift
INPUT int MA_Trend_Indi_AMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Trend_Indi_AMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Trend strategy: DEMA indicator params");
INPUT int MA_Trend_Indi_DEMA_Period = 25;                                    // Period
INPUT int MA_Trend_Indi_DEMA_MA_Shift = 6;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE MA_Trend_Indi_DEMA_Applied_Price = PRICE_TYPICAL;   // Applied Price
INPUT int MA_Trend_Indi_DEMA_Shift = 0;                                      // DEMA Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Trend_Indi_DEMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Trend strategy: FrAMA indicator params");
INPUT int MA_Trend_Indi_FrAMA_Period = 10;                                    // Period
INPUT ENUM_APPLIED_PRICE MA_Trend_Indi_FrAMA_Applied_Price = PRICE_TYPICAL;   // Applied Price
INPUT int MA_Trend_Indi_FrAMA_MA_Shift = 0;                                   // MA Shift
INPUT int MA_Trend_Indi_FrAMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Trend_Indi_FrAMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Trend strategy: Ichimoku indicator params");
// INPUT ENUM_ICHIMOKU_LINE MA_Trend_Indi_Ichimoku_MA_Line = LINE_TENKANSEN; // Ichimoku line for MA
INPUT int MA_Trend_Indi_Ichimoku_Period_Tenkan_Sen = 30;                         // Period Tenkan Sen
INPUT int MA_Trend_Indi_Ichimoku_Period_Kijun_Sen = 10;                          // Period Kijun Sen
INPUT int MA_Trend_Indi_Ichimoku_Period_Senkou_Span_B = 30;                      // Period Senkou Span B
INPUT int MA_Trend_Indi_Ichimoku_Shift = 1;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Trend_Indi_Ichimoku_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Trend strategy: MA indicator params");
INPUT int MA_Trend_Indi_MA_Period = 22;                                    // Period
INPUT int MA_Trend_Indi_MA_MA_Shift = 0;                                   // MA Shift
INPUT ENUM_MA_METHOD MA_Trend_Indi_MA_Method = MODE_LWMA;                  // MA Method
INPUT ENUM_APPLIED_PRICE MA_Trend_Indi_MA_Applied_Price = PRICE_TYPICAL;   // Applied Price
INPUT int MA_Trend_Indi_MA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Trend_Indi_MA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Trend strategy: Price Channel indicator params");
INPUT int MA_Trend_Indi_PriceChannel_Period = 26;                                    // Period
INPUT int MA_Trend_Indi_PriceChannel_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Trend_Indi_PriceChannel_SourceType = IDATA_ICUSTOM;  // Source type
INPUT_GROUP("MA Trend strategy: SAR indicator params");
INPUT float MA_Trend_Indi_SAR_Step = 0.04f;                                 // Step
INPUT float MA_Trend_Indi_SAR_Maximum_Stop = 0.4f;                          // Maximum stop
INPUT int MA_Trend_Indi_SAR_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Trend_Indi_SAR_SourceType = IDATA_ICUSTOM;  // Source type
INPUT_GROUP("MA Trend strategy: TEMA indicator params");
INPUT int MA_Trend_Indi_TEMA_Period = 10;                                    // Period
INPUT int MA_Trend_Indi_TEMA_MA_Shift = 0;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE MA_Trend_Indi_TEMA_Applied_Price = PRICE_TYPICAL;   // Applied Price
INPUT int MA_Trend_Indi_TEMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Trend_Indi_TEMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("MA Trend strategy: VIDYA indicator params");
INPUT int MA_Trend_Indi_VIDYA_Period = 30;                                    // Period
INPUT int MA_Trend_Indi_VIDYA_MA_Period = 20;                                 // MA Period
INPUT int MA_Trend_Indi_VIDYA_MA_Shift = 1;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE MA_Trend_Indi_VIDYA_Applied_Price = PRICE_TYPICAL;   // Applied Price
INPUT int MA_Trend_Indi_VIDYA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE MA_Trend_Indi_VIDYA_SourceType = IDATA_BUILTIN;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_MA_TrendParams_Defaults : StgParams {
  Stg_MA_TrendParams_Defaults()
      : StgParams(::MA_Trend_SignalOpenMethod, ::MA_Trend_SignalOpenFilterMethod, ::MA_Trend_SignalOpenLevel,
                  ::MA_Trend_SignalOpenBoostMethod, ::MA_Trend_SignalCloseMethod, ::MA_Trend_SignalCloseFilter,
                  ::MA_Trend_SignalCloseLevel, ::MA_Trend_PriceStopMethod, ::MA_Trend_PriceStopLevel,
                  ::MA_Trend_TickFilterMethod, ::MA_Trend_MaxSpread, ::MA_Trend_Shift) {
    Set(STRAT_PARAM_LS, ::MA_Trend_LotSize);
    Set(STRAT_PARAM_OCL, ::MA_Trend_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, ::MA_Trend_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, ::MA_Trend_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, ::MA_Trend_SignalOpenFilterTime);
  }
};

class Stg_MA_Trend : public Strategy {
 public:
  Stg_MA_Trend(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_MA_Trend *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_MA_TrendParams_Defaults stg_ma_trend_defaults;
    StgParams _stg_params(stg_ma_trend_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_MA_Trend(_stg_params, _tparams, _cparams, "MA Trend");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    // Initialize indicators.
    switch (::MA_Trend_Type) {
      case STG_MA_TREND_TYPE_AMA:  // AMA
      {
        IndiAMAParams _indi_params(::MA_Trend_Indi_AMA_InpPeriodAMA, ::MA_Trend_Indi_AMA_InpFastPeriodEMA,
                                   ::MA_Trend_Indi_AMA_InpSlowPeriodEMA, ::MA_Trend_Indi_AMA_InpShiftAMA, PRICE_TYPICAL,
                                   ::MA_Trend_Indi_AMA_Shift);
        _indi_params.SetDataSourceType(::MA_Trend_Indi_AMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_AMA(_indi_params), ::MA_Trend_Type);
        _indi_params.SetTf(PERIOD_D1);
        SetIndicator(new Indi_AMA(_indi_params), ::MA_Trend_Type + 1);
        break;
      }
      case STG_MA_TREND_TYPE_DEMA:  // DEMA
      {
        IndiDEIndiMAParams _indi_params(::MA_Trend_Indi_DEMA_Period, ::MA_Trend_Indi_DEMA_MA_Shift,
                                        ::MA_Trend_Indi_DEMA_Applied_Price, ::MA_Trend_Indi_DEMA_Shift);
        _indi_params.SetDataSourceType(::MA_Trend_Indi_DEMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_DEMA(_indi_params), ::MA_Trend_Type);
        _indi_params.SetTf(PERIOD_D1);
        SetIndicator(new Indi_DEMA(_indi_params), ::MA_Trend_Type + 1);
        break;
      }
      case STG_MA_TREND_TYPE_FRAMA:  // FrAMA
      {
        IndiFrAIndiMAParams _indi_params(::MA_Trend_Indi_FrAMA_Period, ::MA_Trend_Indi_FrAMA_MA_Shift,
                                         ::MA_Trend_Indi_FrAMA_Applied_Price, ::MA_Trend_Indi_FrAMA_Shift);
        _indi_params.SetDataSourceType(::MA_Trend_Indi_FrAMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_FrAMA(_indi_params), ::MA_Trend_Type);
        _indi_params.SetTf(PERIOD_D1);
        SetIndicator(new Indi_FrAMA(_indi_params), ::MA_Trend_Type + 1);
        break;
      }
      case STG_MA_TREND_TYPE_ICHIMOKU:  // Ichimoku
      {
        IndiIchimokuParams _indi_params(::MA_Trend_Indi_Ichimoku_Period_Tenkan_Sen,
                                        ::MA_Trend_Indi_Ichimoku_Period_Kijun_Sen,
                                        ::MA_Trend_Indi_Ichimoku_Period_Senkou_Span_B, ::MA_Trend_Indi_Ichimoku_Shift);
        _indi_params.SetDataSourceType(::MA_Trend_Indi_Ichimoku_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_Ichimoku(_indi_params), ::MA_Trend_Type);
        _indi_params.SetTf(PERIOD_D1);
        SetIndicator(new Indi_Ichimoku(_indi_params), ::MA_Trend_Type + 1);
        break;
      }
      case STG_MA_TREND_TYPE_MA:  // MA
      {
        IndiMAParams _indi_params(::MA_Trend_Indi_MA_Period, ::MA_Trend_Indi_MA_MA_Shift, ::MA_Trend_Indi_MA_Method,
                                  ::MA_Trend_Indi_MA_Applied_Price, ::MA_Trend_Indi_MA_Shift);
        _indi_params.SetDataSourceType(::MA_Trend_Indi_MA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_MA(_indi_params), ::MA_Trend_Type);
        _indi_params.SetTf(PERIOD_D1);
        SetIndicator(new Indi_MA(_indi_params), ::MA_Trend_Type + 1);
        break;
      }
      case STG_MA_TREND_TYPE_PRICE_CHANNEL:  // Price Channel
      {
        IndiPriceChannelParams _indi_params(::MA_Trend_Indi_PriceChannel_Period, ::MA_Trend_Indi_PriceChannel_Shift);
        _indi_params.SetDataSourceType(::MA_Trend_Indi_PriceChannel_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_PriceChannel(_indi_params), ::MA_Trend_Type);
        _indi_params.SetTf(PERIOD_D1);
        SetIndicator(new Indi_PriceChannel(_indi_params), ::MA_Trend_Type + 1);
        break;
      }
      case STG_MA_TREND_TYPE_SAR:  // SAR
      {
        IndiSARParams _indi_params(::MA_Trend_Indi_SAR_Step, ::MA_Trend_Indi_SAR_Maximum_Stop,
                                   ::MA_Trend_Indi_SAR_Shift);
        _indi_params.SetDataSourceType(::MA_Trend_Indi_SAR_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_SAR(_indi_params), ::MA_Trend_Type);
        _indi_params.SetTf(PERIOD_D1);
        SetIndicator(new Indi_SAR(_indi_params), ::MA_Trend_Type + 1);
        break;
      }
      case STG_MA_TREND_TYPE_TEMA:  // TEMA
      {
        IndiTEMAParams _indi_params(::MA_Trend_Indi_TEMA_Period, ::MA_Trend_Indi_TEMA_MA_Shift,
                                    ::MA_Trend_Indi_TEMA_Applied_Price, ::MA_Trend_Indi_TEMA_Shift);
        _indi_params.SetDataSourceType(::MA_Trend_Indi_TEMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_TEMA(_indi_params), ::MA_Trend_Type);
        _indi_params.SetTf(PERIOD_D1);
        SetIndicator(new Indi_TEMA(_indi_params), ::MA_Trend_Type + 1);
        break;
      }
      case STG_MA_TREND_TYPE_VIDYA:  // VIDYA
      {
        IndiVIDYAParams _indi_params(::MA_Trend_Indi_VIDYA_Period, ::MA_Trend_Indi_VIDYA_MA_Period,
                                     ::MA_Trend_Indi_VIDYA_MA_Shift, ::MA_Trend_Indi_VIDYA_Applied_Price,
                                     ::MA_Trend_Indi_VIDYA_Shift);
        _indi_params.SetDataSourceType(::MA_Trend_Indi_VIDYA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_VIDYA(_indi_params), ::MA_Trend_Type);
        _indi_params.SetTf(PERIOD_D1);
        SetIndicator(new Indi_VIDYA(_indi_params), ::MA_Trend_Type + 1);
        break;
      }
      case STG_MA_TREND_TYPE_0_NONE:  // (None)
      default:
        break;
    }
  }

  /**
   * Gets price stop value.
   */
  float PriceStop(ENUM_ORDER_TYPE _cmd, ENUM_ORDER_TYPE_VALUE _mode, int _method = 0, float _level = 0.0f,
                  short _bars = 4) {
    float _result = 0;
    if (_method == 0) {
      // Ignores calculation when method is 0.
      return (float)_result;
    }
    float _trade_dist = trade.GetTradeDistanceInValue();
    int _count = (int)fmax(fabs(_level), fabs(_method));
    int _direction = Order::OrderDirection(_cmd, _mode);
    uint _ishift = 0;
    Chart *_chart = trade.GetChart();
    IndicatorBase *_indi = GetIndicator(::MA_Trend_Type);
    IndicatorBase *_indi_trend = GetIndicator(::MA_Trend_Type + 1);
    float _level_pips = (float)(_level * _chart.GetPipSize());
    float _ma_diff = (float)fabs(_indi_trend[_ishift][0] - _indi[_ishift][0]);

    switch (_mode) {
      case ORDER_TYPE_SL:
        _result = (float)_indi_trend[_ishift][0] - _level_pips;
        break;
      case ORDER_TYPE_TP:
        _result = (float)(_indi[_ishift][0] + _ma_diff * _direction) + _level_pips;
        break;
    }
    return (float)_result;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Chart *_chart = trade.GetChart();
    IndicatorBase *_indi = GetIndicator(::MA_Trend_Type);
    IndicatorBase *_indi_trend = GetIndicator(::MA_Trend_Type + 1);
    uint _ishift = _shift;  // @todo: _indi.GetShift();
    // bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift); // @fixme
    bool _result = true;
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    float _level_pips = (float)(_level * _chart.GetPipSize());
    _result &= fabs(_indi_trend[_ishift][0] - _indi_trend[_ishift + 1][0]) > _level_pips;
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _indi.IsIncreasing(1, 0, _shift);
        _result &= _indi_trend.IsIncreasing(1, 0, _shift);
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi.IsIncreasing(1, 0, _shift + 1);
          if (METHOD(_method, 1)) _result &= _indi_trend.IsIncreasing(1, 0, _shift + 1);
          if (METHOD(_method, 2)) _result &= _indi.IsIncreasing(4, 0, _shift + 3);
          if (METHOD(_method, 3))
            _result &= fmax4(_indi[_shift][0], _indi[_shift + 1][0], _indi[_shift + 2][0], _indi[_shift + 3][0]) ==
                       _indi[_shift][0];
        }
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _indi.IsDecreasing(1, 0, _shift);
        _result &= _indi_trend.IsDecreasing(1, 0, _shift);
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi.IsDecreasing(1, 0, _shift + 1);
          if (METHOD(_method, 1)) _result &= _indi_trend.IsDecreasing(1, 0, _shift + 1);
          if (METHOD(_method, 2)) _result &= _indi.IsDecreasing(4, 0, _shift + 3);
          if (METHOD(_method, 3))
            _result &= fmin4(_indi[_shift][0], _indi[_shift + 1][0], _indi[_shift + 2][0], _indi[_shift + 3][0]) ==
                       _indi[_shift][0];
        }
        break;
    }
    return _result;
  }
};
