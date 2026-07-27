# Manual del Expert Advisor: Ganar en 3 Pasos v1.30 (Fibonacci Cestas - Alex Ruiz)

Este documento detalla el funcionamiento del Expert Advisor (EA) **AlexRuiz_Fibo_3Pasos.mq4**, rediseñado en su versión 2.0 para automatizar un sistema de **cesta de operaciones fraccionadas (DCA)** dentro de la zona de retroceso de Fibonacci, mitigando el riesgo de forma exacta.

## 1. Características Principales del EA

El sistema opera de forma 100% algorítmica combinando tendencia, acción del precio y gestión matemática avanzada:

1. **Identificación de Tendencia (Paso 1):**
   - Utiliza una Media Móvil Exponencial (EMA) de 200 periodos.
   - Si el precio está por encima de la EMA, el EA solo buscará **compras**.
   - Si el precio está por debajo de la EMA, el EA solo buscará **ventas**.

2. **Detección del Impulso Valido (Paso 2):**
   - El EA utiliza el indicador interno **ZigZag** para identificar los *Swing Highs* (máximos) y *Swing Lows* (mínimos).
   - Se ha añadido un **Filtro de Impulso Mínimo (`InpMinImpulsePips`)**. El EA ignorará aquellos movimientos del ZigZag que sean simples "ruidos" de mercado (por ejemplo, impulsos de menos de 15 pips), asegurando que el Fibonacci se trace únicamente sobre movimientos institucionales de calidad.

3. **Ejecución en Cesta DCA (Paso 3):**
   - Una vez identificado un impulso sano, el EA coloca **3 órdenes pendientes simultáneas** en los niveles de Fibonacci de retroceso (por defecto 0.382, 0.50 y 0.618).
   - Todas estas operaciones quedan cubiertas por un único **Stop Loss Global** (nivel 0.786).

---

## 2. El Motor Matemático de Riesgo Fraccionado

La mayor innovación del EA es su calculadora de lotaje interno. En lugar de usar un lote fijo peligroso, el EA respeta a raja tabla un límite de riesgo porcentual predefinido.

### ¿Cómo funciona la gestión?
Si decides arriesgar el **1%** de tu cuenta:
- **Operación 1 (Fibo 0.382):** El EA le asigna el **25%** de ese 1% de riesgo. Medirá la distancia en pips desde el 0.382 hasta el Stop Loss (0.786) y calculará mágicamente el lotaje necesario para que, si el precio toca el Stop Loss, la pérdida sea exactamente ese 25%.
- **Operación 2 (Fibo 0.50):** Se le asigna el **40%** de ese 1% de riesgo y se calcula su lote.
- **Operación 3 (Fibo 0.618):** Se le asigna el **35%** de ese 1% de riesgo y se calcula su lote.

> **Resultado:** Si el mercado hace un *Stop Hunt* profundo y toca el nivel 0.786 eliminando tus 3 operaciones, tu pérdida total combinada será matemáticamente exacta al **1.0%** de tu cuenta. 

### Take Profit (Expansión Matemática)
Para exprimir el máximo beneficio en cada tendencia saludable, el EA no utiliza un ratio 1:1 estático. En su lugar, el Take Profit se proyecta de manera automática hacia la extensión de Fibonacci **`-0.272`** (parámetro `InpFiboTP`). Las 3 operaciones de la cesta se cerrarán de manera simultánea al alcanzar este objetivo institucional, permitiendo obtener ratios de Riesgo/Beneficio asimétricos masivos de hasta 1:3 o 1:4 con una sola cesta.

---

## 3. Limpieza Automática de Cestas

El mercado está vivo y en constante movimiento. 
- Si el EA coloca una cesta de 3 órdenes esperando el retroceso, pero el precio en su lugar continúa con la tendencia y crea un nuevo máximo/mínimo (extendiendo el impulso original en el ZigZag), las órdenes colocadas quedan "obsoletas".
- El EA detectará instantáneamente el nuevo impulso, **cancelará y limpiará** las 3 órdenes pendientes antiguas, y trazará una **nueva cesta** adaptada a los nuevos niveles de Fibonacci.

---

## 4. Parámetros Modificables (Inputs)

