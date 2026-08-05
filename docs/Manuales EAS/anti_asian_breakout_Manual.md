# Manual del Expert Advisor: Anti-Asian Breakout V1.0 (Break & Confirm)

Este documento detalla el funcionamiento interno, la lógica estratégica y la configuración del robot de trading `anti_asian_breakout.mq4`. 

A diferencia del Asian Breakout original, este EA no busca operar falsos quiebres o *fakeouts*. Su objetivo es surfear la tendencia institucional genuina tras la ruptura limpia de la caja asiática utilizando un poderoso patrón de continuación (Break & Retest).

---

## 1. La Estrategia: Continuación "Break & Confirm"

El EA busca específicamente **tres pasos consecutivos (Patrón 1-2-3)** en la temporalidad de 15 minutos (M15) para evitar entrar en rupturas falsas:

1.  **La Ruptura (El Impulso):** El EA espera que una vela M15 rompa y cierre por fuera del rango asiático demostrando intención (con un cuerpo de tamaño mínimo predefinido).
2.  **El Amago (El Retroceso):** El 90% de los traders entran en la ruptura y son cazados en el retroceso. Nuestro EA se queda fuera y espera este movimiento (ej. una vela bajista tras una ruptura alcista).
3.  **La Confirmación (La Envolvente):** El EA entra al mercado solo cuando una nueva vela a favor de la tendencia envuelve (o supera) el retroceso, confirmando que la fuerza original de la ruptura sigue intacta.

---

## 2. Parámetros de Entrada Configurable

A continuación, se describen los parámetros exclusivos de esta versión de Continuación, además de los ajustes clásicos compartidos con la versión base.

### MODO CONTINUACION
*   **MinBreakoutBodyPips:** El tamaño mínimo (en pips) que debe tener el cuerpo de la primera vela M15 que rompe la caja. Exige que haya "fuerza" y no solo un roce.
*   **MaxPatternBars:** El número máximo de velas M15 que el EA esperará para que se complete la secuencia (Ruptura -> Amago -> Confirmación). Si pasa este límite (por defecto 8 velas, unas 2 horas) sin que se forme la confirmación, el patrón caduca para evitar entrar en un mercado lateral sucio.

### GESTION DE RIESGO
*   **Lote Dinámico (UseDynamicLot):** Arriesga automáticamente el % de tu cuenta especificado por operación.
*   **Cálculo del Stop Loss:** A diferencia del Asian Breakout original, aquí el SL se coloca de forma técnica y dinámica en el **mínimo (para compras) o máximo (para ventas) de la vela inicial que rompió la caja**. Si el precio rompe este nivel, el patrón de continuación queda invalidado.

### OBJETIVOS DE BENEFICIO & TRAILING STOP
*   **Trailing Stop por defecto:** La naturaleza de las operaciones de continuación implica agarrar grandes impulsos direccionales. Por esto, esta versión viene configurada por defecto para usar **Trailing Stop** en lugar de un TP fijo, permitiendo maximizar el movimiento de expansión de Londres/Nueva York.
*   **Auto Break-Even:** Se puede configurar para que, al ganar un número definido de pips, el Stop Loss se mueva a precio de entrada + pips extra para cubrir comisiones.

### FILTRO DE TENDENCIA Y DÍAS
*   **Trend Filter (H1):** El EA evalúa la tendencia macro de H1 utilizando las EMA de 50 y 200 periodos. Si hay un patrón de ruptura alcista, pero H1 es bajista, el EA abortará la operación para protegerte.
*   **Días de Operación:** Tras pruebas empíricas rigurosas (ej. backtests de junio-julio), se ha demostrado que **los viernes son estadísticamente ineficientes** para esta estrategia de continuación. Los viernes el volumen institucional disminuye por los cierres de fin de semana, lo que genera falsas rupturas y toques directos de Stop Loss (pérdidas del 1%). Por el contrario, los **lunes, martes, miércoles y jueves** presentan un rendimiento excelente con un alto porcentaje de acierto. Por lo tanto, la configuración óptima probada es **desactivar los viernes (`TradeFriday = false`) y mantener activos el resto de días (`TradeMonday = true`)**.

---

## 3. Ejemplo Operativo (Compra)

1.  La caja asiática se forma entre las 03:00 y las 09:00 (hora broker verano; en invierno 02:00–08:00, se ajusta automáticamente).
2.  A las 09:15 se cierra una vela M15 por encima del techo de la caja (Ruptura). El EA marca el mínimo de esa vela como su "Zona de Invalidez".
3.  A las 09:30 cierra una pequeña vela bajista roja que no llega a romper la zona de invalidez (Amago/Retroceso).
4.  A las 09:45 cierra una fuerte vela verde alcista, superando el cuerpo de la vela anterior (Confirmación).
5.  El EA ejecuta una **COMPRA**.
6.  Coloca el Stop Loss en la base de la vela original de las 09:15.
7.  A medida que el precio sube, el Trailing Stop asegura las ganancias automáticamente.
