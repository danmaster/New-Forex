/**
 * @file
 * Implements Oscillator strategy based on the Oscillator indicator.
 */

enum ENUM_STG_OSCILLATOR_TYPE {
  STG_OSCILLATOR_TYPE_0_NONE = 0,  // (None)
  STG_OSCILLATOR_TYPE_AC,          // AC: Accelerator/Decelerator
  STG_OSCILLATOR_TYPE_AD,          // AD: Accumulation/Distribution
  STG_OSCILLATOR_TYPE_AO,          // AO: Awesome
  STG_OSCILLATOR_TYPE_ATR,         // ATR
  STG_OSCILLATOR_TYPE_BEARS,       // Bears Power
  STG_OSCILLATOR_TYPE_BULLS,       // Bulls Power
  STG_OSCILLATOR_TYPE_BWMFI,       // BWMFI
  STG_OSCILLATOR_TYPE_CCI,         // CCI
  STG_OSCILLATOR_TYPE_CHO,         // CHO: Chaikin
  STG_OSCILLATOR_TYPE_CHV,         // CHV: Chaikin Volatility
  STG_OSCILLATOR_TYPE_DEMARKER,    // DeMarker
  STG_OSCILLATOR_TYPE_MFI,         // MFI
  STG_OSCILLATOR_TYPE_MOM,         // MOM: Momentum
  STG_OSCILLATOR_TYPE_OBV,         // OBV: On Balance Volume
  STG_OSCILLATOR_TYPE_PVT,         // PVT: Price and Volume Trend
  STG_OSCILLATOR_TYPE_ROC,         // ROC: Rate of Change
  STG_OSCILLATOR_TYPE_RSI,         // RSI
  STG_OSCILLATOR_TYPE_STDDEV,      // StdDev: Standard Deviation
  STG_OSCILLATOR_TYPE_STOCH,       // Stochastic
  STG_OSCILLATOR_TYPE_TRIX,        // TRIX: Triple Exponential Average
  STG_OSCILLATOR_TYPE_UO,          // UO: Ultimate Oscillator
  STG_OSCILLATOR_TYPE_WAD,         // WAD: Larry Williams' Accumulation/Distribution
  STG_OSCILLATOR_TYPE_WPR,         // WPR
  STG_OSCILLATOR_TYPE_VOL,         // VOL: Volumes
};

