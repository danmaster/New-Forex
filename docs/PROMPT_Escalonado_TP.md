## PROMPT

Estoy manteniendo un EA de ruptura asiática escrito en MQL4: `Experts/Asian_V2.51.mq4`. Funciona en M5, abre una sola operación al día tras un barrido de la caja asiática (Judas Swing / SMC), y actualmente usa **TP fijo 1:3** (input `UseFixedRR = true`, `FixedRiskReward = 3.0`) o, en su defecto, trailing stop por pips fijos.

### Problema que quiero resolver

En backtesting estoy **perdiendo muchas operaciones** que sí llegan a 1:1 e incluso a 1:2 de beneficio, pero que luego **se giran y terminan en SL** mientras yo esperaba el TP completo de 1:3. Esa es la razón principal por la que el profit factor está por debajo de lo esperado.

### Lógica que necesito que implementes (es SIMÉTRICA para BUY y SELL)

Para **cada posición abierta** del EA (MagicNumber `MagicNumber`, símbolo actual), haz el siguiente seguimiento usando dos flags booleanos por ticket (almacénalos en arrays globales como ya se hace con `g_mgmtTickets[]` / `g_mgmtBEDone[]`; reutiliza esa misma estructura):

1. **Calcular el riesgo inicial en pips** al abrir la posición: `riskPips = MathAbs(OrderOpenPrice() - OrderStopLoss()) / Pip`. Si el SL se ha movido por la gestión interna, el riesgo inicial sigue siendo el calculado en la apertura. Rehidrata este dato al iniciar el EA (`OnInit`) igual que ya se hace con `RegisterInitialRisk`.
2. **Estado 0 (recién abierta):** la operación no ha alcanzado 1:1 todavía. No tocar nada distinto al comportamiento actual (SL y TP fijos originales).
3. **Estado 1 (alcanzó 1:1, `flag1alcanzado = true`):** en cuanto `profitPips >= 1.0 * riskPips`, **mueve el StopLoss a Break-Even + buffer** (`OrderOpenPrice() + BreakEvenExtraPips * Pip` para BUY, `OrderOpenPrice() - BreakEvenExtraPips * Pip` para SELL). A partir de aquí la operación ya no puede salir en pérdida, sólo en BE o con ganancias. **NO toques el TP aún.**
4. **Estado 2 (alcanzó 1:2, `flag2alcanzado = true`):** en cuanto `profitPips >= 2.0 * riskPips` **estando el flag1 ya activo**, **reduce el TP al nivel 1:2** (`OrderOpenPrice() + 2 * riskPips * Pip` para BUY, análogo para SELL). Esto significa: si la operación llega a 1:2, **se cierra inmediatamente con OrderClose** a ese precio (no esperes a ver si llega a 1:3). Cuando ejecutes el cierre, imprime log con el ticket, profit en pips y profit en dinero, y resetea los flags para ese ticket.
5. Si entre el 1:1 y el 1:2 el precio **revierte y solo vuelve a tocar el BE** (profit ≈ 0), la operación sale en break-even gracias al SL movido en el paso 3 → **resultado: ganancia cero, no pérdida**. Esto ya lo gestionará el SL que moviste, no necesitas código adicional.
6. Si **nunca llega al 1:1** y se gira, el SL original cierra la posición en pérdida como hasta ahora.

### Resumen del comportamiento buscado

| Escenario | Resultado |
|---|---|
| Sube hasta 1:1 y revierte | Cierra en BE (sin pérdida) |
| Sube hasta 1:1, sigue hasta 1:2 y luego cierra por SL/TP | Cierra con +1R |
| Sube hasta 1:1, sigue hasta 1:2, **se cierra por el TP recolocado a 1:2** | Cierra con +2R (ganancia asegurada) |
| Sube más allá de 1:2 sin que se haya recolocado el TP | Anomalía — recoloca el TP a 1:2 y deja correr; si sigue, idealmente ir a 1:3, PERO **prioridad absoluta es asegurar el 1:2**, nunca ir a pérdida |
| Nunca llega a 1:1 y se gira | Cierra en SL original (-1R) |

> Nota: en este diseño **prefiero asegurar 2R a buscar 3R ocasionalmente**. El TP de 1:3 se mantiene como input, pero solo se aplica si el input `UseFixedRR` está en true y el modo `UseEscalonadoTP` está desactivado. Si `UseEscalonadoTP = true`, **el TP fijo deja de existir** y se sustituye por la lógica de cierre a 1:2 descrita.

