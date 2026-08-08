/**
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_WPR_Params_M15 : IndiWPRParams {
  Indi_WPR_Params_M15() : IndiWPRParams(indi_wpr_defaults, PERIOD_M15) {
    period = 8;
    shift = 0;
  }
} indi_wpr_m15;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_WPR_Params_M15 : StgParams {
  // Struct constructor.
  Stg_WPR_Params_M15() : StgParams(stg_wpr_defaults) {
    lot_size = 0;
    signal_open_method = 2;
    signal_open_level = (float)30.0;
    signal_open_boost = 0;
    signal_close_method = 2;
    signal_close_level = (float)30.0;
    price_profit_method = 60;
    price_profit_level = (float)6;
    price_stop_method = 60;
    price_stop_level = (float)6;
    tick_filter_method = 1;
    max_spread = 0;
  }
} stg_wpr_m15;
