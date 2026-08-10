//+------------------------------------------------------------------+
//|                                                   AsianBox.mq4   |
//|                                      Generado por Antigravity    |
//|                                   Revisado y corregido           |
//| V1.25: Londres/NY con SESIONES REALES (no kill zones). Londres     |
//| 08:00-17:00 local = 10:00-19:00 broker. NY 08:00-17:00 local =     |
//| 15:00-00:00 broker (cruza medianoche). Solape Londres/NY 15-19.    |
//| V1.24: gestion de DST idem EA Asian V2.80. ASIA se compensa por    |
//| DST (Tokio no cambia el reloj) -> franja real constante 00:00-06:00 |
//| GMT. LONDRES y NY FIJAS en hora del broker (siguen el mismo DST     |
//| europeo que el servidor): Londres 08:00-12:00 local y NY 08:00-12:00|
//| local en ambas estaciones. En broker GMT+3 verano/GMT+2 invierno:   |
//| Asia 3-9 verano / 2-8 invierno, Londres 10-14 FIJA, NY 15-19 FIJA.  |
//| Valido para Skilling (GMT+3) y RoboForex (GMT+2/+3), ambos con el   |
//| mismo calendario DST europeo (RefGMTOffset=3).                      |
//| V1.23: horas alineadas al indicador FXN (Alex Ruiz): Asia 20:00- |
//| 02:00 EST / Londres 03:00-07:00 EST / NY 08:00-12:00 EST, con    |
//| huecos de 1h entre sesiones. En GMT real: Asia 00-06, Londres    |
//| 07-11, NY 12-16. En broker GMT+3 verano: Asia 3-9, Londres 10-14,|
//| NY 15-19.                                                         |
//| V1.22: contorno con 4 lineas + relleno sutil mezclado con fondo  |
//| V1.21: caja asiatica alineada al box del video de Alex Ruiz      |
//| (indicador FXN): 01:00-07:00 en grafico UTC+1 = 00:00-06:00 GMT  |
//| real. DST automatico por calendario europeo (idem EAs): Asia     |
//| 03:00-09:00 verano / 02:00-08:00 invierno en hora del broker.    |
//+------------------------------------------------------------------+
#property copyright "Antigravity AI"
#property link      ""
#property version   "1.25"
#property strict
#property indicator_chart_window

//--- Input parameters
input bool   EnableAsia      = true;         // Mostrar Sesion Asiatica
input int    AsiaStartHour   = 3;            // Inicio Asia (Hora Broker verano, auto-DST)
input int    AsiaEndHour     = 9;            // Fin Asia (Hora Broker verano, auto-DST)
input color  AsiaBoxColor    = clrAliceBlue; // Color Caja Asiatica

input bool   EnableLondon    = true;         // Mostrar Sesion Londres
input int    LondonStartHour = 10;           // Inicio Londres (08:00 local, FIJO en hora broker)
input int    LondonEndHour   = 19;           // Fin Londres (17:00 local, FIJO en hora broker)
input color  LondonBoxColor  = clrMistyRose; // Color Caja Londres

input bool   EnableNY        = true;         // Mostrar Sesion Nueva York
input int    NYStartHour     = 15;           // Inicio NY (08:00 local, FIJO en hora broker)
input int    NYEndHour       = 0;            // Fin NY (17:00 local = 00:00 broker, cruza medianoche)
input color  NYBoxColor      = clrHoneydew;  // Color Caja Nueva York

input int    RefGMTOffset    = 3;            // Offset GMT verano del broker (3 = Skilling GMT+3)

input int    DaysToDraw      = 30;           // Días hacia atrás para dibujar

input double BackgroundOpacity = 0.35;         // Opacidad del fondo (0.02-1.0)
input int    BorderWidth     = 1;            // Grosor del contorno