// User input params.
INPUT_GROUP("Oscillator strategy: main strategy params");
INPUT ENUM_STG_OSCILLATOR_TYPE Oscillator_Type = STG_OSCILLATOR_TYPE_CCI;  // Oscillator type
INPUT_GROUP("Oscillator strategy: strategy params");
INPUT float Oscillator_LotSize = 0;                // Lot size
INPUT int Oscillator_SignalOpenMethod = 6;         // Signal open method
INPUT float Oscillator_SignalOpenLevel = 0;        // Signal open level
INPUT int Oscillator_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT int Oscillator_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT int Oscillator_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT int Oscillator_SignalCloseMethod = 0;        // Signal close method
INPUT int Oscillator_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT float Oscillator_SignalCloseLevel = 0;       // Signal close level
INPUT int Oscillator_PriceStopMethod = 0;          // Price limit method
INPUT float Oscillator_PriceStopLevel = 2;         // Price limit level
INPUT int Oscillator_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT float Oscillator_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT short Oscillator_Shift = 0;                  // Shift
INPUT float Oscillator_OrderCloseLoss = 80;        // Order close loss
INPUT float Oscillator_OrderCloseProfit = 80;      // Order close profit
INPUT int Oscillator_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)
INPUT_GROUP("Oscillator strategy: AC oscillator params");
INPUT int Oscillator_Indi_AC_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_AC_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: AD oscillator params");
INPUT int Oscillator_Indi_AD_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_AD_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: ATR oscillator params");
INPUT int Oscillator_Indi_ATR_Period = 13;                                    // Period
INPUT int Oscillator_Indi_ATR_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_ATR_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: Awesome oscillator params");
INPUT int Oscillator_Indi_Awesome_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_Awesome_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: BearsPower oscillator params");
INPUT int Oscillator_Indi_BearsPower_Period = 30;                                    // Period
INPUT ENUM_APPLIED_PRICE Oscillator_Indi_BearsPower_Applied_Price = PRICE_CLOSE;     // Applied Price
INPUT int Oscillator_Indi_BearsPower_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_BearsPower_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: BullsPower oscillator params");
INPUT int Oscillator_Indi_BullsPower_Period = 30;                                    // Period
INPUT ENUM_APPLIED_PRICE Oscillator_Indi_BullsPower_Applied_Price = PRICE_CLOSE;     // Applied Price
INPUT int Oscillator_Indi_BullsPower_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_BullsPower_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: BWMFI oscillator params");
INPUT int Oscillator_Indi_BWMFI_Shift = 1;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_BWMFI_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: CCI oscillator params");
INPUT int Oscillator_Indi_CCI_Period = 20;                                    // Period
INPUT ENUM_APPLIED_PRICE Oscillator_Indi_CCI_Applied_Price = PRICE_TYPICAL;   // Applied Price
INPUT int Oscillator_Indi_CCI_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_CCI_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: Chaikin oscillator params");
INPUT int Oscillator_Indi_CHO_InpFastMA = 10;                                 // Fast EMA period
INPUT int Oscillator_Indi_CHO_InpSlowMA = 30;                                 // Slow MA period
INPUT ENUM_MA_METHOD Oscillator_Indi_CHO_InpSmoothMethod = MODE_SMMA;         // MA method
INPUT ENUM_APPLIED_VOLUME Oscillator_Indi_CHO_InpVolumeType = VOLUME_TICK;    // Volumes
INPUT int Oscillator_Indi_CHO_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_CHO_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: Chaikin Volatility oscillator params");
INPUT unsigned int Oscillator_Indi_CHV_Smooth_Period;                         // Smooth period
INPUT unsigned int Oscillator_Indi_CHV_Period;                                // Period
INPUT ENUM_CHV_SMOOTH_METHOD Oscillator_Indi_CHV_Smooth_Method;               // Smooth method
INPUT int Oscillator_Indi_CHV_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_CHV_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: DeMarker indicator params");
INPUT int Oscillator_Indi_DeMarker_Period = 23;                                    // Period
INPUT int Oscillator_Indi_DeMarker_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_DeMarker_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: MFI oscillator params");
INPUT int Oscillator_Indi_MFI_MA_Period = 22;                                           // MA Period
INPUT ENUM_APPLIED_VOLUME Oscillator_Indi_MFI_Applied_Volume = (ENUM_APPLIED_VOLUME)0;  // Applied volume.
INPUT int Oscillator_Indi_MFI_Shift = 0;                                                // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_MFI_SourceType = IDATA_BUILTIN;            // Source type
INPUT_GROUP("Oscillator strategy: Momentum oscillator params");
INPUT int Oscillator_Indi_Momentum_Period = 12;                                    // Averaging period
INPUT ENUM_APPLIED_PRICE Oscillator_Indi_Momentum_Applied_Price = PRICE_CLOSE;     // Applied Price
INPUT int Oscillator_Indi_Momentum_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_Momentum_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: OBV oscillator params");
INPUT ENUM_APPLIED_PRICE Oscillator_Indi_OBV_Applied_Price = PRICE_CLOSE;     // Applied Price
INPUT int Oscillator_Indi_OBV_Shift = 1;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_OBV_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: PVT oscillator params");
INPUT ENUM_APPLIED_VOLUME Oscillator_Indi_PVT_InpVolumeType = VOLUME_TICK;    // Volumes
INPUT int Oscillator_Indi_PVT_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_PVT_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: ROC oscillator params");
INPUT int Oscillator_Indi_ROC_Period = 16;                                    // Period
INPUT ENUM_APPLIED_PRICE Oscillator_Indi_ROC_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int Oscillator_Indi_ROC_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_ROC_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: RSI oscillator params");
INPUT int Oscillator_Indi_RSI_Period = 16;                                    // Period
INPUT ENUM_APPLIED_PRICE Oscillator_Indi_RSI_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int Oscillator_Indi_RSI_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_RSI_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: StdDev oscillator params");
INPUT int Oscillator_Indi_StdDev_MA_Period = 24;                                 // Period
INPUT int Oscillator_Indi_StdDev_MA_Shift = 0;                                   // MA Shift
INPUT ENUM_MA_METHOD Oscillator_Indi_StdDev_MA_Method = (ENUM_MA_METHOD)3;       // MA Method
INPUT ENUM_APPLIED_PRICE Oscillator_Indi_StdDev_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int Oscillator_Indi_StdDev_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_StdDev_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: Stochastic oscillator params");
INPUT int Oscillator_Indi_Stochastic_KPeriod = 8;                      // K line period
INPUT int Oscillator_Indi_Stochastic_DPeriod = 12;                     // D line period
INPUT int Oscillator_Indi_Stochastic_Slowing = 12;                     // Slowing
INPUT ENUM_MA_METHOD Oscillator_Indi_Stochastic_MA_Method = MODE_EMA;  // Moving Average method
INPUT ENUM_STO_PRICE Oscillator_Indi_Stochastic_Price_Field = 0;       // Price (0 - Low/High or 1 - Close/Close)
INPUT int Oscillator_Indi_Stochastic_Shift = 0;                        // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_Stochastic_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: TRIX oscillator params");
INPUT int Oscillator_Indi_TRIX_InpPeriodEMA = 14;                              // EMA period
INPUT ENUM_APPLIED_PRICE Oscillator_Indi_TRIX_Applied_Price = PRICE_WEIGHTED;  // Applied Price
INPUT int Oscillator_Indi_TRIX_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_TRIX_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: Ultimate oscillator params");
INPUT int Oscillator_Indi_UO_InpFastPeriod = 7;                              // Fast ATR period
INPUT int Oscillator_Indi_UO_InpMiddlePeriod = 14;                           // Middle ATR period
INPUT int Oscillator_Indi_UO_InpSlowPeriod = 28;                             // Slow ATR period
INPUT int Oscillator_Indi_UO_InpFastK = 4;                                   // Fast K
INPUT int Oscillator_Indi_UO_InpMiddleK = 2;                                 // Middle K
INPUT int Oscillator_Indi_UO_InpSlowK = 1;                                   // Slow K
INPUT int Oscillator_Indi_UO_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_UO_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: Williams' Accumulation/Distribution oscillator params");
INPUT int Oscillator_Indi_WAD_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_WAD_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: WPR oscillator params");
INPUT int Oscillator_Indi_WPR_Period = 18;                                    // Period
INPUT int Oscillator_Indi_WPR_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_WPR_SourceType = IDATA_BUILTIN;  // Source type
INPUT_GROUP("Oscillator strategy: Volumes oscillator params");
INPUT ENUM_APPLIED_VOLUME Oscillator_Indi_VOL_InpVolumeType = VOLUME_TICK;    // Volumes
INPUT int Oscillator_Indi_VOL_Shift = 0;                                      // Shift
INPUT ENUM_IDATA_SOURCE_TYPE Oscillator_Indi_VOL_SourceType = IDATA_BUILTIN;  // Source type

