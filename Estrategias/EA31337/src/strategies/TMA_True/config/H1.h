/*
 * @file
 * Defines strategy's and indicator's default parameter values
 * for the given pair symbol and timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct IndiTMATrueParams_H1 : IndiTMATrueParams {
  IndiTMATrueParams_H1() : IndiTMATrueParams(stg_tmat_indi_tmat_defaults, PERIOD_H1) { shift = 0; }
} indi_tmat_h1;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_TMA_True_Params_H1 : StgParams {
  // Struct constructor.
  Stg_TMA_True_Params_H1() : StgParams(stg_tmat_defaults) {
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
    tick_filter_method = 1;
    max_spread = 0;
  }
} stg_tmat_h1;
