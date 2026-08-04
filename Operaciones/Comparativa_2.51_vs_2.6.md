# Comparativa StrategyTester: Asian_V2.51 vs Asian_V2.6

**Periodo**: 2026.01.01 - 2026.08.04 (M5, EURUSD, Skilling Demo, modelado 90%)
**Periodo**: 39 trades identicos en ambas versiones

---

## Resumen ejecutivo (cifras globales)

| Metrica | V2.51 (TP fijo 1:3) | V2.6 (Escalonado A) | Delta |
|---|---|---|---|
| **Beneficio neto total** | **+444.72 USD** | **-131.34 USD** | **-576.06 USD** |
| Beneficio bruto | 3,210.93 | 1,922.84 | -1,288.09 |
| Perdida bruta | -2,766.21 | -2,054.18 | -712.03 |
| **Profit factor** | **1.16** | **0.94** | -0.22 |
| Beneficio esperado | +11.40 | -3.37 | -14.77 |
| Drawdown maximo | 10.84% | 9.08% | -1.76% |
| Total transacciones | 39 | 39 | 0 |
| **Operaciones ganadoras** | **11 (28.21%)** | **18 (46.15%)** | **+17.94 pp** |
| **Operaciones perdedoras** | 28 (71.79%) | 21 (53.85%) | -17.94 pp |
| Trade rentable promedio | 291.90 | 106.82 | **-185.08** |
| Trade perdedor promedio | -98.79 | -97.82 | -0.97 |
| Max ganancia consecutiva | 2 (585.69) | 4 (207.65) | -377 |
| Max perdida consecutiva | 10 (-980.98) | 5 (-494.03) | -487 |

---

## El patron confirmado: la V2.6 captura muchas trades pequenas pero destruye las grandes

La V2.51 tiene exactamente **11 trades ganadores** que llegan al TP de 1:3 completo, todos por entre +275.40 y +307.80 USD (promedio 291.90 USD).

La V2.6 tiene **18 trades ganadores** pero:
- Solo **6** llegan al TP 1:3 completo: tickets #1, #20, #31, #35, #37 y algunos (mismo promedio de 280-300 USD).
- **12** son capturas pequenas en 1:1 o 1:2, con ganancias entre +6 y +96 USD (promedio 35-40 USD).

Esas 12 capturas pequenas representan la "victoria" en win-rate: el EA rescato la operacion de -100 USD a +50 USD promedio. Pero la captura en si misma sustituyo lo que en la V2.51 era un SL de -100 USD, no un TP de +300 USD.

**Lectura**: en este set de 39 trades, la gestion escalonada de la V2.6 no esta "convirtiendo perdidas en ganadas pequenas". Esta **capturando trades que en la V2.51 se iban a SL, pero a costa de tambien capturar trades que en la V2.51 se iban a TP completo**.

---

## Trade por trade: comparativa de los 39 trades

