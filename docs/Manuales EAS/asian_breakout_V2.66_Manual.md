# Manual de Usuario — Asian Breakout V2.66 (Estrategia Alex Ruiz)

> **Este manual reemplaza el concepto de todas las versiones anteriores.** V2.63+ dejó de ser un *breakout* a mercado tras barrido+falsa ruptura y pasó a ser la estrategia **fiel al vídeo de Alex Ruiz**: ordenes pendientes (Sell/Buy Limit) en la **Zona de Liquidez Externa**, colocadas **después de la ruptura** del borde de la caja, con TP estructural en el extremo opuesto.

---

## 1. El cambio de concepto (por qué V2.66 es diferente)

Las versiones V2.0–V2.62 operaban **a mercado** (OP_BUY/OP_SELL) cuando el precio barría el borde de la caja asiática y confirmaba reversión con una vela (patrón 1-2-3). Ese comportamiento sigue vivo en `Anti_Asian_V2.10.mq4` (la estrategia *anti*).

**V2.63 en adelante reproduce exactamente lo que Alex Ruiz enseña en el vídeo** (fuente: `Estrategias/Asian_Breakout/Transcripcion_video.md`):

| Concepto del vídeo | Implementación V2.66 |
|---|---|
| Temporalidad 5 minutos, EURUSD | Gráfico M5 (funciona en cualquier TF del chart) |
| **Paso 1:** Identificar el Rango Asiático | `StartHour=3` / `EndHour=9` (hora broker verano) = caja real **00:00–06:00 GMT** (box del vídeo 01:00–07:00 en gráfico UTC+1). Ajuste DST automático |
| **Paso 2:** Tendencia bajista → espera ruptura del **techo** (toma de liquidez) | `UseMacroTrendFilter=true` (EMA 200 H1): bajista → solo SELL |
| **Paso 3:** Ubicar la **Zona de Liquidez Externa** más cercana, **descartando zonas dentro de la caja** | `UseSwingLiquidity=true`: detecta el swing (fractal) más cercano fuera de la caja, se dibuja en **púrpura** |
| **Paso 4:** Sell Limit al **inicio de la zona**, SL **por encima** de la zona, TP en la **parte opuesta** | `WaitForBreakout=true`: coloca la Limit **cuando el precio rompe el techo** (`Bid > asianHigh`), en el borde inferior de la zona, SL por encima, TP = `asianLow` |
| "Esperar, sin modificar nada, a que el precio alcance ese punto" | Gestión **purista** por defecto: BE/lock/trailing/escalonado **desactivados** |

### Secuencia completa del día (tendencia bajista, ejemplo del vídeo)

1. Al cierre de la caja asiática (09:00 hora broker verano), el EA calcula `asianHigh`/`asianLow`.
2. Detecta el **swing alto más cercano por encima de la caja** (fractal M5 previo) → zona de liquidez púrpura. Si no hay swing válido, usa el offset fijo `ExternalEntryPips` (fallback).
3. **Espera a que el precio rompa el techo** (`Bid > asianHigh`). En ese momento coloca el **Sell Limit** al inicio de la zona (borde inferior de la banda púrpura).
4. SL por encima de la zona de liquidez (`sellZoneTop + ExternalSLDistancePips`), TP = **extremo opuesto de la caja** (`asianLow`).
5. La orden pendiente se llena si el precio sube hasta la zona y retrocede (falsa ruptura → Judas Swing). TP estructural o SL. Sin gestión intermedia.

> [!NOTE]
> Si el precio **nunca rompe** el borde dentro de la ventana de Londres, el EA no coloca nada ese día. Espera la ruptura: fiel a Alex ("espera a que el precio rompa la parte superior").

---

## 2. Modo de colocación vs. versiones antiguas

| | Anti (V2.10/V2.13) | **Asian V2.66** |
|---|---|---|
| Tipo de orden | Mercado (`OP_BUY`/`OP_SELL`) | **Pendiente** (`OP_SELLLIMIT`/`OP_BUYLIMIT`) |
| Señal de entrada | Barrido del borde + vela de reversión 1-2-3 | **Ruptura** del borde + zona de liquidez externa |
| TP | Extremo opuesto de la caja | Extremo opuesto de la caja (`asianLow`/`asianHigh`) |
| Momento de colocación | Inmediato tras confirmación | **Tras la ruptura** (`WaitForBreakout`) |
| Lado según tendencia | Continúa la tendencia del breakout | **Contra-impulso** (a favor de la tendencia macro: en bajista se vende el techo) |

Ambas EAs comparten la **misma caja asiática** (00:00–06:00 GMT) y pueden correr en paralelo como sistemas complementarios.

---

## 3. Inputs clave (bloques de V2.63 → V2.66)

### 3.1 `--- ESTRATEGIA ALEX RUIZ ---` (V2.63)

