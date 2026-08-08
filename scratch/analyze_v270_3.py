import re
import sys
sys.stdout.reconfigure(encoding='latin-1')

path = r'C:\Users\rhood\Desktop\New-Forex\Operaciones\Asian_V2.70_3.htm'
with open(path, 'r', encoding='latin-1') as f:
    content = f.read()

rows = re.findall(r'<tr[^>]*>(.*?)</tr>', content, re.DOTALL)

trades = []
for row in rows:
    cells = re.findall(r'<td[^>]*>(.*?)</td>', row, re.DOTALL)
    cells = [re.sub(r'<[^>]+>', '', c).strip() for c in cells]
    if not cells:
        continue
    first = cells[0]
    if first in ('#',) or not first.isdigit():
        continue
    num = int(first)
    time = cells[1] if len(cells) > 1 else ''
    typ = cells[2] if len(cells) > 2 else ''
    ordid = cells[3] if len(cells) > 3 else ''
    vol = cells[4] if len(cells) > 4 else ''
    price = cells[5] if len(cells) > 5 else ''
    sl = cells[6] if len(cells) > 6 else ''
    tp = cells[7] if len(cells) > 7 else ''
    profit = cells[8] if len(cells) > 8 else ''
    balance = cells[9] if len(cells) > 9 else ''
    trades.append({
        'n': num, 'time': time, 'type': typ, 'ord': ordid,
        'vol': float(vol) if vol else 0, 'price': float(price) if price else 0,
        'sl': float(sl) if sl else 0, 'tp': float(tp) if tp else 0,
        'profit': float(profit) if profit else 0, 'balance': float(balance) if balance else 0
    })

def to_dt(s):
    m = re.match(r'(\d{4})\.(\d{2})\.(\d{2}) (\d{2}):(\d{2})', s)
    if not m:
        return None
    import datetime
    return datetime.datetime(int(m.group(1)), int(m.group(2)), int(m.group(3)),
                             int(m.group(4)), int(m.group(5)))

# Agrupar por orden: la fila 'close/sl/tp' cierra la orden abierta con ese num de orden.
# Reconstruimos: para cada orden, buscamos la fila de apertura (buy/sell) y el cierre.
results = []
open_orders = {}
for t in trades:
    if t['type'] in ('buy', 'sell'):
        open_orders[t['ord']] = t
    elif t['type'] in ('close', 's/l', 't/p', 'sl', 'tp'):
        op = open_orders.get(t['ord'])
        if not op:
            continue
        dt = to_dt(op['time'])
        cd = to_dt(t['time'])
        sl_dist = abs(op['price'] - op['sl']) / 0.0001
        tp_dist = abs(op['price'] - op['tp']) / 0.0001
        rr_structural = tp_dist / sl_dist if sl_dist else 0
        if op['type'] == 'buy':
            entry = op['price']; exit_ = t['price']
        else:
            entry = op['price']; exit_ = t['price']
        direction = op['type']
        # R alcanzado (pips ganados / pips SL)
        r_achieved = (exit_ - entry) / 0.0001 / sl_dist if sl_dist else 0
        if direction == 'sell':
            r_achieved = (entry - exit_) / 0.0001 / sl_dist if sl_dist else 0
        results.append({
            'date': op['time'], 'close_date': t['time'],
            'day': dt.strftime('%A') if dt else '?',
            'hour': dt.hour if dt else -1,
            'dir': 'SELL' if direction == 'sell' else 'BUY',
            'entry': entry, 'exit': exit_,
            'sl_pips': sl_dist, 'tp_pips': tp_dist,
            'rr': rr_structural, 'r': r_achieved,
            'profit': t['profit'], 'result': 'WIN' if t['profit'] > 0 else 'LOSS'
        })

print(f"{'#':>2} {'Fecha':<12} {'Dia':<10} {'Hora':>4} {'Dir':<4} {'SL':>5} {'TP':>6} {'RR':>5} {'R':>6} {'PyG':>8}  Res")
for i, r in enumerate(results, 1):
    print(f"{i:>2} {r['date']:<12} {r['day']:<10} {r['hour']:>4} {r['dir']:<4} "
          f"{r['sl_pips']:>5.1f} {r['tp_pips']:>6.1f} {r['rr']:>5.2f} {r['r']:>6.2f} {r['profit']:>8.2f}  {r['result']}")

wins = [r for r in results if r['result'] == 'WIN']
losses = [r for r in results if r['result'] == 'LOSS']
print(f"\nTotal: {len(results)}  W: {len(wins)} ({len(wins)/len(results)*100:.1f}%)  L: {len(losses)}")
print(f"Win sum: {sum(r['profit'] for r in wins):.2f}  Loss sum: {sum(r['profit'] for r in losses):.2f}  Net: {sum(r['profit'] for r in results):.2f}")
print(f"Promedio R en wins: {sum(r['r'] for r in wins)/len(wins):.2f}   Promedio R en losses: {sum(r['r'] for r in losses)/len(losses):.2f}")
print(f"RR estructural: wins avg {sum(r['rr'] for r in wins)/len(wins):.2f}, losses avg {sum(r['rr'] for r in losses)/len(losses):.2f}")

# Racha de pérdidas al final
print(f"\nSecuencia resultados: {' '.join('W' if r['result']=='WIN' else 'L' for r in results)}")

# Patron por dia
from collections import Counter
day_w = Counter(r['day'] for r in wins)
day_l = Counter(r['day'] for r in losses)
print(f"\nWins por dia: {dict(day_w)}")
print(f"Losses por dia: {dict(day_l)}")

