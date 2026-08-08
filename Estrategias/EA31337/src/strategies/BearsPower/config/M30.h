/**
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_BearsPower_Params_M30 : IndiBearsPowerParams {
  Indi_BearsPower_Params_M30() : IndiBearsPowerParams(indi_bears_defaults, PERIOD_M30) {
    applied_price = (ENUM_APPLIED_PRICE)1;
    period = 8;
    shift = 0;
  }
} indi_bears_m30;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_BearsPower_Params_M30 : StgParams {
  // Struct constructor.
  Stg_BearsPower_Params_M30() : StgParams(stg_bears_defaults) {
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
    tick_filter_method = 32;
    max_spread = 0;
  }
} stg_bears_m30;
