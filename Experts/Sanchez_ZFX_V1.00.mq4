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
input double   StopLossPaddingPips     = 2.0;         // Pips de margen para el SL (encima/debajo mecha)

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

// Variables Globales
double prevDayHigh = 0.0, prevDayLow = 0.0;
double prevSessionHigh = 0.0, prevSessionLow = 0.0;
int lastDayProcessed = -1;
datetime lastBarM5 = 0;

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
   // Actualizar Alto y Bajo del dia anterior
   int currentDay = TimeDay(TimeCurrent());
   if(currentDay != lastDayProcessed)
   {
      prevDayHigh = iHigh(Symbol(), PERIOD_D1, 1);
      prevDayLow  = iLow(Symbol(), PERIOD_D1, 1);
      lastDayProcessed = currentDay;
   }
   
   // Determinar Sesiones (Simplificado)
   string currentTime = TimeToStr(TimeCurrent(), TIME_MINUTES);
   
   if(currentTime >= AsiaStart && currentTime < AsiaEnd) {
      // Asia session
   }
   else if(currentTime >= LondonStart && currentTime < LondonEnd) {
      // Londres. Prev session = Asia
      int startIdx = iBarShift(Symbol(), PERIOD_M5, StringToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + AsiaStart));
      int endIdx   = iBarShift(Symbol(), PERIOD_M5, StringToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + AsiaEnd));
      if(startIdx > endIdx && endIdx >= 0) {
         int highIdx = iHighest(Symbol(), PERIOD_M5, MODE_HIGH, startIdx - endIdx, endIdx);
         int lowIdx  = iLowest(Symbol(), PERIOD_M5, MODE_LOW, startIdx - endIdx, endIdx);
         if(highIdx >= 0) prevSessionHigh = High[highIdx];
         if(lowIdx >= 0)  prevSessionLow  = Low[lowIdx];
      }
   }
   else if(currentTime >= NYStart && currentTime < NYEnd) {
      // NY. Prev session = Londres
      int startIdx = iBarShift(Symbol(), PERIOD_M5, StringToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + LondonStart));
      int endIdx   = iBarShift(Symbol(), PERIOD_M5, StringToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + LondonEnd));
      if(startIdx > endIdx && endIdx >= 0) {
         int highIdx = iHighest(Symbol(), PERIOD_M5, MODE_HIGH, startIdx - endIdx, endIdx);
         int lowIdx  = iLowest(Symbol(), PERIOD_M5, MODE_LOW, startIdx - endIdx, endIdx);
         if(highIdx >= 0) prevSessionHigh = High[highIdx];
         if(lowIdx >= 0)  prevSessionLow  = Low[lowIdx];
      }
   }
}

//+------------------------------------------------------------------+
//| Comprobar Liquidity Sweep                                        |
//+------------------------------------------------------------------+
int CheckLiquiditySweep(double levelHigh, double levelLow)
{
   // Devuelve 1 para Sweep de Venta (saca High), -1 para Sweep de Compra (saca Low), 0 para nada
   
   // H4 y H1
   double h4High = iHigh(Symbol(), PERIOD_H4, 1);
   double h4Low  = iLow(Symbol(), PERIOD_H4, 1);
   double h4Close = iClose(Symbol(), PERIOD_H4, 1);
   
   double h1High = iHigh(Symbol(), PERIOD_H1, 1);
   double h1Low  = iLow(Symbol(), PERIOD_H1, 1);
   double h1Close = iClose(Symbol(), PERIOD_H1, 1);
   
   bool sweepH4Low = (h4Low < levelLow && h4Close > levelLow);
   bool sweepH1Low = (h1Low < levelLow && h1Close > levelLow);
   
   bool sweepH4High = (h4High > levelHigh && h4Close < levelHigh);
   bool sweepH1High = (h1High > levelHigh && h1Close < levelHigh);
   
   if(sweepH4Low && sweepH1Low) return -1;
   if(sweepH4High && sweepH1High) return 1;
   
   return 0;
}

//+------------------------------------------------------------------+
//| Comprobar Vela Envolvente (M5)                                   |
//+------------------------------------------------------------------+
int CheckEngulfing()
{
   // 1 = Alcista, -1 = Bajista
   double close1 = iClose(Symbol(), PERIOD_M5, 1);
   double open1  = iOpen(Symbol(), PERIOD_M5, 1);
   double close2 = iClose(Symbol(), PERIOD_M5, 2);
   double open2  = iOpen(Symbol(), PERIOD_M5, 2);
   
   // Alcista
   if(close2 < open2 && close1 > open1 && close1 >= open2 && open1 <= close2)
      return 1;
      
   // Bajista
   if(close2 > open2 && close1 < open1 && close1 <= open2 && open1 >= close2)
      return -1;
      
   return 0;
}

//+------------------------------------------------------------------+
//| Calcular Lotaje Segun Riesgo                                     |
//+------------------------------------------------------------------+
double CalculateLotSize(double slPrice)
{
   if(FixedLotSize > 0) return FixedLotSize;
   
   double riskMoney = AccountBalance() * (RiskPercent / 100.0);
   double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   
   double pipsToSl = MathAbs(slPrice - Ask) / Point;
   if(Digits == 3 || Digits == 5) pipsToSl /= 10.0;
   
   double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   double lot = riskMoney / (pipsToSl * 10 * tickValue);
   
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
   
   datetime currentBarM5 = iTime(Symbol(), PERIOD_M5, 0);
   if(currentBarM5 == lastBarM5) return;
   
   UpdateStructuralLevels();
   
   int sweepPD = (prevDayHigh > 0 && prevDayLow > 0) ? CheckLiquiditySweep(prevDayHigh, prevDayLow) : 0;
   int sweepPS = (prevSessionHigh > 0 && prevSessionLow > 0) ? CheckLiquiditySweep(prevSessionHigh, prevSessionLow) : 0;
   
   int activeSweep = 0;
   double targetSLPrice = 0.0;
   
   if(sweepPD != 0) {
      activeSweep = sweepPD;
      targetSLPrice = (sweepPD == 1) ? iHigh(Symbol(), PERIOD_H4, 1) : iLow(Symbol(), PERIOD_H4, 1);
   }
   else if(sweepPS != 0) {
      activeSweep = sweepPS;
      targetSLPrice = (sweepPS == 1) ? iHigh(Symbol(), PERIOD_H4, 1) : iLow(Symbol(), PERIOD_H4, 1);
   }
   
   if(activeSweep != 0)
   {
      int engulfing = CheckEngulfing();
      double pipsPad = StopLossPaddingPips * (Digits == 3 || Digits == 5 ? 10 : 1) * Point;
      
      if(activeSweep == -1 && engulfing == 1) // Comprar
      {
         double sl = targetSLPrice - pipsPad;
         double tp = Ask + (Ask - sl);
         double lot = CalculateLotSize(sl);
         
         int ticket = OrderSend(Symbol(), OP_BUY, lot, Ask, Slippage, sl, tp, TradeComment, MagicNumber, 0, Blue);
         if(ticket > 0) lastBarM5 = currentBarM5;
      }
      else if(activeSweep == 1 && engulfing == -1) // Vender
      {
         double sl = targetSLPrice + pipsPad;
         double tp = Bid - (sl - Bid);
         double lot = CalculateLotSize(sl);
         
         int ticket = OrderSend(Symbol(), OP_SELL, lot, Bid, Slippage, sl, tp, TradeComment, MagicNumber, 0, Red);
         if(ticket > 0) lastBarM5 = currentBarM5;
      }
   }
}
