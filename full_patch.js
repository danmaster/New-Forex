const fs = require('fs');
let file = fs.readFileSync('c:/Users/rhood/Desktop/New-Forex/Experts/Asian_V2.0.mq4', 'utf8');

// Apply V2.5 baseline patches
file = file.replace('asian_breakout_V1.016.mq4', 'Asian_V2.5.mq4');
file = file.replace('version   \"2.00\"', 'version   \"2.50\"');

file = file.replace('input bool     UseDynamicLot     = true;', 'input int      SlippagePoints    = 3;          // Slippage maximo (points)\n#define SLIPPAGE SlippagePoints\ninput bool     UseDynamicLot     = true;');

const onInitOld = '   // Solucionar el problema de \"Fractional Pips\"';
const onInitNew = `   if(UseAutoBreakEven && UseBreakEvenAt1R)
      Print("ATENCION: Ambos modos de BE activos. Solo se aplicara 'UseBreakEvenAt1R' (ignora 'UseAutoBreakEven').");

   if(UseNewsFilter && !GlobalVariableCheck("SMC_News_High") && !GlobalVariableCheck("SMC_News_Med"))
      Print("ALERTA: News_Fetcher.mq4 no detectada en chart. Filtro de noticias DESACTIVADO.");

   Print("Aviso: Filtro de tendencia macro DESHABILITADO por diseno (Judas Swing requiere operar contra el impulso). IsTrendAligned siempre retorna true.");

   // Rehidratar arrays
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol())
           {
            int t = OrderTicket();
            if(StringFind(OrderComment(), "from #") >= 0 && g_partialClosedCount < 100)
              {
               g_partialClosedTickets[g_partialClosedCount] = t;
               g_partialClosedCount++;
              }
           }
        }
     }

   // Solucionar el problema de "Fractional Pips"`;
file = file.replace(onInitOld, onInitNew);

const highOld = `               int barsPassed = iBarShift(Symbol(), Period(), timeSweptHigh);
               if(barsPassed > MaxCandlesOutside || (Time[0] - timeSweptHigh > MaxMinutesForReversal * 60)) // Usamos Time[0] actual
                 {
                  sweptHigh = false;
                  patternFoundHigh = false; // Reset
                  peakHigh = 0;
                 }
               else
                 {
                  // Buscar el patrÃ³n MIENTRAS estamos fuera (al cierre de cada vela)
                  if(!patternFoundHigh && isBearishReversal(1)) patternFoundHigh = true;
                 }`;
const highNew = `               int barsPassed = iBarShift(Symbol(), Period(), timeSweptHigh);
               bool caducadoPorVelas = (barsPassed >= 0 && barsPassed > MaxCandlesOutside);
               bool caducadoPorTiempo = (Time[0] - timeSweptHigh > MaxMinutesForReversal * 60);
               if(barsPassed < 0 || caducadoPorVelas || caducadoPorTiempo)
                 {
                  sweptHigh = false;
                  patternFoundHigh = false; // Reset
                  peakHigh = 0;
                 }
               else
                 {
                  if(!patternFoundHigh && isBearishReversal(1)) patternFoundHigh = true;
                 }`;
file = file.replace(highOld, highNew);

const lowOld = `               int barsPassed = iBarShift(Symbol(), Period(), timeSweptLow);
               if(barsPassed > MaxCandlesOutside || (Time[0] - timeSweptLow > MaxMinutesForReversal * 60))
                 {
                  sweptLow = false;
                  patternFoundLow = false; // Reset
                  troughLow = 0;
                 }
               else
                 {
                  // Buscar el patrÃ³n MIENTRAS estamos fuera (al cierre de cada vela)
                  if(!patternFoundLow && isBullishReversal(1)) patternFoundLow = true;
                 }`;
const lowNew = `               int barsPassed = iBarShift(Symbol(), Period(), timeSweptLow);
               bool caducadoPorVelas = (barsPassed >= 0 && barsPassed > MaxCandlesOutside);
               bool caducadoPorTiempo = (Time[0] - timeSweptLow > MaxMinutesForReversal * 60);
               if(barsPassed < 0 || caducadoPorVelas || caducadoPorTiempo)
                 {
                  sweptLow = false;
                  patternFoundLow = false; // Reset
                  troughLow = 0;
                 }
               else
                 {
                  if(!patternFoundLow && isBullishReversal(1)) patternFoundLow = true;
                 }`;
file = file.replace(lowOld, lowNew);

file = file.replace('if(Bid < sl)', 'double stopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;\n                  if(Bid < sl && (sl - Bid) >= stopLevel)');
file = file.replace('if(Ask > sl)', 'double stopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;\n                  if(Ask > sl && (Ask - sl) >= stopLevel)');

file = file.replace(', 3, clrOrange', ', SLIPPAGE, clrOrange');
file = file.replace(', 3, clrOrange', ', SLIPPAGE, clrOrange');
file = file.replace(', 3, clrOrange', ', SLIPPAGE, clrOrange');
file = file.replace(', 3, sl, actualTP, "SMC Reversion Sell"', ', SLIPPAGE, sl, actualTP, "SMC Reversion Sell"');
file = file.replace(', 3, sl, actualTP, "SMC Reversion Buy"', ', SLIPPAGE, sl, actualTP, "SMC Reversion Buy"');
file = file.replace(', 3, stopLoss, takeProfit, "SMC Limit Manual"', ', SLIPPAGE, stopLoss, takeProfit, "SMC Limit Manual"');

