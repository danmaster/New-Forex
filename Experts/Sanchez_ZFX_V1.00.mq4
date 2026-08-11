//+------------------------------------------------------------------+
//|                                              Sanchez_ZFX_V1.00.mq4|
//|                                  Copyright 2026, New-Forex       |
//+------------------------------------------------------------------+
#property copyright "New-Forex"
#property link      "https://github.com/danmaster/New-Forex"
#property version   "1.00"
#property strict

//--- Entradas
input string   TradeComment            = "Sanchez ZFX";
input int      MagicNumber             = 8888;
input double   RiskPercent             = 1.0;         // Riesgo por operacion (%)
input double   FixedLotSize            = 0.0;         // Lote fijo (si es > 0, ignora Riesgo %)
input int      Slippage                = 3;           // Slippage maximo
input double   StopLossPaddingPoints   = 20.0;        // Puntos/Ticks de margen para el SL (encima/debajo mecha)

input string   str_session             = "--- Horarios del Broker (Skilling) ---";
input string   AsiaStart               = "00:00";
input string   AsiaEnd                 = "08:00";
input string   LondonStart             = "09:00";
input string   LondonEnd               = "18:00";
input string   NYStart                 = "15:00";
input string   NYEnd                   = "22:00";

input string   str_trading             = "--- Horario de Trading Permitido ---";
input string   TradingStart1           = "09:00";     // Apertura de Londres (Skilling)
input string   TradingEnd1             = "12:00";
input string   TradingStart2           = "15:00";     // Apertura de NY (Skilling)
input string   TradingEnd2             = "18:00";

input string   str_trigger             = "--- Gatillo (Confirmacion 4) ---";
input ENUM_TIMEFRAMES TriggerTF        = PERIOD_M5;   // MT4 no tiene M3 -> usar M5 (en indices y forex)
input double   SweepProximityPoints    = 40.0;        // Distancia max en puntos de la envolvente al nivel barrido

// Variables Globales
double prevDayHigh = 0.0, prevDayLow = 0.0;
double prevSessionHigh = 0.0, prevSessionLow = 0.0;
int lastDayProcessed = -1;
datetime lastTriggerBar = 0;
double lastSweptLevelUsed = 0.0; // Evita re-entradas en el mismo nivel

//+------------------------------------------------------------------+
//| Inicializacion                                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Validar Horario Operativo                                        |
//+------------------------------------------------------------------+
bool IsTradingTime()
{
   string currentTime = TimeToStr(TimeCurrent(), TIME_MINUTES);
   
   bool inSession1 = (currentTime >= TradingStart1 && currentTime <= TradingEnd1);
   bool inSession2 = (currentTime >= TradingStart2 && currentTime <= TradingEnd2);
   
   return (inSession1 || inSession2);
}

//+------------------------------------------------------------------+
//| Actualizar Niveles Estructurales                                 |
//+------------------------------------------------------------------+
void UpdateStructuralLevels()
{
   // Alto y Bajo del dia anterior
   int currentDay = TimeDay(TimeCurrent());
   if(currentDay != lastDayProcessed)
   {
      prevDayHigh = iHigh(Symbol(), PERIOD_D1, 1);
      prevDayLow  = iLow(Symbol(), PERIOD_D1, 1);
      lastDayProcessed = currentDay;
   }
   
   // Determinar la sesion anterior a cada ventana de trading.
   // Congelamos el bloque horario exacto para evitar un nivel movil.
   string currentTime = TimeToStr(TimeCurrent(), TIME_MINUTES);
   int startIdx = -1;
   int endIdx = -1;

   if(currentTime >= LondonStart && currentTime < LondonEnd)
   {
      startIdx = iBarShift(Symbol(), PERIOD_M5, StringToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + AsiaStart), false);
      endIdx   = iBarShift(Symbol(), PERIOD_M5, StringToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + AsiaEnd), false);
   }
   else if(currentTime >= NYStart && currentTime < NYEnd)
   {
      startIdx = iBarShift(Symbol(), PERIOD_M5, StringToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + LondonStart), false);
      endIdx   = iBarShift(Symbol(), PERIOD_M5, StringToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + NYStart), false);
   }

   // Rango desde el inicio de la sesion hasta el fin de esa misma sesion
   if(startIdx >= 0 && endIdx >= 0 && startIdx >= endIdx)
   {
      int count = startIdx - endIdx + 1;
      int highIdx = iHighest(Symbol(), PERIOD_M5, MODE_HIGH, count, endIdx);
      int lowIdx  = iLowest(Symbol(), PERIOD_M5, MODE_LOW, count, endIdx);

      if(highIdx >= 0) prevSessionHigh = iHigh(Symbol(), PERIOD_M5, highIdx);
      if(lowIdx >= 0)  prevSessionLow  = iLow(Symbol(), PERIOD_M5, lowIdx);
   }
}

