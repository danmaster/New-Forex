# Manual del Expert Advisor: Quick_Flip_Scalper

Este documento detalla la lógica estratégica, los requisitos y la configuración del robot de trading `Quick_Flip_Scalper.mq4`. Esta estrategia está basada en cazar la manipulación institucional ("Judas Swing") en la apertura del mercado de Nueva York, recomendada principalmente para operar en el **SP500 (US500)** y el **Nasdaq 100 (US100)** en la temporalidad de **5 minutos (M5)**.

---

## 1. Lógica de Operación (Paso a Paso)

El EA opera de forma 100% autónoma cazando la volatilidad de la apertura americana. Su ejecución se basa en los siguientes pasos:

1. **La Caja de 15 Minutos (Opening Range):** A la hora de apertura especificada (ej. 16:30 Hora de Servidor Europeo), el EA monitoriza las 3 primeras velas de 5 minutos (15 minutos en total). Registra el punto más alto y más bajo de ese periodo para formar su "Caja".
2. **Filtro de Volatilidad (ATR Diario):** Antes de continuar, el robot mide la caja frente al Average True Range (ATR) del gráfico diario. Si la caja inicial de 15 minutos representa menos del 25% del rango diario promedio, se considera que "no hay suficiente gasolina" y se bloquea la operativa de ese día.
3. **El Barrido (Judas Swing):** El EA espera a que las instituciones rompan la caja engañando a los operadores minoristas (cazando Stop Losses). Si el precio sale de la caja y luego forma un patrón de velas de reversión extremo (un Martillo o una vela Envolvente) devolviéndolo al interior, se dispara la entrada.
4. **Gestión de Riesgo Dinámica (1%):** Al detectar la señal, calcula la distancia exacta del Stop Loss (justo detrás de la mecha de la trampa). En base a esto, abre un lotaje específico para que, si se pierde la operación, solo se pierda un 1% (o el valor que decidas) de tu capital actual.
5. **Asegurar Ganancias (Cierre Parcial):** Una vez dentro, el robot monitoriza el precio en vivo. Si el precio avanza a tu favor alcanzando una relación 1:1 (ganas lo mismo que estabas arriesgando), el EA **cierra el 50% de tus lotes**, asegurando ganancias en tu cuenta. Inmediatamente, mueve el Stop Loss restante al punto de entrada (Breakeven), garantizando una operación 100% libre de riesgo.
6. **Notificación al Móvil:** El robot enviará avisos Push a tu móvil de forma nativa cada vez que se ejecute una entrada, un cierre parcial, o la gestión del Stop Loss.

---

## 2. Parámetros de Configuración (Inputs)

### Configuración de Horario
*   **`InpOpenHour` (16) / `InpOpenMinute` (30):** La hora del servidor de tu bróker en la que abre oficialmente la bolsa de Nueva York (09:30 AM EST). Para brókers europeos, suele ser las 16:30 o 15:30.
*   **`InpDurationMinutes` (90):** El tiempo máximo que el robot estará buscando la trampa institucional. Pasados 90 minutos (hora y media de la apertura), el mercado suele entrar en rango, por lo que el robot apaga su escáner.

### Gestión de Riesgo
*   **`InpRiskPercent` (1.0):** El porcentaje de tu balance total que perderás si toca el Stop Loss. (Recomendado: 1.0%).
*   **`InpMaxLot` (50.0):** Medida de seguridad técnica para evitar que el bróker rechace operaciones que excedan el límite de volumen de su servidor.
*   **`InpMagicNumber` (888123):** Número de identificación del EA. **CRÍTICO:** Debe ser diferente al del *Asian Breakout* para que ambos puedan trabajar en la misma cuenta sin interferir.

### Indicadores
*   **`InpATRPeriod` (14):** Los días que usa el ATR para medir la volatilidad histórica del activo.
*   **`InpATRMultiplier` (0.25):** El porcentaje (25%) del rango diario que la caja debe superar para ser considerada válida.
*   **`InpSLPadding` (0):** Puntos extra de "respiro" que se añaden al Stop Loss más allá de la mecha de manipulación (útil para el spread agresivo del Nasdaq).
*   **`InpStrictPatterns` (true):** Obliga a que la vela de reversión sea perfecta (Martillo o Envolvente clara).

### Gestión de Operación
*   **`InpPartialCloseRatio` (1.0):** Ratio Riesgo/Beneficio al cual el robot tomará la primera ganancia. Un valor de `1.0` significa que si arriesgas 10€, tomará ganancias al estar en positivo 10€.
*   **`InpPartialClosePct` (50.0):** Porcentaje de la posición total que se cerrará en el paso anterior.
*   **`InpMoveToBE` (true):** Si es `true`, tras ejecutar el cierre parcial, el Stop Loss del resto de la posición se moverá automáticamente al precio exacto de entrada (Breakeven).
*   **`InpSendPush` (true):** Activa las notificaciones Push nativas para que te llegue un aviso instantáneo a la app MetaTrader de tu teléfono.

### Visual
*   **`InpDrawBox` (true):** Dibuja automáticamente un rectángulo de color en tu gráfico para que puedas auditar visualmente cuál fue el "Opening Range" que el robot utilizó ese día.
*   **`InpBoxColor` (DodgerBlue):** El color de la caja de 15 minutos en la pantalla.

---

## 3. Entorno y Consideraciones
*   **Activos Ideales:** SP500 (US500) para movimientos limpios. Nasdaq 100 (US100) para movimientos agresivos.
*   **Temporalidad (Timeframe):** Es estrictamente obligatorio anclar el EA al gráfico de **M5 (5 Minutos)**. 
*   **Convivencia:** Este EA puede (y debe) operar en la misma cuenta VPS que el *Asian Breakout*, siempre y cuando se coloquen en ventanas de gráficos diferentes, ya que operan franjas horarias y activos distintos y poseen `Magic Numbers` diferentes.