| Input | Default | Descripción |
|---|---|---|
| `ExternalEntryPips` | `2` | **Fallback**: distancia de la Limit al borde de la caja cuando no hay swing válido |
| `ExternalSLDistancePips` | `10` | Distancia del SL desde la Limit, por encima/debajo del nivel barrido |
| `UseMacroTrendFilter` | `true` | Operar SOLO a favor de la tendencia macro (EMA) |
| `MacroTrendPeriod` | `200` | Periodo de la EMA de tendencia |
| `MacroTrendTF` | `PERIOD_H1` | Timeframe de la EMA de tendencia |
| `MinRR` | `1.5` | R:R mínimo exigido (caja/SL). Si no llega, se salta el día |

### 3.2 `--- ZONA DE LIQUIDEZ EXTERNA ---` (V2.65)

| Input | Default | Descripción |
|---|---|---|
| `UseSwingLiquidity` | `true` | Detectar la zona de liquidez por **swing (fractal)** del gráfico en vez de offset fijo |
| `LiquidityZonePips` | `3` | Semi-ancho de la banda púrpura alrededor del swing |
| `MinLiquidityDistPips` | `1` | Distancia mínima del swing al borde de la caja → **descarta zonas dentro o en el borde** |
| `MaxLiquidityDistPips` | `60` | Distancia máxima del swing al borde de la caja |
| `SwingLookbackBars` | `500` | Velas hacia atrás para buscar el swing (estructura previa a la caja) |
| `DrawLiquidityZones` | `true` | Dibujar las zonas detectadas en **púrpura** en el gráfico |

### 3.3 `WaitForBreakout` (V2.66) — *nuevo*

| Input | Default | Descripción |
|---|---|---|
| `WaitForBreakout` | `true` | **Esperar a que el precio ROMPA el borde de la caja antes de colocar la Limit** (fiel a Alex: "en el momento que rompe el techo, allí pone la orden limit"). SELL → `Bid > asianHigh`; BUY → `Ask < asianLow`. Si no rompe, no opera ese día |

### 3.4 Gestión purista (dejar por defecto)

`UseTrailingStop=false`, `UseAutoBreakEven=false`, `UseBreakEvenAt1R=false`, `UseEscalonadoTP=false`, `UsePartialClose=false`, `CloseAtEndOfDay=false`. Salida = TP estructural o SL.

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

---

## 5. Despliegue

1. Copiar `Experts/Asian_V2.63.mq4` a `MQL4/Experts/` local.
2. Compilar en MetaEditor (0 errores / 0 warnings).
3. Adjuntar a un gráfico **EURUSD M5** (misma temporalidad que el vídeo; los fractales se calculan en el TF del chart).
4. Confirmar inputs de § 3 (en especial `WaitForBreakout=true`, `UseSwingLiquidity=true`).
5. `AutoTrading` ON.

---

## 6. Validación (backtest forward)

1. `Symbol: EURUSD`, `Period: M5`, `Model: Every tick based on real ticks`.
2. Fecha de arranque sugerida: un periodo de 3+ meses (la estrategia opera casi a diario en lunes-jueves).
3. Guardar `.htm` en `Operaciones/` con el nombre `StrategyTester Asian_V2.66.htm`.

### Plantilla de resultados

```
EA            : Asian_V2.66
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

- **Ventana de colocación:** tras la ruptura y hasta `PendingExpiryHour` (11:00, apertura de Londres). Los pendientes que no se llenan se borran a esa hora.
- **Un solo lado por día** con el filtro de tendencia activo (default). Sin filtro, si ambos lados están activos, se espera a que **ambos** rompan antes de colocar.
- **News filter** (`UseNewsFilter=true` por defecto): bloquea la colocación durante noticias de alto impacto (lee Global Variables de `News_Fetcher.mq4`).
- **TF del gráfico:** el swing y la caja se calculan en el timeframe al que está adjunto el EA. Usar **M5** para fidelidad al vídeo.
- **Requisito de R:R:** días con caja muy pequeña o SL amplio se saltan por `MinRR`/`MaxSLPips` (30 pips).

---

## 8. Historial de versiones relevantes

| Versión | Cambio |
|---|---|
| V2.64 | Caja asiática alineada al box del vídeo: 00:00–06:00 GMT (03:00–09:00 verano / 02:00–08:00 invierno, `StartHour=3`/`EndHour=9`, DST automático) |
| V2.65 | **Detección automática de la Zona de Liquidez Externa** por swing (fractal), dibujo en púrpura, descarte de zonas dentro de la caja |
| V2.66 | **Espera de la ruptura** antes de colocar la Limit (`WaitForBreakout`). TP estructural confirmado (extremo opuesto de la caja) |

---

## 9. Rollback

Si V2.66 diera peor que V2.64/2.65:
1. `WaitForBreakout=false` restaura la colocación inmediata al cierre de la caja (comportamiento V2.63–2.65).
2. `UseSwingLiquidity=false` restaura el offset fijo (`ExternalEntryPips`).
3. Los backups están en `Experts/backups/` (`Asian_V2.63_2026-08-05_0959.mq4` y `_0856.mq4`).
