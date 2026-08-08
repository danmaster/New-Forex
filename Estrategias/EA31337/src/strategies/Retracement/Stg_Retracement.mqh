/**
 * @file
 * Implements Retracement strategy based on the Fibonacci retracement levels.
 */

enum ENUM_STG_RETRACEMENT_TYPE {
  STG_RETRACEMENT_TYPE_0_NONE = 0,     // (None)
  STG_RETRACEMENT_TYPE_AMA,            // AMA: Adaptive Moving Average
  STG_RETRACEMENT_TYPE_DEMA,           // DEMA: Double Exponential Moving Average
  STG_RETRACEMENT_TYPE_FRAMA,          // FrAMA: Fractal Adaptive Moving Average
  STG_RETRACEMENT_TYPE_ICHIMOKU,       // Ichimoku
  STG_RETRACEMENT_TYPE_MA,             // MA: Moving Average
  STG_RETRACEMENT_TYPE_PRICE_CHANNEL,  // Price Channel
  STG_RETRACEMENT_TYPE_SAR,            // SAR: Parabolic Stop and Reverse
  STG_RETRACEMENT_TYPE_TEMA,           // TEMA: Triple Exponential Moving Average
  STG_RETRACEMENT_TYPE_VIDYA,          // VIDYA: Variable Index Dynamic Average
};

// User params.
INPUT_GROUP("Retracement strategy: main strategy params");
INPUT ENUM_STG_RETRACEMENT_TYPE Retracement_Indi_Type =
    STG_RETRACEMENT_TYPE_ICHIMOKU;                                       // Retracement: Indicator MA type
