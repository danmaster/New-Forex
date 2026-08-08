/**
 * @file
 * Implements Indicator strategy to run common or custom indicators.
 */

// User input params.
INPUT_GROUP("Indicator strategy: strategy params");
INPUT float Indicator_LotSize = 0;                // Lot size
INPUT int Indicator_SignalOpenMethod = 68;        // Signal open method
INPUT float Indicator_SignalOpenLevel = 20;       // Signal open level
INPUT int Indicator_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int Indicator_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT int Indicator_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int Indicator_SignalCloseMethod = 0;        // Signal close method
INPUT int Indicator_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float Indicator_SignalCloseLevel = 20;      // Signal close level
INPUT int Indicator_PriceStopMethod = 0;          // Price limit method
INPUT float Indicator_PriceStopLevel = 2;         // Price limit level
INPUT int Indicator_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT float Indicator_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short Indicator_Shift = 0;                  // Shift
INPUT float Indicator_OrderCloseLoss = 80;        // Order close loss
INPUT float Indicator_OrderCloseProfit = 80;      // Order close profit
INPUT int Indicator_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Indicator strategy: Indicator indicator params");
INPUT ENUM_INDICATOR_TYPE Indicator_Indi_Indicator_Type = INDI_CHAIKIN;            // Indicator type
INPUT int Indicator_Indi_Indicator_Mode = 0;                                       // Mode to use
INPUT string Indicator_Indi_Indicator_Path = INDI_CUSTOM_PATH;                     // Custom only: Path
INPUT string Indicator_Indi_Indicator_Params = "[12]";                             // Custom only: Params
INPUT int Indicator_Indi_Indicator_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Indicator_Indi_Indicator_SourceType = IDATA_BUILTIN;  // Source type
INPUT ENUM_EA_DATA_EXPORT_METHOD Indicator_Indi_Indicator_DataExportMethod = EA_DATA_EXPORT_NONE;  // Export method

// Structs.

// Defines struct with default user strategy values.
struct Stg_Indicator_Params_Defaults : StgParams {
  Stg_Indicator_Params_Defaults()
      : StgParams(::Indicator_SignalOpenMethod, ::Indicator_SignalOpenFilterMethod, ::Indicator_SignalOpenLevel,
                  ::Indicator_SignalOpenBoostMethod, ::Indicator_SignalCloseMethod, ::Indicator_SignalCloseFilter,
                  ::Indicator_SignalCloseLevel, ::Indicator_PriceStopMethod, ::Indicator_PriceStopLevel,
                  ::Indicator_TickFilterMethod, ::Indicator_MaxSpread, ::Indicator_Shift) {
    Set(STRAT_PARAM_LS, Indicator_LotSize);
    Set(STRAT_PARAM_OCL, Indicator_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Indicator_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Indicator_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Indicator_SignalOpenFilterTime);
  }
};

