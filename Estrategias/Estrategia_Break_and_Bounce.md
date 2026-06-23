# Estrategia de Scalping: "Break and Bounce" (Rompe y Rebota)

Esta estrategia, extraída del video "This Simple Scalping Strategy Makes Me Over $10,000/Month", se basa en la acción del precio pura (sin indicadores) y aprovecha la liquidez generada en los máximos y mínimos del día anterior.

## Resumen de la Estrategia
Es un modelo mecánico de 3 pasos que se ejecuta en múltiples temporalidades (Daily, 15m y 5m) durante las primeras 2.5 horas de la apertura del mercado. Busca confirmaciones de falsos rompimientos o re-testeos de niveles clave diarios.

---

## Paso a Paso para la Implementación

### Paso 1: Identificar los Niveles Clave (Gráfico Diario - 1D)
1. Abre el gráfico en temporalidad diaria (1D).
2. Localiza la vela del día anterior.
3. Dibuja una "caja" o marca dos líneas horizontales: una en el **máximo del día anterior** y otra en el **mínimo del día anterior**.
4. Extiende estas líneas hacia la derecha para que cubran el día actual de operativa. 
   - *Fundamento:* Estos niveles representan las zonas donde los compradores y vendedores más fuertes entraron ayer. Por ende, hay mucha liquidez institucional allí.

### Paso 2: Confirmar la Ruptura (Gráfico de 15 Minutos - 15m)
1. Baja a la temporalidad de 15 minutos (15m).
2. Espera a que se produzca una ruptura de la caja que dibujaste en el Paso 1.
3. **Regla de Oro:** Para que la ruptura sea confirmada, una vela completa de 15 minutos **DEBE CERRAR** por encima del máximo (para compras) o por debajo del mínimo (para ventas). Si solo la mecha cruza el nivel, no es válido.

### Paso 3: Entrada Perfecta con el Retesteo (Gráfico de 5 Minutos - 5m)
1. Una vez confirmada la ruptura en 15m, baja al gráfico de 5 minutos (5m).
2. Espera a que el precio regrese y **re-testee** el nivel que acaba de romper (ya sea el máximo o el mínimo del día anterior).
3. Busca **patrones de velas de reversión** en este nivel:
   - **Para Compras (Largo):** Busca un *Hammer* (Martillo) precedido de un movimiento bajista claro, o una vela *Bullish Engulfing* (Envolvente Alcista).
   - **Para Ventas (Corto):** Busca un *Inverted Hammer* (Martillo Invertido) precedido de un movimiento alcista, o una vela *Bearish Engulfing* (Envolvente Bajista).
4. **Filtro de Tiempo:** Esto DEBE ocurrir dentro de las primeras **2.5 horas desde la apertura del mercado**. Si ocurre después, se descarta el trade.

### Ejecución del Trade
- **Entrada (Hammer/Martillo):** Entra en la ruptura del nivel máximo del martillo.
- **Entrada (Engulfing/Envolvente):** Puedes entrar en cuanto el precio supere el máximo/mínimo de la vela anterior que está siendo envuelta.
- **Stop Loss (SL):** Se coloca justo por debajo de la mecha inferior del patrón (para compras) o por encima de la mecha superior (para ventas).
- **Take Profit (TP):** Fija un objetivo de beneficios de **2 a 3 veces** la distancia de tu Stop Loss (Ratio Riesgo/Beneficio de 1:2 o 1:3).
- *Nota Adicional:* Si el trade sigue abierto al cierre del mercado (final del día), ciérralo manualmente.

---

## Evaluación de la Estrategia: ¿Es ganadora?

**Conclusión:** Sí, teóricamente es una estrategia ganadora, robusta y con mucho sentido institucional, pero requiere disciplina férrea.

### Puntos Fuertes (Por qué funciona):
1. **Lógica de Mercado (Liquidez):** Al operar los altos y bajos del día previo, te estás sumando a donde se inyecta el verdadero volumen del mercado.
2. **Filtrado del Ruido:** Al exigir un cierre de vela de 15 minutos para la ruptura, y luego bajar a 5 minutos para afinar la entrada, te protege de la mayoría de los "fakeouts" (falsos rompimientos bruscos).
3. **Gestión de Riesgo (R:R):** Al tener un stop loss ajustado (basado en la mecha de una vela de 5 minutos) y buscar un Take Profit de 1:2 o 1:3, la esperanza matemática del sistema es altísima.
4. **Mecánica y Objetiva:** No depende de indicadores rezagados ni interpretaciones subjetivas. Se rompe el nivel, cierra la vela, re-testea, deja patrón = entras.

### Estadísticas del Autor:
Según el autor del vídeo (que programó un algoritmo para backtestearla durante meses), la estrategia tiene un **Win Rate del 70%** y un **Profit Factor de 1.6**. 

### Aspectos a Tener en Cuenta (Precauciones):
- **Baja Frecuencia:** Al ser tan estricta (retesteo y patrón de reversión en las primeras 2.5 horas), puede que un activo solo dé 2 o 3 entradas al mes. Necesitarás escanear varios activos diariamente.
- **Depende del activo:** Ideal para activos con buena liquidez en apertura (ej. Índices americanos en sesión NY o pares mayores en sesión Londres/NY).

*Recomendación final:* Backtestea la estrategia con al menos 100 operaciones en un activo específico (como EURUSD, GBPUSD o US100) para adaptarla a tus horarios y conocer la distribución real de las ganancias/pérdidas.