INPUT ENUM_PP_TYPE Retracement_Levels_Calc_Method = PP_CLASSIC;          // Method for level calculations
INPUT ENUM_APPLIED_PRICE Retracement_Levels_Applied_Price = PRICE_HIGH;  // Calculation mode
INPUT ENUM_TIMEFRAMES Retracement_Levels_Tf = PERIOD_D1;                 // Calculation timeframe
INPUT_GROUP("Retracement strategy: strategy params");
INPUT float Retracement_LotSize = 0;                // Lot size
INPUT int Retracement_SignalOpenMethod = 0;         // Signal open method (-3-3)
INPUT float Retracement_SignalOpenLevel = 4.0f;     // Signal open level (-100-100)
INPUT int Retracement_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int Retracement_SignalOpenFilterTime = 3;     // Signal open filter time
INPUT int Retracement_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int Retracement_SignalCloseMethod = 0;        // Signal close method (-3-3)
INPUT int Retracement_SignalCloseFilter = 0;        // Signal close filter (-127-127)
INPUT float Retracement_SignalCloseLevel = 4.0f;    // Signal close level (-100-100)
INPUT int Retracement_PriceStopMethod = 1;          // Price stop method (0-127)
INPUT float Retracement_PriceStopLevel = 2;         // Price stop level
INPUT int Retracement_TickFilterMethod = 32;        // Tick filter method
INPUT float Retracement_MaxSpread = 4.0;            // Max spread to trade (pips)
INPUT short Retracement_Shift = 0;                  // Shift
INPUT float Retracement_OrderCloseLoss = 80;        // Order close loss
INPUT float Retracement_OrderCloseProfit = 80;      // Order close profit
INPUT int Retracement_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Retracement strategy: AMA indicator params");
INPUT int Retracement_Indi_AMA_InpPeriodAMA = 20;                              // AMA period
INPUT int Retracement_Indi_AMA_InpFastPeriodEMA = 4;                           // Fast EMA period
INPUT int Retracement_Indi_AMA_InpSlowPeriodEMA = 30;                          // Slow EMA period
INPUT int Retracement_Indi_AMA_InpShiftAMA = 4;                                // AMA shift
INPUT int Retracement_Indi_AMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Retracement_Indi_AMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Retracement strategy: DEMA indicator params");
INPUT int Retracement_Indi_DEMA_Period = 25;                                    // Period
INPUT int Retracement_Indi_DEMA_MA_Shift = 6;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE Retracement_Indi_DEMA_Applied_Price = PRICE_TYPICAL;   // Applied Price
INPUT int Retracement_Indi_DEMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Retracement_Indi_DEMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Retracement strategy: FrAMA indicator params");
INPUT int Retracement_Indi_FrAMA_Period = 10;                                    // Period
INPUT ENUM_APPLIED_PRICE Retracement_Indi_FrAMA_Applied_Price = PRICE_MEDIAN;    // Applied Price
INPUT int Retracement_Indi_FrAMA_MA_Shift = 0;                                   // MA Shift
INPUT int Retracement_Indi_FrAMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Retracement_Indi_FrAMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Retracement strategy: Ichimoku indicator params");
// INPUT ENUM_ICHIMOKU_LINE Retracement_Indi_Ichimoku_MA_Line = LINE_TENKANSEN; // Ichimoku line for MA
INPUT int Retracement_Indi_Ichimoku_Period_Tenkan_Sen = 30;                         // Period Tenkan Sen
INPUT int Retracement_Indi_Ichimoku_Period_Kijun_Sen = 10;                          // Period Kijun Sen
INPUT int Retracement_Indi_Ichimoku_Period_Senkou_Span_B = 30;                      // Period Senkou Span B
INPUT int Retracement_Indi_Ichimoku_Shift = 1;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Retracement_Indi_Ichimoku_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Retracement strategy: MA indicator params");
INPUT int Retracement_Indi_MA_Period = 26;                                    // Period
INPUT int Retracement_Indi_MA_MA_Shift = 0;                                   // MA Shift
INPUT ENUM_MA_METHOD Retracement_Indi_MA_Method = MODE_LWMA;                  // MA Method
INPUT ENUM_APPLIED_PRICE Retracement_Indi_MA_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int Retracement_Indi_MA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Retracement_Indi_MA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Retracement strategy: Price Channel indicator params");
INPUT int Retracement_Indi_PriceChannel_Period = 26;                                    // Period
INPUT int Retracement_Indi_PriceChannel_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Retracement_Indi_PriceChannel_SourceType = IDATA_ICUSTOM;  // Source type
INPUT_GROUP("Retracement strategy: SAR indicator params");
INPUT float Retracement_Indi_SAR_Step = 0.04f;                                 // Step
INPUT float Retracement_Indi_SAR_Maximum_Stop = 0.4f;                          // Maximum stop
INPUT int Retracement_Indi_SAR_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Retracement_Indi_SAR_SourceType = IDATA_ICUSTOM;  // Source type
INPUT_GROUP("Retracement strategy: TEMA indicator params");
INPUT int Retracement_Indi_TEMA_Period = 10;                                    // Period
INPUT int Retracement_Indi_TEMA_MA_Shift = 0;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE Retracement_Indi_TEMA_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int Retracement_Indi_TEMA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Retracement_Indi_TEMA_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Retracement strategy: VIDYA indicator params");
INPUT int Retracement_Indi_VIDYA_Period = 30;                                    // Period
INPUT int Retracement_Indi_VIDYA_MA_Period = 20;                                 // MA Period
INPUT int Retracement_Indi_VIDYA_MA_Shift = 1;                                   // MA Shift
INPUT ENUM_APPLIED_PRICE Retracement_Indi_VIDYA_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int Retracement_Indi_VIDYA_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Retracement_Indi_VIDYA_SourceType = IDATA_BUILTIN;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_Retracement_Params_Defaults : StgParams {
  Stg_Retracement_Params_Defaults()
      : StgParams(::Retracement_SignalOpenMethod, ::Retracement_SignalOpenFilterMethod, ::Retracement_SignalOpenLevel,
                  ::Retracement_SignalOpenBoostMethod, ::Retracement_SignalCloseMethod, ::Retracement_SignalCloseFilter,
                  ::Retracement_SignalCloseLevel, ::Retracement_PriceStopMethod, ::Retracement_PriceStopLevel,
                  ::Retracement_TickFilterMethod, ::Retracement_MaxSpread, ::Retracement_Shift) {
    Set(STRAT_PARAM_LS, Retracement_LotSize);
    Set(STRAT_PARAM_OCL, Retracement_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Retracement_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Retracement_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Retracement_SignalOpenFilterTime);
  }
};

