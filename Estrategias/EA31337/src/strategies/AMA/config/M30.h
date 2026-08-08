/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_AMA_Params_M30 : IndiAIndiMAParams {
  Indi_AMA_Params_M30() : IndiAIndiMAParams(indi_ama_defaults, PERIOD_M30) { shift = 0; }
} indi_ama_m30;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_AMA_Params_M30 : StgParams {
  // Struct constructor.
  Stg_AMA_Params_M30() : StgParams(stg_ama_defaults) {}
} stg_ama_m30;
