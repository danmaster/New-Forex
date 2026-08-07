import os
import re

file_path = r"c:\Users\rhood\Desktop\New-Forex\Experts\Asian_V2.80.mq4"

with open(file_path, "r", encoding="cp1252") as f:
    content = f.read()

# Make sure we add the header properly
if "PRICE ACTION FILTER (Judas Rejection)" not in content:
    new_header = """//| V2.80 = PRICE ACTION FILTER (Judas Rejection).                    |
//|  - Implementado filtro para evitar "escaladas alcistas" falsas    |
//|    que atropellaban las ordenes Limit. Ahora el EA espera a que   |
//|    la vela de ruptura (M5) cierre dejando una mecha de rechazo    |
//|    (pinbar) para confirmar la manipulacion antes de entrar.       |"""
    content = content.replace('//|  lookback 30): 19 op, 13W/6L (68.4%), +750.58, PF 2.19, DD 3.63%. La  |', 
                              '//|  lookback 30): 19 op, 13W/6L (68.4%), +750.58, PF 2.19, DD 3.63%. La  |\n' + new_header)

# Inputs
if "PriceAction_Settings" not in content:
    inputs_str = 'input string   Mode_Settings     = "--- MODO DE LIQUIDEZ (SMC) ---";'
    new_inputs = """input string   PriceAction_Settings = "--- PRICE ACTION (V2.80) ---";
input bool     UsePriceActionFilter = true;       // V2.80: Exigir vela de rechazo (mecha) antes de entrar
input double   MinWickRejectionPercent = 50.0;    // V2.80: % minimo de la mecha de rechazo sobre la vela total

input string   Mode_Settings     = "--- MODO DE LIQUIDEZ (SMC) ---";"""
    content = content.replace(inputs_str, new_inputs)

# Logic
old_logic_pattern = r"(\s+bool sellBreakOK = true;\s+bool buyBreakOK  = true;\s+if\(WaitForBreakout\)\s+\{\s+sellBreakOK = \(!doSell \|\| Bid > asianHigh\);\s+buyBreakOK  = \(!doBuy  \|\| Ask < asianLow\);\s+\})"

def replacer(m):
    return """                 bool sellBreakOK = true;
                 bool buyBreakOK  = true;
                 
                 if(WaitForBreakout)
                   {
                    sellBreakOK = (!doSell || Bid > asianHigh);
                    buyBreakOK  = (!doBuy  || Ask < asianLow);
                   }
                   
                 // V2.80: Price Action Filter (Rechazo Judas)
                 if(UsePriceActionFilter)
                   {
                    bool validSellRejection = false;
                    bool validBuyRejection  = false;
                    
                    // Comprobar vela anterior [1] para ver si dejo rechazo (Judas Swing real)
                    double candleSize1 = High[1] - Low[1];
                    if(candleSize1 > 0)
                      {
                       double upperWick = High[1] - MathMax(Open[1], Close[1]);
                       double lowerWick = MathMin(Open[1], Close[1]) - Low[1];
                       
                       if(High[1] > asianHigh && (upperWick / candleSize1) * 100.0 >= MinWickRejectionPercent)
                          validSellRejection = true;
                          
                       if(Low[1] < asianLow && (lowerWick / candleSize1) * 100.0 >= MinWickRejectionPercent)
                          validBuyRejection = true;
                      }
                      
                    sellBreakOK = (!doSell || validSellRejection);
                    buyBreakOK  = (!doBuy  || validBuyRejection);
                   }"""

if "Price Action Filter (Rechazo Judas)" not in content:
    content, count = re.subn(old_logic_pattern, replacer, content)
    print(f"Replaced logic {count} times.")

with open(file_path, "w", encoding="cp1252") as f:
    f.write(content)
print("File rewritten.")