//--- Estado interno
datetime g_lastBarTime = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorShortName("Market Sessions Box");

   ValidateHours("Asia", AsiaStartHour, AsiaEndHour);
   ValidateHours("Londres", LondonStartHour, LondonEndHour);
   ValidateHours("Nueva York", NYStartHour, NYEndHour);

   g_lastBarTime = 0;
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Valida que las horas de sesión estén en rango 0-23 y no sean 0   |
//+------------------------------------------------------------------+
void ValidateHours(string name, int startH, int endH)
  {
   if(startH < 0 || startH > 23 || endH < 0 || endH > 23)
      Print("SessionsBox: advertencia - horas de sesión '", name, "' fuera de rango 0-23.");
   if(startH == endH)
      Print("SessionsBox: advertencia - sesión '", name, "' tiene duración cero (Start == End).");
   }

//+------------------------------------------------------------------+
//| AJUSTE AUTOMATICO DE DST (Horario Verano/Invierno)               |
//| Idem EAs Asian/Anti-Asian: calendario europeo DETERMINISTICO     |
//| (ultimo domingo de marzo -> ultimo domingo de octubre). El broker|
//| europeo (Skilling) pasa de GMT+3 (verano) a GMT+2 (invierno).    |
//| Los inputs de sesion estan calibrados a RefGMTOffset (verano);   |
//| en invierno se desplazan 1h antes para cubrir la misma franja    |
//| real todo el ano (caja asiatica real: 00:00-06:00 GMT).          |
//+------------------------------------------------------------------+
int GetLastSundayDay(int year, int month)
  {
   int lastDay = 31;
   if(month == 4 || month == 6 || month == 9 || month == 11) lastDay = 30;
   if(month == 2) lastDay = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28;
   string dateStr = StringFormat("%04d.%02d.%02d 00:00:00", year, month, lastDay);
   datetime dt = StrToTime(dateStr);
   int dow = TimeDayOfWeek(dt);
   return lastDay - dow;
  }

bool IsBrokerSummerTime(datetime t)
  {
   int year  = TimeYear(t);
   int month = TimeMonth(t);
   int day   = TimeDay(t);
   if(month < 3 || month > 10) return false;
   if(month > 3 && month < 10) return true;
   int lastSunday = GetLastSundayDay(year, month);
   if(month == 3)  return (day >= lastSunday);
   if(month == 10) return (day < lastSunday);
   return false;
  }

int GetBrokerGMTOffset()
  {
   int refOffset = (RefGMTOffset >= 2 && RefGMTOffset <= 14) ? RefGMTOffset : 3;
   return IsBrokerSummerTime(TimeCurrent()) ? refOffset : (refOffset - 1);
  }

// Ajusta una hora de sesion (calibrada a RefGMTOffset) a la hora del broker actual
int AdjustBoxHour(int hour)
  {
   int h = hour + GetBrokerGMTOffset() - RefGMTOffset;
   h = h % 24;
   if(h < 0) h += 24;
   return h;
  }

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0, "SessionBox_");
  }

//+------------------------------------------------------------------+
//| Calcula el fin de sesión soportando cruce de medianoche          |
//+------------------------------------------------------------------+
datetime GetSessionEnd(datetime dayStart, int startH, int endH)
  {
   if(endH <= startH)
      return dayStart + (endH + 24) * 3600; // la sesión termina al día siguiente
   return dayStart + endH * 3600;
  }

