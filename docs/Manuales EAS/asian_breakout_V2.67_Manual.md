# Manual de Usuario — Asian Breakout V2.67 (Estrategia Alex Ruiz)

> **Este manual reemplaza el concepto de todas las versiones anteriores.** V2.63+ dejó de ser un *breakout* a mercado tras barrido+falsa ruptura y pasó a ser la estrategia **fiel al vídeo de Alex Ruiz**: ordenes pendientes (Sell/Buy Limit) en la **Zona de Liquidez Externa**, colocadas **después de la ruptura** del borde de la caja, con TP estructural en el extremo opuesto. V2.67 añade la **gestión avanzada de salida** validada en backtest (Enero–Julio 2026).

---

## 1. El cambio de concepto (por qué V2.67 es diferente)

Las versiones V2.0–V2.62 operaban **a mercado** (OP_BUY/OP_SELL) cuando el precio barría el borde de la caja asiática y confirmaba reversión con una vela (patrón 1-2-3). Ese comportamiento sigue vivo en `Anti_Asian_V2.10.mq4` (la estrategia *anti*).

**V2.63 en adelante reproduce exactamente lo que Alex Ruiz enseña en el vídeo** (fuente: `Estrategias/Asian_Breakout/Transcripcion_video.md`):

| Concepto del vídeo | Implementación V2.67 |
|---|---|
| Temporalidad 5 minutos, EURUSD | Gráfico M5 (funciona en cualquier TF del chart) |
| **Paso 1:** Identificar el Rango Asiático | `StartHour=3` / `EndHour=9` (hora broker verano) = caja real **00:00–06:00 GMT** (box del vídeo 01:00–07:00 en gráfico UTC+1). Ajuste DST automático |
| **Paso 2:** Tendencia bajista → espera ruptura del **techo** (toma de liquidez) | `UseMacroTrendFilter=true` (EMA 200 H1): bajista → solo SELL |
| **Paso 3:** Ubicar la **Zona de Liquidez Externa** más cercana, **descartando zonas dentro de la caja** | `UseSwingLiquidity=true`: detecta el swing (fractal) más cercano fuera de la caja, se dibuja en **púrpura** |
| **Paso 4:** Sell Limit al **inicio de la zona**, SL **por encima** de la zona, TP en la **parte opuesta** | `WaitForBreakout=true`: coloca la Limit **cuando el precio rompe el techo** (`Bid > asianHigh`), en el borde inferior de la zona, SL por encima, TP = `asianLow` |
| "Esperar, sin modificar nada, a que el precio alcance ese punto" | Gestión **purista en entrada** (sin BE a 1R): la salida la gestionan la escalera por retroceso y el cierre parcial de V2.67 |

### Qué añade V2.67 (gestión de salida)

1. **Market Fallback** (`UseMarketFallback=true`): si la ruptura escapa sin que la Limit se llene (precio > borde + `MarketFallbackPips`), el EA entra **a mercado a favor** en lugar de dejar el pendiente hasta la caducidad. Convierte los días "Limit borrada a las 13h" en operaciones reales.
2. **Escalera de beneficio por retroceso** (`UseRetraceProfitLock=true`): se **prueba el TP estructural 1:3 intacto**. Solo cuando el precio **retrocede** `RetraceConfirmRR` (en R) desde su pico — habiendo alcanzado al menos `RetraceMinPeakRR` — se coloca una orden de salida pendiente en el último peldaño cruzado (`RetraceStepRR`). Si el precio sigue, la pendiente **ratchea** hacia el beneficio; si revierte, captura el peldaño y cierra. *Anti-capado*: no se arma por tocar un nivel.
3. **Cierre parcial 50% a ~1R** (`UsePartialClose=true`, `PartialClosePips=18`): asegura ganancia en la mitad del lote sin capar el tramo al TP estructural.

### Secuencia completa del día (tendencia bajista, ejemplo del vídeo)

1. Al cierre de la caja asiática (09:00 hora broker verano), el EA calcula `asianHigh`/`asianLow`.
2. Detecta el **swing alto más cercano por encima de la caja** (fractal M5 previo) → zona de liquidez púrpura. Si no hay swing válido, usa el offset fijo `ExternalEntryPips` (fallback).
3. **Espera a que el precio rompa el techo** (`Bid > asianHigh`). En ese momento coloca el **Sell Limit** al inicio de la zona (borde inferior de la banda púrpura).
4. SL por encima de la zona de liquidez (`sellZoneTop + ExternalSLDistancePips`), TP = **extremo opuesto de la caja** (`asianLow`).
5. **Si la ruptura escapa** (no se llena la Limit), el market fallback entra a mercado a favor.
6. En beneficio: **cierre parcial 50% a ~1R** y la **escalera por retroceso** captura el último peldaño solo si el precio revierte desde su pico. Si llega al TP estructural, gana el 1:3 completo.