class Stg_Indicator : public Strategy {
 public:
  Stg_Indicator(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Indicator *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_Indicator_Params_Defaults stg_indi_defaults;
    StgParams _stg_params(stg_indi_defaults);
    // Initialize indicator.
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Indicator(_stg_params, _tparams, _cparams, "Indicator");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    int _ishift = ::Indicator_Indi_Indicator_Shift;
    ENUM_TIMEFRAMES _tf = Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF);
    IndicatorBase *_indi = NULL;
    // IndicatorParams _params;
    switch (Indicator_Indi_Indicator_Type) {
      case INDI_NONE:  // (None)
        break;
      case INDI_AC:  // Accelerator Oscillator
        _indi = new Indi_AC(_tf);
        break;
      case INDI_AD:  // Accumulation/Distribution
        _indi = new Indi_AD(_tf);
        break;
      case INDI_ADX:  // Average Directional Index
        _indi = new Indi_ADX(_tf);
        break;
      case INDI_ADXW:  // ADX by Welles Wilder
        _indi = new Indi_ADXW(_tf);
        break;
      case INDI_ALLIGATOR:  // Alligator
        _indi = new Indi_Alligator(_tf);
        break;
      case INDI_AMA:  // Adaptive Moving Average
        _indi = new Indi_AMA(_tf);
        break;
      case INDI_APPLIED_PRICE:  // Applied Price over OHLC Indicator
        _indi = new Indi_AppliedPrice(_tf);
        break;
      case INDI_AO:  // Awesome Oscillator
        _indi = new Indi_AO(_tf);
        break;
      case INDI_ASI:  // Accumulation Swing Index
        _indi = new Indi_ASI(_tf);
        break;
      case INDI_ATR:  // Average True Range
        _indi = new Indi_ATR(_tf);
        break;
      case INDI_BANDS:  // Bollinger Bands
        _indi = new Indi_Bands(_tf);
        break;
      case INDI_BANDS_ON_PRICE:  // Bollinger Bands (on Price)
        // @todo
        _indi = new Indi_Bands(_tf);
        break;
      case INDI_BEARS:  // Bears Power
        _indi = new Indi_BearsPower(_tf);
        break;
      case INDI_BULLS:  // Bulls Power
        _indi = new Indi_BullsPower(_tf);
        break;
      case INDI_BWMFI:  // Market Facilitation Index
        _indi = new Indi_BWMFI(_tf);
        break;
      case INDI_BWZT:  // Bill Williams' Zone Trade
        _indi = new Indi_BWZT(_tf);
        break;
      case INDI_CANDLE:  // Candle Pattern Detector
        _indi = new Indi_Candle(_tf);
        break;
      case INDI_CCI:  // Commodity Channel Index
        _indi = new Indi_CCI(_tf);
        break;
      case INDI_CCI_ON_PRICE:  // Commodity Channel Index (CCI) (on Price)
        // @todo
        _indi = new Indi_CCI(_tf);
        break;
      case INDI_CHAIKIN:  // Chaikin Oscillator
        _indi = new Indi_CHO(_tf);
        break;
      case INDI_CHAIKIN_V:  // Chaikin Volatility
        _indi = new Indi_CHV(_tf);
        break;
      case INDI_COLOR_BARS:  // Color Bars
        _indi = new Indi_ColorBars(_tf);
        break;
      case INDI_COLOR_CANDLES_DAILY:  // Color Candles Daily
        _indi = new Indi_ColorCandlesDaily(_tf);
        break;
      case INDI_COLOR_LINE:  // Color Line
        _indi = new Indi_ColorLine(_tf);
        break;
      case INDI_CUSTOM:  // Custom indicator
      {
        IndiCustomParams _iparams_custom(::Indicator_Indi_Indicator_Path, _ishift);
        _iparams_custom.SetTf(_tf);
        if (StringLen(Indicator_Indi_Indicator_Params) > 2) {
          Matrix<double> _iparams_args = Indicator_Indi_Indicator_Params;
          for (int _ipa = 0; _ipa < _iparams_args.GetSize(); _ipa++) {
            DataParamEntry _iparam_entry = _iparams_args[_ipa].Val();
            _iparams_custom.AddParam(_iparam_entry);
          }
        }
        _indi = new Indi_Custom(_iparams_custom);
        break;
      }
      case INDI_CUSTOM_MOVING_AVG:  // Custom Moving Average
        _indi = new Indi_CustomMovingAverage(_tf);
        break;
      case INDI_DEMA:  // Double Exponential Moving Average
        _indi = new Indi_DEMA(_tf);
        break;
      case INDI_DEMARKER:  // DeMarker
        _indi = new Indi_DeMarker(_tf);
        break;
      case INDI_DEMO:  // Demo/Dummy Indicator
        _indi = new Indi_Demo(_tf);
        break;
      case INDI_DETRENDED_PRICE:  // Detrended Price Oscillator
        _indi = new Indi_Price(_tf);
        break;
      case INDI_DRAWER:  // Drawer (Socket-based) Indicator
        // @todo
        _indi = new Indi_Drawer(_tf);
        break;
      case INDI_ENVELOPES:  // Envelopes
        _indi = new Indi_Drawer(_tf);
        break;
      case INDI_ENVELOPES_ON_PRICE:  // Evelopes (on Price)
        // @todo
        _indi = new Indi_Envelopes(_tf);
        break;
      case INDI_FORCE:  // Force Index
        _indi = new Indi_Force(_tf);
        break;
      case INDI_FRACTALS:  // Fractals
        _indi = new Indi_Fractals(_tf);
        break;
      case INDI_FRAMA:  // Fractal Adaptive Moving Average
        _indi = new Indi_FrAMA(_tf);
        break;
      case INDI_GATOR:  // Gator Oscillator
        _indi = new Indi_Gator(_tf);
        break;
      case INDI_HEIKENASHI:  // Heiken Ashi
        _indi = new Indi_HeikenAshi(_tf);
        break;
      case INDI_ICHIMOKU:  // Ichimoku Kinko Hyo
        _indi = new Indi_Ichimoku(_tf);
        break;
      case INDI_KILLZONES:  // Killzones
        _indi = new Indi_Killzones(_tf);
        break;
      case INDI_MA:  // Moving Average
        _indi = new Indi_MA(_tf);
        break;
      case INDI_MACD:  // MACD
        _indi = new Indi_MACD(_tf);
        break;
      case INDI_MA_ON_PRICE:  // Moving Average (on Price).
        // @todo
        _indi = new Indi_MA(_tf);
        break;
      case INDI_MARKET_FI:  // Market Facilitation Index
        // @todo
        //_indi = new Indi_XXX(_tf);
        break;
      case INDI_MASS_INDEX:  // Mass Index
        _indi = new Indi_MassIndex(_tf);
        break;
      case INDI_MFI:  // Money Flow Index
        _indi = new Indi_MFI(_tf);
        break;
      case INDI_MOMENTUM:  // Momentum
        _indi = new Indi_Momentum(_tf);
        break;
      case INDI_MOMENTUM_ON_PRICE:  // Momentum (on Price)
        // @todo
        _indi = new Indi_Momentum(_tf);
        break;
      case INDI_OBV:  // On Balance Volume
        _indi = new Indi_OBV(_tf);
        break;
      case INDI_OHLC:  // OHLC (Open-High-Low-Close)
        _indi = new Indi_OHLC(_tf);
        break;
      case INDI_OSMA:  // OsMA
        _indi = new Indi_OsMA(_tf);
        break;
      case INDI_PATTERN:  // Pattern Detector
        _indi = new Indi_Pattern(_tf);
        break;
      case INDI_PIVOT:  // Pivot Detector
        _indi = new Indi_Pivot(_tf);
        break;
      case INDI_PRICE:  // Price
        _indi = new Indi_Price(_tf);
        break;
      case INDI_PRICE_CHANNEL:  // Price Channel
        _indi = new Indi_PriceChannel(_tf);
        break;
      case INDI_PRICE_FEEDER:  // Indicator which returns prices from custom array
        _indi = new Indi_PriceFeeder(_tf);
        break;
      case INDI_PRICE_VOLUME_TREND:  // Price and Volume Trend
        _indi = new Indi_PriceVolumeTrend(_tf);
        break;
      case INDI_RATE_OF_CHANGE:  // Rate of Change
        _indi = new Indi_RateOfChange(_tf);
        break;
      case INDI_RS:  // Indi_Math-based RSI indicator.
        _indi = new Indi_RS(_tf);
        break;
      case INDI_RSI:  // Relative Strength Index
        _indi = new Indi_RSI(_tf);
        break;
      case INDI_RSI_ON_PRICE:  // Relative Strength Index (RSI) (on Price)
        // @todo
        _indi = new Indi_RSI(_tf);
        break;
      case INDI_RVI:  // Relative Vigor Index
        _indi = new Indi_RVI(_tf);
        break;
      case INDI_SAR:  // Parabolic SAR
        _indi = new Indi_SAR(_tf);
        break;
      case INDI_SPECIAL_MATH:  // Math operations over given indicator.
        _indi = new Indi_Math(_tf);
        break;
      case INDI_STDDEV:  // Standard Deviation
        _indi = new Indi_StdDev(_tf);
        break;
      case INDI_STDDEV_ON_MA_SMA:  // Standard Deviation on Moving Average in SMA mode
        // @todo
        _indi = new Indi_StdDev(_tf);
        break;
      case INDI_STDDEV_ON_PRICE:  // Standard Deviation (on Price)
        // @todo
        _indi = new Indi_StdDev(_tf);
        break;
      case INDI_STDDEV_SMA_ON_PRICE:  // Standard Deviation in SMA mode (on Price)
        // @todo
        _indi = new Indi_StdDev(_tf);
        break;
      case INDI_STOCHASTIC:  // Stochastic Oscillator
        _indi = new Indi_Stochastic(_tf);
        break;
      case INDI_TEMA:  // Triple Exponential Moving Average
        _indi = new Indi_TEMA(_tf);
        break;
      case INDI_TICK:  // Tick
        // @todo
        //_indi = new Indi_Tick(_tf);
        break;
      case INDI_TMA_TRUE:  // Triangular Moving Average True
        // @todo
        //_indi = new Indi_TMA_True(_tf);
        break;
      case INDI_TRIX:  // Triple Exponential Moving Averages Oscillator
        _indi = new Indi_TRIX(_tf);
        break;
      case INDI_ULTIMATE_OSCILLATOR:  // Ultimate Oscillator
        _indi = new Indi_UltimateOscillator(_tf);
        break;
      case INDI_VIDYA:  // Variable Index Dynamic Average
        _indi = new Indi_VIDYA(_tf);
        break;
      case INDI_VOLUMES:  // Volumes
        _indi = new Indi_Volumes(_tf);
        break;
      case INDI_VROC:  // Volume Rate of Change
        _indi = new Indi_VROC(_tf);
        break;
      case INDI_WILLIAMS_AD:  // Larry Williams' Accumulation/Distribution
        _indi = new Indi_WilliamsAD(_tf);
        break;
      case INDI_WPR:  // Williams' Percent Range
        _indi = new Indi_WPR(_tf);
        break;
      case INDI_ZIGZAG:  // ZigZag
        _indi = new Indi_ZigZag(_tf);
        break;
      case INDI_ZIGZAG_COLOR:  // ZigZag Color
        _indi = new Indi_ZigZagColor(_tf);
        break;
      default:
        break;
    }
    if (_indi != NULL) {
      SetIndicator(_indi, Indicator_Indi_Indicator_Type);
    }
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    IndicatorBase *_indi = GetIndicator(::Indicator_Indi_Indicator_Type);
    bool _result = true;
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    IndicatorSignal _signals = _indi.GetSignals(4, _shift);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _indi[Indicator_Indi_Indicator_Mode][_shift] > _level;
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _indi[Indicator_Indi_Indicator_Mode][_shift] < _level;
        _result &= _method > 0 ? _signals.CheckSignals(_method) : _signals.CheckSignalsAll(-_method);
        break;
    }
    return _result;
  }

  /**
   * Executes on new time periods.
   */
  void OnPeriod(unsigned int _periods = DATETIME_NONE) {
    ENUM_EA_DATA_EXPORT_METHOD _export_method;
    IndicatorBase *_indi;
    if ((_periods & DATETIME_MINUTE) != 0) {
      // New minute started.
      _export_method = ::Indicator_Indi_Indicator_DataExportMethod;
      if (_export_method != EA_DATA_EXPORT_NONE) {
        _indi = GetIndicator(::Indicator_Indi_Indicator_Type);
        _indi.GetEntry();
      }
    }
    if ((_periods & DATETIME_HOUR) != 0) {
      // New hour started.
    }
    if ((_periods & DATETIME_DAY) != 0) {
      // New day started.
      _export_method = ::Indicator_Indi_Indicator_DataExportMethod;
      if (_export_method != EA_DATA_EXPORT_NONE) {
        ENUM_TIMEFRAMES _tf = Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF);
        _indi = GetIndicator(::Indicator_Indi_Indicator_Type);
        if (_indi.GetData().Size() > 0) {
          // Perform an export of data.
          int _serializer_flags = SERIALIZER_FLAG_SKIP_HIDDEN | SERIALIZER_FLAG_INCLUDE_DEFAULT |
                                  SERIALIZER_FLAG_INCLUDE_DYNAMIC | SERIALIZER_FLAG_REUSE_STUB |
                                  SERIALIZER_FLAG_REUSE_OBJECT;
          string _indi_key =
              StringFormat("%s-%d-%d-%d", __FILE__, _tf, _indi.GetData().GetMin(), _indi.GetData().GetMax());
          SerializerConverter _stub = Serializer::MakeStubObject<BufferStruct<IndicatorDataEntry>>(_serializer_flags);
          SerializerConverter _obj = SerializerConverter::FromObject(_indi.GetData(), _serializer_flags);
          if (_export_method == EA_DATA_EXPORT_CSV || _export_method == EA_DATA_EXPORT_ALL) {
            _obj.ToFile<SerializerCsv>(_indi_key + ".csv", _serializer_flags, &_stub);
          }
          if (_export_method == EA_DATA_EXPORT_DB || _export_method == EA_DATA_EXPORT_ALL) {
            SerializerSqlite::ConvertToFile(_obj, _indi_key + ".sqlite", "idata", _serializer_flags, &_stub);
          }
          if (_export_method == EA_DATA_EXPORT_JSON || _export_method == EA_DATA_EXPORT_ALL) {
            _obj.ToFile<SerializerJson>(_indi_key + ".json", _serializer_flags, &_stub);
          }
          // Required for SERIALIZER_FLAG_REUSE_STUB flag.
          _stub.Clean();
          // Required for SERIALIZER_FLAG_REUSE_OBJECT flag.
          _obj.Clean();
          // Clear cache after export.
          _indi.ExecuteAction(INDI_ACTION_CLEAR_CACHE);
        }
      }
    }
    if ((_periods & DATETIME_WEEK) != 0) {
      // New week started.
    }
    if ((_periods & DATETIME_MONTH) != 0) {
      // New month started.
    }
    if ((_periods & DATETIME_YEAR) != 0) {
      // New year started.
    }
  }
};
