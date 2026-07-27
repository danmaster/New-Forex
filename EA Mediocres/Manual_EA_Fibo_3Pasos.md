# Manual del Expert Advisor: Ganar en 3 Pasos (Fibonacci - Alex Ruiz)

Este documento detalla el funcionamiento del Expert Advisor (EA) **AlexRuiz_Fibo_3Pasos.mq4**, diseñado para automatizar la estrategia "Ganar en 3 pasos" basada en los retrocesos de Fibonacci y la Acción del Precio enseñada por Alex Ruiz.

## 1. Características Principales del EA

El sistema opera de forma 100% algorítmica y se basa en tres pilares, eliminando la subjetividad del trazado manual:

1. **Identificación de Tendencia (Paso 1):**
   - Utiliza una Media Móvil Exponencial (EMA) de 200 periodos.
   - Si el precio está por encima de la EMA, el EA solo buscará **compras**.
   - Si el precio está por debajo de la EMA, el EA solo buscará **ventas**.

2. **Detección del Impulso (Paso 2):**
   - En lugar de trazar el Fibonacci a "ojo", el EA utiliza el indicador interno **ZigZag** para identificar los *Swing Highs* (máximos) y *Swing Lows* (mínimos) más recientes.
   - El último movimiento válido trazado por el ZigZag se convierte en nuestro impulso direccional (del 100% al 0%).

3. **Ejecución en la Golden Zone (Paso 3):**
   - Una vez identificado el impulso, el EA calcula matemáticamente el nivel de retroceso deseado (por defecto **50%** o `0.50`).
   - El EA coloca una orden pendiente (`Buy Limit` o `Sell Limit`) exactamente en ese precio.

---

## 2. Diferencias Clave: EA vs. Enfoque Manual de Alex Ruiz

Aunque el EA respeta la estructura de mercado que enseña Alex Ruiz, cuenta con optimizaciones lógicas para sobrevivir al trading algorítmico sin intervención humana:

### A. Gestión de Órdenes (Auto-Limpieza)
- **Manual:** Un trader dibuja el Fibo y si el precio rompe el nivel 0% (iniciando un nuevo impulso sin haber retrocedido a la Golden Zone), el trader borra su Fibonacci y dibuja uno nuevo.
- **En el EA:** Se ha programado una rutina de *limpieza*. Si el EA tiene una orden `Limit` esperando en el 50%, pero el ZigZag dibuja un **nuevo impulso más reciente**, el EA **elimina automáticamente** la orden antigua abandonada y recalcula la nueva zona dorada, garantizando que nunca se opere sobre un análisis caducado.

### B. Stop Loss Adaptativo (ATR Buffer)
- **Manual:** Alex Ruiz suele colocar el Stop Loss visualmente por detrás del inicio del impulso (nivel 100%), dejando un ligero "respiro" subjetivo.
- **En el EA:** El "respiro" ya no es subjetivo. El EA utiliza el indicador **ATR (Average True Range)**. El Stop Loss se ubica matemáticamente en el nivel 100% **más el valor del ATR multiplicado por un factor (por defecto 1.5)**. Esto protege la operación contra manipulaciones (*Stop Hunts*) o *wicks* violentos, especialmente en activos como el Oro.

### C. Take Profit y Risk/Reward
- **Manual:** Se suelen buscar zonas de liquidez o bloques de órdenes para cerrar la operación.
- **En el EA:** Para garantizar un perfil de rentabilidad matemático superior a 1:1, el TP está fijado en la extensión `-0.27` de Fibonacci. Al entrar en el 50% con un SL en el 100%+ATR, alcanzar el -0.27 garantiza que la ganancia sea siempre mayor a la pérdida.

---

## 3. Parámetros Modificables (Inputs)

Al cargar el EA en el gráfico, puedes ajustar los siguientes parámetros:

- **InpLotSize (0.1):** Tamaño de la posición.
- **InpEmaPeriod (200):** Periodo de la EMA que filtra la tendencia.
- **InpAtrPeriod (14) & InpAtrMultiplier (1.5):** Controlan el "respiro" del Stop Loss. Si operes EURUSD puedes bajar el multiplicador a `1.0`. Si operas Oro, `1.5` o `2.0` es recomendable.
- **InpZigZagDepth (12), Deviation (5), Backstep (3):** Sensibilidad del algoritmo para detectar los impulsos. Reducir el Depth hará que trace impulsos más pequeños y rápidos.
- **InpFiboEntryLevel (0.50):** El nivel exacto donde se pone la orden pendiente. Si prefieres el 61.8%, cambia este valor a `0.618`.
- **InpFiboTPLevel (-0.27):** Extensión de toma de ganancias.

---

## 4. Recomendaciones de Uso
- **Instrumentos:** Pares Mayores (EURUSD, GBPUSD), Oro (XAUUSD) o Índices (US30).
- **Timeframe:** M5 o M15 para operaciones intradía rápidas, o H1 para Swing Trading.
- **Prueba:** Siempre ejecuta el EA en modo visual (*Strategy Tester*) tras cambiar los parámetros del ZigZag para asegurarte de que el tamaño de los impulsos se adapta a lo que buscas visualizar.
