# Análisis del EA `Anti_Asian_V1.0.mq4`

> Documento generado a partir de la lectura directa del archivo `Experts/Anti_Asian_V1.0.mq4`. No se ha modificado el código fuente.

## 1. Identificación

| Campo | Valor |
|---|---|
| Archivo en disco | `Experts/Anti_Asian_V1.0.mq4` |
| Nombre interno (cabecera) | `anti_asian_breakout_V1.0.mq4` |
| Versión declarada (`#property version`) | `1.00` (MQL4 limita a 2 decimales) |
| Copyright | `Antigravity AI` |
| Plataforma | MetaTrader 4 (MQL4) |
| Modo de compilación | `#property strict` |
| Magic Number | `200200` (lo distingue del EA hermano "Asian Breakout") |

> ⚠️ **Aviso de nomenclatura:** el archivo en disco se llama `Anti_Asian_V1.0.mq4`, pero el nombre declarado dentro del código fuente sigue siendo `anti_asian_breakout_V1.0.mq4`. Ambos se refieren al mismo EA.

## 2. Propósito

Expert Advisor de **anti-ruptura de la sesión asiática** sobre M15. En lugar de seguir la primera ruptura del rango asiático, **detecta rupturas falsas (Judas Swing / fakeouts)** y entra a favor del **movimiento real posterior** (continuación).

## 3. Parámetros de entrada

### 3.1 Ajustes generales

| Parámetro | Default | Función |
|---|---|---|
| `UseDynamicLot` | `true` | Activa lote dinámico por riesgo % |
| `RiskPercent` | `1.0` | % del balance arriesgado por operación |
| `InpSendPush` | `true` | Envía notificaciones push al móvil |
| `FixedLotSize` | `0.10` | Lote fijo si el dinámico está desactivado |
| `MinBoxPips` | `10` | Tamaño mínimo de la caja asiática |
| `MaxBoxPips` | `50` | Tamaño máximo de la caja asiática |
| `MagicNumber` | `200200` | Identificador de operaciones del EA |
| `StartHour` | `2` | Inicio de la sesión Asia (02:00 hora Skilling) |
| `EndHour` | `8` | Fin de la sesión Asia (08:00) |
| `MaxEntryHour` | `18` | Hora tope para cazar la ruptura |

### 3.2 Filtro de días

| Día | Permitido por defecto |
|---|---|
| Lunes | ✅ |
| Martes | ✅ |
| Miércoles | ✅ |
| Jueves | ✅ |
| Viernes | ❌ |

### 3.3 Objetivos de beneficio

| Parámetro | Default | Función |
|---|---|---|
| `FixedRiskReward` | `3.0` | Ratio R:R fijo cuando se usa TP por ratio |
| `UseFixedRR` | `false` | Activa TP por ratio (1:3). Sobrescribe el trailing |

### 3.4 Trailing Stop

| Parámetro | Default | Función |
|---|---|---|
| `UseTrailingStop` | `true` | Activa trailing stop (default en modo continuación) |
| `TrailingPips` | `15` | Distancia del trailing al precio |

### 3.5 Stop Loss

| Parámetro | Default | Función |
|---|---|---|
| `MinSLPips` | `5` | SL mínimo en pips |

### 3.6 Gestión de operaciones

| Parámetro | Default | Función |
|---|---|---|
| `UseAutoBreakEven` | `true` | Activa break-even automático |
| `BreakEvenActivation` | `15` | Pips de ganancia para activar BE |
| `BreakEvenExtraPips` | `1` | Pips extra sobre el SL para cubrir comisiones |
| `UsePartialClose` | `false` | Activa cierre parcial automático |
| `PartialClosePips` | `15` | Pips de ganancia para cierre parcial |
| `PartialClosePercent` | `50.0` | % del lote original a cerrar |
| `MaxTradesPerDay` | `1` | Máximo de operaciones por día (modo continuación) |
| `CloseAtEndOfDay` | `false` | Cierra todo a las 23:00 |

### 3.7 Modo continuación (SMC)

| Parámetro | Default | Función |
|---|---|---|
| `MinBreakoutTotalPips` | `5.0` | Mínimo de pips totales de la vela de ruptura (`0` desactiva) |
| `MinBreakoutBodyPips` | `2` | Mínimo de pips del cuerpo de la vela M15 de ruptura |
| `MaxPullbackIntoBoxPercent` | `40.0` | % máximo que el pullback puede meterse en la caja (estricto) |
| `MaxPatternBars` | `8` | Velas M15 máximas para completar el patrón |

### 3.8 Filtro de tendencia

| Parámetro | Default | Función |
|---|---|---|
| `UseTrendFilter` | `true` | Activa filtro EMA (modo Auto) |
| `TrendTF` | `PERIOD_H1` | Temporalidad de tendencia |
| `FastEMAPeriod` | `50` | Periodo EMA rápida |
| `SlowEMAPeriod` | `200` | Periodo EMA lenta |