// Structs.

// Defines struct with default user strategy values.
struct Stg_Oscillator_Params_Defaults : StgParams {
  Stg_Oscillator_Params_Defaults()
      : StgParams(::Oscillator_SignalOpenMethod, ::Oscillator_SignalOpenFilterMethod, ::Oscillator_SignalOpenLevel,
                  ::Oscillator_SignalOpenBoostMethod, ::Oscillator_SignalCloseMethod, ::Oscillator_SignalCloseFilter,
                  ::Oscillator_SignalCloseLevel, ::Oscillator_PriceStopMethod, ::Oscillator_PriceStopLevel,
                  ::Oscillator_TickFilterMethod, ::Oscillator_MaxSpread, ::Oscillator_Shift) {
    Set(STRAT_PARAM_LS, Oscillator_LotSize);
    Set(STRAT_PARAM_OCL, Oscillator_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Oscillator_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Oscillator_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Oscillator_SignalOpenFilterTime);
  }
};

class Stg_Oscillator : public Strategy {
 public:
  Stg_Oscillator(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Oscillator *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_Oscillator_Params_Defaults stg_oscillator_defaults;
    StgParams _stg_params(stg_oscillator_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Oscillator(_stg_params, _tparams, _cparams, "Oscillator");
    return _strat;
  }

  /**
   * Validate soscillators's entry.
   */
  bool IsValidEntry(IndicatorBase *_indi, int _shift = 0) {
    bool _result = true;
    switch (Oscillator_Type) {
      case STG_OSCILLATOR_TYPE_AC:
        _result &= dynamic_cast<Indi_AC *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_AC *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_AD:
        _result &= dynamic_cast<Indi_AD *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_AD *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_AO:
        _result &= dynamic_cast<Indi_AO *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_AO *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_ATR:
        _result &= dynamic_cast<Indi_ATR *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_ATR *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_BEARS:
        _result &= dynamic_cast<Indi_BearsPower *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_BearsPower *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_BULLS:
        _result &= dynamic_cast<Indi_BullsPower *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_BullsPower *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_BWMFI:
        _result &= dynamic_cast<Indi_BWMFI *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_BWMFI *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_CCI:
        _result &= dynamic_cast<Indi_CCI *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_CCI *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_CHO:
        _result &= dynamic_cast<Indi_CHO *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_CHO *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_CHV:
        _result &= dynamic_cast<Indi_CHV *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_CHV *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_DEMARKER:
        _result &= dynamic_cast<Indi_DeMarker *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_DeMarker *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_MFI:
        _result &= dynamic_cast<Indi_MFI *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_MFI *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_MOM:
        _result &= dynamic_cast<Indi_Momentum *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_Momentum *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_OBV:
        _result &= dynamic_cast<Indi_OBV *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_OBV *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_PVT:
        _result &= dynamic_cast<Indi_PriceVolumeTrend *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_PriceVolumeTrend *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_ROC:
        _result &= dynamic_cast<Indi_RateOfChange *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_RateOfChange *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_RSI:
        _result &= dynamic_cast<Indi_RSI *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_RSI *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_STDDEV:
        _result &= dynamic_cast<Indi_StdDev *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_StdDev *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_STOCH:
        _result &= dynamic_cast<Indi_Stochastic *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_Stochastic *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_TRIX:
        _result &= dynamic_cast<Indi_TRIX *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_TRIX *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_UO:
        _result &= dynamic_cast<Indi_UltimateOscillator *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_UltimateOscillator *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_WPR:
        _result &= dynamic_cast<Indi_WPR *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_WPR *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_WAD:
        _result &= dynamic_cast<Indi_WilliamsAD *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_WilliamsAD *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
        break;
      case STG_OSCILLATOR_TYPE_VOL:
        _result &= dynamic_cast<Indi_Volumes *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift) &&
                   dynamic_cast<Indi_Volumes *>(_indi).GetFlag(INDI_ENTRY_FLAG_IS_VALID, _shift + 1);
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
    switch (Oscillator_Type) {
      case STG_OSCILLATOR_TYPE_AC:  // AC
      {
        IndiACParams _indi_params(::Oscillator_Indi_AC_Shift);
        _indi_params.SetDataSourceType(Oscillator_Indi_AC_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_AC(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_AD:  // AD
      {
        IndiADParams _indi_params(::Oscillator_Indi_AD_Shift);
        _indi_params.SetDataSourceType(Oscillator_Indi_AD_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_AD(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_AO:  // AO
      {
        IndiAOParams _indi_params(::Oscillator_Indi_Awesome_Shift);
        _indi_params.SetDataSourceType(Oscillator_Indi_Awesome_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_AO(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_ATR:  // ATR
      {
        IndiATRParams _indi_params(::Oscillator_Indi_ATR_Period, ::Oscillator_Indi_ATR_Shift);
        _indi_params.SetDataSourceType(Oscillator_Indi_ATR_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_ATR(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_BEARS:  // Bears
      {
        IndiBearsPowerParams _indi_params(::Oscillator_Indi_BearsPower_Period,
                                          ::Oscillator_Indi_BearsPower_Applied_Price,
                                          ::Oscillator_Indi_BearsPower_Shift);
        _indi_params.SetDataSourceType(Oscillator_Indi_BearsPower_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_BearsPower(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_BULLS:  // Bulls
      {
        IndiBullsPowerParams _indi_params(::Oscillator_Indi_BullsPower_Period,
                                          ::Oscillator_Indi_BullsPower_Applied_Price,
                                          ::Oscillator_Indi_BullsPower_Shift);
        _indi_params.SetDataSourceType(Oscillator_Indi_BullsPower_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_BullsPower(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_BWMFI:  // BWMFI
      {
        IndiBWIndiMFIParams _indi_params(::Oscillator_Indi_BWMFI_Shift);
        _indi_params.SetDataSourceType(Oscillator_Indi_BWMFI_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_BWMFI(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_CCI:  // CCI
      {
        IndiCCIParams _indi_params(::Oscillator_Indi_CCI_Period, ::Oscillator_Indi_CCI_Applied_Price,
                                   ::Oscillator_Indi_CCI_Shift);
        _indi_params.SetDataSourceType(Oscillator_Indi_CCI_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_CCI(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_CHO:  // Chaikin (CHO)
      {
        IndiCHOParams _indi_params(::Oscillator_Indi_CHO_InpFastMA, ::Oscillator_Indi_CHO_InpSlowMA,
                                   ::Oscillator_Indi_CHO_InpSmoothMethod, ::Oscillator_Indi_CHO_InpVolumeType,
                                   ::Oscillator_Indi_CHO_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_CHO_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_CHO(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_CHV:  // Chaikin Volatility (CHV)
      {
        IndiCHVParams _indi_params(::Oscillator_Indi_CHV_Smooth_Period, ::Oscillator_Indi_CHV_Period,
                                   ::Oscillator_Indi_CHV_Smooth_Method, ::Oscillator_Indi_CHV_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_CHV_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_CHV(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_DEMARKER:  // DeMarker
      {
        IndiDeMarkerParams _indi_params(::Oscillator_Indi_DeMarker_Period, ::Oscillator_Indi_DeMarker_Shift);
        _indi_params.SetDataSourceType(Oscillator_Indi_DeMarker_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_DeMarker(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_MFI:  // MFI
      {
        IndiMFIParams _indi_params(::Oscillator_Indi_MFI_MA_Period, ::Oscillator_Indi_MFI_Applied_Volume,
                                   ::Oscillator_Indi_MFI_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_MFI_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_MFI(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_MOM:  // MOM
      {
        IndiMomentumParams _indi_params(::Oscillator_Indi_Momentum_Period, ::Oscillator_Indi_Momentum_Applied_Price,
                                        ::Oscillator_Indi_Momentum_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_Momentum_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_Momentum(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_OBV:  // OBV
      {
        IndiOBVParams _indi_params(::Oscillator_Indi_OBV_Applied_Price, ::Oscillator_Indi_OBV_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_OBV_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_OBV(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_PVT:  // PVT
      {
        IndiPriceVolumeTrendParams _indi_params(::Oscillator_Indi_PVT_InpVolumeType, ::Oscillator_Indi_PVT_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_PVT_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_PriceVolumeTrend(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_ROC:  // ROC
      {
        IndiRateOfChangeParams _indi_params(::Oscillator_Indi_ROC_Period, ::Oscillator_Indi_ROC_Applied_Price,
                                            ::Oscillator_Indi_ROC_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_ROC_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_RateOfChange(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_RSI:  // RSI
      {
        IndiRSIParams _indi_params(::Oscillator_Indi_RSI_Period, ::Oscillator_Indi_RSI_Applied_Price,
                                   ::Oscillator_Indi_RSI_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_RSI_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_RSI(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_STDDEV:  // StdDev
      {
        IndiStdDevParams _indi_params(::Oscillator_Indi_StdDev_MA_Period, ::Oscillator_Indi_StdDev_MA_Shift,
                                      ::Oscillator_Indi_StdDev_MA_Method, ::Oscillator_Indi_StdDev_Applied_Price,
                                      ::Oscillator_Indi_StdDev_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_StdDev_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_StdDev(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_STOCH:  // Stochastic
      {
        IndiStochParams _indi_params(::Oscillator_Indi_Stochastic_KPeriod, ::Oscillator_Indi_Stochastic_DPeriod,
                                     ::Oscillator_Indi_Stochastic_Slowing, ::Oscillator_Indi_Stochastic_MA_Method,
                                     ::Oscillator_Indi_Stochastic_Price_Field, ::Oscillator_Indi_Stochastic_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_Stochastic_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_Stochastic(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_TRIX:  // TRIX
      {
        IndiTRIXParams _indi_params(::Oscillator_Indi_TRIX_InpPeriodEMA, ::Oscillator_Indi_TRIX_Applied_Price,
                                    ::Oscillator_Indi_TRIX_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_TRIX_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_TRIX(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_UO:  // UO
      {
        IndiUltimateOscillatorParams _indi_params(
            ::Oscillator_Indi_UO_InpFastPeriod, ::Oscillator_Indi_UO_InpMiddlePeriod,
            ::Oscillator_Indi_UO_InpSlowPeriod, ::Oscillator_Indi_UO_InpFastK, ::Oscillator_Indi_UO_InpMiddleK,
            ::Oscillator_Indi_UO_InpSlowK, ::Oscillator_Indi_UO_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_UO_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_UltimateOscillator(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_WAD:  // Williams' AD
      {
        IndiWilliamsADParams _indi_params(::Oscillator_Indi_WAD_Shift);
        _indi_params.SetDataSourceType(Oscillator_Indi_WAD_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_WilliamsAD(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_WPR:  // WPR
      {
        IndiWPRParams _indi_params(::Oscillator_Indi_WPR_Period, ::Oscillator_Indi_WPR_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_WPR_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_WPR(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_VOL:  // Volumes
      {
        IndiVolumesParams _indi_params(::Oscillator_Indi_VOL_InpVolumeType, ::Oscillator_Indi_VOL_Shift);
        _indi_params.SetDataSourceType(::Oscillator_Indi_VOL_SourceType);
        _indi_params.SetTf(Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF));
        SetIndicator(new Indi_Volumes(_indi_params), ::Oscillator_Type);
        break;
      }
      case STG_OSCILLATOR_TYPE_0_NONE:  // (None)
      default:
        break;
    }
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    IndicatorBase *_indi = GetIndicator(::Oscillator_Type);
    // uint _ishift = _indi.GetShift();
    bool _result = Oscillator_Type != STG_OSCILLATOR_TYPE_0_NONE && IsValidEntry(_indi, _shift);
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result &= _indi.IsIncreasing(1, 0, _shift);
        _result &= _indi.IsIncByPct(_level, 0, _shift, 2);
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi.IsDecreasing(1, 0, _shift + 1);
          if (METHOD(_method, 1)) _result &= _indi.IsIncreasing(4, 0, _shift + 3);
          if (METHOD(_method, 2))
            _result &= fmax4(_indi[_shift][0], _indi[_shift + 1][0], _indi[_shift + 2][0], _indi[_shift + 3][0]) ==
                       _indi[_shift][0];
        }
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result &= _indi.IsDecreasing(1, 0, _shift);
        _result &= _indi.IsDecByPct(_level, 0, _shift, 2);
        if (_result && _method != 0) {
          if (METHOD(_method, 0)) _result &= _indi.IsIncreasing(1, 0, _shift + 1);
          if (METHOD(_method, 1)) _result &= _indi.IsDecreasing(4, 0, _shift + 3);
          if (METHOD(_method, 2))
            _result &= fmin4(_indi[_shift][0], _indi[_shift + 1][0], _indi[_shift + 2][0], _indi[_shift + 3][0]) ==
                       _indi[_shift][0];
        }
        break;
    }
    return _result;
  }
};