### Requisitos técnicos

- **No** rompas la lógica de `UseBreakEvenAt1R` que ya existe; el modo escalonado debe ser **mutuamente excluyente** con él (si `UseEscalonadoTP = true`, ignora `UseBreakEvenAt1R`).
- El nuevo modo debe llamarse **`UseEscalonadoTP`** (input bool) y consumir **tres inputs nuevos**:
  - `EscalonadoRR1` (double, default `1.0`) → ratio del primer escalón
  - `EscalonadoRR2` (double, default `2.0`) → ratio donde se cierra
  - `BreakEvenExtraPips` ya existe, **reutilízalo**.
- Toda la gestión debe correr desde `OnTick()`, llamando a una nueva función `ManageEscalonadoTP()` justo al inicio, antes que `ManagePartialClose()` y de los `ManageAutoBreakEven / ManageTrailingStop / ManageBreakEvenAt1R` actuales.
- Si `OnInit()` detecta posiciones vivas del EA con MagicNumber `MagicNumber`, **rehidrata los flags desde el precio actual**: si el profit ya está en zona de 1:1 ó 1:2, marca los flags correspondientes para que el siguiente tick no deje la operación sin protección.
- **Cuidado con `OrderModify` y `OrderClose`**: respeta `MODE_STOPLEVEL` y el `Digits` del símbolo. Si el TP recalculado está demasiado cerca del precio, avisa con Print en lugar de enviar una orden que el broker rechace.
- **No** introduzcas nuevas dependencias externas. Todo debe funcionar igual que el resto del EA (5 dígitos, Pip = 10 * Point en brokers de 5 dígitos, etc.).
- Logs claros en español, una línea por evento: `Escalado 1:1 alcanzado en ticket #X`, `Escalado TP recolocado a 1:2 en ticket #X`, `Escalado cierre en 1:2 ejecutado en ticket #X, profit = YY USD`.

### Entregables

1. El código MQL4 listo para pegar dentro de `Experts/Asian_V2.51.mq4`, indicando exactamente:
   - Bloque de inputs a añadir (línea aproximada).
   - Variables globales a añadir junto a `g_mgmtTickets[]` / `g_mgmtBEDone[]`.
   - Nueva función `ManageEscalonadoTP()` completa.
   - Modificaciones necesarias en `OnInit()` para rehidratar flags.
   - Modificaciones necesarias en `OnTick()` para llamar a la función.
2. Una explicación breve (1 párrafo) de por qué esta lógica debería mejorar el profit factor del EA.
3. Una lista de **riesgos o efectos colaterales** conocidos de la lógica (p. ej.: reentrada el mismo día tras cerrar a 1:2 + ¿bloqueo por `HasActiveTrades`? ¿reentrada permitida? — confirma el comportamiento esperado y propón la solución).

No necesito el indicador, sólo el código del EA. El EA actual está en `C:\Users\rhood\Desktop\New-Forex\Experts\Asian_V2.51.mq4`. Mantén el estilo de comentarios del archivo original (cabecera con `+---+`, `Print()` para logs, `NormalizeDouble(..., Digits)` para precios, estructura `if(OrderSelect(...))` para iterar órdenes).

---

## Notas internas mías (no van al prompt)

- La idea es **asegurar 1R como mínimo después del 1:1**, y **asegurar 2R al llegar a 1:2 recolocando el TP**. Esto convierte lo que era un sistema "win big o lose small" en un sistema "win 1R / win 2R / ocasionalmente 3R".
- El input `BreakEvenExtraPips` ya existe (default 1 pip) — sirve de buffer de comisiones, perfecto.
- Tamaño de arrays: ya hay `g_mgmtTickets[200]`. Añadir flags adicionales del mismo tamaño no es problema.
- Considerar pedirle a la IA que también respete `MaxTradesPerDay`: si la operación se cierra a 1:2 y aún no alcanzamos `MaxTradesPerDay`, ¿queremos reentrada? Decisión por defecto: **no**, mantengo `HasActiveTrades` liberando ese slot solo cuando cierre la posición (sea por TP a 1:2, sea por SL original). Eso encaja con el comportamiento actual.
- Documento generado el 2026-08-04 para acompañar `Asian_V2.51.mq4` (versión que introduce DST automático y gestión anti-ruido NY).