struct Retracement_BarOHLC : public BarOHLC {
  bool GetLevels(ENUM_PP_TYPE _type, ENUM_APPLIED_PRICE _ap, double &_pp, double &_r1, double &_r2, double &_r3,
                 double &_r4, double &_s1, double &_s2, double &_s3, double &_s4) {
    double _range = GetRange();
    switch (_ap) {
      case PRICE_HIGH:
        _ap = IsBull() ? _ap : PRICE_LOW;
        break;
      case PRICE_LOW:
        _ap = IsBear() ? _ap : PRICE_HIGH;
        break;
      default:
        break;
    }
    switch (_type) {
      case PP_CAMARILLA:
        // A set of eight very probable levels which resemble support and resistance values for a current trend.
        _pp = GetAppliedPrice(_ap);
        _r1 = (double)(close + _range * 1.1 / 12);
        _r2 = (double)(close + _range * 1.1 / 6);
        _r3 = (double)(close + _range * 1.1 / 4);
        _r4 = (double)(close + _range * 1.1 / 2);
        _s1 = (double)(close - _range * 1.1 / 12);
        _s2 = (double)(close - _range * 1.1 / 6);
        _s3 = (double)(close - _range * 1.1 / 4);
        _s4 = (double)(close - _range * 1.1 / 2);
        break;
      case PP_CLASSIC:
        _pp = GetAppliedPrice(_ap);
        _r1 = (2 * _pp) - low;   // R1 = (H - L) * 1.1 / 12 + C (1.0833)
        _r2 = _pp + _range;      // R2 = (H - L) * 1.1 / 6 + C (1.1666)
        _r3 = _pp + _range * 2;  // R3 = (H - L) * 1.1 / 4 + C (1.25)
        _r4 = _pp + _range * 3;  // R4 = (H - L) * 1.1 / 2 + C (1.5)
        _s1 = (2 * _pp) - high;  // S1 = C - (H - L) * 1.1 / 12 (1.0833)
        _s2 = _pp - _range;      // S2 = C - (H - L) * 1.1 / 6 (1.1666)
        _s3 = _pp - _range * 2;  // S3 = C - (H - L) * 1.1 / 4 (1.25)
        _s4 = _pp - _range * 3;  // S4 = C - (H - L) * 1.1 / 2 (1.5)
        break;
      case PP_FIBONACCI:
        _pp = GetAppliedPrice(_ap);
        _r1 = (double)(_pp + 0.236 * _range);
        _r2 = (double)(_pp + 0.382 * _range);
        _r3 = (double)(_pp + 0.500 * _range);
        _r4 = (double)(_pp + 0.618 * _range);
        // _r5 = (double)(_pp + 0.786 * _range);
        _s1 = (double)(_pp - 0.236 * _range);
        _s2 = (double)(_pp - 0.382 * _range);
        _s3 = (double)(_pp - 0.500 * _range);
        _s4 = (double)(_pp - 0.618 * _range);
        // _s5 = (double)(_pp - 0.786 * _range);
        break;
      case PP_FLOOR:
        // Most basic and popular type of pivots used in Forex trading technical analysis.
        _pp = GetAppliedPrice(_ap);    // Pivot (P) = (H + L + C) / 3
        _r1 = (2 * _pp) - low;         // Resistance (R1) = (2 * P) - L
        _r2 = _pp + _range;            // R2 = P + H - L
        _r3 = high + 2 * (_pp - low);  // R3 = H + 2 * (P - L)
        _r4 = _r3;
        _s1 = (2 * _pp) - high;        // Support (S1) = (2 * P) - H
        _s2 = _pp - _range;            // S2 = P - H + L
        _s3 = low - 2 * (high - _pp);  // S3 = L - 2 * (H - P)
        _s4 = _s3;                     // ?
        break;
      case PP_TOM_DEMARK:
        // Tom DeMark's pivot point (predicted lows and highs of the period).
        _pp = GetAppliedPrice(_ap);
        _r1 = (2 * _pp) - low;  // New High = X / 2 - L.
        _r2 = _pp + _range;
        _r3 = _r1 + _range;
        _r4 = _r2 + _range;      // ?
        _s1 = (2 * _pp) - high;  // New Low = X / 2 - H.
        _s2 = _pp - _range;
        _s3 = _s1 - _range;
        _s4 = _s2 - _range;  // ?
        break;
      case PP_WOODIE:
        // Woodie's pivot point are giving more weight to the Close price of the previous period.
        // They are similar to floor pivot points, but are calculated in a somewhat different way.
        _pp = GetAppliedPrice(_ap);  // Pivot (P) = (H + L + 2 * C) / 4
        _r1 = (2 * _pp) - low;       // Resistance (R1) = (2 * P) - L
        _r2 = _pp + _range;          // R2 = P + H - L
        _r3 = _r1 + _range;
        _r4 = _r2 + _range;      // ?
        _s1 = (2 * _pp) - high;  // Support (S1) = (2 * P) - H
        _s2 = _pp - _range;      // S2 = P - H + L
        _s3 = _s1 - _range;
        _s4 = _s2 - _range;  // ?
        break;
      default:
        break;
    }
    return _r4 > _r3 && _r3 > _r2 && _r2 > _r1 && _r1 > _pp && _pp > _s1 && _s1 > _s2 && _s2 > _s3 && _s3 > _s4;
  }
};

