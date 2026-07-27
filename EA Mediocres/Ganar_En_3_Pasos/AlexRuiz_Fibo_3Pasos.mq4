//+------------------------------------------------------------------+
//|                                        AlexRuiz_Fibo_3Pasos.mq4  |
//|                                  Copyright 2026, Antigravity AI  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Antigravity AI"
#property link      ""
#property version   "1.30"
#property strict

//--- Inputs Generales
input double   InpRiskPercent     = 1.0;       // Riesgo Total de la Cuenta (%)
input int      InpEmaPeriod       = 200;       // Periodo de EMA (Tendencia)
input int      InpZigZagDepth     = 12;        // ZigZag Depth
input int      InpZigZagDeviation = 30;        // ZigZag Deviation
input int      InpZigZagBackstep  = 3;         // ZigZag Backstep
input int      InpMagicNumber     = 888999;    // Magic Number

//--- Inputs de Fibonacci (Niveles y Riesgo Fraccionado)
input double   InpFibo1           = 0.382;     // Fibo Entrada 1
input double   InpRiskSplit1      = 25.0;      // Porcentaje del riesgo para Entrada 1 (%)
input double   InpFibo2           = 0.500;     // Fibo Entrada 2
input double   InpRiskSplit2      = 40.0;      // Porcentaje del riesgo para Entrada 2 (%)
input double   InpFibo3           = 0.618;     // Fibo Entrada 3
input double   InpRiskSplit3      = 35.0;      // Porcentaje del riesgo para Entrada 3 (%)
input double   InpFiboSL          = 0.786;     // Fibo Stop Loss (Global)
input double   InpFiboTP          = 0.0;       // Fibo Take Profit (Extensión)
input double   InpMinImpulsePips  = 30.0;      // Filtro: Impulso mínimo en Pips

//--- Filtros de Tiempo y Día
input bool     InpUseTimeFilter   = false;     // Activar Filtro de Horario
input int      InpStartHour       = 1;         // Hora de inicio (Broker) ej: 1
input int      InpEndHour         = 18;        // Hora de fin (Broker) ej: 18
input bool     InpUseFridayFilter = true;      // Activar Filtro de Viernes
input int      InpFridayStopHour  = 14;        // Hora límite los Viernes ej: 14

