# Manual EA Asian Breakout SMC V1.02 (Multi-Timeframe)

## 1. Naturaleza del Expert Advisor (EA)
La **Versión 1.02** del *Asian Breakout SMC* da un salto evolutivo importante al incorporar una arquitectura **Multi-Timeframe (MTF)**. Este EA está diseñado específicamente para ejecutar la estrategia purista de Smart Money Concepts (SMC) enseñada por Alex Ruiz, aprovechando las manipulaciones de liquidez que ocurren a la salida de la sesión asiática.

A diferencia de versiones anteriores (Uni-Temporales), la V1.02 trabaja en dos marcos temporales simultáneamente para garantizar una precisión milimétrica:
- **Visión Macro (Gráfico de 15 Minutos - M15):** Utilizada exclusivamente para analizar el contexto, definir los límites de la caja asiática y confirmar que la ruptura (Sweep) tiene volumen institucional.
- **Visión Micro (Gráfico de 5 Minutos - M5):** Utilizada como "gatillo de francotirador" para ejecutar la entrada en el mercado justo cuando se forma el patrón de reversión, optimizando el punto de entrada y reduciendo el Stop Loss.

## 2. Flujo Operativo Multi-Timeframe (Paso a Paso)

La secuencia exacta que sigue el EA de forma automática es la siguiente:

1. **La Caja en M15:** El EA lee el gráfico de 15 minutos en segundo plano y traza el rango de la sesión asiática (típicamente 02:00 a 08:00).
2. **La Ruptura en M15 (Sweep):** El EA espera a que una vela de **15 minutos** cierre por fuera del rango asiático. No valida cualquier ruptura; el cuerpo de esa vela debe medir un mínimo de pips (configurable mediante `MinBreakoutBodyPips`) para demostrar intención y volumen.
3. **Activación de Trampa y Cambio a M5:** En el instante en que M15 confirma la ruptura, el EA activa la trampa y pasa su atención analítica al gráfico de **5 minutos**.
4. **El Cronómetro de M5 (`MaxCandlesOutside`):** A partir del sweep, el EA empieza a contar velas de 5 minutos. Si el precio no regresa a la caja y forma el patrón de entrada dentro de un límite estricto de velas (por defecto 3 velas M5, es decir, 15 minutos), el EA **anula la trampa**. Esto evita quedarse esperando reversiones falsas o tardías (cambios estructurales).
5. **El Gatillo en M5:** Si dentro de ese margen de tiempo el precio regresa a la caja formando un patrón de reversión (Envolvente o Pinbar) en el gráfico de **5 minutos**, el EA ejecuta la operación inmediatamente.

## 3. Nuevos Parámetros de la V1.02

La sección `--- MODO DE LIQUIDEZ (SMC MTF) ---` incluye configuraciones avanzadas para controlar la exigencia de la trampa:

*   **`MinBreakoutBodyPips` (Por defecto = 2):** Establece el tamaño mínimo del cuerpo que debe tener la vela de M15 que rompe la caja. Exigir un cuerpo de 2 pips evita que el EA caiga en pequeños ruidos del mercado y asegura que detecte un barrido con intención.
*   **`MaxCandlesOutside` (Por defecto = 3):** Es el tiempo de gracia de la trampa. Indica cuántas velas de **M5** (5 minutos) puede permanecer el mercado por fuera de la caja antes de regresar. Si supera este número, la trampa caduca y el EA ignora la entrada.
*   **`MaxMinutesForReversal` (Por defecto = 120):** Un seguro a nivel general por si la lógica de velas fallase. Corta cualquier intento de trampa si han pasado 2 horas absolutas.

## 4. Uso y Recomendación de Gráficos

Gracias a su motor MTF, **no importa en qué gráfico dejes abierto el EA**. Sin embargo, la recomendación oficial para usar la versión 1.02 es:

> **Arrastra el EA a un gráfico de M5 (5 Minutos).**

**¿Por qué?**
Aunque el EA leerá la ruptura de M15 por su cuenta, tener el EA visualmente en el gráfico de M5 te permitirá a ti (como operador humano) ver exactamente el patrón de velas (Pinbar o Envolvente) que el EA está utilizando de gatillo, haciendo que tu backtesting visual y tu supervisión concuerden al 100% con las acciones del robot.

## 5. Resumen de Ventajas de la V1.02
*   **Cero Operaciones Fantasma:** El límite `MaxCandlesOutside` previene entradas absurdas horas después de que ocurriera la manipulación.
*   **Contexto vs Precisión:** Reúne lo mejor de ambos mundos. La solidez y fiabilidad de detectar manipulaciones en marcos mayores (M15), sumado a la ejecución rápida y de menor riesgo de los marcos menores (M5).
*   **Alineación Total con SMC:** El EA no actúa como un simple bot de niveles, sino que interpreta la intención institucional (volumen de barrido + reacción rápida).
