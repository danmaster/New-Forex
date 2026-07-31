# Manual del Expert Advisor: Asian Breakout V1.03 (ATR & Protection Filters)

Este documento detalla las características, lógica interna y parámetros del robot de trading `asian_breakout_V1.03.mq4`.

---

## 1. Novedades y Optimizaciones de la Versión 1.03

La V1.03 incluye mejoras defensivas e institucionales diseñadas para evitar ser cazados por barridos de liquidez, ruido de sesión tarde y picos de noticias macroeconómicas:

1. **Ventana de Operativa Restringida a Londres (`MaxTradeHour = 12`):**
   * El EA únicamente escanea y ejecuta entradas entre las **08:00 y las 12:00 hora servidor** (Apertura de Londres).
   * Elimina cualquier operación fantasma o tardía por la tarde en la sesión de Nueva York.

2. **Gatillo de Reversión Estricto SMC (Pinbar & Envolvente):**
   * Revisa en el marco de M5 que el reingreso sea un rechazo institucional genuino:
     * **Envolvente:** La vela de reingreso debe cerrar superando el mínimo/máximo previo (`close <= prevLow` en ventas / `close >= prevHigh` en compras).
     * **Pinbar con mecha:** La mecha de rechazo debe representar al menos el **45% del rango total de la vela**.

3. **Stop Loss Adaptativo por Volatilidad (ATR):**
   * El búfer de seguridad se calcula como: `Buffer = ATR(14) * 1.5`.
   * Aleja automáticamente el Stop Loss en momentos de alta volatilidad.

4. **Filtro de Volatilidad / Blackout de Noticias (`IsVolatilitySafe`):**
   * Si una vela M15 supera `2.5x` el valor promedio del ATR, el EA identifica la noticia y entra en **modo enfriamiento/bloqueo** por `30 minutos` (`VolatilityBlackoutMinutes`).

---

## 2. Parámetros de Configuración Destacados (V1.03)

### Ajustes Generales
* **`StartHour` (2):** Inicio de la caja asiática (02:00).
* **`EndHour` (8):** Fin de la caja asiática e inicio del escaneo (08:00).
* **`MaxTradeHour` (12):** Hora límite de entrada (se apaga a las 12:00).

### Ajustes de Stop Loss & ATR
* **`UseATRStopLoss` (true):** Activa el cálculo dinámico del buffer de Stop Loss por ATR.
* **`ATRPeriod` (14):** Período de velas para calcular el ATR.
* **`ATRMultiplier` (1.5):** Multiplicador para adaptar la distancia del buffer.
* **`ATRTF` (PERIOD_M15):** Temporalidad de cálculo del ATR.

### Filtro de Noticias & Volatilidad
* **`UseVolatilityFilter` (true):** Detección y bloqueo automático tras impulsos extremos por noticias.
* **`SpikeATRThreshold` (2.5):** Umbral de rango de vela M15 en múltiplos de ATR para declarar "Noticia".
* **`VolatilityBlackoutMinutes` (30):** Tiempo de enfriamiento en minutos en los que se pausan nuevas operaciones.

---

## 3. Archivos del Expert Advisor

* **Ruta local:** [asian_breakout_V1.03.mq4](file:///c:/Users/USER/Desktop/New%20Forex/Experts/asian_breakout_V1.03.mq4)
