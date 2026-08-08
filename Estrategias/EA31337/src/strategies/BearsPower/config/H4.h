/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_BearsPower_Params_H4 : IndiBearsPowerParams {
  Indi_BearsPower_Params_H4() : IndiBearsPowerParams(indi_bears_defaults, PERIOD_H4) {
    applied_price = (ENUM_APPLIED_PRICE)0;
    period = 14;
    shift = 0;
  }
} indi_bears_h4;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_bears_Params_H4 : StgParams {
  // Struct constructor.
  Stg_bears_Params_H4() : StgParams(stg_bears_defaults) {
    lot_size = 0;
    signal_open_method = 2;
    signal_open_level = (float)0;
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
} stg_bears_h4;
