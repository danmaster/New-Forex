/**
 * @file
 * Implements Oscillator strategy.
 */

// Includes conditional compilation directives.
#include "config/define.h"

// Includes EA31337 framework.
#include <EA31337-classes/EA.mqh>
#include <EA31337-classes/Indicators/Indi_AC.mqh>
#include <EA31337-classes/Indicators/Indi_AD.mqh>
#include <EA31337-classes/Indicators/Indi_ADX.mqh>
#include <EA31337-classes/Indicators/Indi_AO.mqh>
#include <EA31337-classes/Indicators/Indi_ATR.mqh>
#include <EA31337-classes/Indicators/Indi_BWMFI.mqh>
#include <EA31337-classes/Indicators/Indi_BearsPower.mqh>
#include <EA31337-classes/Indicators/Indi_BullsPower.mqh>
#include <EA31337-classes/Indicators/Indi_CCI.mqh>
#include <EA31337-classes/Indicators/Indi_CHO.mqh>
#include <EA31337-classes/Indicators/Indi_CHV.mqh>
#include <EA31337-classes/Indicators/Indi_DeMarker.mqh>
#include <EA31337-classes/Indicators/Indi_MFI.mqh>
#include <EA31337-classes/Indicators/Indi_Momentum.mqh>
#include <EA31337-classes/Indicators/Indi_OBV.mqh>
#include <EA31337-classes/Indicators/Indi_PriceVolumeTrend.mqh>
#include <EA31337-classes/Indicators/Indi_RSI.mqh>
#include <EA31337-classes/Indicators/Indi_RateOfChange.mqh>
#include <EA31337-classes/Indicators/Indi_StdDev.mqh>
#include <EA31337-classes/Indicators/Indi_Stochastic.mqh>
#include <EA31337-classes/Indicators/Indi_TRIX.mqh>
#include <EA31337-classes/Indicators/Indi_UltimateOscillator.mqh>
#include <EA31337-classes/Indicators/Indi_Volumes.mqh>
#include <EA31337-classes/Indicators/Indi_WPR.mqh>
#include <EA31337-classes/Indicators/Indi_WilliamsAD.mqh>
// #include <EA31337-classes/Indicators/Oscillator/includes.h>
#include <EA31337-classes/Strategy.mqh>

// Inputs.
input int Active_Tfs = M15B + M30B + H1B + H2B + H3B + H4B + H6B +
                       H8B;               // Timeframes (M1=1,M2=2,M5=16,M15=256,M30=1024,H1=2048,H2=4096,H3,H4,H6,H8)
input ENUM_LOG_LEVEL Log_Level = V_INFO;  // Log level.
input bool Info_On_Chart = true;          // Display info on chart.

// Includes strategy.
#include "Stg_Oscillator.mqh"

// Defines.
#define ea_name "Strategy Oscillator"
#define ea_version "2.000"
#define ea_desc "Strategy based on selected oscillator-type multi-valued indicators."
#define ea_link "https://github.com/EA31337/Strategy-Oscillator"
#define ea_author "EA31337 Ltd"

// Properties.
#property version ea_version
#ifdef __MQL4__
#property description ea_name
#property description ea_desc
#endif
#property link ea_link
#property copyright "Copyright 2016-2023, EA31337 Ltd"

// Class variables.
EA *ea;

/* EA event handler functions */

/**
 * Implements "Init" event handler function.
 *
 * Invoked once on EA startup.
 */
int OnInit() {
  bool _result = true;
  EAParams ea_params(__FILE__, Log_Level);
  ea = new EA(ea_params);
  _result &= ea.StrategyAdd<Stg_Oscillator>(Active_Tfs);
  return (_result ? INIT_SUCCEEDED : INIT_FAILED);
}

/**
 * Implements "Tick" event handler function (EA only).
 *
 * Invoked when a new tick for a symbol is received, to the chart of which the Expert Advisor is attached.
 */
void OnTick() {
  ea.ProcessTick();
  if (!ea.GetTerminal().IsOptimization()) {
    ea.UpdateInfoOnChart();
  }
}

/**
 * Implements "Deinit" event handler function.
 *
 * Invoked once on EA exit.
 */
void OnDeinit(const int reason) { Object::Delete(ea); }