//+------------------------------------------------------------------+
//| Comprobar Liquidity Sweep (LS) en H4 y H1                        |
//+------------------------------------------------------------------+
//  Devuelve 1 para sweep de Venta (barre High), -1 para sweep de Compra
//  (barre Low), 0 si no hay patron. Requiere que TANTO H4 como H1 hayan
//  barrido el nivel con mecha y que el precio vuelva al otro lado
//  (rechazo), que es el Liquidity Sweep de la estrategia.
int CheckLiquiditySweep(double levelHigh, double levelLow)
{
   // H1 en formacion: barrido + precio actual al otro lado (rechazo en curso)
   double h1Low   = iLow(Symbol(), PERIOD_H1, 0);
   double h1High  = iHigh(Symbol(), PERIOD_H1, 0);
   double h1Open  = iOpen(Symbol(), PERIOD_H1, 0);

   // H4 en formacion: barrido + precio actual al otro lado (rechazo en curso)
   double h4Low   = iLow(Symbol(), PERIOD_H4, 0);
   double h4High  = iHigh(Symbol(), PERIOD_H4, 0);
   double h4Open  = iOpen(Symbol(), PERIOD_H4, 0);

   double bid = Bid;

   // Sweep de minimos -> Compra (-1)
   bool h1SweepLow = (h1Low < levelLow && bid > levelLow);
   bool h4SweepLow = (h4Low < levelLow && bid > levelLow);
   
   if(h4Low < levelLow && levelLow > 0)
   {
      if(bid > levelLow)
      {
         if(h1Low < levelLow) {
            if(h1Open > levelLow && h4Open > levelLow) {
               Print("DEBUG BUY: Sweep Confirmado (-1). Nivel=", levelLow, " Bid=", bid);
               return -1;
            } else Print("DEBUG BUY FALLO: H1 o H4 nacieron bajo el nivel (re-barrido).");
         } // Silenciado H1 no confirma
      } // Silenciado H4 no confirma rechazo
   }

   // Sweep de maximos -> Venta (1)
   bool h1SweepHigh = (h1High > levelHigh && bid < levelHigh);
   bool h4SweepHigh = (h4High > levelHigh && bid < levelHigh);
   
   if(h4High > levelHigh && levelHigh > 0)
   {
      if(bid < levelHigh)
      {
         if(h1High > levelHigh) {
            if(h1Open < levelHigh && h4Open < levelHigh) {
               Print("DEBUG SELL: Sweep Confirmado (1). Nivel=", levelHigh, " Bid=", bid);
               return 1;
            }
         }
      }
   }

   return 0;
}

//+------------------------------------------------------------------+
//| Comprobar Vela Envolvente (gatillo, Confirmacion 4)              |
//+------------------------------------------------------------------+
//  1 = Alcista, -1 = Bajista, 0 = nada.
//  Ademas exige que la envolvente se forme cerca del nivel barrido
//  (proximidad en puntos), porque el gatillo es justo en el LS.
int CheckEngulfing(double levelPrice, int sweepDir)
{
   double close1 = iClose(Symbol(), TriggerTF, 1);
   double open1  = iOpen(Symbol(), TriggerTF, 1);
   double high1  = iHigh(Symbol(), TriggerTF, 1);
   double low1   = iLow(Symbol(), TriggerTF, 1);
   double close2 = iClose(Symbol(), TriggerTF, 2);
   double open2  = iOpen(Symbol(), TriggerTF, 2);

   double proximity = SweepProximityPoints * Point;

   bool nearLevel = false;
   // Compra (-1): el minimo de la envolvente se forma en/por debajo del nivel barrido
   if(sweepDir == -1)
      nearLevel = (low1 <= levelPrice + proximity);
   // Venta (1): el maximo de la envolvente se forma en/por encima del nivel barrido
   if(sweepDir == 1)
      nearLevel = (high1 >= levelPrice - proximity);

   if(!nearLevel) return 0;

   // Alcista
   if(close2 < open2 && close1 > open1 && close1 >= open2 && open1 <= close2)
      return 1;

   // Bajista
   if(close2 > open2 && close1 < open1 && close1 <= open2 && open1 >= close2)
      return -1;

   return 0;
}

