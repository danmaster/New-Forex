# Plantilla para Comparativa: V2.51 vs V2.6 vs V2.61

> **Como usar:** renombrar este archivo a `Comparativa_2.51_vs_2.6_vs_2.61.md` despues de correr el Strategy Tester de `Asian_V2.61.mq4` sobre el mismo periodo (2026.01.01 - 2026.08.04, EURUSD, M5, 90% modeling) y pegar los numeros abajo.

---

## Resumen ejecutivo (cifras globales)

| Metrica | V2.51 (TP fijo 1:3) | V2.6 (Escalonado A) | V2.61 (Fix A1+A2) | V2.61 vs V2.51 |
|---|---|---|---|---|
| **Beneficio neto total** | +444.72 USD | -131.34 USD | **___ USD** | ___ |
| Beneficio bruto | 3,210.93 | 1,922.84 | ___ | ___ |
| Perdida bruta | -2,766.21 | -2,054.18 | ___ | ___ |
| **Profit factor** | 1.16 | 0.94 | **___** | ___ |
| Beneficio esperado | +11.40 | -3.37 | ___ | ___ |
| Drawdown maximo | 10.84% | 9.08% | ___ % | ___ pp |
| Total transacciones | 39 | 39 | 39 | 0 |
| **Operaciones ganadoras** | 11 (28.21%) | 18 (46.15%) | ___ (___%) | ___ pp |
| Operaciones perdedoras | 28 (71.79%) | 21 (53.85%) | ___ (___%) | ___ pp |
| Trade ganador promedio | +291.90 | +106.82 | ___ | ___ |
| Trade perdedor promedio | -98.79 | -97.82 | ___ | ___ |
| Max ganancia consecutiva | 2 (585.69) | 4 (207.65) | ___ (___) | ___ |
| Max perdida consecutiva | 10 (-980.98) | 5 (-494.03) | ___ (___) | ___ |

---

## Prediccion teorica pre-backtest

Si Fix A2 funciona segun el analisis del 2026-08-04:

