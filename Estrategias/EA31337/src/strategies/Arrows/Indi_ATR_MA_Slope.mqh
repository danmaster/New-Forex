//+------------------------------------------------------------------+
//|                                 Copyright 2016-2023, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/*
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

// Prevents processing the same indicator file twice.
#ifndef INDI_ATR_MA_SLOPE_MQH
#define INDI_ATR_MA_SLOPE_MQH

// Defines
#define INDI_ATR_MA_SLOPE_PATH "indicators-other\\Oscillators\\Arrows"

// Indicator line identifiers used in the indicator.
enum ENUM_ATR_MA_SLOPE_MODE {
  ATR_MA_SLOPE_SLOPE = 0,         // Slope
  ATR_MA_SLOPE_LONG = 1,          // Long signal
  ATR_MA_SLOPE_SHORT = 2,         // Short signal
  ATR_MA_SLOPE_FLAT = 3,          // Neutral plot
  FINAL_ATR_MA_SLOPE_MODE_ENTRY,  // n/a
};

// Structs.

// Defines struct to store indicator parameter values.
struct IndiAtrMaSlopeParams : public IndicatorParams {
  // Indicator params.
  int number_of_bars;
  double slope_threshold;
  int slope_ma_period;
  int slope_atr_period;

  // Struct constructors.
  IndiAtrMaSlopeParams(int _number_of_bars = 100, double _slope_threshold = 2.0, int _slope_ma_period = 7,
                       int _slope_atr_period = 50, int _shift = 0)
      : number_of_bars(_number_of_bars),
        slope_threshold(_slope_threshold),
        slope_ma_period(_slope_ma_period),
        slope_atr_period(_slope_atr_period),
        IndicatorParams(INDI_CUSTOM, FINAL_ATR_MA_SLOPE_MODE_ENTRY, TYPE_DOUBLE) {
#ifdef __resource__
    custom_indi_name = "::" + INDI_ATR_MA_SLOPE_PATH + "\\ATR_MA_Slope";
#else
    custom_indi_name = "ATR_MA_Slope";
#endif
    SetDataSourceType(IDATA_ICUSTOM);
  };

  IndiAtrMaSlopeParams(IndiAtrMaSlopeParams &_params, ENUM_TIMEFRAMES _tf) {
    THIS_REF = _params;
    tf = _tf;
  }

  // Getters.
  int GetNumberOfBars() { return number_of_bars; }
  double GetThreshold() { return slope_threshold; }
  int GetMaPeriod() { return slope_ma_period; }
  int GetAtrPeriod() { return slope_atr_period; }
  // Setters.
  void SetNumberOfBars(int _value) { number_of_bars = _value; }
  void SetThreshold(double _value) { slope_threshold = _value; }
  void SetMaPeriod(int _value) { slope_ma_period = _value; }
  void SetAtrPeriod(int _value) { slope_atr_period = _value; }
};

/**
 * Implements indicator class.
 */
class Indi_ATR_MA_Slope : public Indicator<IndiAtrMaSlopeParams> {
 public:
  /**
   * Class constructor.
   */
  Indi_ATR_MA_Slope(IndiAtrMaSlopeParams &_p, IndicatorBase *_indi_src = NULL)
      : Indicator<IndiAtrMaSlopeParams>(_p, _indi_src) {}
  Indi_ATR_MA_Slope(ENUM_TIMEFRAMES _tf = PERIOD_CURRENT) : Indicator(INDI_CUSTOM, _tf){};

  /**
   * Returns the indicator's value.
   *
   */
  IndicatorDataEntryValue GetEntryValue(int _mode = 0, int _shift = -1) {
    double _value = EMPTY_VALUE;
    int _ishift = _shift >= 0 ? _shift : iparams.GetShift();
    switch (iparams.idstype) {
      case IDATA_ICUSTOM:
        _value = iCustom(istate.handle, Get<string>(CHART_PARAM_SYMBOL), Get<ENUM_TIMEFRAMES>(CHART_PARAM_TF),
                         iparams.custom_indi_name, Get<ENUM_TIMEFRAMES>(CHART_PARAM_TF), iparams.GetNumberOfBars(),
                         iparams.GetThreshold(), iparams.GetMaPeriod(), iparams.GetAtrPeriod(), _mode, _ishift);
        break;
      default:
        SetUserError(ERR_INVALID_PARAMETER);
        _value = EMPTY_VALUE;
        break;
    }
    return _value;
  }

  /**
   * Checks if indicator entry values are valid.
   */
  virtual bool IsValidEntry(IndicatorDataEntry &_entry) {
    // Slope  value needs to be positive exempt DBL_MAX.
    return _entry.values[(int)ATR_MA_SLOPE_SLOPE].IsGt(0) && _entry.values[(int)ATR_MA_SLOPE_SLOPE] != DBL_MAX;
  }
};

#endif  // INDI_ATR_MA_SLOPE_MQH
