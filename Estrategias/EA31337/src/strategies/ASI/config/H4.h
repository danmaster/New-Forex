/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_ASI_Params_H4 : ASIIndiParams {
  Indi_ASI_Params_H4() : ASIIndiParams(indi_asi_defaults, PERIOD_H4) { shift = 0; }
} indi_asi_h4;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_ASI_Params_H4 : StgParams {
  // Struct constructor.
  Stg_ASI_Params_H4() : StgParams(stg_asi_defaults) {}
} stg_asi_h4;