//+------------------------------------------------------------------+
//| Helper function to draw / update a session box                  |
//| fullRecalc = true  -> recorre todas las velas de la sesión       |
//| fullRecalc = false -> solo compara la vela en formación (rápido) |
//+------------------------------------------------------------------+
void DrawSessionBox(string prefix, datetime dayStart, int startH, int endH, color boxColor,
                     datetime currentTime, bool fullRecalc)
  {
   if(startH == endH) return; // sesión de duración cero, se ignora

   datetime t1 = dayStart + startH * 3600;
   datetime t2 = GetSessionEnd(dayStart, startH, endH);

   if(currentTime < t1) return; // Aún no empieza la sesión

   string objName = "SessionBox_" + prefix + "_" + TimeToString(dayStart, TIME_DATE);

   color fillColor = GetSubtleFill(boxColor);

   //--- Actualización ligera: solo la vela en formación, sin recorrer todo el rango
   if(!fullRecalc)
     {
      if(currentTime <= t2 && ObjectFind(0, objName) >= 0)
        {
         double curMax = ObjectGetDouble(0, objName, OBJPROP_PRICE1);
         double curMin = ObjectGetDouble(0, objName, OBJPROP_PRICE2);

         if(High[0] > curMax) curMax = High[0];
         if(Low[0]  < curMin) curMin = Low[0];

         ObjectSetDouble(0, objName, OBJPROP_PRICE1, curMax);
         ObjectSetDouble(0, objName, OBJPROP_PRICE2, curMin);
         UpdateBoxBorder(objName, t1, t2, curMax, curMin, boxColor);
        }
      return;
     }

   //--- Recalculo completo (primer cálculo o vela nueva)
   int shift1 = iBarShift(Symbol(), Period(), t1);
   
   // Ajustar shift1 para que apunte al primer bar que esté dentro o después de t1
   while(shift1 >= 0 && iTime(Symbol(), Period(), shift1) < t1)
     {
      shift1--;
     }

   datetime evalEndTime = (currentTime < t2) ? currentTime : t2;
   // Restamos 1 segundo para que no incluya la vela que inicia exactamente en t2
   int shift2 = iBarShift(Symbol(), Period(), evalEndTime - 1);
   
   // Asegurarse de que shift2 no sea posterior al fin de la sesión
   while(shift2 >= 0 && iTime(Symbol(), Period(), shift2) >= evalEndTime)
     {
      shift2++;
     }

   if(shift1 < 0 || shift2 < 0 || shift1 < shift2) return;

   double maxPrice = -1.0;
   double minPrice = 99999.0;
   bool valid = false;

   for(int j = shift2; j <= shift1; j++)
     {
      if(j < 0 || j >= Bars) continue;
      if(High[j] > maxPrice) maxPrice = High[j];
      if(Low[j]  < minPrice) minPrice = Low[j];
      valid = true;
     }

   if(valid)
     {
      //--- Relleno sutil (detrás de las velas)
      if(ObjectFind(0, objName) < 0)
        {
         ObjectCreate(0, objName, OBJ_RECTANGLE, 0, t1, maxPrice, t2, minPrice);
         ObjectSetInteger(0, objName, OBJPROP_COLOR, fillColor);
         ObjectSetInteger(0, objName, OBJPROP_BACK, true);
         ObjectSetInteger(0, objName, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, objName, OBJPROP_HIDDEN, true);
        }
      else
        {
         ObjectSetDouble(0, objName, OBJPROP_PRICE1, maxPrice);
         ObjectSetDouble(0, objName, OBJPROP_PRICE2, minPrice);
         ObjectSetInteger(0, objName, OBJPROP_TIME1, t1);
         ObjectSetInteger(0, objName, OBJPROP_TIME2, t2);
         ObjectSetInteger(0, objName, OBJPROP_COLOR, fillColor);
        }

      //--- Contorno: 4 líneas (superior, inferior, izquierda, derecha)
      UpdateBoxBorder(objName, t1, t2, maxPrice, minPrice, boxColor);
     }
  }

//+------------------------------------------------------------------+
//| Dibuja/actualiza el contorno de la caja con 4 líneas OBJ_TREND   |
//+------------------------------------------------------------------+
void UpdateBoxBorder(string baseName, datetime t1, datetime t2, double maxPrice, double minPrice, color clr)
  {
   DrawBorderLine(baseName + "_Top",    t1, maxPrice, t2, maxPrice, clr);
   DrawBorderLine(baseName + "_Bottom", t1, minPrice, t2, minPrice, clr);
   DrawBorderLine(baseName + "_Left",   t1, minPrice, t1, maxPrice, clr);
   DrawBorderLine(baseName + "_Right",  t2, minPrice, t2, maxPrice, clr);
  }