- **Categoria A** (7 trades rescatados: #3, #5, #11, #16, #18, #23, #27): V2.61 deberia seguir rescatandolos via BE en 1:1 → ~+175 USD.
- **Categoria B** (6 trades cortados en V2.6: #12, #14, #19, #26, #28, #29): V2.61 deberia **dejarlos correr** al TP 1:3 → recuperacion esperada ~+1,572 USD.
- **Categoria C** (5 trades que tocan TP en ambos: #1, #20, #31, #35, #37): V2.61 igual, ~+1,435 USD.
- **Categoria D** (21 trades muertos en SL): V2.61 igual, ~-2,073 USD.

**Total V2.61 esperado**: ~+1,100 USD sobre los 39 trades (rango +800 a +1,250).
**Mejora vs V2.51 (+444.72): +650 a +800 USD adicionales**.

---

## Trade por trade: comparativa de los 39 trades

| # | Fecha | Tipo | V2.51 | V2.6 | V2.61 | Delta V2.61 vs V2.51 |
|---|---|---|---|---|---|---|
| 1 | 2026.01.06 11:20 | sell | t/p +299.97 | t/p +299.97 | ___ | ___ |
| 2 | 2026.01.07 11:45 | buy | s/l -102.46 | s/l -102.46 | ___ | ___ |
| 3 | 2026.01.13 11:00 | buy | s/l -101.70 | +11.30 | ___ | ___ |
| 4 | 2026.01.14 12:10 | sell | s/l -100.50 | s/l -102.00 | ___ | ___ |
| 5 | 2026.01.22 08:35 | sell | s/l -99.90 | +13.60 | ___ | ___ |
| 6 | 2026.01.29 08:15 | sell | s/l -98.70 | s/l -100.80 | ___ | ___ |
| 7 | 2026.02.12 18:15 | sell | s/l -96.96 | s/l -99.99 | ___ | ___ |
| 8 | 2026.02.16 12:45 | buy | s/l -96.00 | s/l -99.00 | ___ | ___ |
| 9 | 2026.02.17 09:30 | buy | s/l -95.76 | s/l -97.44 | ___ | ___ |
| 10 | 2026.03.12 17:25 | buy | s/l -95.04 | s/l -96.80 | ___ | ___ |
| 11 | 2026.03.18 12:35 | buy | s/l -93.96 | +95.12 | ___ | ___ |
| 12 | 2026.03.19 12:20 | buy | t/p +275.40 | +6.30 | ___ | ___ |
| 13 | 2026.03.23 15:15 | sell | s/l -92.16 | s/l -92.16 | ___ | ___ |
| 14 | 2026.03.24 09:15 | buy | t/p +284.31 | +11.80 | ___ | ___ |
| 15 | 2026.03.25 08:15 | buy | s/l -97.28 | s/l -95.76 | ___ | ___ |
| 16 | 2026.03.26 12:15 | buy | s/l -96.03 | +9.80 | ___ | ___ |
| 17 | 2026.04.06 11:10 | sell | s/l -94.72 | s/l -94.72 | ___ | ___ |
| 18 | 2026.04.13 10:15 | sell | s/l -94.35 | +11.10 | ___ | ___ |
| 19 | 2026.04.15 15:50 | buy | t/p +281.25 | +12.60 | ___ | ___ |
| 20 | 2026.04.23 19:00 | sell | t/p +290.40 | t/p +282.48 | ___ | ___ |
| 21 | 2026.04.27 11:30 | sell | s/l -99.45 | s/l -97.50 | ___ | ___ |
| 22 | 2026.05.07 11:20 | sell | s/l -98.10 | s/l -96.30 | ___ | ___ |
| 23 | 2026.05.12 09:20 | buy | s/l -97.60 | +95.77 | ___ | ___ |
| 24 | 2026.05.20 18:25 | sell | s/l -96.46 | s/l -96.46 | ___ | ___ |
| 25 | 2026.05.27 09:20 | sell | s/l -95.50 | s/l -95.50 | ___ | ___ |
| 26 | 2026.06.08 09:30 | sell | t/p +283.05 | +94.35 | ___ | ___ |
| 27 | 2026.06.11 16:30 | buy | s/l -97.20 | +7.00 | ___ | ___ |
| 28 | 2026.06.15 09:35 | sell | t/p +288.15 | +95.20 | ___ | ___ |
| 29 | 2026.06.18 10:40 | sell | t/p +297.54 | +11.10 | ___ | ___ |
| 30 | 2026.06.23 11:15 | sell | s/l -102.06 | s/l -96.39 | ___ | ___ |
| 31 | 2026.06.30 19:20 | sell | t/p +300.30 | t/p +286.65 | ___ | ___ |
| 32 | 2026.07.01 18:10 | buy | s/l -103.36 | s/l -98.80 | ___ | ___ |
| 33 | 2026.07.02 10:10 | sell | s/l -103.50 | s/l -97.50 | ___ | ___ |
| 34 | 2026.07.08 09:15 | sell | s/l -102.12 | s/l -96.20 | ___ | ___ |
| 35 | 2026.07.15 10:00 | sell | t/p +302.76 | t/p +287.10 | ___ | ___ |
| 36 | 2026.07.22 10:30 | sell | s/l -103.70 | s/l -98.60 | ___ | ___ |
| 37 | 2026.07.27 10:50 | sell | t/p +307.80 | t/p +291.60 | ___ | ___ |
| 38 | 2026.07.30 10:50 | buy | s/l -106.56 | s/l -100.64 | ___ | ___ |
| 39 | 2026.08.03 09:55 | buy | s/l -105.08 | s/l -99.16 | ___ | ___ |

---

## Notas para el operador

- Si el total real **supera +800 USD**, V2.61 es el nuevo candidato de produccion.
- Si esta en **+400 a +800 USD**, sigue siendo bueno, intentar tunear `EscalonadoPullbackPips` (rango util 0.3 a 0.8).
- Si esta **por debajo de V2.51**, volver a V2.51 y conservar V2.61 como archivo historico (no desplegar).
