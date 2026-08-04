# Comparativa Backtesting: Asian Breakout

## Resumen de Versiones

| Versión | Fechas | Beneficio Neto | Factor Beneficio | Win Rate | Drawdown Máx | Operaciones | Ratio R:R |
| --------- | -------- | ---------------- | ------------------ | ---------- | -------------- | ------------- | ----------- |
| V1.0 | 2026.06.16 - 2026.07.31 | $1014.99 | 2.90 | 50.00% | 3.60% | 10 | 3.0 |
| V1.01 | 2026.06.16 - 2026.07.31 | $0.00 | N/A | 0.00% | 0.00% | 0 | 3.0 |
| V1.015 | 2026.06.16 - 2026.07.31 | $292.09 | 1.95 | 62.50% | 3.49% | 8 | 3.0 |
| V1.016 | 2026.06.16 - 2026.07.31 | $1014.57 | 2.90 | 50.00% | 3.55% | 10 | 3.0 |
| V1.03 | 2026.06.16 - 2026.07.31 | $181.10 | 1.45 | 33.33% | 4.15% | 6 | 3.0 |
| V2.0 | 2026.06.16 - 2026.07.31 | $667.28 | 1.59 | 35.29% | 8.39% | 17 | 3.0 |
| V2.5 | 2026.06.16 - 2026.07.31 | $667.28 | 1.59 | 35.29% | 8.39% | 17 | 3.0 |

---

## Detalles por Versión

### Asian Breakout V1.0

**Condiciones de Prueba:**

- **Símbolo:** EURUSD
- **Periodo:** M5 (Cada tick, 90% calidad)
- **Fechas:** 2026.06.16 - 2026.07.31
- **Spread:** 10

**Parámetros Destacados:**

- Lote Dinámico (1% riesgo)
- Días Operativos: Martes, Miércoles, Jueves (Lunes y Viernes desactivados)
- Ratio R:R: 3.0 (TP Fijo)
- Tamaño Caja: 10 a 50 pips
- Horario Asia: 02:00 a 08:00 (Fin de búsqueda: 23:00)
- SMC: Buscar liquidez en AMBOS sentidos
- Gestión: Trailing Stop (False), Auto Break-Even (False), Cierre Parcial (False)

**Resultados:**

- **Depósito Inicial:** $10,000.00
- **Beneficio Neto Total:** $1014.99 (Balance Final: $11,014.99)
- **Factor de Beneficio (Profit Factor):** 2.90
- **Drawdown Máximo:** 3.60% ($396.85)
- **Total de Transacciones:** 10
  - Ganadoras: 5 (50.00%)
  - Perdedoras: 5 (50.00%)

---

### Asian Breakout V1.01

**Condiciones de Prueba:**

- **Símbolo:** EURUSD
- **Periodo:** M5 (Cada tick, 90% calidad)
- **Fechas:** 2026.06.16 - 2026.07.31
- **Spread:** 10

**Parámetros Destacados:**

- Lote Dinámico (1% riesgo)
- Días Operativos: Martes, Miércoles, Jueves (Lunes y Viernes desactivados)
- Ratio R:R: 3.0 (TP Fijo)
- Tamaño Caja: 15 a 50 pips (Mínimo incrementado a 15)
- Stop Loss Mínimo: 15 pips (Incrementado)
- Margen Spread (pips extra): 8 (Incrementado)
- Horario Asia: 02:00 a 08:00 (Fin de búsqueda: 23:00)
- Filtro de Tendencia (EMA): **ACTIVADO** (H4, EMA 50 y EMA 200)
- Gestión: Auto Break-Even (**ACTIVADO** a los 15 pips)

**Resultados:**

- **Depósito Inicial:** $10,000.00
- **Beneficio Neto Total:** $0.00 (Balance Final: $10,000.00)
- **Total de Transacciones:** 0

*(Nota: Al añadir el filtro de tendencia en H4, junto con el aumento de pips extra de margen a 8, el tamaño mínimo de la caja a 15 y el SL mínimo a 15, el sistema se volvió demasiado restrictivo y filtró absolutamente todas las posibles entradas en este mes y medio).*

---

### Asian Breakout V1.015

**Condiciones de Prueba:**

