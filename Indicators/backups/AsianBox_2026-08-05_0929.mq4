//+------------------------------------------------------------------+
//|                                                  SessionsBox.mq4 |
//|                                      Generado por Antigravity    |
//|                                   Revisado y corregido           |
//+------------------------------------------------------------------+
#property copyright "Antigravity AI"
#property link      ""
#property version   "1.20"
#property strict
#property indicator_chart_window

//--- Input parameters
input bool   EnableAsia      = true;         // Mostrar Sesion Asiatica
input int    AsiaStartHour   = 2;            // Inicio Asia (Hora Broker)
input int    AsiaEndHour     = 8;            // Fin Asia (Hora Broker)
input color  AsiaBoxColor    = clrAliceBlue; // Color Caja Asiatica

input bool   EnableLondon    = true;         // Mostrar Sesion Londres
input int    LondonStartHour = 9;            // Inicio Londres (Hora Broker)
input int    LondonEndHour   = 18;           // Fin Londres (Hora Broker)
input color  LondonBoxColor  = clrMistyRose; // Color Caja Londres

input bool   EnableNY        = true;         // Mostrar Sesion Nueva York
input int    NYStartHour     = 14;           // Inicio NY (Hora Broker)
input int    NYEndHour       = 23;           // Fin NY (Hora Broker)
input color  NYBoxColor      = clrHoneydew;  // Color Caja Nueva York

input int    DaysToDraw      = 30;           // Días hacia atrás para dibujar

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

   //--- Actualización ligera: solo la vela en formación, sin recorrer todo el rango
   if(!fullRecalc)
     {
      if(currentTime <= t2 && ObjectFind(0, objName) >= 0)
        {
         double curMax = ObjectGetDouble(0, objName, OBJPROP_PRICE1);
         double curMin = ObjectGetDouble(0, objName, OBJPROP_PRICE2);

         if(High[0] > curMax) ObjectSetDouble(0, objName, OBJPROP_PRICE1, High[0]);
         if(Low[0]  < curMin) ObjectSetDouble(0, objName, OBJPROP_PRICE2, Low[0]);
        }
      return;
     }

   //--- Recalculo completo (primer cálculo o vela nueva)
   int shift1 = iBarShift(Symbol(), Period(), t1);

   datetime evalEndTime = (currentTime < t2) ? currentTime : t2;
   // Restamos 1 segundo para que no incluya la vela que inicia exactamente en t2
   int shift2 = iBarShift(Symbol(), Period(), evalEndTime - 1);

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
      if(ObjectFind(0, objName) < 0)
        {
         ObjectCreate(0, objName, OBJ_RECTANGLE, 0, t1, maxPrice, t2, minPrice);
         ObjectSetInteger(0, objName, OBJPROP_COLOR, boxColor);
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
        }
     }
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

   for(int i = 0; i < daysLimit; i++)
     {
      datetime dayStart = iTime(Symbol(), PERIOD_D1, i);
      if(dayStart == 0) continue;

      if(EnableAsia)   DrawSessionBox("Asia",   dayStart, AsiaStartHour,   AsiaEndHour,   AsiaBoxColor,   currentTime, fullRecalc);
      if(EnableLondon) DrawSessionBox("London", dayStart, LondonStartHour, LondonEndHour, LondonBoxColor, currentTime, fullRecalc);
      if(EnableNY)     DrawSessionBox("NY",     dayStart, NYStartHour,     NYEndHour,     NYBoxColor,     currentTime, fullRecalc);
     }

   ChartRedraw(0);

   return(rates_total);
  }
//+------------------------------------------------------------------+