> [!NOTE]
> Si el precio **nunca rompe** el borde dentro de la ventana de Londres, el EA no coloca nada ese día. Espera la ruptura: fiel a Alex ("espera a que el precio rompa la parte superior").

---

## 2. Modo de colocación vs. versiones antiguas

| | Anti (V2.10/V2.13) | **Asian V2.67** |
|---|---|---|
| Tipo de orden | Mercado (`OP_BUY`/`OP_SELL`) | **Pendiente** (`OP_SELLLIMIT`/`OP_BUYLIMIT`) + **mercado** (fallback V2.67) |
| Señal de entrada | Barrido del borde + vela de reversión 1-2-3 | **Ruptura** del borde + zona de liquidez externa |
| TP | Extremo opuesto de la caja | Extremo opuesto de la caja (`asianLow`/`asianHigh`) |
| Momento de colocación | Inmediato tras confirmación | **Tras la ruptura** (`WaitForBreakout`) |
| Lado según tendencia | Continúa la tendencia del breakout | **Contra-impulso** (a favor de la tendencia macro: en bajista se vende el techo) |
| Gestión de salida | Purista | Cierre parcial 50% a ~1R + escalera por retroceso + TP 1:3 |

Ambas EAs comparten la **misma caja asiática** (00:00–06:00 GMT) y pueden correr en paralelo como sistemas complementarios.

---

## 3. Inputs clave (bloques de V2.63 → V2.67)

### 3.1 `--- ESTRATEGIA ALEX RUIZ ---` (V2.63)

| Input | Default | Descripción |
|---|---|---|
| `ExternalEntryPips` | `2` | **Fallback**: distancia de la Limit al borde de la caja cuando no hay swing válido |
| `ExternalSLDistancePips` | `12` | Distancia del SL desde la Limit, por encima/debajo del nivel barrido (V2.67: 10→12 para dejar el SL más fuera de la caja y reducir toques de Judas-swing) |
| `UseMacroTrendFilter` | `true` | Operar SOLO a favor de la tendencia macro (EMA) |
| `MacroTrendPeriod` | `200` | Periodo de la EMA de tendencia |
| `MacroTrendTF` | `PERIOD_H1` | Timeframe de la EMA de tendencia |
| `MinRR` | `1.2` | R:R mínimo exigido (caja/SL). Si no llega, se salta el día (V2.67: 1.5→1.2) |

### 3.2 `--- ZONA DE LIQUIDEZ EXTERNA ---` (V2.65)

| Input | Default | Descripción |
|---|---|---|
| `UseSwingLiquidity` | `true` | Detectar la zona de liquidez por **swing (fractal)** del gráfico en vez de offset fijo |
| `LiquidityZonePips` | `3` | Semi-ancho de la banda púrpura alrededor del swing |
| `MinLiquidityDistPips` | `1` | Distancia mínima del swing al borde de la caja → **descarta zonas dentro o en el borde** |
| `MaxLiquidityDistPips` | `60` | Distancia máxima del swing al borde de la caja |
| `SwingLookbackBars` | `500` | Velas hacia atrás para buscar el swing (estructura previa a la caja) |
| `DrawLiquidityZones` | `true` | Dibujar las zonas detectadas en **púrpura** en el gráfico |

### 3.3 `WaitForBreakout` (V2.66)

| Input | Default | Descripción |
|---|---|---|
| `WaitForBreakout` | `true` | **Esperar a que el precio ROMPA el borde de la caja antes de colocar la Limit** (fiel a Alex: "en el momento que rompe el techo, allí pone la orden limit"). SELL → `Bid > asianHigh`; BUY → `Ask < asianLow`. Si no rompe, no opera ese día |

### 3.4 `MARKET FALLBACK` (V2.67) — *nuevo*

| Input | Default | Descripción |
|---|---|---|
| `UseMarketFallback` | `true` | Si la ruptura escapa sin llenar la Limit, entrar **a mercado a favor** (evita quemar el día con un pendiente que no se activa) |
| `MarketFallbackPips` | `6` | Pips más allá del borde de la caja para considerar la ruptura "escapada" y pasar a mercado |

### 3.5 `ESCALERA DE BENEFICIO POR RETROCESO` (V2.67) — *nuevo*