//--- Global Variables
datetime lastImpulseTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("EA Alex Ruiz Fibo 3 Pasos v2.0 (Cesta) Inicializado.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Función para calcular el lotaje dinámico                         |
//+------------------------------------------------------------------+
double CalculateLotSize(double riskAmount, double entryPrice, double slPrice)
  {
   double tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
   double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   if (tickSize == 0.0 || tickValue == 0.0) return MarketInfo(Symbol(), MODE_MINLOT);
   
   double lossInTicks = MathAbs(entryPrice - slPrice) / tickSize;
   if (lossInTicks == 0.0) return MarketInfo(Symbol(), MODE_MINLOT);
   
   double lot = riskAmount / (lossInTicks * tickValue);
   
   // Normalizar
   double minLot = MarketInfo(Symbol(), MODE_MINLOT);
   double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   
   lot = MathFloor(lot / lotStep) * lotStep;
   if(lot < minLot) lot = minLot;
   if(lot > maxLot) lot = maxLot;
   
   return lot;
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // 1. Identificar Tendencia (EMA)
   double ema = iMA(Symbol(), 0, InpEmaPeriod, 0, MODE_EMA, PRICE_CLOSE, 1);
   bool isUptrend = (Close[1] > ema);
   bool isDowntrend = (Close[1] < ema);
   
   // 2. Identificar el último Impulso (ZigZag)
   double swingHigh = 0.0;
   double swingLow = 0.0;
   datetime timeHigh = 0;
   datetime timeLow = 0;
   int foundPoints = 0;
   
   for(int i = 1; i < 500; i++)
     {
      double zz = iCustom(Symbol(), 0, "ZigZag", InpZigZagDepth, InpZigZagDeviation, InpZigZagBackstep, 0, i);
      if(zz > 0.0)
        {
         if(foundPoints == 0)
           {
            if(High[i] == zz) { swingHigh = zz; timeHigh = Time[i]; }
            if(Low[i] == zz)  { swingLow = zz; timeLow = Time[i]; }
            foundPoints++;
           }
         else if(foundPoints == 1)
           {
            if(High[i] == zz && swingHigh == 0.0) { swingHigh = zz; timeHigh = Time[i]; foundPoints++; }
            if(Low[i] == zz && swingLow == 0.0)   { swingLow = zz; timeLow = Time[i]; foundPoints++; }
            if(foundPoints == 2) break;
           }
        }
     }
     
   if(foundPoints < 2 || swingHigh == 0.0 || swingLow == 0.0) return;
   
   bool impulseIsUp = (timeHigh > timeLow); 
   bool impulseIsDown = (timeLow > timeHigh); 
   datetime currentImpulseTime = impulseIsUp ? timeHigh : timeLow;
   
   // 3. Comprobar órdenes existentes
   bool hasOpenTrade = false;
   bool hasPendingOrder = false;
   int pendingTickets[30];
   int pendingCount = 0;
   
   for(int j = OrdersTotal() - 1; j >= 0; j--)
     {
      if(OrderSelect(j, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == InpMagicNumber)
           {
            if(OrderType() == OP_BUY || OrderType() == OP_SELL)
              {
               hasOpenTrade = true;
              }
            else
              {
               hasPendingOrder = true;
               if(pendingCount < 30)
                 {
                  pendingTickets[pendingCount] = OrderTicket();
                  pendingCount++;
                 }
              }
           }
        }
     }
     
   // --- FILTRO DE VIERNES ESTRICTO ---
   bool isFridayStop = false;
   if(InpUseFridayFilter && DayOfWeek() == 5 && Hour() >= InpFridayStopHour)
     {
      isFridayStop = true;
     }

   if(isFridayStop)
     {
      if(hasPendingOrder)
        {
         for(int k = 0; k < pendingCount; k++)
           {
            if(OrderSelect(pendingTickets[k], SELECT_BY_TICKET))
              {
               OrderDelete(pendingTickets[k]);
              }
           }
         Print("Filtro de Viernes Activo: Órdenes pendientes eliminadas para evitar riesgo de fin de semana.");
         hasPendingOrder = false;
         pendingCount = 0;
        }
     }

   // Si hay una operación ABIERTA, la cesta está activa. 
   // Dejamos las pendientes quietas para que enganchen el nivel 0.50 y 0.618 si el precio baja más,
   // A MENOS que sea viernes por la tarde (ya fueron eliminadas arriba).
   if(hasOpenTrade) return;
   
   // --- FILTRO DE TIEMPO Y DIAS ---
   bool canTrade = true;
   if(InpUseTimeFilter)
     {
      int currentHour = Hour();
      if(currentHour < InpStartHour || currentHour >= InpEndHour) canTrade = false;
     }
     
   if(isFridayStop) canTrade = false;

   // Si estamos fuera de horario, y NO hay operaciones abiertas, borramos las pendientes para no quedar atrapados
   if(!canTrade)
     {
      if(hasPendingOrder)
        {
         for(int k = 0; k < pendingCount; k++)
           {
            if(OrderSelect(pendingTickets[k], SELECT_BY_TICKET))
              {
               OrderDelete(pendingTickets[k]);
              }
           }
         Print("Fuera de horario de trading: Órdenes pendientes (Limits) eliminadas para evitar la sesión Asiática/Fin de Semana.");
        }
      return;
     }
   
   // Si no hay operaciones abiertas, pero el impulso es exactamente el mismo que ya operamos
   if(currentImpulseTime == lastImpulseTime) return; 
   
   // Si llegamos aquí, es un impulso NUEVO y NO hay operaciones abiertas.
   // Si quedaron órdenes pendientes del impulso anterior, las eliminamos.
   if(hasPendingOrder)
     {
      for(int k = 0; k < pendingCount; k++)
        {
         if(OrderSelect(pendingTickets[k], SELECT_BY_TICKET))
           {
            OrderDelete(pendingTickets[k]);
           }
        }
      Print("Órdenes pendientes antiguas eliminadas por nuevo impulso.");
     }
     
   // 4. Calcular Cesta Fibo y Entrar (Límites)
   double totalRiskAmount = AccountBalance() * (InpRiskPercent / 100.0);
   double risk1 = totalRiskAmount * (InpRiskSplit1 / 100.0);
   double risk2 = totalRiskAmount * (InpRiskSplit2 / 100.0);
   double risk3 = totalRiskAmount * (InpRiskSplit3 / 100.0);
   
   double impulseRange = MathAbs(swingHigh - swingLow);
   
   // --- FILTRO DE IMPULSO MINIMO ---
   double pipsToPoints = (MarketInfo(Symbol(), MODE_POINT) == 0.00001 || MarketInfo(Symbol(), MODE_POINT) == 0.001) ? 10.0 : 1.0;
   double minImpulsePoints = InpMinImpulsePips * MarketInfo(Symbol(), MODE_POINT) * pipsToPoints;
   
   if(impulseRange < minImpulsePoints)
     {
      // Ignoramos este impulso por ser demasiado pequeño
      return;
     }
   
   if(isUptrend && impulseIsUp)
     {
      double entry1 = swingHigh - (impulseRange * InpFibo1);
      double entry2 = swingHigh - (impulseRange * InpFibo2);
      double entry3 = swingHigh - (impulseRange * InpFibo3);
      double slPrice = swingHigh - (impulseRange * InpFiboSL);
      
      // El Take Profit usando la extensión de Fibonacci
      double tpPrice = swingHigh - (impulseRange * InpFiboTP); 
      
      // Calcular Lotajes
      double lot1 = CalculateLotSize(risk1, entry1, slPrice);
      double lot2 = CalculateLotSize(risk2, entry2, slPrice);
      double lot3 = CalculateLotSize(risk3, entry3, slPrice);
      
      if(Close[0] > entry1)
        {
         OrderSend(Symbol(), OP_BUYLIMIT, lot1, entry1, 3, slPrice, tpPrice, "Fibo L1", InpMagicNumber, 0, clrGreen);
         OrderSend(Symbol(), OP_BUYLIMIT, lot2, entry2, 3, slPrice, tpPrice, "Fibo L2", InpMagicNumber, 0, clrLime);
         OrderSend(Symbol(), OP_BUYLIMIT, lot3, entry3, 3, slPrice, tpPrice, "Fibo L3", InpMagicNumber, 0, clrLimeGreen);
         
         lastImpulseTime = currentImpulseTime;
         Print("Cesta BUY colocada. SL: ", slPrice, " TP: ", tpPrice);
        }
     }
   else if(isDowntrend && impulseIsDown)
     {
      double entry1 = swingLow + (impulseRange * InpFibo1);
      double entry2 = swingLow + (impulseRange * InpFibo2);
      double entry3 = swingLow + (impulseRange * InpFibo3);
      double slPrice = swingLow + (impulseRange * InpFiboSL);
      
      // El Take Profit usando la extensión de Fibonacci
      double tpPrice = swingLow + (impulseRange * InpFiboTP);
      
      // Calcular Lotajes
      double lot1 = CalculateLotSize(risk1, entry1, slPrice);
      double lot2 = CalculateLotSize(risk2, entry2, slPrice);
      double lot3 = CalculateLotSize(risk3, entry3, slPrice);
      
      if(Close[0] < entry1)
        {
         OrderSend(Symbol(), OP_SELLLIMIT, lot1, entry1, 3, slPrice, tpPrice, "Fibo L1", InpMagicNumber, 0, clrRed);
         OrderSend(Symbol(), OP_SELLLIMIT, lot2, entry2, 3, slPrice, tpPrice, "Fibo L2", InpMagicNumber, 0, clrOrangeRed);
         OrderSend(Symbol(), OP_SELLLIMIT, lot3, entry3, 3, slPrice, tpPrice, "Fibo L3", InpMagicNumber, 0, clrDarkRed);
         
         lastImpulseTime = currentImpulseTime;
         Print("Cesta SELL colocada. SL: ", slPrice, " TP: ", tpPrice);
        }
     }
  }
//+------------------------------------------------------------------+