- **Símbolo:** EURUSD
- **Periodo:** M5 (Cada tick, 90% calidad)
- **Fechas:** 2026.06.16 - 2026.07.31
- **Spread:** 10

**Parámetros Destacados:**

- Lote Dinámico (1% riesgo)
- Ratio R:R: 3.0 (TP Fijo)
- Tamaño Caja: 15 a 50 pips
- Stop Loss Mínimo: 15 pips
- Margen Spread (pips extra): 8
- Horario Asia: 02:00 a 08:00 (Cierre forzoso a las 13:00)
- Filtro de Tendencia (EMA): **ACTIVADO** (H4, EMA 50)
- Gestión: Trailing Stop (**ACTIVADO** - 15 pips), Auto Break-Even (**ACTIVADO** a los 15 pips)

**Resultados:**

- **Depósito Inicial:** $10,000.00
- **Beneficio Neto Total:** $292.09 (Balance Final: $10,292.09)
- **Factor de Beneficio (Profit Factor):** 1.95
- **Drawdown Máximo:** 3.49% ($368.13)
- **Total de Transacciones:** 8
  - Ganadoras: 5 (62.50%)
  - Perdedoras: 3 (37.50%)

*(Nota: En esta versión se observa una cantidad masiva de modificaciones de órdenes (modify) debido al Trailing Stop dinámico de 15 pips. El Win Rate mejora (62.50%) al asegurar operaciones, pero el Trailing "asfixia" algunas tendencias cortándolas antes de llegar al TP 1:3, resultando en un Beneficio Neto mucho menor ($292.09) comparado con las versiones sin trailing).*

---

### Asian Breakout V1.016

**Condiciones de Prueba:**

- **Símbolo:** EURUSD
- **Periodo:** M5 (Cada tick, 90% calidad)
- **Fechas:** 2026.06.16 - 2026.07.31
- **Spread:** 10

**Parámetros Destacados:**

- Lote Dinámico (1% riesgo)
- Días Operativos: Martes, Miércoles, Jueves (Lunes y Viernes desactivados)
- Ratio R:R: 3.0 (TP Fijo)
- Tamaño Caja: 10 a 50 pips
- Horario Asia: 02:00 a 08:00 (Fin de búsqueda: 23:00)
- SMC: Buscar liquidez en AMBOS sentidos
- Gestión: Trailing Stop (False), Auto Break-Even (False), Cierre Parcial (False)

**Resultados:**

- **Depósito Inicial:** $10,000.00
- **Beneficio Neto Total:** $1014.57 (Balance Final: $11,014.57)
- **Factor de Beneficio (Profit Factor):** 2.90
- **Drawdown Máximo:** 3.55% ($391.54)
- **Total de Transacciones:** 10
  - Ganadoras: 5 (50.00%)
  - Perdedoras: 5 (50.00%)

---

### Asian Breakout V1.03

**Condiciones de Prueba:**

- **Símbolo:** EURUSD
- **Periodo:** M5 (Cada tick, 90% calidad)
- **Fechas:** 2026.06.16 - 2026.07.31
- **Spread:** 10

**Parámetros Destacados:**

- Lote Dinámico (1% riesgo)
- Ratio R:R: 3.0 (TP Fijo)
- Tamaño Caja: 10 a 50 pips
- Gestión Clásica ("Purista"): Trailing Stop y Auto Break-Even **DESACTIVADOS**
- Stop Loss: **Dinámico por ATR** (M15, Período 14, Multiplicador 1.5x) + 3 pips extra (SL Mínimo: 5)
- Filtro de Noticias (Spikes): **ACTIVADO** (Bloqueo de 30 min si vela M15 > 2.5x ATR)
- Modo Liquidez Avanzado (SMC MTF): Mínimo cuerpo vela ruptura (2 pips), Máx velas fuera de caja (6 velas), Tiempo máx caducidad (120 min).

**Resultados:**

- **Depósito Inicial:** $10,000.00
- **Beneficio Neto Total:** $181.10 (Balance Final: $10,181.10)
- **Factor de Beneficio (Profit Factor):** 1.45
- **Drawdown Máximo:** 4.15% ($427.53)
- **Total de Transacciones:** 6
  - Ganadoras: 2 (33.33%)
  - Perdedoras: 4 (66.67%)

