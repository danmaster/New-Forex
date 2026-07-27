# Manual del Expert Advisor: Asian Breakout V1.02 (SMC Multi-Timeframe)

Este documento detalla el funcionamiento interno, la lógica estratégica y la configuración del robot de trading `asian_breakout_V1.02.mq4`, el cual incorpora una innovadora arquitectura Multi-Timeframe (MTF) para ejecutar con máxima precisión la metodología de *Smart Money Concepts* (SMC) de Alex Ruiz.

---

## 1. La Novedad: Arquitectura Multi-Timeframe (MTF)

A diferencia de versiones anteriores, la V1.02 trabaja en dos marcos temporales simultáneamente para garantizar que el EA no opere en movimientos erráticos o "fantasmas", sino en verdaderos engaños institucionales:

1.  **Visión Macro (Gráfico M15):** Utilizada exclusivamente para analizar el contexto global. El EA lee el gráfico de 15 minutos en segundo plano para definir los límites exactos de la caja asiática y confirmar que la ruptura (*Sweep*) es un quiebre estructural con fuerza y volumen (midiendo el tamaño del cuerpo de la vela M15).
2.  **Visión Micro (Gráfico M5):** Utilizada como "gatillo de francotirador". En el instante en que M15 confirma la ruptura, el EA activa su cronómetro y empieza a leer exclusivamente velas de 5 minutos, buscando el patrón exacto de reversión (Envolvente o Pinbar) para ejecutar la entrada rápidamente y con el menor Stop Loss posible.

---

## 2. Lógica de Operación (Paso a Paso)

1.  **La Caja en M15:** El EA traza internamente el Máximo y el Mínimo de la sesión asiática (típicamente 02:00 a 08:00) leyendo el gráfico de 15 minutos.
2.  **La Ruptura en M15 (Sweep):** El EA espera a que una vela de **15 minutos** cierre por fuera del rango asiático. Para validarlo, exige que el cuerpo de esa vela de M15 mida un mínimo de pips (`MinBreakoutBodyPips`), demostrando intención institucional.
3.  **Activación del Cronómetro en M5:** Al detectarse la ruptura en M15, el EA centra su atención en el marco temporal de **5 minutos**. Empieza a contar cuántas velas de M5 se forman por fuera de la caja (`MaxCandlesOutside`).
4.  **Caducidad de la Trampa:** Si el precio no regresa a la caja dentro del límite estricto de velas (por defecto 3 velas M5, que equivalen a 15 minutos de margen), el EA **anula la trampa automáticamente**. Esto previene que el EA opere por la tarde en base a una ruptura ocurrida en la mañana.
5.  **Gatillo en M5:** Si antes de que acabe el tiempo el precio regresa a la caja formando un patrón de reversión (Envolvente Bajista/Alcista o Pinbar) en el gráfico de **5 minutos**, el EA ejecuta la operación.
6.  **Gestión de Riesgo (1%):** El EA calcula automáticamente el lotaje para que, si la operación toca el Stop Loss (colocado al otro lado de la manipulación), la pérdida sea exactamente el % de la cuenta estipulado.

---

## 3. Parámetros de Configuración Destacados (Inputs)

### Modo de Liquidez (SMC MTF)
*   **`AutoFindLiquidity` (true):** Activa toda esta búsqueda autónoma.
*   **`MinBreakoutBodyPips` (2):** Tamaño mínimo (en pips) que debe tener el cuerpo de la vela de M15 que rompe la caja. Si la ruptura es solo una mecha o un cuerpo minúsculo (menor a 2 pips), el EA lo ignorará por falta de convicción.
*   **`MaxCandlesOutside` (3):** El cronómetro de gracia. Indica cuántas velas de **M5** puede el mercado quedarse fuera de la caja antes de regresar con el gatillo. Por defecto permite 3 velas de M5 (15 minutos).
*   **`MaxMinutesForReversal` (120):** Un seguro a nivel general. Corta cualquier intento de trampa si han pasado 120 minutos absolutos desde que ocurrió la ruptura.

### Ajustes Generales
*   **`RiskPercent` (1,0):** El porcentaje de tu balance total a arriesgar.
*   **`FixedRiskReward` (3,0):** El ratio R:R. Busca ganar 3 veces lo que se arriesga.
*   **Filtro de Días:** Por defecto (tras backtesting intensivo), solo opera Martes, Miércoles y Jueves. Lunes y Viernes están apagados por su alta tasa de trampas erráticas.

### Filtro de Tendencia (Trend Filter)
*   **`UseTrendFilter` (true):** Alinea las operaciones con la tendencia macro del marco temporal H1 usando medias móviles (EMA 50 y 200). Esto cumple con el Paso 2 de la estrategia de Alex Ruiz:
    *   Si la tendencia es **bajista**, solo permite **ventas** (tras ruptura superior del rango).
    *   Si la tendencia es **alcista**, solo permite **compras** (tras ruptura inferior del rango).

---

## 4. Uso y Recomendación de Gráficos

Gracias a su motor MTF interno, **no importa en qué gráfico dejes abierto el EA**. Sin embargo, la recomendación oficial para usar la versión 1.02 es:

> **Arrastra el EA a un gráfico de M5 (5 Minutos).**

**¿Por qué?**
Aunque el EA leerá la ruptura de M15 por su cuenta, tener el EA visualmente en el gráfico de M5 te permitirá ver el patrón de velas (Pinbar o Envolvente) exacto que el EA está utilizando para disparar el gatillo, haciendo que tu análisis humano y el del robot estén sincronizados en la pantalla.
