# TO-DO para Asian_V2.70 y Futuras Versiones

## Ideas de Optimización Pendientes (Dilema de Primavera)

### 1. Filtro de Momentum en el Judas Swing (Ruptura Asiática)
Actualmente, el EA ejecuta la orden Limit incluso si la ruptura asiática se produce por "sangrado lento" (velitas pequeñas, sin fuerza), lo que a menudo indica una tendencia real lenta en lugar de una trampa de liquidez.
*   **Acción:** Investigar la implementación de un filtro que mida el tamaño o volumen de la vela que rompe la caja (vela "decidida"). Si la ruptura no se hace con fuerza, se cancela la búsqueda de la zona de liquidez.

### 2. Filtro de Entrada por Confirmación (Vela Gatillo)
La estrategia actual usa órdenes `Limit` (entrada ciega). En días de fuerte tendencia (como el 6 y el 16 de Abril de 2026), el mercado atraviesa la zona institucional de largo sin hacer siquiera un retroceso.
*   **Acción:** Evaluar cambiar la lógica de órdenes pendientes a una entrada a Mercado **solo** tras la formación de una vela de rechazo o patrón de reversión claro dentro de la zona morada.
*   *Nota de riesgo:* Este cambio estructural es grande y anula el concepto de "francotirador" original, pero protegería al EA de rupturas continuas que no respetan el Fakeout.

## Ajustes Ya Aplicados (V2.70)
*   **Cierre Virtual (Virtual Ladder):** Reemplazados los Stop de protección por un sistema de vigilancia en memoria que esquiva los límites de los brokers.
*   **Parche de Riesgo en Market Fallback:** Arreglado un bug que asignaba el lotaje calculado para la orden Limit a las órdenes de Mercado (lo que generaba pérdidas superiores al 1% cuando el Stop Loss estaba muy lejos).
