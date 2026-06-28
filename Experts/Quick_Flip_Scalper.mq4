//+------------------------------------------------------------------+
//|                                           Quick_Flip_Scalper.mq4 |
//|                                  Copyright 2026, Antigravity AI  |
//+------------------------------------------------------------------+
#property copyright "Antigravity AI"
#property link      ""
#property version   "1.00"
#property strict

//--- Inputs
input string   SesionSettings = "--- Configuración de Horario ---";
input int      InpOpenHour = 16;         // Hora de Apertura (Server Time)
input int      InpOpenMinute = 30;       // Minuto de Apertura
input int      InpDurationMinutes = 90;  // Duración de la sesión (minutos)

input string   RiskSettings = "--- Gestión de Riesgo ---";
input double   InpRiskPercent = 1.0;     // Riesgo % por operación
input double   InpMaxLotSize = 50.0;     // Lote Máximo
input int      InpMagicNumber = 888123;  // Magic Number

input string   IndiSettings = "--- Indicadores ---";
input int      InpATRPeriod = 14;        // Período ATR Diario
input double   InpATRMultiplier = 0.25;  // Multiplicador ATR (25%)
input int      InpSLPadding = 0;         // Holgura Stop Loss (Puntos)
input bool     InpStrictPatterns = true; // Exigir patrones estrictos

input string   TradeMgmtSettings = "--- Gestión de Operación ---";
input double   InpPartialCloseRatio = 1.0;  // Ratio R:R para cierre parcial (1.0 = 1:1)
input double   InpPartialClosePct = 50.0;   // % de lotes a cerrar
input bool     InpMoveToBE = true;          // Mover SL a Breakeven tras cierre parcial
input bool     InpSendPush = true;          // Enviar Notificación al Móvil

input string   VisualSettings = "--- Visual ---";
input bool     InpDrawBox = true;        // Dibujar caja de 15m
input color    InpBoxColor = clrDodgerBlue; // Color de la caja

//--- Global Variables
datetime todayTradeDay = 0;
bool     isActiveToday = false;
bool     isBoxDrawn = false;
double   boxHigh = 0.0;
double   boxLow = 0.0;
datetime boxStartTime = 0;
datetime boxEndTime = 0;
bool     tradeTakenToday = false;
bool     partialClosedToday = false;
bool     is15mCandleBullish = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   if(Period() != PERIOD_M5) {
      Print("Advertencia: Se recomienda usar el EA en gráfico M5.");
   }
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectDelete(0, "QuickFlipBox");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   ManageOpenTrades();
   
   if(IsNewCandle())
   {
      datetime currentTime = Time[0]; // Usar la hora de apertura de la vela, no el último tick
      MqlDateTime dt;
      TimeToStruct(currentTime, dt);
      
      // Reset diario
      if(dt.day_of_year != todayTradeDay)
      {
         todayTradeDay = dt.day_of_year;
         isActiveToday = false;
         isBoxDrawn = false;
         tradeTakenToday = false;
         partialClosedToday = false;
         boxHigh = 0;
         boxLow = 0;
         ObjectDelete(0, "QuickFlipBox");
      }
      
      // Calcular minutos desde inicio del día
      int currentTotalMinutes = dt.hour * 60 + dt.min;
      int openTotalMinutes = InpOpenHour * 60 + InpOpenMinute;
      int endTotalMinutes = openTotalMinutes + InpDurationMinutes;
      
      // Fase 1: Fin de la vela de 15 minutos
      if(currentTotalMinutes == openTotalMinutes + 15 && !isActiveToday && !tradeTakenToday)
      {
         Check15mBox(currentTime, openTotalMinutes);
      }
      
      // Fase 2: Buscar setups en los primeros 90 minutos
      if(isActiveToday && !tradeTakenToday && currentTotalMinutes > openTotalMinutes + 15 && currentTotalMinutes <= endTotalMinutes)
      {
         CheckEntrySetup();
      }
   }
}