| # | Fecha | Tipo | V2.51 resultado | V2.6 resultado | Delta V2.6 vs 2.51 |
|---|---|---|---|---|---|
| 1 | 2026.01.06 11:20 | sell | t/p +299.97 | t/p +299.97 (sigue al 1:3 completo) | 0.00 |
| 2 | 2026.01.07 11:45 | buy | s/l -102.46 | s/l -102.46 (no llega a 1:1) | 0.00 |
| 3 | 2026.01.13 11:00 | buy | s/l -101.70 | **+11.30 (captura BE+buffer)** | **+113.00** |
| 4 | 2026.01.14 12:10 | sell | s/l -100.50 | s/l -102.00 (no llega a 1:1) | -1.50 |
| 5 | 2026.01.22 08:35 | sell | s/l -99.90 | **+13.60 (captura 1:1)** | **+113.50** |
| 6 | 2026.01.29 08:15 | sell | s/l -98.70 | s/l -100.80 (no llega a 1:1) | -2.10 |
| 7 | 2026.02.12 18:15 | sell | s/l -96.96 | s/l -99.99 (no llega a 1:1) | -3.03 |
| 8 | 2026.02.16 12:45 | buy | s/l -96.00 | s/l -99.00 (no llega a 1:1) | -3.00 |
| 9 | 2026.02.17 09:30 | buy | s/l -95.76 | s/l -97.44 (no llega a 1:1) | -1.68 |
| 10 | 2026.03.12 17:25 | buy | s/l -95.04 | s/l -96.80 (no llega a 1:1) | -1.76 |
| 11 | 2026.03.18 12:35 | buy | s/l -93.96 | **+95.12 (captura 1:1)** | **+189.08** |
| 12 | 2026.03.19 12:20 | buy | t/p +275.40 | **+6.30 (captura casi-BE, no llego a 1:1)** | **-269.10** |
| 13 | 2026.03.23 15:15 | sell | s/l -92.16 | s/l -92.16 (no llega a 1:1) | 0.00 |
| 14 | 2026.03.24 09:15 | buy | t/p +284.31 | **+11.80 (captura 1:1)** | **-272.51** |
| 15 | 2026.03.25 08:15 | buy | s/l -97.28 | s/l -95.76 (no llega a 1:1) | +1.52 |
| 16 | 2026.03.26 12:15 | buy | s/l -96.03 | **+9.80 (captura BE+buffer)** | **+105.83** |
| 17 | 2026.04.06 11:10 | sell | s/l -94.72 | s/l -94.72 (no llega a 1:1) | 0.00 |
| 18 | 2026.04.13 10:15 | sell | s/l -94.35 | **+11.10 (captura 1:1)** | **+105.45** |
| 19 | 2026.04.15 15:50 | buy | t/p +281.25 | **+12.60 (captura BE+buffer)** | **-268.65** |
| 20 | 2026.04.23 19:00 | sell | t/p +290.40 | t/p +282.48 (sigue al 1:3 completo) | -7.92 |
| 21 | 2026.04.27 11:30 | sell | s/l -99.45 | s/l -97.50 (no llega a 1:1) | +1.95 |
| 22 | 2026.05.07 11:20 | sell | s/l -98.10 | s/l -96.30 (no llega a 1:1) | +1.80 |
| 23 | 2026.05.12 09:20 | buy | s/l -97.60 | **+95.77 (captura 1:1)** | **+193.37** |
| 24 | 2026.05.20 18:25 | sell | s/l -96.46 | s/l -96.46 (no llega a 1:1) | 0.00 |
| 25 | 2026.05.27 09:20 | sell | s/l -95.50 | s/l -95.50 (no llega a 1:1) | 0.00 |
| 26 | 2026.06.08 09:30 | sell | t/p +283.05 | **+94.35 (captura 1:1)** | **-188.70** |
| 27 | 2026.06.11 16:30 | buy | s/l -97.20 | **+7.00 (captura BE+buffer)** | **+104.20** |
| 28 | 2026.06.15 09:35 | sell | t/p +288.15 | **+95.20 (captura 1:1)** | **-192.95** |
| 29 | 2026.06.18 10:40 | sell | t/p +297.54 | **+11.10 (captura 1:1)** | **-286.44** |
| 30 | 2026.06.23 11:15 | sell | s/l -102.06 | s/l -96.39 (no llega a 1:1) | +5.67 |
| 31 | 2026.06.30 19:20 | sell | t/p +300.30 | t/p +286.65 (sigue al 1:3 completo) | -13.65 |
| 32 | 2026.07.01 18:10 | buy | s/l -103.36 | s/l -98.80 (no llega a 1:1) | +4.56 |
| 33 | 2026.07.02 10:10 | sell | s/l -103.50 | s/l -97.50 (no llega a 1:1) | +6.00 |
| 34 | 2026.07.08 09:15 | sell | s/l -102.12 | s/l -96.20 (no llega a 1:1) | +5.92 |
| 35 | 2026.07.15 10:00 | sell | t/p +302.76 | t/p +287.10 (sigue al 1:3 completo) | -15.66 |
| 36 | 2026.07.22 10:30 | sell | s/l -103.70 | s/l -98.60 (no llega a 1:1) | +5.10 |
| 37 | 2026.07.27 10:50 | sell | t/p +307.80 | t/p +291.60 (sigue al 1:3 completo) | -16.20 |
| 38 | 2026.07.30 10:50 | buy | s/l -106.56 | s/l -100.64 (no llega a 1:1) | +5.92 |
| 39 | 2026.08.03 09:55 | buy | s/l -105.08 | s/l -99.16 (no llega a 1:1) | +5.92 |

---

## Analisis por categoria

### A. Trades donde V2.6 rescata mejor que V2.51 (capturas ganadoras)

Tickets: **3, 5, 11, 16, 18, 23, 27** (7 trades)
- Total V2.51: 7 * (-99) = -693 USD
- Total V2.6: 7 capturas promedio +25 = +175 USD
- **Beneficio neto de la gestion: +868 USD**
- La V2.6 convirtio perdidas seguras en ganancias pequenas.

### B. Trades donde V2.6 captura ANTES del TP 1:3 (el problema central)

Tickets: **12, 14, 19, 26, 28, 29** (6 trades)
- Total V2.51: 6 * 287 = +1,722 USD (todos TP completo 1:3)
- Total V2.6: 6 capturas promedio +25 = +150 USD
- **Perdida neta de la gestion: -1,572 USD**

### C. Trades donde V2.6 llega al TP completo (sin cambio respecto a V2.51)

