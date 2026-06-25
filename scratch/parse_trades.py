import re
import json
import sys

# Forzar utf-8
sys.stdout.reconfigure(encoding='utf-8')

file_path = r'c:\Users\USER\Desktop\New Forex\Operaciones\operaciones.txt'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# El HTML está en una sola línea. Podemos intentar splitear por '<tr class="ka-tr ka-row'
tr_blocks = content.split('<tr class="ka-tr ka-row')
trades = []

print(f"Total blocks split: {len(tr_blocks)}")

for block in tr_blocks[1:]: # Skip el primer trozo que no es una fila de operación
    # ID del trade
    trade_id_match = re.search(r'data="(\d+)"', block)
    if not trade_id_match:
        continue
    trade_id = trade_id_match.group(1)
    
    # Extraer fechas (data-part="1" que suele ser la entrada)
    dates = re.findall(r'<div class="cell-rUaWh0C3" data-part="1">([^<]+)</div>', block)
    entry_date_str = ""
    for d in dates:
        if "2026" in d or "2025" in d:
            entry_date_str = d
            break
            
    # Extraer PyG neta
    values = re.findall(r'<div class="value-SLMKagwH">([^<]+)</div><div class="currency-SLMKagwH">USD</div>', block)
    net_pnl_str = ""
    if len(values) >= 3:
        net_pnl_str = values[2]
        
    trades.append({
        'id': int(trade_id),
        'entry_date': entry_date_str,
        'pnl': net_pnl_str
    })

# Escribimos los resultados a un archivo JSON para leerlo fácilmente
with open(r'c:\Users\USER\Desktop\New Forex\scratch\trades.json', 'w', encoding='utf-8') as f:
    json.dump(trades, f, indent=2, ensure_ascii=False)

print(f"Extracted {len(trades)} trades")