// Clean Accents
file = file.replace(/DinÃ¡mico/g, 'Dinamico');
file = file.replace(/operaciÃ³n/g, 'operacion');
file = file.replace(/NotificaciÃ³n/g, 'Notificacion');
file = file.replace(/MÃ³vil/g, 'Movil');
file = file.replace(/TamaÃ±o/g, 'Tamano');
file = file.replace(/MÃ­nimo/g, 'Minimo');
file = file.replace(/MÃ¡ximo/g, 'Maximo');
file = file.replace(/mÃ¡xima/g, 'maxima');
file = file.replace(/MÃ¡x\./g, 'Max.');
file = file.replace(/AutomÃ¡tico/g, 'Automatico');
file = file.replace(/reversiÃ³n/g, 'reversion');
file = file.replace(/RectÃ¡ngulo/g, 'Rectangulo');
file = file.replace(/después/g, 'despues');
file = file.replace(/despuÃ©s/g, 'despues');
file = file.replace(/dÃ­a/g, 'dia');
file = file.replace(/dÃ­gitos/g, 'digitos');
file = file.replace(/aÃ±os/g, 'anos');
file = file.replace(/diseÃ±o/g, 'diseno');
file = file.replace(/diseÃ±ado/g, 'disenado');
file = file.replace(/evalÃºa/g, 'evalua');
file = file.replace(/seÃ±ales/g, 'senales');
file = file.replace(/estÃ¡/g, 'esta');
file = file.replace(/patrÃ³n/g, 'patron');
file = file.replace(/FallÃ³/g, 'Fallo');
file = file.replace(/opciÃ³n/g, 'opcion');
file = file.replace(/OpciÃ³n/g, 'Opcion');
file = file.replace(/simetrÃ­a/g, 'simetria');


// DST LOGIC INJECTION
const dstLogic = `
//+------------------------------------------------------------------+
//| Auto DST (Daylight Saving Time) Checker                          |
//| Returns true if current server time is in US DST                 |
//+------------------------------------------------------------------+
bool IsUSADST(datetime time)
  {
   int year = TimeYear(time);
   int month = TimeMonth(time);
   
   if(month < 3 || month > 11) return false;
   if(month > 3 && month < 11) return true;
   
   // Calcular el segundo domingo de marzo
   datetime march1 = StringToTime(IntegerToString(year) + ".03.01");
   int dayOfWeekMar1 = TimeDayOfWeek(march1);
   int secondSundayMar = 15 - dayOfWeekMar1; 
   if(dayOfWeekMar1 == 0) secondSundayMar = 8;
   
   // Calcular el primer domingo de noviembre
   datetime nov1 = StringToTime(IntegerToString(year) + ".11.01");
   int dayOfWeekNov1 = TimeDayOfWeek(nov1);
   int firstSundayNov = 8 - dayOfWeekNov1;
   if(dayOfWeekNov1 == 0) firstSundayNov = 1;
   
   int day = TimeDay(time);
   
   if(month == 3)
     {
      if(day > secondSundayMar) return true;
      if(day == secondSundayMar && TimeHour(time) >= 2) return true;
      return false;
     }
     
   if(month == 11)
     {
      if(day < firstSundayNov) return true;
      if(day == firstSundayNov && TimeHour(time) < 2) return true;
      return false;
     }
     
   return false;
  }
`;

const onTickOld = `//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+`;

const onTickNew = dstLogic + onTickOld;

file = file.replace(onTickOld, onTickNew);

file = file.replace(/hour >= StartHour && hour < EndHour/g, 'hour >= adjustedStartHour && hour < adjustedEndHour');
file = file.replace(/TimeHour\(Time\[0\]\) <= MaxEntryHour/g, 'TimeHour(Time[0]) <= adjustedMaxEntry');
file = file.replace(/hour > EndHour/g, 'hour > adjustedEndHour');
file = file.replace(/TimeHour\(Time\[0\]\) == EndHour/g, 'TimeHour(Time[0]) == adjustedEndHour');

const startOnTickOld = `void OnTick()
  {
   // 1. Filtrado basico de dias
   int currentDayOfWeek = DayOfWeek();`;
   
const startOnTickNew = `void OnTick()
  {
   int adjustedStartHour = StartHour;
   int adjustedEndHour = EndHour;
   int adjustedMaxEntry = MaxEntryHour;
   
   if(IsUSADST(TimeCurrent()))
     {
      adjustedStartHour = StartHour + 1;
      if(adjustedStartHour > 23) adjustedStartHour -= 24;
      adjustedEndHour = EndHour + 1;
      if(adjustedEndHour > 23) adjustedEndHour -= 24;
      adjustedMaxEntry = MaxEntryHour + 1;
      if(adjustedMaxEntry > 23) adjustedMaxEntry -= 24;
     }

   // 1. Filtrado basico de dias
   int currentDayOfWeek = DayOfWeek();`;

file = file.replace(startOnTickOld, startOnTickNew);

fs.writeFileSync('c:/Users/rhood/Desktop/New-Forex/Experts/Asian_V2.5.mq4', file, 'utf8');
console.log('Success!');