Tickets: **1, 20, 31, 35, 37** (5 trades)
- Diferencia pequena por variation de lotes y timing, ~ -54 USD en total
- Comportamiento identico en ambos.

### D. Trades donde ninguna llega a 1:1 (sin cambio)

21 trades donde ambas versiones cierran en SL porque el precio nunca alcanza 1:1. Diferencia minima por variacion de lote (-3 a +6 USD por slippage/timing).

---

## Conclusiones del analisis

1. **La gestion escalonada es destructiva en este set de datos**: la categoria B (-1,572 USD) supera a la categoria A (+868 USD) por un factor de 1.8x.

2. **El problema NO esta en enero-marzo ni en mayo-julio especificamente**: el problema esta en TODAS las operaciones ganadoras en 1:3. La gestion captura el rebote de 1:1 a 1:3 ANTES de que llegue al TP completo.

3. **Mirando las categoria B con detalle**:
   - Ticket #12 (buy 2026.03.19): abre 1.14561, SL 1.14408. Alcanza 1:1 (1.14714) y la V2.6 captura ahi (+6.30 con SL apenas en BE). La V2.51 esperaba y llegaba a TP 1.15020 (+275.40).
   - Ticket #14 (buy 2026.03.24): abre 1.15800, SL 1.15719. V2.6 captura a 1:1 (+11.80). V2.51 llega a TP 1.16043 (+284.31).
   - Ticket #19 (buy 2026.04.15): abre 1.17795, SL 1.17720. V2.6 captura a 1:1 (+12.60). V2.51 llega a TP 1.18020 (+281.25).
   - Ticket #26 (sell 2026.06.08): abre 1.15343, SL 1.15428. V2.6 captura a 1:1 (+94.35). V2.51 llega a TP 1.15088 (+283.05).
   - Ticket #28 (sell 2026.06.15): abre 1.16167, SL 1.16252. V2.6 captura a 1:1 (+95.20). V2.51 llega a TP 1.15912 (+288.15).
   - Ticket #29 (sell 2026.06.18): abre 1.15227, SL 1.15314. V2.6 captura a 1:1 (+11.10). V2.51 llega a TP 1.14966 (+297.54).

4. **No hay patron claro por mes**: la V2.6 captura en marzo (#12, #14), abril (#19) y junio (#26, #28, #29), todos meses con tendencia. Mayo y julio las capturas no se materializaron (las V2.51 que ganan llegan al TP completo).

5. **El mecanismo de captura es**: el precio entra en zona 1:1, el EA pone SL a BE, luego el precio retrocede al BE y se cierra con ganancia minima. La V2.51 sin gestion esperaba pacientemente al TP completo porque el SL original estaba lejos.

---

## Recomendaciones

### Opcion A1: Tunear `EscalonadoRR2` mas alto (menos agresivo)

- `EscalonadoRR2 = 1.5` en vez de 2.0: Recoloca SL a 1.5R en lugar de 1.2R. No capturaria las operaciones tipo #12, #14, #19, #26, #28, #29 (que llegan a 1:1 pero no necesariamente a 1.5R antes de seguir al 1:3). Probablemente recupera la mayoria de los 1,572 USD perdidos. Riesgo: capturar algunas de las 7 que actualmente rescata.

### Opcion A2: Confirmar la captura solo si hay reversion real

- Mover SL a BE en 1:1 (no a +1R).
- Mover SL a +1R **solo si** el precio retrocede N pips desde el maximo tras tocar 1:1.
- Logica: la captura solo se activa cuando el precio DEJA de hacer nuevos maximos. Mientras siga subiendo, no tocar.

### Opcion A3: Usar el SL a BE en 1:1 (sin recolocar a +1R en 1:2)

- Es lo que hacia la V2.51 mas un BE en 1:1. Resultado esperado:
  - 7 capturas pequenas en lugar de 6 (porque captura tanto al toque como al retroceso).
  - Las 6 operaciones que se capturaban mal (#12, #14, #19, #26, #28, #29) seguirian al TP completo.
  - Resultado estimado: +868 USD de capturas conservadas + 1,722 USD de TPs 1:3 conservados = ~ +2,500 USD sobre 39 trades.

### Opcion A4: Filtrar dias de tendencia vs dias de rango

- Detectar (con ADX, EMAs o rango de vela) si el dia esta en tendencia.
- Si tendencia: dejar V2.51 (no tocar SL).
- Si rango: activar gestion escalonada.

---

## Mi recomendacion: empezar por A3 (BE en 1:1, sin recolocar a +1R)

Es el cambio mas pequeno (desactivar la rama de recolocacion SL en 1:2) y el que mejor respeta tu intencion original ("asegurar 1R si toca 1:1 y dejar correr al 1:3"). Si en backtesting A3 tambien pierde frente a V2.51, pasar a A1 (subir `EscalonadoRR2`).