| Input | Default | Descripción |
|---|---|---|
| `UseRetraceProfitLock` | `true` | Probar el TP estructural (1:3) y, SOLO si el precio revierte desde su pico, capturar el último escalón cruzado con una orden de salida pendiente |
| `RetraceStepRR` | `1.0` | Peldaño de la escalera (en R): en 1R, 2R, 3R... se colocan/suben las pendientes de protección |
| `RetraceConfirmRR` | `0.4` | Retroceso mínimo (en R) **desde el pico** para considerar que el precio está REVIRTIENDO y solo ahí armar la escalera (anti-capado) |
| `RetraceMinPeakRR` | `1.3` | Pico mínimo (en R) que debe haber alcanzado la operación antes de poder armar la protección al revertir |
| `RetraceExitMagic` | `50505` | Magic de las órdenes pendientes de salida (separado del `MagicNumber` para no interferir con la entrada) |

### 3.6 Gestión de salida (defaults V2.67)

| Input | Default | Descripción |
|---|---|---|
| `UsePartialClose` | `true` | Cierre parcial automático: **50% del lote a ~1R** (`PartialClosePips=18`), asegura ganancia sin capar el tramo al TP |
| `UseTrailingStop` | `false` | Purista (el trailing tradicional está fuera del concepto; la salida la gestiona la escalera) |
| `UseAutoBreakEven` | `false` | — |
| `UseBreakEvenAt1R` | `false` | **Sustituido** por la escalera de retroceso (V2.67) |
| `UseEscalonadoTP` | `false` | — |
| `MaxSLPips` | `40` | SL máximo permitido (V2.67: 30→40 permite SL ligeramente más anchos) |
| `MaxBoxPips` | `70` | Tamaño máximo de caja (V2.67: 50→70; EURUSD M5 excede 50 con frecuencia) |
| `PendingExpiryHour` | `13` | Caducidad de los pendientes (V2.67: 11→13 para ampliar la ventana de entrada) |

---

## 4. Cálculo de la colocación (Modo Auto)

```
Zona SELL (tendencia bajista):
  swingHigh  = swing (fractal) más cercano por encima de asianHigh
  sellZoneBottom = swingHigh - LiquidityZonePips * Pip
  sellZoneTop    = swingHigh + LiquidityZonePips * Pip
  SellLimit  = sellZoneBottom                     ← "inicio de la zona" (borde más cercano a la caja)
  SL         = sellZoneTop + ExternalSLDistancePips * Pip   ← "por encima de la zona de liquidez"
  TP         = asianLow                            ← "parte opuesta del rango asiático"

Zona BUY (tendencia alcista): espejo simétrico por debajo de asianLow.
```

Si `UseSwingLiquidity=false` o no hay swing válido → fallback al offset fijo (`extHigh = asianHigh + ExternalEntryPips * Pip`), idéntico a V2.63/2.64.

**Filtro de distancia (Paso 3 del vídeo):** un swing solo cuenta si su distancia al borde supera `(LiquidityZonePips + MinLiquidityDistPips) * Pip` (la banda completa queda **fuera** de la caja) y no excede `MaxLiquidityDistPips`. Así se respeta la regla *"si hay una zona de liquidez dentro del propio rango asiático, no nos interesa"*.

**Market Fallback (V2.67):** si `WaitForBreakout` está activo y, dentro de la ventana de entrada, `Bid > asianHigh + MarketFallbackPips * Pip` (SELL) — la ruptura ha escapado — se limpia el pendiente y se entra a mercado a favor con el mismo SL estructural (sobre la zona) y TP (`asianLow`).

**Escalera por retroceso (V2.67):** para cada posición abierta se sigue el **pico máximo de beneficio (en R)**. Solo si `picoR >= RetraceMinPeakRR` y el precio retrocede `picoR - profitR >= RetraceConfirmRR`, se coloca un `Sell Stop`/`Buy Stop` de salida en el último peldaño cruzado (`floor(profitR / RetraceStepRR) * RetraceStepRR`). Si el precio avanza de nuevo, la pendiente se **recoloca** en el peldaño superior (ratchet). Si el precio llega al TP estructural primero, gana el 1:3 intacto; si la pendiente se llena, se cierra la operación capturando el peldaño.

---

## 5. Despliegue

1. Copiar `Experts/Asian_V2.63.mq4` a `MQL4/Experts/` local.
2. Compilar en MetaEditor (0 errores / 0 warnings).
3. Adjuntar a un gráfico **EURUSD M5** (misma temporalidad que el vídeo; los fractales se calculan en el TF del chart).
4. Confirmar inputs de § 3 (en especial `WaitForBreakout=true`, `UseSwingLiquidity=true`, `UseMarketFallback=true`, `UseRetraceProfitLock=true`).
5. `AutoTrading` ON.

---

## 6. Validación (backtest forward)