//+------------------------------------------------------------------+
//| Crea o mueve una línea del contorno                               |
//+------------------------------------------------------------------+
void DrawBorderLine(string name, datetime p1t, double p1, datetime p2t, double p2, color clr)
  {
   if(ObjectFind(0, name) < 0)
     {
      ObjectCreate(0, name, OBJ_TREND, 0, p1t, p1, p2t, p2);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, name, OBJPROP_WIDTH, BorderWidth);
      ObjectSetInteger(0, name, OBJPROP_RAY, false);
      ObjectSetInteger(0, name, OBJPROP_BACK, false); // <--- False para que se dibujen por encima de los fondos
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
     }
   else
     {
      ObjectMove(0, name, 0, p1t, p1);
      ObjectMove(0, name, 1, p2t, p2);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
     }
  }

//+------------------------------------------------------------------+
//| Mezcla el color de la sesión con el fondo para un relleno sutil   |
//+------------------------------------------------------------------+
color GetSubtleFill(color clr)
  {
   double a = BackgroundOpacity;
   if(a < 0.02) a = 0.02;
   if(a > 1.0) a = 1.0;

   color bg = (color)ChartGetInteger(0, CHART_COLOR_BACKGROUND, 0);

   int br = bg & 0xFF,        bg2 = (bg >> 8) & 0xFF,   bb = (bg >> 16) & 0xFF;
   int cr = clr & 0xFF,       cg = (clr >> 8) & 0xFF,   cb = (clr >> 16) & 0xFF;

   int nr = (int)(cr * a + br * (1.0 - a));
   int ng = (int)(cg * a + bg2 * (1.0 - a));
   int nb = (int)(cb * a + bb * (1.0 - a));

   return (color)((nb << 16) | (ng << 8) | nr);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   if(prev_calculated == 0)
     {
      ObjectsDeleteAll(0, "SessionBox_");
      g_lastBarTime = 0;
     }

   datetime currentTime = TimeCurrent();

   bool isNewBar = (time[0] != g_lastBarTime);
   if(isNewBar) g_lastBarTime = time[0];

   // fullRecalc: primer cálculo o cada vez que se forma una vela nueva
   bool fullRecalc = (prev_calculated == 0) || isNewBar;

   // Si es la primera vez, dibuja todos los días. Si no, actualiza solo hoy y ayer.
   int daysLimit = (prev_calculated == 0) ? DaysToDraw : 2;

   //--- Horas de sesion.
   //--- ASIA se compensa por DST (Tokio no cambia el reloj): franja real
   //--- constante 00:00-06:00 GMT todo el ano (idem EA Asian V2.80).
   //--- LONDRES y NY son FIJAS en hora del broker (siguen el mismo DST
   //--- europeo que el servidor): su franja real ya es constante en hora
   //--- local (Londres 08:00-12:00, NY 08:00-12:00) en ambas estaciones.
   int adjAsiaStart = AdjustBoxHour(AsiaStartHour);
   int adjAsiaEnd   = AdjustBoxHour(AsiaEndHour);
   int adjLonStart  = LondonStartHour;
   int adjLonEnd    = LondonEndHour;
   int adjNYStart   = NYStartHour;
   int adjNYEnd     = NYEndHour;

   for(int i = 0; i < daysLimit; i++)
     {
      datetime dayStart = iTime(Symbol(), PERIOD_D1, i);
      if(dayStart == 0) continue;

      if(EnableAsia)   DrawSessionBox("Asia",   dayStart, adjAsiaStart, adjAsiaEnd, AsiaBoxColor,   currentTime, fullRecalc);
      if(EnableLondon) DrawSessionBox("London", dayStart, adjLonStart,  adjLonEnd,  LondonBoxColor, currentTime, fullRecalc);
      if(EnableNY)     DrawSessionBox("NY",     dayStart, adjNYStart,   adjNYEnd,   NYBoxColor,     currentTime, fullRecalc);
     }

   ChartRedraw(0);

   return(rates_total);
  }
//+------------------------------------------------------------------+