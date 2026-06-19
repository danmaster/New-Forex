# Manual del Expert Advisor: AsianBreakout_100D

Este documento detalla el funcionamiento interno, la lógica estratégica y la configuración del robot de trading `AsianBreakout_100D.mq4`, basado en la metodología institucional (Smart Money Concepts) de la "Estrategia de los 100$" de Alex Ruiz.

---

## 1. Lógica de Operación (Paso a Paso)

El EA opera de forma 100% autónoma buscando un único escenario al día (Falsa Ruptura de Sesión Asiática o *Asian Sweep*). Su ejecución se basa en los siguientes pasos:

1. **Identificación de la Caja Asiática:** Al llegar la hora de fin de sesión (por defecto 08:00), el EA traza internamente el Máximo (Techo) y el Mínimo (Suelo) del precio durante las horas asiáticas.
2. **Filtro de Volatilidad (Tamaño de Caja):** Antes de operar, el EA mide la caja. Si la distancia entre el techo y el suelo es demasiado pequeña (ej. menos de 10 pips) o excesivamente grande (ej. más de 50 pips), el EA cancela la operativa del día para evitar falsas señales o mercados erráticos.
3. **Detección de la Trampa (Sweep):** El EA espera a que el precio rompa el techo o el suelo de la caja. Memoriza el punto más lejano que alcanza la mecha de manipulación (`peakHigh` o `troughLow`).
4. **Confirmación Institucional:** El EA no entra inmediatamente tras la ruptura. Espera a que la vela de 5 minutos termine de formarse. Si el **cuerpo de la vela cierra por dentro de la caja**, confirma la reversión.
5. **Filtro de Ratio Riesgo/Beneficio (R:R):** Antes de apretar el gatillo, el EA calcula dónde iría el Stop Loss (1 pip por detrás de la mecha de manipulación) y dónde iría el Take Profit (exactamente en el centro de la caja asiática). Si la ganancia potencial no es, como mínimo, X veces superior al riesgo (por defecto 2.0), la operación se descarta por no ser matemáticamente eficiente.
6. **Gestión de Riesgo Dinámica:** Si el ratio es válido, el EA calcula matemáticamente cuántos lotes exactos debe abrir para arriesgar únicamente un porcentaje fijo de tu cuenta (ej. 1%). Da igual si el Stop Loss está a 5 o a 15 pips; la pérdida monetaria será siempre la misma.
7. **Salida:** Una vez abierta la operación a mercado, el EA coloca automáticamente el SL y el TP. La orden se gestionará sola. Solo se permite una operación por día, evitando la sobreoperativa y el "revenge trading".

---

## 2. Parámetros de Configuración (Inputs)

A continuación, se explican todos los parámetros disponibles en las propiedades del EA y el motivo de su existencia:

### Ajustes Generales
*   **`UseDynamicLot` (true/false):** Activa el cálculo automático de lotes. *¿Por qué?* Para que el riesgo sea siempre el mismo porcentaje de tu cuenta sin importar la distancia en pips del Stop Loss.
*   **`RiskPercent` (1.0):** El porcentaje de tu balance total que estás dispuesto a perder por cada operación. *Recomendación:* Mantener entre 1.0% y 2.0%.
*   **`MinRewardRiskRatio` (2.0):** El filtro matemático que impide entrar en malos trades. Si está en 2.0, significa que el EA solo entrará si el Take Profit en pips es al menos el doble de grande que el Stop Loss en pips. *¿Por qué?* Evita entrar cuando una vela gigante de confirmación cierra muy profundo dentro de la caja, arruinando el precio de entrada y el ratio.
*   **`FixedLotSize` (0.10):** Lote manual que se usará de respaldo únicamente si apagas `UseDynamicLot` o hay un fallo de lectura en el servidor del broker.
*   **`WaitCandleClose` (true/false):** Si es `true`, el EA espera a que termine el tiempo de la vela para confirmar la reversión con el cierre del cuerpo. Si es `false`, entra de forma agresiva y automática ("al tick") en el milisegundo en que el precio cruza la línea de vuelta a la caja.
*   **`MinBoxPips` (10) / `MaxBoxPips` (50):** Límites de tamaño de la sesión asiática. *¿Por qué?* Cajas menores a 10 pips indican un mercado muerto y sin volumen; mayores a 50 pips indican que ya hubo una gran expansión en la sesión de Asia y es peligroso buscar reversiones (la manipulación ya ocurrió).
*   **`MagicNumber` (100100):** Número de identificación único del EA. Permite al robot distinguir sus propias operaciones de las que tú abras manualmente en el mismo gráfico.
*   **`StartHour` (2) / `EndHour` (8):** Horas del servidor del broker donde se considera el inicio y fin del rango asiático. *Importante:* Debes ajustar estos valores según el huso horario (GMT) del broker que estés usando (por defecto están configurados para Skilling).

### Modo de Liquidez
*   **`AutoFindLiquidity` (true/false):** Si es `true`, el EA ejecuta todo el paso a paso descrito arriba de forma totalmente autónoma (Modo Auto-Sweep).
*   **`ManualBoxName` ("ZonaLiquidez"):** Si apagas el modo automático (`AutoFindLiquidity = false`), el EA pasará a Modo Semiautomático. En este modo, el robot no buscará la reversión; en su lugar, esperará a que tú dibujes un rectángulo en el gráfico de MetaTrader y lo nombres "ZonaLiquidez". El EA calculará y colocará una orden pendiente límite (Buy Limit o Sell Limit) apoyándose en la caja de Asia y en tu rectángulo manual. *¿Por qué?* Para los días en los que quieras operar un "Bloque de Órdenes" (Order Block) lejano específico que tú mismo has visto, permitiendo al EA ser un simple ejecutor de tu análisis.

---

## 3. Consideraciones Técnicas
*   **Pares Recomendados:** Diseñado y optimizado para **EUR/USD** (el par más líquido).
*   **Temporalidad (Timeframe):** Es obligatorio anclar el EA al gráfico de **M5 (5 Minutos)**. El filtro de cierre de vela (`WaitCandleClose`) ejecuta su lógica basándose en el temporizador del gráfico donde se encuentra instalado.
*   **Entorno:** El sistema está diseñado para VPS (servidores virtuales) debido a que monitoriza constantemente la acción del precio (`OnTick`) después de las 08:00 hs.
