/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct IndiACParams_H1 : IndiACParams {
  IndiACParams_H1() : IndiACParams(indi_ac_defaults, PERIOD_H1) { shift = 0; }
} indi_ac_h1;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_AC_Params_H1 : StgParams {
  // Struct constructor.
  Stg_AC_Params_H1() : StgParams(stg_ac_defaults) {
    lot_size = 0;
    signal_open_method = 2;
    signal_open_level = (float)0.0;
    signal_open_boost = 0;
    signal_close_method = 2;
    signal_close_level = (float)0.0;
    price_profit_method = 60;
    price_profit_level = (float)6;
    price_stop_method = 60;
    price_stop_level = (float)6;
    tick_filter_method = 32;
    max_spread = 0;
  }
} stg_ac_h1;
