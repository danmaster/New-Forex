/**
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_Bands_Params_M5 : IndiBandsParams {
  Indi_Bands_Params_M5() : IndiBandsParams(indi_bands_defaults, PERIOD_M5) {
    applied_price = (ENUM_APPLIED_PRICE)2;
    bshift = 4;
    deviation = 0.6;
    period = 7;
    shift = 0;
  }
} indi_bands_m5;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Bands_Params_M5 : StgParams {
  // Struct constructor.
  Stg_Bands_Params_M5() : StgParams(stg_bands_defaults) {
    lot_size = 0;
    signal_open_method = 2;
    signal_open_level = (float)0.0;
    signal_open_boost = 0;
    signal_close_method = 2;
    signal_close_level = (float)0;
    price_profit_method = 60;
    price_profit_level = (float)6;
    price_stop_method = 60;
    price_stop_level = (float)6;
    tick_filter_method = 1;
    max_spread = 0;
  }
} stg_bands_m5;