*(Nota: Esta versión vuelve al enfoque "purista" sin trailing ni break-even, pero introduce filtros muy sofisticados (SL por ATR, filtro de spikes y validación de liquidez avanzada). Como resultado, la cantidad de operaciones bajó a solo 6. El Win Rate cayó al 33.33% (se perdieron más de las que se ganaron), pero gracias a mantener el Take Profit intacto en un ratio 1:3, el sistema se mantiene rentable y termina en positivo, aunque con menos fuerza que la V1.0 original).*

---

### Asian Breakout V2.0

**Condiciones de Prueba:**

- **Símbolo:** EURUSD
- **Periodo:** M5 (Cada tick, 90% calidad)
- **Fechas:** 2026.06.16 - 2026.07.31
- **Spread:** 10

**Parámetros Destacados:**

- Lote Dinámico (1% riesgo)
- Ratio R:R: 3.0 (TP Fijo)
- Tamaño Caja: 10 a 50 pips
- Gestión: Trailing Stop y Break-Even **DESACTIVADOS**
- Horario de Caza (Ruptura): Extendido hasta las 23:00
- Filtro de Noticias (API): **ACTIVADO** (Bloquea operativas 30 min antes y después de Carpetas Rojas. Naranjas desactivado).
- Modo Liquidez Avanzado (SMC):
  - Mínimo cuerpo vela ruptura: 2 pips
  - Mínimo pips TOTALES vela entrada: 8.0 pips
  - Máx velas M5 fuera de caja antes de revertir: 36
  - Máx minutos absolutos para caducar: 240

**Resultados:**

- **Depósito Inicial:** $10,000.00
- **Beneficio Neto Total:** $667.28 (Balance Final: $10,667.28)
- **Factor de Beneficio (Profit Factor):** 1.59
- **Drawdown Máximo:** 8.39% ($889.00)
- **Total de Transacciones:** 17
  - Ganadoras: 6 (35.29%)
  - Perdedoras: 11 (64.71%)

*(Nota: Esta es la primera iteración de la rama V2.0. Al usar el Filtro de Noticias por API Real (evitando la ambigüedad del ATR) y, lo más importante, al dar muchísimo más margen de maniobra al precio para cazar liquidez (240 minutos / 36 velas fuera de caja), el sistema identificó muchas más oportunidades (17 trades). Aunque el Win Rate se mantiene alrededor del 35%, dejar que las 6 operaciones ganadoras toquen el TP de 1:3 catapulta el beneficio neto a $667.28. El Drawdown sube al 8.39%, pero la curva de equidad es marcadamente ascendente).*

---

### Asian Breakout V2.5

**Condiciones de Prueba:**

- **Símbolo:** EURUSD
- **Periodo:** M5 (Cada tick, 90% calidad)
- **Fechas:** 2026.06.16 - 2026.07.31
- **Spread:** 10

**Parámetros Destacados (Novedades respecto a V2.0):**

- Slippage Máximo: 3 puntos (NUEVO)
- Hora de corte diario: 23:00 (NUEVO)
- Cerrar operaciones a final del día (EOD): **DESACTIVADO** (NUEVO)
- *El resto de parámetros (Filtro API, SMC, R:R 3.0, sin Trailing) se mantienen idénticos a la V2.0.*

**Resultados:**

- **Depósito Inicial:** $10,000.00
- **Beneficio Neto Total:** $667.28 (Balance Final: $10,667.28)
- **Factor de Beneficio (Profit Factor):** 1.59
- **Drawdown Máximo:** 8.39% ($889.00)
- **Total de Transacciones:** 17
  - Ganadoras: 6 (35.29%)
  - Perdedoras: 11 (64.71%)

*(Nota: Los resultados de la V2.5 son **exactamente idénticos** a la V2.0 en este backtest. Esto ocurre porque las nuevas funciones (control de slippage y cierre EOD) no alteran las entradas, y como el cierre a final de día estaba desactivado (`false`), el comportamiento general es un calco de la V2.0. Sirve para confirmar que el núcleo de la estrategia sigue funcionando correctamente tras las actualizaciones de código).*
