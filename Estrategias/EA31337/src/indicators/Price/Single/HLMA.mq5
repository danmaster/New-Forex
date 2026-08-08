//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                                 Copyright 2016-2024, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/*
 *  This file is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * @file
 * Implements High-Low MA.
 */

// Defines.
#define INDI_FULL_NAME "High-Low MA"
#define INDI_SHORT_NAME "HLMA"

// Indicator properties.
#ifdef __MQL__
  #property indicator_chart_window
  #property indicator_buffers 1
  #property indicator_plots 1
  #property indicator_type1 DRAW_LINE
  #property indicator_color1 Red
#endif

// Indicator buffers.
double HighProximityBuffer[];
double ExtHLMABuffer[];

#ifdef __MQL__
  #property copyright "2016-2024, EA31337 Ltd"
  #property link "https://ea31337.github.io"
  #property description INDI_FULL_NAME
#endif

// Includes.
#include <EA31337-classes/Indicator.define.h>

// Input parameters.
// input int HLMA_Period = 14;                               // MA period // @todo
input ENUM_TIMEFRAMES HLMA_Tf = PERIOD_D1;                  // Timeframe for High-Low calculation
input ENUM_APPLIED_PRICE HLMA_AppliedPrice = PRICE_MEDIAN;  // Applied Price
// input ENUM_APPLIED_PRICE HLMA_Shift = 0;  // Shift // @todo

/**
 * Initizalization.
 */
int OnInit() {
  // Initialize indicator buffers.
  SetIndexBuffer(0, ExtHLMABuffer);
  IndicatorSetString(INDICATOR_SHORTNAME, INDI_SHORT_NAME);

  PlotIndexSetString(0, PLOT_LABEL, INDI_SHORT_NAME);
  PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, DBL_MAX);

  // Sets first bar from what index will be drawn
  // PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, HLMA_Period - 1);
  // Sets indicator shift.
  // PlotIndexSetInteger(0, PLOT_SHIFT, HLMA_Shift);

  return (INIT_SUCCEEDED);
}

/**
 * Proximity calculation function.
 */
int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[],
                const double &high[], const double &low[], const double &close[], const long &tick_volume[],
                const long &volume[], const int &spread[]) {
  //--- calculate start position
  int start = prev_calculated > 0 ? prev_calculated - 1 : 0;

  //--- main loop
  for (int i = start; i < rates_total; i++) {
    // Find the corresponding bar in the external timeframe.
    int corresponding_bar = iBarShift(NULL, HLMA_Tf, time[i]);

    if (corresponding_bar == -1) {
      continue;  // If no corresponding bar, skip calculation.
    }

    // Get the high and low of the corresponding bar in the selected timeframe
    double highestHigh = iHigh(NULL, HLMA_Tf, corresponding_bar);
    double lowestLow = iLow(NULL, HLMA_Tf, corresponding_bar);

    // Calculate the price based on the selected HLMA_AppliedPrice
    ExtHLMABuffer[i] = iCustomPrice(NULL, HLMA_Tf, corresponding_bar, HLMA_AppliedPrice);
  }

  return (rates_total);
}

/**
 * Custom function to get the price based on ENUM_APPLIED_PRICE.
 */
double iCustomPrice(const string symbol, ENUM_TIMEFRAMES timeframe, int index, ENUM_APPLIED_PRICE _ap) {
  switch (_ap) {
    case PRICE_CLOSE:
      return iClose(symbol, timeframe, index);
    case PRICE_OPEN:
      return iOpen(symbol, timeframe, index);
    case PRICE_HIGH:
      return iHigh(symbol, timeframe, index);
    case PRICE_LOW:
      return iLow(symbol, timeframe, index);
    case PRICE_MEDIAN:
      return (iHigh(symbol, timeframe, index) + iLow(symbol, timeframe, index)) / 2.0;
    case PRICE_TYPICAL:
      return (iHigh(symbol, timeframe, index) + iLow(symbol, timeframe, index) + iClose(symbol, timeframe, index)) /
             3.0;
    case PRICE_WEIGHTED:
      return (iHigh(symbol, timeframe, index) + iLow(symbol, timeframe, index) + 2 * iClose(symbol, timeframe, index)) /
             4.0;
    default:
      return iClose(symbol, timeframe, index);  // Default to close price.
  }
}
