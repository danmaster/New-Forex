# Manual del Expert Advisor: AsianBreakout_100D

Este documento detalla el funcionamiento interno, la lÃ³gica estratÃ©gica y la configuraciÃ³n del robot de trading `AsianBreakout_100D.mq4`, basado en la metodologÃ­a institucional (Smart Money Concepts) de la "Estrategia de los 100$" de Alex Ruiz.

---

## 1. LÃ³gica de OperaciÃ³n (Paso a Paso)

El EA opera de forma 100% autÃ³noma buscando un Ãºnico escenario al dÃ­a (Falsa Ruptura de SesiÃ³n AsiÃ¡tica o *Asian Sweep*). Su ejecuciÃ³n se basa en los siguientes pasos:

1. **IdentificaciÃ³n de la Caja AsiÃ¡tica:** Al llegar la hora de fin de sesiÃ³n (por defecto 08:00), el EA traza internamente el MÃ¡ximo (Techo) y el MÃ­nimo (Suelo) del precio durante las horas asiÃ¡ticas.
2. **Filtro de Volatilidad (TamaÃ±o de Caja):** Antes de operar, el EA mide la caja. Si la distancia entre el techo y el suelo es demasiado pequeÃ±a (ej. menos de 10 pips) o excesivamente grande (ej. mÃ¡s de 50 pips), el EA cancela la operativa del dÃ­a para evitar falsas seÃ±ales o mercados errÃ¡ticos.
3. **DetecciÃ³n de la Trampa (Sweep):** El EA espera a que el precio rompa el techo o el suelo de la caja. Memoriza el punto mÃ¡s lejano que alcanza la mecha de manipulaciÃ³n (`peakHigh` o `troughLow`).
4. **ConfirmaciÃ³n Institucional:** El EA no entra inmediatamente tras la ruptura. Espera a que la vela de 5 minutos termine de formarse. Si el **cuerpo de la vela cierra por dentro de la caja**, confirma la reversiÃ³n.
5. **Filtro de Ratio Riesgo/Beneficio (R:R):** Antes de apretar el gatillo, el EA calcula dÃ³nde irÃ­a el Stop Loss (1 pip por detrÃ¡s de la mecha de manipulaciÃ³n) y dÃ³nde irÃ­a el Take Profit (exactamente en el centro de la caja asiÃ¡tica). Si la ganancia potencial no es, como mÃ­nimo, X veces superior al riesgo (por defecto 2.0), la operaciÃ³n se descarta por no ser matemÃ¡ticamente eficiente.
6. **GestiÃ³n de Riesgo DinÃ¡mica:** Si el ratio es vÃ¡lido, el EA calcula matemÃ¡ticamente cuÃ¡ntos lotes exactos debe abrir para arriesgar Ãºnicamente un porcentaje fijo de tu cuenta (ej. 1%). Da igual si el Stop Loss estÃ¡ a 5 o a 15 pips; la pÃ©rdida monetaria serÃ¡ siempre la misma.
7. **Salida:** Una vez abierta la operaciÃ³n a mercado, el EA coloca automÃ¡ticamente el SL y el TP. La orden se gestionarÃ¡ sola. Solo se permite una operaciÃ³n por dÃ­a, evitando la sobreoperativa y el "revenge trading".

---

## 2. ParÃ¡metros de ConfiguraciÃ³n (Inputs)

A continuaciÃ³n, se explican todos los parÃ¡metros disponibles en las propiedades del EA y el motivo de su existencia:

