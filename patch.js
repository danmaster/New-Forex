const fs = require('fs');
let file = fs.readFileSync('c:/Users/rhood/Desktop/New-Forex/Experts/Asian_V2.0.mq4', 'utf8');

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

fs.writeFileSync('c:/Users/rhood/Desktop/New-Forex/Experts/Asian_V2.5.mq4', file, 'utf8');
console.log('Success');
