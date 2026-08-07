import struct
import sys
import datetime
import numpy as np

HST = r'C:\Program Files (x86)\Skilling MT4 Terminal\history\SkillingLimited-Demo\EURUSD5.hst'

def read_hst(path):
    with open(path, 'rb') as f:
        data = f.read()
    ver, = struct.unpack_from('<i', data, 0)
    period, = struct.unpack_from('<i', data, 80)
    digits, = struct.unpack_from('<i', data, 84)
    n = (len(data) - 148) // 44
    arr = np.frombuffer(data, dtype=np.dtype([
        ('t', '<i8'), ('open', '<f8'), ('low', '<f8'),
        ('high', '<f8'), ('close', '<f8'), ('vol', '<i4')
    ]), count=n, offset=148)
    # MT4 stores open,low,high,close in that order in RateInfo
    # Filtrar registros corruptos (sentinelas/trailing garbage)
    ok = (arr['t'] > datetime.datetime(1990, 1, 1).timestamp()) & \
         (arr['t'] < datetime.datetime(2035, 1, 1).timestamp())
    arr = arr[ok]
    return arr, period, digits

if __name__ == '__main__':
    arr, period, digits = read_hst(HST)
    print(f'period={period} digits={digits} bars={len(arr)}')
    print('range:', datetime.datetime.utcfromtimestamp(int(arr['t'][0])), '->',
          datetime.datetime.utcfromtimestamp(int(arr['t'][-1])))
    # Show bars around 2026.01.12
    start = np.searchsorted(arr['t'], datetime.datetime(2026, 1, 12, 0, 0).timestamp())
    for i in range(start, start + 5):
        r = arr[i]
        print(i, datetime.datetime.utcfromtimestamp(int(r['t'])), r['open'], r['low'], r['high'], r['close'], r['vol'])
