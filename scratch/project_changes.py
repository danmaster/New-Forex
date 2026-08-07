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
            'vol': float(cells[4]) if cells[4] else 0,
            'price': float(cells[5]) if cells[5] else 0,
            'sl': float(cells[6]) if cells[6] else 0,
            'tp': float(cells[7]) if cells[7] else 0,
            'profit': float(cells[8]) if cells[8] else 0,
        })
    return trades

def proj(path, be_lock_rr=0.5, pause_streak=2, cooldown_days=30, lookback_days=60):
    trades = parse(path)
    open_orders = {}
    closed = []  # (open_time_dt, dir, entry, sl, tp, vol, profit, exit_r, close_kind)
    for t in trades:
        if t['type'] in ('buy', 'sell'):
            open_orders[t['ord']] = t
        elif t['type'] in ('close', 's/l', 't/p'):
            op = open_orders.get(t['ord'])
            if not op:
                continue
            m = re.match(r'(\d{4})\.(\d{2})\.(\d{2}) (\d{2}):(\d{2})', op['time'])
            dt = datetime.datetime(*[int(x) for x in m.groups()])
            sl_dist = abs(op['price'] - op['sl']) / 0.0001
            if op['type'] == 'buy':
                r = (t['price'] - op['price']) / 0.0001 / sl_dist
            else:
                r = (op['price'] - t['price']) / 0.0001 / sl_dist
            if t['type'] == 't/p':
                kind = 'TP'
            elif t['type'] == 's/l':
                kind = 'SL'
            elif r < 0.2:
                kind = 'BE'
            elif r < 0.7:
                kind = 'PARC'
            else:
                kind = '1R'
            closed.append({'dt': dt, 'dir': op['type'], 'entry': op['price'],
                           'sl': op['sl'], 'tp': op['tp'], 'vol': op['vol'],
                           'profit': t['profit'], 'r': r, 'kind': kind})

    # USD por punto-lote aproximado a partir del propio trade (5 digitos: 1 pip = 0.0001)
    # Usamos: usd_per_pip_lot = profit / (pips * lots) para calibrar $ por pip/lot
    calib = []
    for c in closed:
        if c['vol'] > 0:
            pips = abs(c['profit']) / (c['vol'] * 10)  # 1 lote * 1 pip ~ $10 en EURUSD; calibrar:
    # mejor: inferir del primer trade
    c0 = closed[0]
    pips0 = abs(c0['entry'] - c0['sl']) / 0.0001
    usd_per_pip_lot = abs(c0['profit']) / (pips0 * c0['vol'])

    # Recalcular profit con BE lock 0.5R para los trades tipo 'BE' (peaks 1.0-1.3R)
    out = []
    for c in closed:
        p = c['profit']
        kind = c['kind']
        if kind == 'BE':
            p_new = be_lock_rr * (abs(c['entry'] - c['sl']) / 0.0001) * c['vol'] * usd_per_pip_lot
            out.append({**c, 'profit_new': p_new, 'r_new': be_lock_rr, 'kind_new': 'BE%.1f' % be_lock_rr})
        else:
            out.append({**c, 'profit_new': p, 'r_new': c['r'], 'kind_new': kind})

    # Aplicar pausa por racha (contador en memoria + cooldown fijo)
    streak = 0
    paused_until = None
    final = []
    for c in out:
        if paused_until is not None and c['dt'] < paused_until:
            final.append({'dt': c['dt'], 'skipped': True})
            continue
        final.append({**c, 'skipped': False})
        if c['profit_new'] < 0:
            streak += 1
            if pause_streak > 0 and streak >= pause_streak:
                paused_until = c['dt'] + datetime.timedelta(days=cooldown_days)
                streak = 0
        else:
            streak = 0

    active = [f for f in final if not f['skipped']]
    wins = [f for f in active if f['profit_new'] > 0]
    losses = [f for f in active if f['profit_new'] <= 0]
    net = sum(f['profit_new'] for f in active)
    skipped = [f for f in final if f['skipped']]
    gross_w = sum(f['profit_new'] for f in wins)
    gross_l = -sum(f['profit_new'] for f in losses)
    return {
        'total': len(active), 'wins': len(wins), 'losses': len(losses),
        'net': net, 'pf': gross_w / gross_l if gross_l else float('inf'),
        'skipped_pnl': sum(0 for _ in skipped),  # lo que se evito
        'skipped_list': [f['dt'] for f in skipped],
        'winrate': len(wins) / len(active) * 100 if active else 0,
    }

if __name__ == '__main__':
    for rep in [r'Operaciones\Asian_V2.70_2.htm', r'Operaciones\Asian_V2.70_3.htm']:
        print('=' * 70)
        print(rep)
        base = proj(rep, be_lock_rr=0.1, pause_streak=0, cooldown_days=14)
        a = proj(rep, be_lock_rr=0.5, pause_streak=0, cooldown_days=14)
        b14 = proj(rep, be_lock_rr=0.5, pause_streak=2, cooldown_days=14)
        b30 = proj(rep, be_lock_rr=0.5, pause_streak=2, cooldown_days=30)
        for name, r in [('BASELINE (BE0.1, sin pausa)', base),
                        ('A: BE lock 0.5R', a),
                        ('A+B: BE0.5 + racha=2, cooldown 14', b14),
                        ('A+B: BE0.5 + racha=2, cooldown 30', b30)]:
            print(f"  {name:<40} trades={r['total']:>2} W={r['wins']:>2} L={r['losses']:>2} "
                  f"wr={r['winrate']:>5.1f}% net={r['net']:>8.2f} PF={r['pf']:>5.2f} "
                  f"skipped={[d.strftime('%d.%m') for d in r['skipped_list']]}")
