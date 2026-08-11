# Manual de Operatividad: EA Sanchez ZFX V1.00

## Filosofía de la Estrategia ("Lo Simple Siempre Gana")
Este Expert Advisor (EA) está construido estrictamente bajo los parámetros de la estrategia "Lo Simple Siempre Gana" explicada por Sanchez ZFX. El EA elimina el componente psicológico y la ansiedad, automatizando la detección de **Liquidity Sweeps** (barridos de liquidez) en los únicos niveles estructurales que importan: los altos y bajos de sesiones y del día anterior.

La estrategia no busca adivinar la dirección del mercado a largo plazo. Su objetivo es cazar el retroceso inicial inmediato que ocurre después de que las instituciones toman la liquidez de un nivel clave. Por ello, el Take Profit siempre es un riesgo/beneficio de 1:1, logrando un Win Rate extremadamente alto.

---

## Parámetros del EA (Inputs)

### ⚙️ Configuración General
- **TradeComment**: Etiqueta para identificar las operaciones en el historial (Por defecto: "Sanchez ZFX").
- **MagicNumber**: Identificador único del EA para no interferir con otros robots (Por defecto: `8888`).
- **RiskPercent**: Porcentaje de riesgo del balance total de la cuenta por cada operación (Por defecto: `1.0`%).
- **FixedLotSize**: Si se coloca un valor mayor a `0.0`, el EA ignorará el `RiskPercent` y operará siempre con este lotaje fijo.
- **Slippage**: Deslizamiento máximo permitido en pips al entrar a mercado (Por defecto: `3`).
- **StopLossPaddingPips**: Pips de holgura que se añaden al Stop Loss por encima o debajo de la mecha del barrido para evitar cierres prematuros por el spread (Por defecto: `2.0`).

### ⏰ Configuración de Horarios (Horario del Broker)
Estos parámetros definen cuándo ocurrieron las sesiones anteriores para calcular la liquidez.
- **AsiaStart / AsiaEnd**: Inicio y fin de la sesión Asiática (Por defecto: `00:00` - `08:00`).
- **LondonStart / LondonEnd**: Inicio y fin de la sesión de Londres (Por defecto: `08:00` - `13:00`).
- **NYStart / NYEnd**: Inicio y fin de la sesión de Nueva York (Por defecto: `13:00` - `21:00`).

### 🚀 Horario de Trading Permitido (Filtro Operativo)
El EA solo buscará entradas dentro de estos rangos horarios, simulando tu presencia durante las ventanas de volatilidad (aperturas de Londres y Nueva York).
- **TradingStart1 / TradingEnd1**: Rango de la apertura de Londres (Por defecto: `09:00` - `12:00` hora Skilling).
- **TradingStart2 / TradingEnd2**: Rango de la apertura de Nueva York (Por defecto: `15:00` - `18:00` hora Skilling).

### 🎯 Gatillo (Confirmación 4)
- **TriggerTF**: Temporalidad donde se busca la vela envolvente (Order Block). Por defecto es M5, pero puede ajustarse a M3 para índices.
- **SweepProximityPoints**: Distancia máxima permitida (en puntos) entre la envolvente y el nivel barrido. Evita tomar operaciones en retrocesos que ocurren muy lejos del punto estructural original.

---

## Lógica Operativa (Paso a Paso)

El EA se ejecuta en temporalidad de **5 Minutos (M5)**, pero monitorea los cierres de H1 y H4 en tiempo real. 

1. **Zonas de Liquidez:** El bot identifica constantemente el Alto y Bajo del día anterior (D1) y el Alto y Bajo de la sesión inmediatamente anterior (según la hora del broker configurada).
2. **El "Liquidity Sweep" (Confirmación MTF en tiempo real):** 
   - El EA monitoriza las velas *en formación* (en vivo) de H4 y H1.
   - Si el precio cruza un nivel estructural y luego es rechazado regresando al otro lado (dejando una mecha tanto en H1 como en H4 de forma simultánea), se confirma el barrido sin necesidad de esperar al cierre de 4 horas.
3. **El Gatillo (Envolvente y Proximidad):**
   - Una vez confirmado el rechazo MTF en vivo, el EA espera en la temporalidad definida en `TriggerTF` (ej. M5 o M3).
   - Se requiere que se forme una **Vela Envolvente** muy cerca de la toma de liquidez (filtrado por `SweepProximityPoints`). Si la vela envolvente se forma, se ejecuta la entrada.
4. **Gestión de la Operación:**
   - **Stop Loss:** Se coloca matemáticamente justo por encima (o por debajo) del **nivel real barrido**, sumándole el margen de `StopLossPaddingPoints`.
   - **Take Profit:** Se calcula matemáticamente para ser igual a la distancia del Stop Loss (Riesgo/Beneficio 1:1).

---

## 💡 Recomendaciones de Uso

1. **Temporalidad (Timeframe):** Adjuntar el EA **únicamente al gráfico de M5** (o M3 si estás operando índices en plataformas que lo soporten y el EA se modifique para tal fin). El código ya hace las lecturas internas de H1 y H4 automáticamente.
2. **Backtesting:** Realiza pruebas exhaustivas (Backtesting) en el probador de estrategias (Strategy Tester) utilizando el modelo "Cada Tick" (Every Tick).
3. **Pares Recomendados:** Estrategia altamente efectiva en Índices (NASDAQ/US100, US30) y pares mayores (EURUSD, GBPUSD) donde las aperturas de Londres y NY inyectan volumen puro.
4. **Varias Cuentas:** Tal y como aconseja Sanchez, si el EA te demuestra ser consistente, es mejor usarlo en diferentes cuentas, o en distintas franjas horarias, para diversificar el riesgo de racha perdedora (Drawdown).
