/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_Pivot_Params_M15 : PivotIndiParams {
  Indi_Pivot_Params_M15() : PivotIndiParams(indi_pivot_defaults, PERIOD_M15) { shift = 0; }
} indi_pivot_m15;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Pivot_Params_M15 : StgParams {
  // Struct constructor.
  Stg_Pivot_Params_M15() : StgParams(stg_pivot_defaults) {}
} stg_pivot_m15;
