/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_Pivot_Params_M30 : PivotIndiParams {
  Indi_Pivot_Params_M30() : PivotIndiParams(indi_pivot_defaults, PERIOD_M30) { shift = 0; }
} indi_pivot_m30;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Pivot_Params_M30 : StgParams {
  // Struct constructor.
  Stg_Pivot_Params_M30() : StgParams(stg_pivot_defaults) {}
} stg_pivot_m30;