//+------------------------------------------------------------------+
//| Verifica la vela de 15m y el ATR                                 |
//+------------------------------------------------------------------+
void Check15mBox(datetime currentTime, int openTotalMinutes)
{
   // Buscar la vela M15 correspondiente a la apertura.
   // Como estamos en M5, la apertura fue hace 3 velas (15 minutos).
   int highestShift = iHighest(Symbol(), PERIOD_M5, MODE_HIGH, 3, 1);
   int lowestShift = iLowest(Symbol(), PERIOD_M5, MODE_LOW, 3, 1);
   
   boxHigh = High[highestShift];
   boxLow = Low[lowestShift];
   
   double boxSize = boxHigh - boxLow;
   
   // Obtener ATR Diario de ayer
   double atrDaily = iATR(Symbol(), PERIOD_D1, InpATRPeriod, 1);
   
   if(boxSize >= atrDaily * InpATRMultiplier)
   {
      isActiveToday = true;
      boxStartTime = Time[3]; // Hace 3 velas empezó
      boxEndTime = boxStartTime + (InpDurationMinutes * 60);
      
      double open15m = iOpen(Symbol(), PERIOD_M15, 1);
      double close15m = iClose(Symbol(), PERIOD_M15, 1);
      is15mCandleBullish = (close15m > open15m);
      
      if(InpDrawBox) DrawBox();
      Print("Quick Flip: Caja de 15m Válida. Tamaño: ", boxSize, " ATR*0.25: ", atrDaily * InpATRMultiplier);
   }
   else
   {
      Print("Quick Flip: Caja de 15m muy pequeña. Tamaño: ", boxSize, " Necesario (25% ATR): ", atrDaily * InpATRMultiplier);
   }
}

//+------------------------------------------------------------------+
//| Dibuja el rectángulo en el gráfico                               |
//+------------------------------------------------------------------+
void DrawBox()
{
   string name = "QuickFlipBox";
   ObjectDelete(0, name);
   ObjectCreate(0, name, OBJ_RECTANGLE, 0, boxStartTime, boxHigh, boxEndTime, boxLow);
   ObjectSetInteger(0, name, OBJPROP_COLOR, InpBoxColor);
   ObjectSetInteger(0, name, OBJPROP_BACK, true);
   isBoxDrawn = true;
}

//+------------------------------------------------------------------+
//| Busca patrones de velas para entrar                              |
//+------------------------------------------------------------------+
void CheckEntrySetup()
{
   // Analizar la vela 1 (la que acaba de cerrar)
   double o1 = Open[1];
   double h1 = High[1];
   double l1 = Low[1];
   double c1 = Close[1];
   
   double o2 = Open[2];
   double h2 = High[2];
   double l2 = Low[2];
   double c2 = Close[2];
   
   // --- CONDICIÓN DE VENTA (Por encima de la caja) ---
   if(is15mCandleBullish && (l1 > boxHigh || h1 > boxHigh)) // El precio debe haber superado la caja
   {
      // Patrón Envolvente Bajista o Shooting Star (Martillo invertido)
      bool isBearishEngulfing = (c2 > o2) && (c1 < o1) && (c1 < o2) && (o1 >= c2);
      
      double bodySize = MathAbs(o1 - c1);
      double upperWick = h1 - MathMax(o1, c1);
      double lowerWick = MathMin(o1, c1) - l1;
      bool isShootingStar = (upperWick > bodySize * 2) && (lowerWick < bodySize);
      
      bool bearishPattern = InpStrictPatterns ? (isBearishEngulfing || isShootingStar) : ((c1 < o1) && (isShootingStar || c1 < l2));
      
      if(bearishPattern)
      {
         double sl = h1 + (Point * InpSLPadding); // Un poco de margen
         double tp = boxLow; // Objetivo en el extremo opuesto
         ExecuteTrade(OP_SELL, sl, tp);
         return;
      }
   }
   
   // --- CONDICIÓN DE COMPRA (Por debajo de la caja) ---
   if(!is15mCandleBullish && (h1 < boxLow || l1 < boxLow)) // El precio debe haber bajado de la caja
   {
      // Patrón Envolvente Alcista o Martillo
      bool isBullishEngulfing = (c2 < o2) && (c1 > o1) && (c1 > o2) && (o1 <= c2);
      
      double bodySize = MathAbs(o1 - c1);
      double upperWick = h1 - MathMax(o1, c1);
      double lowerWick = MathMin(o1, c1) - l1;
      bool isHammer = (lowerWick > bodySize * 2) && (upperWick < bodySize);
      
      bool bullishPattern = InpStrictPatterns ? (isBullishEngulfing || isHammer) : ((c1 > o1) && (isHammer || c1 > h2));
      
      if(bullishPattern)
      {
         double sl = l1 - (Point * InpSLPadding); // Margen
         double tp = boxHigh; // Objetivo en el extremo opuesto
         ExecuteTrade(OP_BUY, sl, tp);
         return;
      }
   }
}

