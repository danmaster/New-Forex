import re
import sys
import datetime
from collections import Counter
sys.stdout.reconfigure(encoding='utf-8')

path = sys.argv[1] if len(sys.argv) > 1 else r'C:\Users\rhood\Desktop\New-Forex\Operaciones\Asian_V2.70_3.htm'
with open(path, 'r', encoding='latin-1') as f:
    content = f.read()

rows = re.findall(r'<tr[^>]*>(.*?)</tr>', content, re.DOTALL)
trades = []
for row in rows:
    cells = re.findall(r'<td[^>]*>(.*?)</td>', row, re.DOTALL)
    cells = [re.sub(r'<[^>]+>', '', c).strip() for c in cells]
    if not cells or not cells[0].isdigit():
        continue
    num = int(cells[0])
    time = cells[1] if len(cells) > 1 else ''
    typ = cells[2] if len(cells) > 2 else ''
    ordid = cells[3] if len(cells) > 3 else ''
    price = cells[5] if len(cells) > 5 else ''
    sl = cells[6] if len(cells) > 6 else ''
    tp = cells[7] if len(cells) > 7 else ''
    profit = cells[8] if len(cells) > 8 else ''
    trades.append({
        'n': num, 'time': time, 'type': typ, 'ord': ordid,
        'price': float(price) if price else 0,
        'sl': float(sl) if sl else 0, 'tp': float(tp) if tp else 0,
        'profit': float(profit) if profit else 0
    })

def to_dt(s):
    m = re.match(r'(\d{4})\.(\d{2})\.(\d{2}) (\d{2}):(\d{2})', s)
    if not m:
        return None
    return datetime.datetime(int(m.group(1)), int(m.group(2)), int(m.group(3)),
                             int(m.group(4)), int(m.group(5)))

results = []
open_orders = {}
for t in trades:
    if t['type'] in ('buy', 'sell'):
        open_orders[t['ord']] = t
    elif t['type'] in ('close', 's/l', 't/p'):
        op = open_orders.get(t['ord'])
        if not op:
            continue
        dt = to_dt(op['time'])
        sl_dist = abs(op['price'] - op['sl']) / 0.0001
        tp_dist = abs(op['price'] - op['tp']) / 0.0001
        rr_structural = tp_dist / sl_dist if sl_dist else 0
        if op['type'] == 'buy':
            r_achieved = (t['price'] - op['price']) / 0.0001 / sl_dist if sl_dist else 0
        else:
            r_achieved = (op['price'] - t['price']) / 0.0001 / sl_dist if sl_dist else 0
        # Clasificar el tipo de salida
        if t['type'] == 't/p':
            close_kind = 'TP_estruct'
        elif t['type'] == 's/l':
            close_kind = 'SL'
        elif r_achieved < 0.2:
            close_kind = 'BE_lock'
        elif r_achieved < 0.7:
            close_kind = 'parcial'
        else:
            close_kind = '1R_ladder'
        results.append({
            'date': op['time'],
            'day': dt.strftime('%A') if dt else '?',
            'dir': 'SELL' if op['type'] == 'sell' else 'BUY',
            'entry': op['price'], 'exit': t['price'],
            'sl_pips': sl_dist, 'tp_pips': tp_dist,
            'rr': rr_structural, 'r': r_achieved,
            'profit': t['profit'], 'kind': close_kind,
            'res': 'WIN' if t['profit'] > 0 else 'LOSS'
        })

print(f"{'#':>2} {'Fecha':<12} {'Dia':<10} {'Dir':<4} {'SL':>5} {'TP':>6} {'RR':>5} {'R':>6} {'PyG':>8} {'Salida':<10}  Res")
for i, r in enumerate(results, 1):
    print(f"{i:>2} {r['date']:<12} {r['day']:<10} {r['dir']:<4} {r['sl_pips']:>5.1f} {r['tp_pips']:>6.1f} {r['rr']:>5.2f} {r['r']:>6.2f} {r['profit']:>8.2f} {r['kind']:<10}  {r['res']}")

wins = [r for r in results if r['res'] == 'WIN']
losses = [r for r in results if r['res'] == 'LOSS']
kinds = Counter(r['kind'] for r in results)
print(f"\nTotal: {len(results)}  W: {len(wins)} ({len(wins)/len(results)*100:.1f}%)  L: {len(losses)}")
print(f"Net: {sum(r['profit'] for r in results):.2f}  (W sum {sum(r['profit'] for r in wins):.2f} / L sum {sum(r['profit'] for r in losses):.2f})")
print(f"Salidas: {dict(kinds)}")
print(f"Secuencia: {' '.join('W' if r['res']=='WIN' else 'L' for r in results)}")
print(f"Rachas de L: {[r['r'] for r in results if r['res']=='LOSS']}")
# TP estructural vs 1R: cuantas habrian llegado al TP segun R alcanzado
fulltp = [r for r in results if r['kind'] == 'TP_estruct']
onear = [r for r in results if r['kind'] == '1R_ladder']
print(f"\nTP estructural alcanzado: {len(fulltp)} trades -> {sum(r['profit'] for r in fulltp):.2f} USD")
print(f"Cortados por ladder a 1R: {len(onear)} trades -> {sum(r['profit'] for r in onear):.2f} USD")