1. `Symbol: EURUSD`, `Period: M5`, `Model: Every tick based on real ticks`.
2. Fecha de arranque sugerida: un periodo de 3+ meses (la estrategia opera casi a diario en lunes-jueves).
3. Guardar `.htm` en `Operaciones/` con el nombre `StrategyTester Asian_V2.67.htm`.

### Resultados de referencia (Enero–Julio 2026, EURUSD M5, cada tick, Skilling demo)

Los informes `Operaciones/Asian_2.63 (6)_01..04.htm` muestran la evolución hasta la configuración V2.67:

| Test | Configuración | Benef. neto | Profit factor | Drawdown máx | Win rate |
|---|---|---|---|---|---|
| (6)_01 | V2.66 base (MaxBox50, expiry11, SL10, MinRR1.5, sin gestión) | **-97.06** | 0.80 | 4.55% | 28.6% (2/7) |
| (6)_02 | V2.67 sin gestión de salida | **-110.88** | 0.93 | 9.54% | 33.3% (7/21) |
| (6)_03 | **V2.67 completa** (fallback + escalera + cierre parcial 50%) | **+191.03** | **1.16** | 6.72% | 58.8% (20/34) |
| (6)_04 | RetraceConfirmRR=0.8 / RetraceMinPeakRR=2 | **+191.03** | 1.16 | 6.72% | 58.8% (20/34) |

> [!NOTE]
> (6)_03 y (6)_04 dieron resultado idéntico en este periodo, lo que indica que en enero–julio 2026 los parámetros de confirmación de la escalera no alteraron el resultado final. Conviene validar en un periodo adicional (p. ej. 2025) para confirmar que la escalera aporta valor.

### Plantilla de resultados

```
EA            : Asian_V2.67
Periodo       : ___
Símbolo/TF    : EURUSD / M5
Spread        : ___
Benef. neto   : ___ USD
Profit factor : ___
Win rate      : ___% (___/___)
Avg winner    : +___ USD
Avg loser     : -___ USD
Drawdown max  : ___% (___ USD)
```

---

## 7. Limitaciones y notas

- **Ventana de colocación:** tras la ruptura y hasta `PendingExpiryHour` (13:00, apertura de Londres). Los pendientes que no se llenan se borran a esa hora (o se convierten a mercado por el fallback si la ruptura escapó).
- **Un solo lado por día** con el filtro de tendencia activo (default). Sin filtro, si ambos lados están activos, se espera a que **ambos** rompan antes de colocar.
- **News filter** (`UseNewsFilter=true` por defecto): bloquea la colocación durante noticias de alto impacto (lee Global Variables de `News_Fetcher.mq4`).
- **TF del gráfico:** el swing y la caja se calculan en el timeframe al que está adjunto el EA. Usar **M5** para fidelidad al vídeo.
- **Requisito de R:R:** días con caja muy pequeña o SL amplio se saltan por `MinRR` (1.2) / `MaxSLPips` (40 pips).
- **Magic de la escalera:** `RetraceExitMagic=50505` es independiente del `MagicNumber` de entrada; no interfieren.

---

## 8. Historial de versiones relevantes

| Versión | Cambio |
|---|---|
| V2.64 | Caja asiática alineada al box del vídeo: 00:00–06:00 GMT (03:00–09:00 verano / 02:00–08:00 invierno, `StartHour=3`/`EndHour=9`, DST automático) |
| V2.65 | **Detección automática de la Zona de Liquidez Externa** por swing (fractal), dibujo en púrpura, descarte de zonas dentro de la caja |
| V2.66 | **Espera de la ruptura** antes de colocar la Limit (`WaitForBreakout`). TP estructural confirmado (extremo opuesto de la caja) |
| V2.67 | **Market Fallback** (entrada a mercado si la ruptura escapa), **escalera de beneficio por retroceso** (`UseRetraceProfitLock`), **cierre parcial 50% a ~1R**, params ampliados (MaxBox 70, expiry 13, SL 12, MinRR 1.2, MaxSL 40). Backtest 7m: +191 USD, PF 1.16 |

---

## 9. Rollback

Si V2.67 diera peor que V2.64/2.65:
1. `WaitForBreakout=false` restaura la colocación inmediata al cierre de la caja (comportamiento V2.63–2.65).
2. `UseSwingLiquidity=false` restaura el offset fijo (`ExternalEntryPips`).
3. `UseMarketFallback=false` / `UseRetraceProfitLock=false` / `UsePartialClose=false` restauran la gestión purista V2.66.
4. Los backups están en `Experts/backups/` (`Asian_V2.63_2026-08-05_edit760.mq4` con la gestión V2.67, y `_0856.mq4`/`_0959.mq4` pre-V2.66).
