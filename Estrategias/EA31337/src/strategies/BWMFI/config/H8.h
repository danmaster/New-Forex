/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_BWMFI_Params_H8 : IndiBWIndiMFIParams {
  Indi_BWMFI_Params_H8() : IndiBWIndiMFIParams(indi_bwmfi_defaults, PERIOD_H8) { shift = 0; }
} indi_bwmfi_h8;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_BWMFI_Params_H8 : StgParams {
  // Struct constructor.
  Stg_BWMFI_Params_H8() : StgParams(stg_bwmfi_defaults) {
    lot_size = 0;
    signal_open_method = 2;
    signal_open_level = (float)0;
    signal_open_boost = 0;
    signal_close_method = 2;
    signal_close_level = (float)0;
    price_profit_method = 60;
    price_profit_level = 6;
    price_stop_method = 60;
    price_stop_level = 6;
    tick_filter_method = 1;
    max_spread = 0;
  }
} stg_bwmfi_h8;
