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
- **TradingStart1 / TradingEnd1**: Rango de la apertura de Londres (Por defecto: `08:00` - `11:00`).
- **TradingStart2 / TradingEnd2**: Rango de la apertura de Nueva York (Por defecto: `13:00` - `16:00`).

---

## Lógica Operativa (Paso a Paso)

El EA se ejecuta en temporalidad de **5 Minutos (M5)**, pero monitorea los cierres de H1 y H4 en tiempo real. 

1. **Zonas de Liquidez:** El bot identifica constantemente el Alto y Bajo del día anterior (D1) y el Alto y Bajo de la sesión inmediatamente anterior (según la hora del broker configurada).
2. **El "Liquidity Sweep" (Confirmación MTF):** 
   - El EA comprueba la última vela cerrada de H4 y la última de H1.
   - Ambas velas deben haber superado (roto) uno de los niveles de liquidez, pero su precio de cierre (`Close`) debe ser inferior al nivel (si es un máximo) o superior al nivel (si es un mínimo). 
   - Si la vela cierra con cuerpo más allá del nivel, se considera un "Liquidity Run" y el EA cancela la posibilidad de operar.
3. **El Gatillo (Envolvente en M5):**
   - Una vez confirmado el barrido en H4 y H1, el EA espera pacientemente en M5.
   - Si detecta una **Vela Envolvente** (Order Block) en dirección opuesta a la toma de liquidez, ejecuta la entrada inmediatamente al cierre de esa vela de M5.
4. **Gestión de la Operación:**
   - **Stop Loss:** Se coloca en el extremo absoluto (High/Low) de la vela de barrido (H4), sumándole el margen de `StopLossPaddingPips`.
   - **Take Profit:** Se calcula matemáticamente para ser igual a la distancia del Stop Loss (Riesgo/Beneficio 1:1).

---

## 💡 Recomendaciones de Uso

1. **Temporalidad (Timeframe):** Adjuntar el EA **únicamente al gráfico de M5** (o M3 si estás operando índices en plataformas que lo soporten y el EA se modifique para tal fin). El código ya hace las lecturas internas de H1 y H4 automáticamente.
2. **Backtesting:** Realiza pruebas exhaustivas (Backtesting) en el probador de estrategias (Strategy Tester) utilizando el modelo "Cada Tick" (Every Tick).
3. **Pares Recomendados:** Estrategia altamente efectiva en Índices (NASDAQ/US100, US30) y pares mayores (EURUSD, GBPUSD) donde las aperturas de Londres y NY inyectan volumen puro.
4. **Varias Cuentas:** Tal y como aconseja Sanchez, si el EA te demuestra ser consistente, es mejor usarlo en diferentes cuentas, o en distintas franjas horarias, para diversificar el riesgo de racha perdedora (Drawdown).