//+------------------------------------------------------------------+
//| Ejecuta la operación calculando el lotaje                        |
//+------------------------------------------------------------------+
void ExecuteTrade(int type, double sl, double tp)
{
   double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   double tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
   if(tickValue == 0 || tickSize == 0) return;
   
   double riskMoney = AccountBalance() * (InpRiskPercent / 100.0);
   double entryPrice = (type == OP_BUY) ? Ask : Bid;
   
   double stopLossPoints = MathAbs(entryPrice - sl) / tickSize;
   if(stopLossPoints == 0) return;
   
   double lotSize = riskMoney / (stopLossPoints * tickValue);
   lotSize = NormalizeDouble(lotSize, 2);
   
   double minLot = MarketInfo(Symbol(), MODE_MINLOT);
   double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   if(lotSize < minLot) lotSize = minLot;
   if(lotSize > maxLot) lotSize = maxLot;
   if(lotSize > InpMaxLotSize) lotSize = InpMaxLotSize;
   
   int ticket = OrderSend(Symbol(), type, lotSize, entryPrice, 3, sl, tp, "QuickFlip", InpMagicNumber, 0, (type==OP_BUY)?clrGreen:clrRed);
   if(ticket > 0)
   {
      Print("Quick Flip: Operación abierta. Ticket: ", ticket);
      tradeTakenToday = true; // Solo un trade por día
      if(InpSendPush) SendNotification("Quick Flip [" + Symbol() + "]: Operación " + ((type==OP_BUY)?"COMPRA":"VENTA") + " abierta a " + DoubleToStr(entryPrice, Digits) + " (Lotes: " + DoubleToStr(lotSize, 2) + ")");
   }
   else
   {
      Print("Quick Flip: Error al abrir operación: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Helper para detectar nueva vela                                  |
//+------------------------------------------------------------------+
bool IsNewCandle()
{
   static datetime lastTime = 0;
   datetime currentTime = Time[0];
   if(currentTime != lastTime)
   {
      lastTime = currentTime;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Gestiona las operaciones abiertas (Cierre Parcial y Breakeven)   |
//+------------------------------------------------------------------+
void ManageOpenTrades()
{
   if(partialClosedToday) return; // Ya se gestionó hoy
   
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == InpMagicNumber)
         {
            double entryPrice = OrderOpenPrice();
            double sl = OrderStopLoss();
            double currentPrice = (OrderType() == OP_BUY) ? Bid : Ask;
            
            // Si el SL ya está en BE (o a favor), no hacer nada
            if((OrderType() == OP_BUY && sl >= entryPrice) || (OrderType() == OP_SELL && sl > 0 && sl <= entryPrice))
            {
               partialClosedToday = true;
               continue;
            }
            
            double risk = MathAbs(entryPrice - sl);
            if(risk == 0) continue; // Evitar división por 0
            
            double profit = (OrderType() == OP_BUY) ? (currentPrice - entryPrice) : (entryPrice - currentPrice);
            
            if(profit >= risk * InpPartialCloseRatio)
            {
               double minLot = MarketInfo(Symbol(), MODE_MINLOT);
               double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
               double currentLots = OrderLots();
               
               double lotsToClose = currentLots * (InpPartialClosePct / 100.0);
               lotsToClose = MathRound(lotsToClose / lotStep) * lotStep;
               
               if(lotsToClose >= minLot && lotsToClose < currentLots)
               {
                  bool closed = OrderClose(OrderTicket(), lotsToClose, currentPrice, 3);
                  if(closed)
                  {
                     Print("Quick Flip: Cierre parcial ejecutado. Lotes cerrados: ", lotsToClose);
                     if(InpSendPush) SendNotification("Quick Flip [" + Symbol() + "]: Cierre Parcial del " + DoubleToStr(InpPartialClosePct, 0) + "% a " + DoubleToStr(currentPrice, Digits) + " ✅");
                     partialClosedToday = true;
                     
                     if(InpMoveToBE)
                     {
                        for(int j = OrdersTotal() - 1; j >= 0; j--)
                        {
                           if(OrderSelect(j, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderMagicNumber() == InpMagicNumber)
                           {
                              bool modified = OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice(), OrderTakeProfit(), 0);
                              if(modified) Print("Quick Flip: Stop Loss movido a Breakeven.");
                              break;
                           }
                        }
                     }
                  }
               }
               else
               {
                  partialClosedToday = true; // No se puede cerrar parcial, ignorar
               }
            }
         }
      }
   }
}
//+------------------------------------------------------------------+
