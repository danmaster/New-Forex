# TO-DO para Asian_V2.70 y Futuras Versiones

## Revision V2.70 (Alex Ruiz coherence + bughunt) - 2026-08-06

Se revisó `Experts/Asian_V2.70.mq4` en profundidad, comprobando la
coherencia con la estrategia de Alex Ruiz
(`Estrategias/Asian_Breakout/Transcripcion_video.md`) y eliminando
código muerto de versiones anteriores.

### Bugs arreglados (en Asian_V2.70.mq4)
1. **Deadlock `WaitForBreakout` con filtro de tendencia OFF.** El EA exigía
   romper AMBOS bordes de la caja a la vez (`Bid > techo && Ask < suelo`),
   condición imposible, por lo que el día se quemaba sin colocar nada. Ahora
   espera a que rompa CUALQUIERA de los dos bordes y opera solo ese lado.
2. **Market Fallback en dirección equivocada.** Decidía la dirección por los
   flags `doSell`/`doBuy` en vez del runaway real (`sellRunaway`/
   `buyRunaway`). Con filtro OFF, una ruptura escapada hacia ABAJO entraba a
   SELL a mercado (contra el movimiento). Ahora la dirección la decide el
   runaway concreto.
3. **Compilación rotas por `if(false)` muertos.** Bloques de `OnInit` que
   referían variables inexistentes (`BreakEvenActivation`, `TrailingPips`,
   `UseAutoBreakEven`, etc.) de versiones anteriores. Eliminados.

### Código muerto eliminado
- Arrays/helpers `g_lock*`, `GetLockIndexBy*`, `RemoveLockIndex` (nunca usados
  en V2.70; pertenecían al lock por pendiente de salida de V2.67).
- Validaciones sin sentido (`1.5 <= 0`, `0.5 < 0`) y forward-declaration de
  `RegisterInitialRisk` (no existe en V2.70).
- Comentarios huérfanos de BE/trailing/Escalonado y ramas `if(false)` del TP
  estructural en modo manual (se mantiene TP estructural).
- Comentario de cabecera obsoleto (reescrito como V2.70).

### Coherencia con Alex Ruiz
La lógica encaja con la estrategia: caja asiática 00:00-06:00 GMT, entrada
pendiente al INICIO de la zona de liquidez EXTERNA (no dentro de la caja),
TP en el extremo opuesto de la caja, SL sobre el nivel barrido + distancia
externa, espera a la ruptura antes de colocar la Limit y filtro de tendencia
a favor. El Cierre Virtual no capa el TP estructural ni modifica el SL del
ticket, alineado con la gestión purista de Alex.

## Ajustes Ya Aplicados (V2.70)
*   **Cierre Virtual (Virtual Ladder):** Reemplazados los Stop de protección por un sistema de vigilancia en memoria que esquiva los límites de los brokers.
*   **Parche de Riesgo en Market Fallback:** Arreglado un bug que asignaba el lotaje calculado para la orden Limit a las órdenes de Mercado (lo que generaba pérdidas superiores al 1% cuando el Stop Loss estaba muy lejos).

## Ideas de Optimización Pendientes (Dilema de Primavera)

### 1. Filtro de Momentum en el Judas Swing (Ruptura Asiática)
Actualmente, el EA ejecuta la orden Limit incluso si la ruptura asiática se produce por "sangrado lento" (velitas pequeñas, sin fuerza), lo que a menudo indica una tendencia real lenta en lugar de una trampa de liquidez.
*   **Acción:** Investigar la implementación de un filtro que mida el tamaño o volumen de la vela que rompe la caja (vela "decidida"). Si la ruptura no se hace con fuerza, se cancela la búsqueda de la zona de liquidez.

### 2. Filtro de Entrada por Confirmación (Vela Gatillo)
La estrategia actual usa órdenes `Limit` (entrada ciega). En días de fuerte tendencia (como el 6 y el 16 de Abril de 2026), el mercado atraviesa la zona institucional de largo sin hacer siquiera un retroceso.
*   **Acción:** Evaluar cambiar la lógica de órdenes pendientes a una entrada a Mercado **solo** tras la formación de una vela de rechazo o patrón de reversión claro dentro de la zona morada.
*   *Nota de riesgo:* Este cambio estructural es grande y anula el concepto de "francotirador" original, pero protegería al EA de rupturas continuas que no respetan el Fakeout.

## Decision sobre las ideas pendientes (recomendación del revisor)
*   **Idea 1 (filtro de momentum):** NO aplicar de forma predeterminada. El
  filtro de tendencia (EMA 200 H1) + `ExternalSLDistancePips` (12) +
  `Market Fallback` ya actúan como filtros de calidad implícitos y la
  estrategia de Alex no filtra por fuerza de ruptura. Aplicar un filtro de
  momentum requeriría decidir el umbral y podría descartar rupturas de caja
  lentas pero válidas. Proponer como `input` opcional solo si se valida en
  backtest diferenciado.
*   **Idea 2 (entrada a mercado post-vela):** NO aplicar. Contradice la
  estrategia de Alex: él coloca la orden Limit en el momento de la ruptura y
  la zona de liquidez es la entrada. Cambiar a mercado + vela de rechazo
  anula el concepto de francotirador y la zona de liquidez externa. Se
   mantiene como documentación de riesgo.

## Tuning V2.70b (post-regresión) - 2026-08-06
Comparativa `Asian_V2.70_1.htm` (regresión) vs `Asian_V2.70_2.htm` (baseline restaurado):
- La única diferencia operativa fue `VirtualLadderStepRR`/`VirtualLadderBE_RR` 1.0 -> 2.0. No fue "descapado" real (el ladder rara vez se activa, RR estructural ~1.4-2.1): dejó correr 4 trades que a 1R se bloqueaban -> pasaron de 13W/8L a 9W/12L. Neto 556 -> 194, DD 5.53% -> 8.80%, PF 1.66 -> 1.16. **Regresión confirmada y revertida a 1.0/1.0.**
- `PauseAfterLossStreak` agregado (default 0, OFF). No habilitado: con `MaxTradesPerDay=1` salta días vacíos y su chequeo diario de historia tiene bug de lockout (se re-pausa cada día si no hay un win para resetear el streak). Pendiente reescribir con contador en memoria + cooldown fijo.
- `MinRR` 1.2 -> **1.5** (valor V2.63) aplicado para paliar la racha de SL de rango. Proyección trade-by-trade (`Asian_V2.70_2.htm`): rechaza Feb-25 (+102.6, WIN) + Apr-06 (-108, LOSS) + Jun-09 (-104.4, LOSS). Neto +556 -> ~+666, PF 1.66 -> ~2.06, racha 5 -> 3 (-529 -> -317), DD ~604 -> ~450. Validar en `Asian_V2.70_3.htm`.