### Ajustes Generales
*   **`UseDynamicLot` (true/false):** Activa el cÃ¡lculo automÃ¡tico de lotes. *Â¿Por quÃ©?* Para que el riesgo sea siempre el mismo porcentaje de tu cuenta sin importar la distancia en pips del Stop Loss.
*   **`RiskPercent` (1,0):** El porcentaje de tu balance total que estÃ¡s dispuesto a perder por cada operaciÃ³n. *RecomendaciÃ³n:* Mantener entre 1,0% y 2,0%.
*   **`MinRewardRiskRatio` (2,0):** El filtro matemÃ¡tico que impide entrar en malos trades. Si estÃ¡ en 2,0, significa que el EA solo entrarÃ¡ si el Take Profit en pips es al menos el doble de grande que el Stop Loss en pips. *Â¿Por quÃ©?* Evita entrar cuando una vela gigante de confirmaciÃ³n cierra muy profundo dentro de la caja, arruinando el precio de entrada y el ratio.
*   **`FixedLotSize` (0,10):** Lote manual que se usarÃ¡ de respaldo Ãºnicamente si apagas `UseDynamicLot` o hay un fallo de lectura en el servidor del broker.
*   **`WaitCandleClose` (true/false):** Si es `true`, el EA espera a que termine el tiempo de la vela para confirmar la reversiÃ³n con el cierre del cuerpo. Si es `false`, entra de forma agresiva y automÃ¡tica ("al tick") en el milisegundo en que el precio cruza la lÃ­nea de vuelta a la caja.
*   **`MinBoxPips` (10) / `MaxBoxPips` (50):** LÃ­mites de tamaÃ±o de la sesiÃ³n asiÃ¡tica. *Â¿Por quÃ©?* Cajas menores a 10 pips indican un mercado muerto y sin volumen; mayores a 50 pips indican que ya hubo una gran expansiÃ³n en la sesiÃ³n de Asia y es peligroso buscar reversiones (la manipulaciÃ³n ya ocurriÃ³).
*   **`MagicNumber` (100100):** NÃºmero de identificaciÃ³n Ãºnico del EA. Permite al robot distinguir sus propias operaciones de las que tÃº abras manualmente en el mismo grÃ¡fico.
*   **`StartHour` (2) / `EndHour` (8):** Horas del servidor del broker donde se considera el inicio y fin del rango asiÃ¡tico. *Importante:* Debes ajustar estos valores segÃºn el huso horario (GMT) del broker que estÃ©s usando (por defecto estÃ¡n configurados para Skilling).

### Modo de Liquidez
*   **`AutoFindLiquidity` (true/false):** Si es `true`, el EA ejecuta todo el paso a paso descrito arriba de forma totalmente autÃ³noma (Modo Auto-Sweep).
*   **`ManualBoxName` ("ZonaLiquidez"):** Si apagas el modo automÃ¡tico (`AutoFindLiquidity = false`), el EA pasarÃ¡ a Modo SemiautomÃ¡tico. En este modo, el robot no buscarÃ¡ la reversiÃ³n; en su lugar, esperarÃ¡ a que tÃº dibujes un rectÃ¡ngulo en el grÃ¡fico de MetaTrader y lo nombres "ZonaLiquidez". El EA calcularÃ¡ y colocarÃ¡ una orden pendiente lÃ­mite (Buy Limit o Sell Limit) apoyÃ¡ndose en la caja de Asia y en tu rectÃ¡ngulo manual. *Â¿Por quÃ©?* Para los dÃ­as en los que quieras operar un "Bloque de Ã“rdenes" (Order Block) lejano especÃ­fico que tÃº mismo has visto, permitiendo al EA ser un simple ejecutor de tu anÃ¡lisis.

---

## 3. Consideraciones TÃ©cnicas
*   **Pares Recomendados:** DiseÃ±ado y optimizado para **EUR/USD** (el par mÃ¡s lÃ­quido).
*   **Temporalidad (Timeframe):** Es obligatorio anclar el EA al grÃ¡fico de **M5 (5 Minutos)**. El filtro de cierre de vela (`WaitCandleClose`) ejecuta su lÃ³gica basÃ¡ndose en el temporizador del grÃ¡fico donde se encuentra instalado.
*   **Entorno:** El sistema estÃ¡ diseÃ±ado para VPS (servidores virtuales) debido a que monitoriza constantemente la acciÃ³n del precio (`OnTick`) despuÃ©s de las 08:00 hs.

