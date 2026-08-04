# Manual de Usuario — Asian Breakout V2.61 (MQL4 + Pine)

> Estado: **pendiente de validación con backtest forward**. Esta versión es V2.6 con dos parches quirurgicos para corregir el problema diagnosticado en `Operaciones/Comparativa_2.51_vs_2.6_vs_2.6b.md`.

---

## 1. Qué cambia respecto a V2.6

V2.61 es V2.6 + dos fixes minimos introducidos tras observar que la V2.6 capturaba muchas operaciones prematuramente (categoria B del diagnostico: -1,572 USD en 6 trades que en V2.51 hubieran llegado a TP 1:3 completo).

| Parametro | V2.6 (default) | V2.61 (default) | Por que |
|---|---|---|---|
| `EscalonadoRR2` | `2.0` (tocar 1:2 para lock) | **`1.5`** | Cualquier retroceso real se ve antes en 1.5R que en 2R; permite "armar" mas temprano. |
| `EscalonadoMoveSLto1R` | `false` (no mover) | **`true`** (mover, pero condicionado) | Activamos la logica buena y le añadimos filtro de pullback para eliminar la mala. |
| `EscalonadoPullbackPips` | — | **`0.5`** *(nuevo)* | Retroceso minimo, en unidades de R, desde el pico, necesario antes de recolocar SL a +1R. |
| `g_mgmtFlag2Armed[]` | — | *(nuevo, interno)* | Boleano que se enciende cuando el precio **ya toco** EscalonadoRR2 * riskPips alguna vez. |
| `g_peakProfitLong/Short[]` | — | *(nuevo, interno)* | Tracking del maximo/mínimo visto para detectar retrocesos reales, no ticks puntuales. |

### Semantica nueva del Estado 2

- **Antes (V2.6 Opcion A):** si el precio toca 1:2R, SL → +1R automaticamente. Esto corto 6 trades ganadores (categoria B).
- **Ahora (V2.61 Fix A2):** SL → +1R **solo si** se cumple `flag2Armed == true` (el precio ya toco RR2) **Y** `profitPips <= (EscalonadoRR2 - EscalonadoPullbackPips) * riskPips` (el precio retrocedio al menos 0.5R desde el pico).

Resultado esperado segun backtest manual:
- Categoria A (7 trades rescatados en V2.6): **se mantiene**.
- Categoria B (6 trades cortados en V2.6): **se elimina casi entera** porque ninguno tiene pullback de 0.5R antes de tocar TP 1:3.
- Estimacion global: red **-131 USD → +800 a +1,200 USD** sobre los 39 trades del periodo 2026.01-2026.08.

---

## 2. Compatibilidad y despliegue

| Entorno | Soporte | Notas |
|---|---|---|
| MetaTrader 4 (RoboForex MT4 ProCent, EUR, 1:500, 5-digit) | ✅ Principal | Mismas cuentas que V2.6. |
| MetaTrader 4 (Skilling Demo, EURUSD M5) | ✅ Backtest de referencia | El periodo de validacion usado en las comparativas. |
| TradingView (Pine Script v6) | ✅ Paridad | `TradingView/Asian_V2.61.pine`. News filter no implementado (ver § 5). |
| RoboForex R StocksTrader / MT5 | ❌ | Los `.mq4` no aplican. |

### Despliegue paso a paso (VPS Windows)

1. Conectarse al VPS por RDP.
2. Copiar `Experts/Asian_V2.61.mq4` a `MQL4/Experts/` local del VPS.
3. En MetaEditor: `File → Open` → `Compile`. Verificar 0 errors, 0 warnings.
4. En MT4: `Navigator → Experts → Asian_V2.61`, doble-click sobre el chart EURUSD M5 de la cuenta ProCent.
5. En la pestana **Inputs** marcar los valores de la tabla de § 3.
6. Confirmar que el panel `Experts` muestra `Asian_V2.61 V2.61 loaded OK` y que en el chart aparece el smiley.
7. `Tools → Options → Expert Advisors → Allow automated trading` debe estar **ON**, y el boton `AutoTrading` tambien.

---

## 3. Inputs clave (diferencias respecto a V2.6)