//+------------------------------------------------------------------+
//| Calcular Lotaje Segun Riesgo (Adaptado para Indices/Forex)       |
//+------------------------------------------------------------------+
//  dir: -1 compra (SL por debajo, parte del Ask), 1 venta (SL por
//  encima, parte del Bid).
double CalculateLotSize(double slPrice, int dir)
{
   if(FixedLotSize > 0) return FixedLotSize;
   
   double riskMoney = AccountBalance() * (RiskPercent / 100.0);
   double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   double tickSize  = MarketInfo(Symbol(), MODE_TICKSIZE);
   
   // Puntos de diferencia (Puntos crudos) desde el precio de entrada real
   double entry = (dir == -1) ? Ask : Bid;
   double pointsToSl = MathAbs(entry - slPrice) / tickSize;
   
   double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   double lot = 0;
   
   // Evitar division por 0
   if(pointsToSl > 0 && tickValue > 0) {
      lot = riskMoney / (pointsToSl * tickValue);
   }
   
   lot = MathFloor(lot / lotStep) * lotStep;
   
   double minLot = MarketInfo(Symbol(), MODE_MINLOT);
   double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   
   if(lot < minLot) lot = minLot;
   if(lot > maxLot) lot = maxLot;
   
   return lot;
}

//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!IsTradingTime()) return;
   if(OrdersTotal() > 0) return; // Solo una operacion a la vez

   datetime currentBarTrigger = iTime(Symbol(), TriggerTF, 0);
   if(currentBarTrigger == lastTriggerBar) return;

   UpdateStructuralLevels();

   // Buscar el Liquidity Sweep en los 4 niveles estructurales
   // Prioridad: dia anterior primero, luego sesion anterior.
   int sweepDir = 0;
   double sweptLevel = 0.0;

   if(prevDayHigh > 0 && prevDayLow > 0)
   {
      sweepDir = CheckLiquiditySweep(prevDayHigh, prevDayLow);
      if(sweepDir == -1) sweptLevel = prevDayLow;
      else if(sweepDir == 1) sweptLevel = prevDayHigh;
   }

   if(sweepDir == 0 && prevSessionHigh > 0 && prevSessionLow > 0)
   {
      sweepDir = CheckLiquiditySweep(prevSessionHigh, prevSessionLow);
      if(sweepDir == -1) sweptLevel = prevSessionLow;
      else if(sweepDir == 1) sweptLevel = prevSessionHigh;
   }

   if(sweepDir != 0 && sweptLevel != lastSweptLevelUsed)
   {
      int engulfing = CheckEngulfing(sweptLevel, sweepDir);
      
      if(engulfing != 0) Print("DEBUG: Envolvente detectada (", engulfing, ") en el nivel ", sweptLevel);
      double pointsPad = StopLossPaddingPoints * Point;

      // Compra: barrio minimo (-1) + envolvente alcista
      if(sweepDir == -1 && engulfing == 1)
      {
         double sl = sweptLevel - pointsPad;           // SL debajo de la toma de liquidez
         double tp = Ask + (Ask - sl);                 // TP 1:1
         double lot = CalculateLotSize(sl, -1);

         int ticket = OrderSend(Symbol(), OP_BUY, lot, Ask, Slippage, sl, tp, TradeComment, MagicNumber, 0, Blue);
         if(ticket > 0) {
            lastTriggerBar = currentBarTrigger;
            lastSweptLevelUsed = sweptLevel;
         }
      }
      // Venta: barrio maximo (1) + envolvente bajista
      else if(sweepDir == 1 && engulfing == -1)
      {
         double sl = sweptLevel + pointsPad;           // SL encima de la toma de liquidez
         double tp = Bid - (sl - Bid);                 // TP 1:1
         double lot = CalculateLotSize(sl, 1);

         int ticket = OrderSend(Symbol(), OP_SELL, lot, Bid, Slippage, sl, tp, TradeComment, MagicNumber, 0, Red);
         if(ticket > 0) {
            lastTriggerBar = currentBarTrigger;
            lastSweptLevelUsed = sweptLevel;
         }
      }
   }
}
