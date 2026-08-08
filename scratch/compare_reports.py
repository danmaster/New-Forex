import re
import sys
import datetime
sys.stdout.reconfigure(encoding='utf-8')

def parse(path):
    with open(path, 'r', encoding='latin-1') as f:
        content = f.read()
    rows = re.findall(r'<tr[^>]*>(.*?)</tr>', content, re.DOTALL)
    trades = []
    for row in rows:
        cells = re.findall(r'<td[^>]*>(.*?)</td>', row, re.DOTALL)
        cells = [re.sub(r'<[^>]+>', '', c).strip() for c in cells]
        if not cells or not cells[0].isdigit():
            continue
        trades.append({
            'n': int(cells[0]), 'time': cells[1], 'type': cells[2], 'ord': cells[3],
            'price': float(cells[5]), 'sl': float(cells[6]), 'tp': float(cells[7]),
            'profit': float(cells[8]) if cells[8] else 0
        })
    open_orders = {}
    results = []
    for t in trades:
        if t['type'] in ('buy', 'sell'):
            open_orders[t['ord']] = t
        elif t['type'] in ('close', 's/l', 't/p'):
            op = open_orders.get(t['ord'])
            if not op:
                continue
            sl_dist = abs(op['price'] - op['sl']) / 0.0001
            tp_dist = abs(op['price'] - op['tp']) / 0.0001
            if op['type'] == 'buy':
                r_achieved = (t['price'] - op['price']) / 0.0001 / sl_dist if sl_dist else 0
            else:
                r_achieved = (op['price'] - t['price']) / 0.0001 / sl_dist if sl_dist else 0
            results.append({
                'date': op['time'], 'ord': t['ord'],
                'sl_pips': sl_dist, 'rr': tp_dist / sl_dist if sl_dist else 0,
                'r': r_achieved, 'profit': t['profit'],
                'exit_type': t['type']
            })
    return results

a = parse(sys.argv[1])
b = parse(sys.argv[2])
da = {r['date'] + '|' + r['ord']: r for r in a}
db = {r['date'] + '|' + r['ord']: r for r in b}

print(f"{'#':>2} {'Fecha':<13} {'r2 R':>6} {'r4 R':>6} {'r2 PyG':>9} {'r4 PyG':>9} {'diff':>9}  nota")
all_keys = sorted(set(da) | set(db))
for i, k in enumerate(all_keys, 1):
    ra = da.get(k)
    rb = db.get(k)
    if ra and rb:
        diff = round(rb['profit'] - ra['profit'], 2)
        note = 'CHANGED' if abs(diff) > 0.5 else ''
        print(f"{i:>2} {k.split('|')[0]:<13} {ra['r']:>6.2f} {rb['r']:>6.2f} {ra['profit']:>9.2f} {rb['profit']:>9.2f} {diff:>9.2f}  {note}")
    elif ra:
        print(f"{i:>2} {k.split('|')[0]:<13} {ra['r']:>6.2f} {'':>6} {ra['profit']:>9.2f} {'':>9} {'':>9}  SOLO en v2_2")
    else:
        print(f"{i:>2} {k.split('|')[0]:<13} {'':>6} {rb['r']:>6.2f} {'':>9} {rb['profit']:>9.2f} {'':>9}  SOLO en v2_4")