Al cargar el EA en el gráfico, puedes ajustar todos los valores:

**Gestión de Riesgo y Capital:**
- `InpRiskPercent (1.0)`: Porcentaje total del capital a arriesgar por cesta.

**Estructura de la Cesta Fibonacci:**
- `InpFibo1 (0.382)` y `InpRiskSplit1 (25.0)`: Nivel Fibo y % de riesgo de la Entrada 1.
- `InpFibo2 (0.500)` y `InpRiskSplit2 (40.0)`: Nivel Fibo y % de riesgo de la Entrada 2.
- `InpFibo3 (0.618)` y `InpRiskSplit3 (35.0)`: Nivel Fibo y % de riesgo de la Entrada 3.
- `InpFiboSL (0.786)`: Nivel Fibo donde se ubica el Stop Loss Global.
- `InpFiboTP (-0.272)`: Extensión matemática institucional del Take Profit.

**Filtros de Mercado:**
- `InpEmaPeriod (200)`: Periodo de la EMA para definir si estamos en tendencia alcista o bajista.
- `InpZigZagDepth (12), Deviation (5), Backstep (3)`: Sensibilidad del ZigZag.
- `InpMinImpulsePips (15.0)`: Filtro vital. El EA no trazará el Fibonacci si el impulso detectado por el ZigZag mide menos que esta cantidad de Pips.

**Filtros de Horario (Sesiones de Trading):**
Para evitar los Whipsaws de fin de sesión o quedar atrapado en los rangos asiáticos (apagados por defecto):
- `InpUseTimeFilter (false)`: Ponlo en *true* para habilitar la ventana de tiempo.
- `InpStartHour (1) & InpEndHour (18)`: Horario de apertura y cierre (Hora del broker). Al tocar la *EndHour*, el EA automáticamente borrará cualquier cesta pendiente.
- `InpUseFridayFilter (false)`: Si lo activas, el EA cancelará sus operaciones limit los viernes para no quedar dentro de posiciones durante el fin de semana.
- `InpFridayStopHour (14)`: Hora de cierre específica para el viernes.

---

## 5. Recomendaciones de Uso
- **Timeframe Recomendado:** Se aconseja probar en **M15 o H1**. En M1 el ruido del mercado puede crear demasiados impulsos pequeños.
- **Instrumentos:** Estrategia orientada a activos que respetan bien los pullbacks como EURUSD, GBPUSD y el Oro (XAUUSD).
- **El Filtro es Clave:** Si notas que el EA entra demasiadas veces al día con Stop Loss muy pegados al precio, **aumenta el `InpMinImpulsePips` a 20 o 25**. Esto forzará al EA a operar solo movimientos tendenciales fuertes y saludables.

### ⚠️ Peligro en Cuentas LIVE: La Trampa del Spread (Rollover)
Es de vital importancia comprender por qué el **Filtro de Horario está desactivado por defecto (para maximizar backtesting)**, pero **se recomienda encarecidamente ACTIVARLO en cuentas Live reales**.
- **El Espejismo del Backtest:** Los probadores de estrategias (como MT4) simulan un mercado perfecto con un spread fijo (ej. 1 pip). En el backtest, operar a las 00:00 puede parecer extremadamente rentable.
- **La Realidad del Mercado:** A las 00:00 (hora del servidor), los bancos realizan el cierre diario (Rollover). La liquidez desaparece y **el spread se puede multiplicar x15 o x30**. 
- **La Consecuencia:** Una apertura de spread gigante a medianoche empujará el precio *Ask* violentamente hacia arriba. Si tienes posiciones abiertas o límites pendientes de Venta/Compra con stop losses ajustados, **el spread ampliado activará tu Stop Loss instantáneamente** (-1% de la cuenta) aunque el precio real del mercado no se haya movido en tu contra.

> **💡 Configuración Recomendada (Cuentas Live / Fondeo):**
> Activa el filtro (`InpUseTimeFilter = true`) configurando `StartHour = 2` y `EndHour = 21`. Esto te permitirá operar la sesión asiática (después del rollover) junto con Londres y Nueva York, garantizando que el EA borre todas las órdenes pendientes a las 21:00 y te proteja de pérdidas matemáticas seguras a la medianoche.
