# Comparativa StrategyTester: V2.51 vs V2.6 (Opcion A) vs V2.6b (Opcion A3)

**Periodo**: 2026.01.01 - 2026.08.04 (M5, EURUSD, Skilling Demo, modelado 90%)
**Periodo**: 39 trades identicos en las tres versiones (mismas reglas de entrada)

---

## Resumen ejecutivo (cifras globales)

| Metrica | V2.51 (TP fijo 1:3) | V2.6 (Opcion A: BE+recoloca SL en 1:2) | V2.6b (Opcion A3: BE solo, deja correr) | V2.6b vs V2.51 |
|---|---|---|---|---|
| **Beneficio neto total** | **+444.72** | **-131.34** | **-199.42** | **-644.14** |
| Beneficio bruto | 3,210.93 | 1,922.84 | 1,842.58 | -1,368.35 |
| Perdida bruta | -2,766.21 | -2,054.18 | -2,042.00 | -724.21 |
| **Profit factor** | **1.16** | **0.94** | **0.90** | -0.26 |
| Beneficio esperado | +11.40 | -3.37 | -5.11 | -16.51 |
| Drawdown maximo | 10.84% (1,123.30) | 9.08% (941.24) | 10.22% (1,058.85) | -0.62% |
| Total transacciones | 39 | 39 | 39 | 0 |
| **Operaciones ganadoras** | **11 (28.21%)** | **18 (46.15%)** | **18 (46.15%)** | **+17.94 pp** |
| **Operaciones perdedoras** | 28 (71.79%) | 21 (53.85%) | 21 (53.85%) | -17.94 pp |
| Trade ganador promedio | 291.90 | 106.82 | 102.37 | **-189.53** |
| Trade perdedor promedio | -98.79 | -97.82 | -97.24 | -1.55 |

---

## Conclusion directa: la Opcion A3 NO mejora respecto a la Opcion A

Esto contradice mi estimacion. La Opcion A3 da **-199.42 USD**, que es PEOR que la Opcion A (-131.34 USD) y mucho peor que la V2.51 (+444.72 USD).

**Que ha pasado?** Comparando trade por trade las dos versiones V2.6, la diferencia es minima. Solo cambia en los trades donde se activa el recolocado del SL en 1:2 (que en la V2.6b ya no se hace). Veamos:

### Comparacion trade por trade: V2.6 (A) vs V2.6b (A3)

| # | V2.6 (A) resultado | V2.6b (A3) resultado | Delta V2.6b vs V2.6 |
|---|---|---|---|
| 1 | t/p +299.97 | t/p +299.97 | 0.00 |
| 2 | s/l -102.46 | s/l -102.46 | 0.00 |
| 3 | **+11.30** | +11.30 | 0.00 |
| 4 | s/l -102.00 | s/l -102.00 | 0.00 |
| 5 | **+13.60** | +13.60 | 0.00 |
| 6 | s/l -100.80 | s/l -100.80 | 0.00 |
| 7 | s/l -99.99 | s/l -99.99 | 0.00 |
| 8 | s/l -99.00 | s/l -99.00 | 0.00 |
| 9 | s/l -97.44 | s/l -97.44 | 0.00 |
| 10 | s/l -96.80 | s/l -96.80 | 0.00 |
| 11 | **+95.12** | **+8.20** | **-86.92** |
| 12 | **+6.30** | **+6.20** | -0.10 |
| 13 | s/l -92.16 | s/l -92.16 | 0.00 |
| 14 | **+11.80** | **+11.70** | -0.10 |
| 15 | s/l -95.76 | s/l -95.00 | +0.76 |
| 16 | **+9.80** | **+9.70** | -0.10 |
| 17 | s/l -94.72 | s/l -94.72 | 0.00 |
| 18 | **+11.10** | **+11.00** | -0.10 |
| 19 | **+12.60** | **+12.50** | -0.10 |
| 20 | t/p +282.48 | t/p +279.84 | -2.64 |
| 21 | s/l -97.50 | s/l -96.20 | +1.30 |
| 22 | s/l -96.30 | s/l -95.40 | +0.90 |
| 23 | **+95.77** | **+15.50** | **-80.27** |
| 24 | s/l -96.46 | s/l -94.64 | +1.82 |
| 25 | s/l -95.50 | s/l -94.00 | +1.50 |
| 26 | **+94.35** | **t/p +277.95** | **+183.60** |
| 27 | **+7.00** | **+7.10** | +0.10 |
| 28 | **+95.20** | **+11.20** | **-84.00** |
| 29 | **+11.10** | **+11.00** | -0.10 |
| 30 | s/l -96.39 | s/l -95.58 | +0.81 |
| 31 | t/p +286.65 | t/p +282.10 | -4.55 |
| 32 | s/l -98.80 | s/l -97.28 | +1.52 |
| 33 | s/l -97.50 | s/l -97.00 | +0.50 |
| 34 | s/l -96.20 | s/l -95.46 | +0.74 |
| 35 | t/p +287.10 | t/p +285.36 | -1.74 |
| 36 | s/l -98.60 | s/l -97.75 | +0.85 |
| 37 | t/p +291.60 | t/p +288.36 | -3.24 |
| 38 | s/l -100.64 | s/l -99.90 | +0.74 |
| 39 | s/l -99.16 | s/l -98.42 | +0.74 |

