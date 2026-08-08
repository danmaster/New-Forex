/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_AMA_Params_H8 : IndiAIndiMAParams {
  Indi_AMA_Params_H8() : IndiAIndiMAParams(indi_ama_defaults, PERIOD_H8) { shift = 0; }
} indi_ama_h8;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_AMA_Params_H8 : StgParams {
  // Struct constructor.
  Stg_AMA_Params_H8() : StgParams(stg_ama_defaults) {}
} stg_ama_h8;
