# Manual del Expert Advisor: Asian Breakout V1.02 (SMC Multi-Timeframe)

Este documento detalla el funcionamiento interno, la lógica estratégica y la configuración del robot de trading `asian_breakout_V1.02.mq4`. Esta versión da un salto evolutivo importante al incorporar una innovadora arquitectura Multi-Timeframe (MTF) para ejecutar con máxima precisión la metodología purista de *Smart Money Concepts* (SMC) de Alex Ruiz.

---

## 1. Naturaleza y Arquitectura Multi-Timeframe (MTF)

A diferencia de versiones anteriores (Uni-Temporales), la V1.02 trabaja en dos marcos temporales simultáneamente para garantizar que el EA no opere en movimientos erráticos, sino en verdaderos engaños institucionales:

1. **Visión Macro (Gráfico M15):** Utilizada exclusivamente para analizar el contexto global. El EA lee el gráfico de 15 minutos en segundo plano para definir los límites exactos de la caja asiática y confirmar que la ruptura (*Sweep*) es un quiebre estructural con fuerza y volumen (midiendo el tamaño del cuerpo de la vela M15).
2. **Visión Micro (Gráfico M5):** Utilizada como "gatillo de francotirador". En el instante en que M15 confirma la ruptura, el EA activa su cronómetro y empieza a leer exclusivamente velas de 5 minutos, buscando el patrón exacto de reversión (Envolvente o Pinbar) para ejecutar la entrada rápidamente y con el menor Stop Loss posible.

---

## 2. Flujo Operativo Lógico (Paso a Paso)

La secuencia exacta que sigue el EA de forma automática es la siguiente:

1. **La Caja en M15:** El EA traza internamente el Máximo y el Mínimo de la sesión asiática (típicamente 02:00 a 08:00) leyendo el gráfico de 15 minutos.
2. **La Ruptura en M15 (Sweep):** El EA espera a que una vela de **15 minutos** cierre por fuera del rango asiático. No valida cualquier ruptura; el cuerpo de esa vela debe medir un mínimo de pips (`MinBreakoutBodyPips`), demostrando intención institucional.
3. **Activación de Trampa y Cambio a M5:** Al detectarse la ruptura en M15, el EA centra su atención en el marco temporal de **5 minutos** y empieza a contar cuántas velas de M5 se forman por fuera de la caja.
4. **Caducidad de la Trampa (`MaxCandlesOutside`):** Si el precio no regresa a la caja dentro del límite estricto de velas (por defecto 3 velas M5, que equivalen a 15 minutos de margen), el EA **anula la trampa automáticamente**. Esto previene que el EA opere por la tarde en base a una ruptura matutina.
5. **Gatillo en M5:** Si antes de que acabe el tiempo el precio regresa a la caja formando un patrón de reversión (Envolvente Bajista/Alcista o Pinbar) en el gráfico de **5 minutos**, el EA ejecuta la operación.
6. **Gestión de Riesgo (1%):** El EA calcula automáticamente el lotaje para que, si la operación toca el Stop Loss (colocado al otro lado de la manipulación), la pérdida sea exactamente el % de la cuenta estipulado.

---

## 3. Parámetros de Configuración Destacados (Inputs)

### Modo de Liquidez (SMC MTF)

* **`AutoFindLiquidity` (true):** Activa toda la búsqueda autónoma.
* **`MinBreakoutBodyPips` (2):** Tamaño mínimo del cuerpo de la vela de M15 que rompe la caja. Exigir 2 pips evita caer en pequeños ruidos y asegura que se detecte un barrido con intención.
* **`MaxCandlesOutside` (3):** El cronómetro de gracia. Indica cuántas velas de **M5** (5 minutos) puede el mercado quedarse fuera de la caja antes de regresar. Si supera este límite, la trampa caduca.
* **`MaxMinutesForReversal` (120):** Un seguro a nivel general por si la lógica de velas fallase. Corta cualquier intento de trampa si han pasado 120 minutos absolutos (2 horas) desde que ocurrió la ruptura.

### Ajustes Generales

* **`RiskPercent` (1.0):** El porcentaje de tu balance total a arriesgar. *(Recomendación: Bajar a 0.5% en cuentas reales pequeñas de 1.000€ a 1:30)*.
* **`FixedRiskReward` (3.0):** El ratio R:R. Busca ganar 3 veces lo que se arriesga.
* **Filtro de Días:** Por defecto (tras backtesting intensivo), solo opera Martes, Miércoles y Jueves. Lunes y Viernes están apagados por su alta tasa de trampas erráticas.

### Filtro de Tendencia (Trend Filter)

* **`UseTrendFilter` (true):** Alinea las operaciones con la tendencia macro del marco temporal H1 usando medias móviles (EMA 50 y 200).
  * Si la tendencia es **bajista**, solo permite **ventas** (tras ruptura superior del rango).
  * Si la tendencia es **alcista**, solo permite **compras** (tras ruptura inferior del rango).

---

## 4. Uso y Recomendación de Gráficos

Gracias a su motor MTF interno, **no importa en qué gráfico dejes abierto el EA**. Sin embargo, la recomendación oficial para usar la versión 1.02 es:

> **Arrastra el EA a un gráfico de M5 (5 Minutos).**

**¿Por qué?**
Aunque el EA leerá la ruptura de M15 por su cuenta, tener el EA visualmente en el gráfico de M5 te permitirá a ti (como operador humano) ver exactamente el patrón de velas (Pinbar o Envolvente) que el EA está utilizando para disparar el gatillo, haciendo que tu análisis y tu supervisión concuerden al 100% con las acciones del robot.

---

## 5. Resumen de Ventajas de la V1.02
* **Cero Operaciones Fantasma:** El límite `MaxCandlesOutside` previene entradas absurdas horas después de que ocurriera la manipulación.
* **Contexto vs Precisión:** Reúne lo mejor de ambos mundos. La solidez y fiabilidad de detectar manipulaciones en marcos mayores (M15), sumado a la ejecución rápida y de menor riesgo de los marcos menores (M5).
* **Alineación Total con SMC:** El EA no actúa como un simple bot de niveles, sino que interpreta la intención institucional (volumen de barrido + reacción rápida).