class Stg_Retracement : public Strategy {
 protected:
  Stg_Retracement_Params_Defaults ssparams;

 public:
  Stg_Retracement(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Retracement *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_Retracement_Params_Defaults stg_ma_defaults;
    StgParams _stg_params(stg_ma_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Retracement(_stg_params, _tparams, _cparams, "Retracement");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    // Initialize indicators.
    switch (::Retracement_Indi_Type) {
      case STG_RETRACEMENT_TYPE_AMA:  // AMA
      {
        IndiAMAParams _indi_params(::Retracement_Indi_AMA_InpPeriodAMA, ::Retracement_Indi_AMA_InpFastPeriodEMA,
                                   ::Retracement_Indi_AMA_InpSlowPeriodEMA, ::Retracement_Indi_AMA_InpShiftAMA,
                                   PRICE_TYPICAL, ::Retracement_Indi_AMA_Shift);
        _indi_params.SetDataSourceType(::Retracement_Indi_AMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_AMA(_indi_params), ::Retracement_Indi_Type);
        break;
      }
      case STG_RETRACEMENT_TYPE_DEMA:  // DEMA
      {
        IndiDEIndiMAParams _indi_params(::Retracement_Indi_DEMA_Period, ::Retracement_Indi_DEMA_MA_Shift,
                                        ::Retracement_Indi_DEMA_Applied_Price, ::Retracement_Indi_DEMA_Shift);
        _indi_params.SetDataSourceType(::Retracement_Indi_DEMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_DEMA(_indi_params), ::Retracement_Indi_Type);
        break;
      }
      case STG_RETRACEMENT_TYPE_FRAMA:  // FrAMA
      {
        IndiFrAIndiMAParams _indi_params(::Retracement_Indi_FrAMA_Period, ::Retracement_Indi_FrAMA_MA_Shift,
                                         ::Retracement_Indi_FrAMA_Applied_Price, ::Retracement_Indi_FrAMA_Shift);
        _indi_params.SetDataSourceType(::Retracement_Indi_FrAMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_FrAMA(_indi_params), ::Retracement_Indi_Type);
        break;
      }
      case STG_RETRACEMENT_TYPE_ICHIMOKU:  // Ichimoku
      {
        IndiIchimokuParams _indi_params(
            ::Retracement_Indi_Ichimoku_Period_Tenkan_Sen, ::Retracement_Indi_Ichimoku_Period_Kijun_Sen,
            ::Retracement_Indi_Ichimoku_Period_Senkou_Span_B, ::Retracement_Indi_Ichimoku_Shift);
        _indi_params.SetDataSourceType(::Retracement_Indi_Ichimoku_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_Ichimoku(_indi_params), ::Retracement_Indi_Type);
        break;
      }
      case STG_RETRACEMENT_TYPE_MA:  // MA
      {
        IndiMAParams _indi_params(::Retracement_Indi_MA_Period, ::Retracement_Indi_MA_MA_Shift,
                                  ::Retracement_Indi_MA_Method, ::Retracement_Indi_MA_Applied_Price,
                                  ::Retracement_Indi_MA_Shift);
        _indi_params.SetDataSourceType(::Retracement_Indi_MA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_MA(_indi_params), ::Retracement_Indi_Type);
        break;
      }
      case STG_RETRACEMENT_TYPE_PRICE_CHANNEL:  // Price Channel
      {
        IndiPriceChannelParams _indi_params(::Retracement_Indi_PriceChannel_Period,
                                            ::Retracement_Indi_PriceChannel_Shift);
        _indi_params.SetDataSourceType(::Retracement_Indi_PriceChannel_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_PriceChannel(_indi_params), ::Retracement_Indi_Type);
        break;
      }
      case STG_RETRACEMENT_TYPE_SAR:  // SAR
      {
        IndiSARParams _indi_params(::Retracement_Indi_SAR_Step, ::Retracement_Indi_SAR_Maximum_Stop,
                                   ::Retracement_Indi_SAR_Shift);
        _indi_params.SetDataSourceType(::Retracement_Indi_SAR_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_SAR(_indi_params), ::Retracement_Indi_Type);
        break;
      }
      case STG_RETRACEMENT_TYPE_TEMA:  // TEMA
      {
        IndiTEMAParams _indi_params(::Retracement_Indi_TEMA_Period, ::Retracement_Indi_TEMA_MA_Shift,
                                    ::Retracement_Indi_TEMA_Applied_Price, ::Retracement_Indi_TEMA_Shift);
        _indi_params.SetDataSourceType(::Retracement_Indi_TEMA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_TEMA(_indi_params), ::Retracement_Indi_Type);
        break;
      }
      case STG_RETRACEMENT_TYPE_VIDYA:  // VIDYA
      {
        IndiVIDYAParams _indi_params(::Retracement_Indi_VIDYA_Period, ::Retracement_Indi_VIDYA_MA_Period,
                                     ::Retracement_Indi_VIDYA_MA_Shift, ::Retracement_Indi_VIDYA_Applied_Price,
                                     ::Retracement_Indi_VIDYA_Shift);
        _indi_params.SetDataSourceType(::Retracement_Indi_VIDYA_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_VIDYA(_indi_params), ::Retracement_Indi_Type);
        break;
      }
      case STG_RETRACEMENT_TYPE_0_NONE:  // (None)
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
    IndicatorBase *_indi = GetIndicator(::Retracement_Indi_Type);

    double _pp, _r1, _r2, _r3, _r4, _s1, _s2, _s3, _s4;
    ChartEntry _ohlc_range = _chart.GetEntry(::Retracement_Levels_Tf, _ishift + 1, _chart.GetSymbol());
    Retracement_BarOHLC _bar = _ohlc_range.GetBar().GetOHLC();
    _bar.GetLevels(::Retracement_Levels_Calc_Method, ::Retracement_Levels_Applied_Price, _pp, _r1, _r2, _r3, _r4, _s1,
                   _s2, _s3, _s4);
    float _level_value = _bar.GetRange() / 100 * _level;
    float _ma_level_prox_r = (float)fmin4(fabs(_indi[_ishift][0] - _r1), fabs(_indi[_ishift][0] - _r2),
                                          fabs(_indi[_ishift][0] - _r3), fabs(_indi[_ishift][0] - _r4));
    float _ma_level_prox_s = (float)fmin4(fabs(_indi[_ishift][0] - _s1), fabs(_indi[_ishift][0] - _s2),
                                          fabs(_indi[_ishift][0] - _s3), fabs(_indi[_ishift][0] - _s4));
    switch (_mode) {
      case ORDER_TYPE_SL:
        if (_indi[_ishift][0] > _s1) {
          _result = float(_s1 - _level_value);
        } else if (_indi[_ishift][0] > _s2) {
          _result = float(_s2 - _level_value);
        } else if (_indi[_ishift][0] > _s3) {
          _result = float(_s3 - _level_value);
        } else if (_indi[_ishift][0] > _s4) {
          _result = float(_s4 - _level_value);
        }
        break;
      case ORDER_TYPE_TP:
        if (_indi[_ishift][0] < _r1) {
          _result = float(_r1 - _level_value);
        } else if (_indi[_ishift][0] < _r2) {
          _result = float(_r2 - _level_value);
        } else if (_indi[_ishift][0] < _r3) {
          _result = float(_r3 - _level_value);
        } else if (_indi[_ishift][0] < _r4) {
          _result = float(_r4 - _level_value);
        }
        break;
    }
    return (float)_result;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Chart *_chart = trade.GetChart();
    IndicatorBase *_indi = GetIndicator(::Retracement_Indi_Type);
    // uint _ishift = _indi.GetParams().GetShift(); // @todo: Convert into Get().
    // bool _result = _indi.GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift); // @fixme
    uint _ishift = _shift;
    bool _result = true;
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    double _pp, _r1, _r2, _r3, _r4, _s1, _s2, _s3, _s4;
    ChartEntry _ohlc_range = _chart.GetEntry(::Retracement_Levels_Tf, _shift + 1, _chart.GetSymbol());
    Retracement_BarOHLC _bar = _ohlc_range.GetBar().GetOHLC();
    _bar.GetLevels(::Retracement_Levels_Calc_Method, ::Retracement_Levels_Applied_Price, _pp, _r1, _r2, _r3, _r4, _s1,
                   _s2, _s3, _s4);
    float _level_value = _bar.GetRange() / 100 * _level;
    float _ma_level_prox_r = (float)fmin4(fabs(_indi[_ishift][0] - _r1), fabs(_indi[_ishift][0] - _r2),
                                          fabs(_indi[_ishift][0] - _r3), fabs(_indi[_ishift][0] - _r4));
    float _ma_level_prox_s = (float)fmin4(fabs(_indi[_ishift][0] - _s1), fabs(_indi[_ishift][0] - _s2),
                                          fabs(_indi[_ishift][0] - _s3), fabs(_indi[_ishift][0] - _s4));
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _bar.IsBull();
        _result &= _bar.IsBull() ? _indi.IsIncreasing(1, 0, _ishift) : _indi.IsDecreasing(1, 0, _ishift);
        _result &= _ma_level_prox_s <= _level_value;
        if (_result && _method != 0) {
          if (METHOD(_method, 0))
            _result &= _bar.IsBull() ? fmax4(_indi[_ishift][0], _indi[_ishift + 1][0], _indi[_ishift + 2][0],
                                             _indi[_ishift + 3][0]) == _indi[_ishift][0]
                                     : fmin4(_indi[_ishift][0], _indi[_ishift + 1][0], _indi[_ishift + 2][0],
                                             _indi[_ishift + 3][0]) == _indi[_ishift][0];
        }
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _bar.IsBear();
        _result &= _bar.IsBear() ? _indi.IsDecreasing(1, 0, _ishift) : _indi.IsIncreasing(1, 0, _ishift);
        _result &= _ma_level_prox_s <= _level_value;
        if (_result && _method != 0) {
          if (METHOD(_method, 0))
            _result &= _bar.IsBear() ? fmin4(_indi[_ishift][0], _indi[_ishift + 1][0], _indi[_ishift + 2][0],
                                             _indi[_ishift + 3][0]) == _indi[_ishift][0]
                                     : fmax4(_indi[_ishift][0], _indi[_ishift + 1][0], _indi[_ishift + 2][0],
                                             _indi[_ishift + 3][0]) == _indi[_ishift][0];
        }
        break;
    }
    return _result;
  }
};