Bloque `TP ESCALONADO`:

| Input | Valor | Justificacion |
|---|---|---|
| `UseEscalonadoTP` | `true` | Activa la logica V2.6 (la unica diferencia respecto a V2.51). |
| `EscalonadoRR1` | `1.0` | Igual que V2.6: a 1:1R recolocamos SL a BE. |
| `EscalonadoRR2` | **`1.5`** *(era 2.0)* | FIX A1: dispara el armado del pullback logic antes. |
| `EscalonadoMoveSLto1R` | **`true`** *(era false)* | FIX A2: activado por defecto; la condicion de pullback evita el corte prematuro. |
| `EscalonadoPullbackPips` | **`0.5`** *(nuevo)* | FIX A2: retroceso minimo en R antes de recolocar a +1R. Rango util: 0.3 a 0.8. |

Resto de parametros del EA (sesion asiatica, SMC, lote, news filter) **identicos a V2.6**. Si quieres replicar el setup de backtest de la comparativa, importa los inputs del Strategy Tester guardado.

---

## 4. Procedimiento de validacion (backtest forward)

1. Abrir Strategy Tester en MT4.
2. Symbol: `EURUSD`, Period: `M5`, Model: `Every tick based on real ticks` (90%+), Date: `2026.01.01 - 2026.08.04` (mismo periodo que V2.6).
3. Expert: `Asian_V2.61`. Spread: 10 (o el del broker).
4. Correr.
5. Guardar el Strategy Tester `.htm` en `Operaciones/StrategyTester 2.61.htm` y el GIF en `StrategyTester 2.61.gif`.
6. Una vez compilado, copiar/pegar las nuevas metricas abajo para comparar contra V2.6.

### Plantilla para pegar resultados

```
EA            : Asian_V2.61
Periodo       : 2026.01.01 - 2026.08.04
Símbolo/TF    : EURUSD / M5
Spread        : 10
Benef. neto   : ___ USD
Profit factor : ___
Win rate      : ___% (___/___)
Avg winner    : +___ USD
Avg loser     : -___ USD
Max consec W  : ___
Max consec L  : ___
Drawdown max  : ___% (___ USD)
```

---

## 5. Limitaciones conocidas vs MT4

- **News filter:** el EA MT4 lee `News_Fetcher.mq4`. Pine v6 no tiene equivalente: bloquear manualmente 30 min antes/despues de alta impacto con `TradingView Calendar` o `alert()` sobre eventos EURUSD.
- **Partial close** (`UsePartialClose`): MT4 only. No implementado en Pine.
- **Lot size dinamico 1%:** MT4 only. Pine muestra señales; sizing manual.
- **Persistencia de arrays `g_mgmtXXX[]`:** viven en memoria del EA. Si reinicias MT4 con un trade abierto gestionado, los estados `Flag1`, `Flag2`, `Flag2Armed` se pierden. No es un problema en backtest (simulacion determinista).

---

## 6. Rollback

Si por lo que sea V2.61 da peor que V2.6:

1. Cerrar el chart EURUSD M5 con V2.61.
2. Abrir el mismo chart y cargar V2.6 (`Asian_V2.6.mq4`) con los mismos inputs excepto `EscalonadoRR2=2.0` y `EscalonadoMoveSLto1R=false`.
3. Verificar que `Experts/Asian_V2.6.mq4` sigue intacto (este manual jamas lo toca).

V2.51 sigue siendo el punto de comparacion (ganador del diagnostico a +444.72 USD). Si V2.61 no la supera, volver a V2.51 sigue siendo rentable.

---

## 7. Archivos de este release

| Carpeta | Archivo |
|---|---|
| `Experts/` | `Asian_V2.61.mq4` (nuevo, derivado de V2.6) |
| `TradingView/` | `Asian_V2.61.pine` (nuevo, primera version Pine de Asian Breakout) |
| `docs/Manuales EAS/` | `asian_breakout_V2.61_Manual.md` (este archivo) |
| `Operaciones/` | pendiente: `StrategyTester 2.61.htm`, `Comparativa_2.51_vs_2.6_vs_2.61.md` |

V2.6 y V2.51 **no se tocan**.