## 4. Arquitectura interna

### 4.1 Variables globales de estado

- `lastTradeDay` / `currentSessionDay` — controlan resets diarios y límites por día.
- `Pip` — factor de conversión punto→pip (`10*Point` en brokers 3/5 dígitos).
- `stateLong` / `stateShort` — máquina de estados por lado:
  - `0` = IDLE
  - `1` = BREAKOUT (ruptura genuina detectada)
  - `2` = PULLBACK (amago detectado, esperando confirmación)
- `longBreakoutLow` / `shortBreakoutHigh` — referencia para SL base.
- `timeLongBreakout` / `timeShortBreakout` — marca temporal de la ruptura.
- `g_partialClosedTickets[100]` y `g_partialClosedCount` — control de cierres parciales ya aplicados.

### 4.2 Funciones auxiliares

| Función | Responsabilidad |
|---|---|
| `GetDateKey(datetime)` | Devuelve clave `AAAAMMDD` para comparar días. |
| `CalculateLotSize(slPips)` | Lote dinámico: `riskAmount / (slPoints * tickValue)`, normalizado a `lotStep` y acotado a `minLot`/`maxLot`. |
| `ManageTrailingStop()` | Mueve SL cuando el precio ha avanzado `TrailingPips` a favor. **No se ejecuta si `UseFixedRR=true`** (FIX #2). |
| `ManageAutoBreakEven()` | Cuando el precio alcanza `BreakEvenActivation` pips, lleva el SL a `OpenPrice ± BreakEvenExtraPips`. |
| `IsAlreadyPartiallyClosed(ticket)` | Comprueba si un ticket ya pasó por cierre parcial. |
| `ManagePartialClose()` | Al alcanzar `PartialClosePips` pips, cierra el `PartialClosePercent` del lote. Excluye tickets generados por `OrderClose` (`"from #"`). |
| `IsTrendAligned(isBuy)` | BUY si `EMA50>EMA200` y precio > `EMA200`; SELL en espejo. |
| `GetTradesTodayCount()` | Cuenta operaciones únicas del día en activas + historial (deduplicando por tiempo + tipo). |
| `HasActiveTrades()` | `true` si hay posición abierta con este magic y símbolo. |

## 5. Lógica de trading (paso a paso)

### 5.1 OnTick (orden de ejecución)

1. `ManageTrailingStop()`
2. `ManageAutoBreakEven()`
3. `ManagePartialClose()`
4. **Cierre de fin de día** (si `currentHour >= 23` y `CloseAtEndOfDay=true`)
5. **Cierre de fin de semana** (viernes 22:00, **incondicional**, no depende del flag anterior)
6. Si `GetTradesTodayCount() >= MaxTradesPerDay` **o** `HasActiveTrades()` → `return`
7. Si estamos entre `EndHour` y `MaxEntryHour` → evaluar patrones.

### 5.2 Construcción de la caja asiática

- `timeStart = inicio_día + StartHour*3600`
- `timeEnd   = inicio_día + EndHour*3600`
- Se toman `barsCount = shiftStart - shiftEnd + 1` velas M15 (excluye la vela de las 08:00).
- `asianHigh` / `asianLow` = máximo/mínimo de esa ventana.
- Si el tamaño de la caja queda fuera de `[MinBoxPips, MaxBoxPips]`, se marca el día como `lastTradeDay` y se aborta.

### 5.3 Reset diario

Al cambiar `currentDay` (y sin trades activos):

- `stateLong = stateShort = 0`
- `g_partialClosedCount = 0`
- `currentSessionDay = currentDay`

### 5.4 Invalidación de patrón (Anti-Judas)

En cada nueva vela M15 (`isNewBarM15`):

- Si han pasado más de `MaxPatternBars` desde la ruptura → patrón cancelado.
- Si el precio rompe el extremo guardado (`lowM15 < longBreakoutLow` o `highM15 > shortBreakoutHigh`) → patrón cancelado.
- **Anti-Judas:** si el pullback entra más de `MaxPullbackIntoBoxPercent=40%` dentro de la caja → Judas Swing → cancelación instantánea.

> **FIX #1 (crítico):** al invalidar, se marca `longInvalidatedThisBar` / `shortInvalidatedThisBar`. Esto impide que, **en la misma vela**, el bloque "Paso 1" reactive un patrón nuevo usando los datos de la vela sucia.

### 5.5 Patrón LONG (ruptura alcista)

| Estado | Condición de transición | Acción |
|---|---|---|
| `0` IDLE | `closeM15 > asianHigh`, `bodyPips >= MinBreakoutBodyPips` y `totalPips >= MinBreakoutTotalPips` | → `1` BREAKOUT. Guarda `longBreakoutLow = lowM15` y `timeLongBreakout`. |
| `1` BREAKOUT | `closeM15 < openM15` (amago bajista) | → `2` PULLBACK. |
| `2` PULLBACK | `closeM15 > openM15` y `closeM15 > openM15 de hace 2 velas` | **Entrada BUY** (si la tendencia lo permite). |

### 5.6 Patrón SHORT (ruptura bajista)

Espejo del LONG:

| Estado | Condición de transición | Acción |
|---|---|---|
| `0` IDLE | `closeM15 < asianLow` con cuerpo y rango mínimos | → `1` BREAKOUT. Guarda `shortBreakoutHigh = highM15`. |
| `1` BREAKOUT | `closeM15 > openM15` (amago alcista) | → `2` PULLBACK. |
| `2` PULLBACK | `closeM15 < openM15` y `closeM15 < openM15 de hace 2 velas` | **Entrada SELL** (si la tendencia lo permite). |

## 6. Ejecución de órdenes

Para una **BUY**:

```text
slPips  = (Ask - longBreakoutLow) / Pip
slPips  = max(slPips, MinSLPips)
sl      = Ask - slPips * Pip
lot     = CalculateLotSize(slPips)
tp      = (UseFixedRR) ? Ask + slPips * Pip * FixedRiskReward : 0
OrderSend(Symbol(), OP_BUY, lot, Ask, 3, sl, tp, "Anti-Breakout Buy", MagicNumber, 0, clrBlue)
```

Para una **SELL** es el espejo, con `"Anti-Breakout Sell"` y `clrRed`.

Tras una entrada exitosa: `lastTradeDay = currentDay`, estado a 0, push notification.

## 7. Filtros y protecciones (resumen)

| Capa | Regla | Objetivo |
|---|---|---|
| Caja asiática | Tamaño entre `MinBoxPips` y `MaxBoxPips` | Evitar cajas sin interés o demasiado ruidosas. |
| Días | Lunes–Jueves (viernes off) | Evitar baja liquidez y gaps de fin de semana. |
| Hora de entrada | Solo entre `EndHour` y `MaxEntryHour` | Cazar el movimiento post-Asia sin entrar tarde. |
| **Anti-Judas** | Pullback > 40% de la caja → cancela | Evitar tomar la ruptura falsa como señal. |
| Caducidad | > `MaxPatternBars=8` velas → cancela | Evitar señales zombies. |
| **Tendencia** | EMAs 50/200 en H1 alineadas | Solo operar a favor del sesgo macro. |
| **Máx. trades/día** | 1 | Disciplina "una buena entrada al día". |
| **Cierre viernes 22:00** | Incondicional | Anti-gap. |
| **Cierre 23:00** | Opcional | Time stop. |

## 8. Gestión de la posición abierta

- **Stop Loss** = distancia entrada ↔ extremo guardado en la ruptura (mínimo 5 pips).
- **Take Profit** = opcional. Si `UseFixedRR=true`, ratio 1:3. Si no, lo gestionan trailing/BE/parcial.
- **Trailing Stop** = 15 pips (solo si `UseFixedRR=false`).
- **Break-Even** = 15 pips → SL a `OpenPrice + 1 pip`.
- **Cierre parcial** = 50% a 15 pips (con `UsePartialClose=true`).
- **Push** en cada evento (entrada, cierre parcial, etc.).

## 9. Detalles de implementación relevantes

- **FIX #1:** `longInvalidatedThisBar` / `shortInvalidatedThisBar` evitan re-evaluar la misma vela como nueva ruptura tras una cancelación.
- **FIX #2:** `ManageTrailingStop()` retorna inmediatamente si `UseFixedRR=true`, eliminando el conflicto entre los dos modos.
- **Reset de cierres parciales:** el array `g_partialClosedTickets` se limpia al cambiar de día si no hay trades activos.
- **Cierre finde semana:** incondicional el viernes 22:00, independiente del flag `CloseAtEndOfDay`.
- **Control de `MaxTradesPerDay`:** cuenta tanto órdenes activas como históricas del día, deduplicando por `(tiempo, tipo)`.
- **Filtro anti-"from #":** `ManagePartialClose` ignora tickets cuyo comentario contenga `"from #"` (resultado de un `OrderClose` previo) para no duplicar cierres parciales.

## 10. Resumen ejecutivo

Versión "anti" del EA clásico de Asian Breakout. En lugar de subirse a la **primera** ruptura, **espera un pullback tipo Judas Swing** (limitado al 40% de la caja) y entra a favor del movimiento real posterior con:

- **R:R alto (1:3)** cuando se usa TP fijo.
- **Lote dinámico** por % de riesgo sobre el SL real.
- **Break-even automático** y **trailing stop** configurables.
- **Filtro macro H1 (EMAs 50/200)** y **días permitidos**.
- **Disciplina de 1 operación/día** y **red de seguridad anti-gap** los viernes.
- **Cierre parcial** opcional para asegurar beneficios.
