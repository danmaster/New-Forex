/**
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_Force_Params_M30 : IndiForceParams {
  Indi_Force_Params_M30() : IndiForceParams(indi_force_defaults, PERIOD_M30) {
    applied_price = (ENUM_APPLIED_PRICE)1;
    ma_method = (ENUM_MA_METHOD)3;
    period = 8;
    shift = 0;
  }
} indi_force_m30;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Force_Params_M30 : StgParams {
  // Struct constructor.
  Stg_Force_Params_M30() : StgParams(stg_force_defaults) {
    lot_size = 0;
    signal_open_method = 2;
    signal_open_level = (float)1;
    signal_open_boost = 1;
    signal_close_method = 2;
    signal_close_level = (float)1;
    price_profit_method = 60;
    price_profit_level = (float)1;
    price_stop_method = 60;
    price_stop_level = (float)1;
    tick_filter_method = 1;
    max_spread = 0;
  }
} stg_force_m30;