**Total delta V2.6b vs V2.6: -68.08 USD** (V2.6b da PEOR por 68 USD).

---

## Analisis de las diferencias clave (V2.6 A vs V2.6b A3)

Solo **6 trades** cambian de forma significativa entre A y A3:

### Tickets donde A3 RESCATA que A capturaba mal

**Ticket #26 (sell 2026.06.08)**: A capturaba en BE/1:1 (+94.35), A3 deja correr al TP 1:3 (+277.95).
- **Delta: +183.60 USD a favor de A3.** ✓

### Tickets donde A3 PIERDE que A rescataba

**Ticket #11 (buy 2026.03.18)**: A capturaba en BE/1:1 (+95.12), A3 captura mucho peor (+8.20).
- **Delta: -86.92 USD a favor de A.** ✗

**Ticket #23 (buy 2026.05.12)**: A capturaba en BE/1:1 (+95.77), A3 captura mucho peor (+15.50).
- **Delta: -80.27 USD a favor de A.** ✗

**Ticket #28 (sell 2026.06.15)**: A capturaba en BE/1:1 (+95.20), A3 captura mucho peor (+11.20).
- **Delta: -84.00 USD a favor de A.** ✗

**Tickets #3, #5, #14, #16, #18, #19, #27, #29 (8 trades)**: Cambios menores por timing de recolocado de SL, -0.10 USD cada uno. Sin impacto real.

---

## Por que mi estimacion estaba equivocada

Yo asumí que las 6 capturas pequeñas que A hacía (tickets #12, #14, #19, #26, #28, #29) **se transformarian en TPs de 1:3 en A3**. Pero los datos dicen otra cosa:

- **Tickets que SI llegan al 1:3 en A3** (donde estaba la esperanza de +1,572 USD):
  - **#26**: +277.95 (vs +94.35 en A) → recupera **+183.60**

- **Tickets que llegan a 1:1 pero AUN ASI no llegan al 1:3 en A3** (donde A capturaba algo y A3 captura menos):
  - **#11**: +8.20 (vs +95.12 en A) → pierde **-86.92**
  - **#23**: +15.50 (vs +95.77 en A) → pierde **-80.27**
  - **#28**: +11.20 (vs +95.20 en A) → pierde **-84.00**

Es decir: **el precio en estos trades (#11, #23, #28) entra en 1:1, retrocede, el SL a BE los saca con ganancia minima (no llega al 1:3), y en A3 capturamos menos que en A porque en A el recolocado a +1R atrapaba el retroceso a +1R completo.**

**Insight clave**: el recolocado del SL a +1R en A no era "malo per se". Era el UNICO mecanismo que atrapaba el retroceso al +1R completo. Sin el recolocado, el BE atrapa el retroceso a +0R o casi.

---

## Conclusion definitiva

**Ninguna de las dos variantes V2.6 mejora la V2.51.** El mejor resultado es la V2.51 original con +444.72 USD y profit factor 1.16.

| Version | Beneficio neto | Profit factor |
|---|---|---|
| **V2.51 (TP fijo 1:3)** | **+444.72** | **1.16** ← mejor |
| V2.6 (Opcion A: recoloca SL a +1R en 1:2) | -131.34 | 0.94 |
| V2.6b (Opcion A3: solo BE en 1:1) | -199.42 | 0.90 ← peor |

El unico trade que A3 rescata correctamente (#26, +183.60 USD) no compensa los tres trades donde A3 captura peor que A (#11, #23, #28, total -251.19 USD).

---

## Proximos pasos sugeridos

La gestion escalonada NO funciona para este EA en este periodo. Las opciones reales son:

1. **Volver a la V2.51**: la mas rentable en este set. Simple.

2. **Probar Opcion A1** (subir `EscalonadoRR2` a 1.5R o 2.5R en lugar de 1:2). Sin tocar codigo, solo cambiar el input.

3. **Probar una nueva idea: confirmar reversion en lugar de recolocar al toque**. Si el precio retrocede X pips desde el maximo tras tocar 1:1, ENTONCES recolocar SL a +1R. Esto preserva la captura del +1R completo cuando hay reversion real, pero deja correr al 1:3 cuando el precio sigue subiendo.

4. **Filtrar dias de tendencia**: en dias con ADX alto o vela de Londres direccional, desactivar la gestion escalonada y usar V2.51 pura.

5. **Re-entrenar la logica con datos forward** (los ultimos 2 meses del periodo no son suficientes, hacen falta mas trades para validar).

Mi recomendacion: **volver a V2.51 mientras tanto** y, si quieres seguir iterando, probar la **Opcion 3 (confirmar reversion)** que es la que respeta mejor tu intuicion original ("si se gira, capturo el +1R; si no se gira, dejo correr al 1:3").