/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_Pivot_Params_H1 : PivotIndiParams {
  Indi_Pivot_Params_H1() : PivotIndiParams(indi_pivot_defaults, PERIOD_H1) { shift = 0; }
} indi_pivot_h1;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Pivot_Params_H1 : StgParams {
  // Struct constructor.
  Stg_Pivot_Params_H1() : StgParams(stg_pivot_defaults) {}
} stg_pivot_h1;
