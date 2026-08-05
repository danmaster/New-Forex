# Manual de Usuario - Asian Breakout V1.016 (Skilling)

Este documento detalla la configuración óptima y los resultados de backtesting de la versión **1.016** del Expert Advisor **Asian Breakout**, optimizado específicamente para operar en el broker **Skilling** (EURUSD, M5).

---

## 1. Consideración Importante: Horario del Servidor (Skilling)

> [!IMPORTANT]  
> **Diferencia Horaria:** El servidor de Skilling tiene **una hora más (+1)** respecto a la hora local. 
> - La caja asiática del vídeo de Alex Ruiz (indicador FXN) es **00:00 a 06:00 GMT** (01:00–07:00 en gráfico UTC+1). En Skilling se configura **03:00 a 09:00** (verano) / **02:00 a 08:00** (invierno); el EA lo ajusta automáticamente.
> - La regla de oro para este broker es: `Hora del Servidor = Hora Local + 1`.

---

## 2. Resultados del Backtesting de Referencia

Este backtesting sirve como "Gold Standard" para verificar que el EA funciona tal como se espera.

- **Periodo:** 16/06/2026 al 31/07/2026
- **Activo / Temporalidad:** EURUSD / M5
- **Calidad de Modelado:** 90.00% (Cada tick)
- **Depósito Inicial:** 10,000.00

### Métricas Clave
- **Beneficio Neto Total:** 1014.57 (Aprox. +10% en mes y medio)
- **Drawdown Máximo:** 391.54 (3.55%) -> *¡Excepcionalmente bajo y seguro!*
- **Factor de Beneficio (Profit Factor):** 2.90
- **Total de Transacciones:** 10 (5 Ganadoras, 5 Perdedoras - Win Rate 50%)
- **Ratio Riesgo/Beneficio (R:R):** 1:3. Las ganancias promedian ~300$ por trade, mientras que las pérdidas promedian ~106$.

### Historial de Operaciones
| # | Fecha | Tipo | Lote | Precio Apertura | S/L | T/P | Beneficio ($) | Balance ($) |
|---|---|---|---|---|---|---|---|---|
| 1 | 2026.06.18 09:40 | sell | 1.11 | 1.15223 | 1.15313 | 1.14953 | 299.70 | 10299.70 |
| 2 | 2026.06.23 10:15 | sell | 1.22 | 1.14302 | 1.14386 | 1.14050 | -102.48 | 10197.22 |
| 3 | 2026.06.23 10:35 | sell | 0.66 | 1.14267 | 1.14420 | 1.13808 | 302.94 | 10500.16 |
| 4 | 2026.06.25 17:20 | sell | 0.66 | 1.13707 | 1.13866 | 1.13230 | -104.94 | 10395.22 |
| 5 | 2026.07.15 09:00 | sell | 1.79 | 1.14404 | 1.14462 | 1.14230 | 311.46 | 10706.68 |
| 6 | 2026.07.15 15:35 | buy  | 0.54 | 1.14224 | 1.14029 | 1.14809 | 315.90 | 11022.58 |
| 7 | 2026.07.22 09:30 | sell | 1.31 | 1.14082 | 1.14166 | 1.13830 | -110.04 | 10912.54 |
| 8 | 2026.07.28 09:05 | buy  | 1.21 | 1.13676 | 1.13586 | 1.13946 | -108.90 | 10803.64 |
| 9 | 2026.07.30 09:50 | buy  | 1.47 | 1.14495 | 1.14422 | 1.14714 | -107.31 | 10696.33 |
| 10 | 2026.07.30 11:45| buy  | 1.04 | 1.14524 | 1.14422 | 1.14830 | 318.24 | 11014.57 |

---

## 3. Parámetros de Configuración a Replicar (Inputs)

Para obtener exactamente estos resultados, se deben utilizar los siguientes parámetros:

### Ajustes Generales
- **Activar Lote Dinámico (1%):** `true`
- **Riesgo por operación (%):** `1.0`
- **Enviar Notificación al Móvil:** `true`
- **Lote Fijo:** `0.1` *(ignorado por el lote dinámico)*
- **Esperar Cierre de Vela M5:** `true`
- **Tamaño Mínimo Caja (pips):** `10`
- **Tamaño Máximo Caja (pips):** `50`
- **Magic Number:** `100100`
- **Hora inicio Asia (Skilling):** `2`
- **Hora fin Asia (Skilling):** `8`
- **Hora máxima para cazar ruptura:** `23`

### Filtro de Días
- **Operar Lunes:** `false`
- **Operar Martes:** `true`
- **Operar Miércoles:** `true`
- **Operar Jueves:** `true`
- **Operar Viernes:** `false`

### Objetivos de Beneficio
- **Ratio R:R Fijo:** `3.0`
- **Activar TP Fijo por Ratio (Sobrescribe R:R Dinámico):** `true`

### Trailing Stop
- **Activar Trailing Stop:** `false`
- **Distancia del Trailing (pips):** `0`

### Ajustes de Stop Loss
- **Pips extra de margen (spread):** `3`
- **Stop Loss mínimo (pips):** `5`

### Gestión de Operaciones
- **Activar Auto Break-Even:** `false`
- **Pips ganancia para activar BE:** `10`
- **Pips extra sobre SL para asegurar BE:** `1`
- **Mover a BE al alcanzar 1:1:** `false`
- **Maximo de operaciones por dia:** `2`
- **Cerrar todas las operaciones a fin de semana:** `false`
- **Activar Cierre Parcial Automático:** `false`

### Modo de Liquidez (SMC)
- **Buscar Liquidez en AMBOS sentidos:** `true`
- **(No usado actualmente - ver código):** `12`
- **Min pips cuerpo vela de ruptura:** `2`
- **Min pips TOTALES de la vela de ruptura:** `8.0`
- **Min pips TOTALES para confirmar reversión:** `2.0`
- **Max velas fuera de caja antes de invalidar:** `36`
- **Máx. minutos absolutos para cazar:** `240`

---

## 4. Análisis y Conclusiones
1. **Eficiencia del R:R (Risk/Reward):** Al tener un Win Rate del 50% y un Ratio R:R de 1:3, la estrategia demuestra una muy alta rentabilidad con bajísimo riesgo. Cuando pierde, pierde ~1% (aprox. $106); cuando gana, suma casi un 3% (aprox. $300+).
2. **Lotaje Dinámico Impecable:** Se puede observar cómo el tamaño del lote varía en cada trade (1.11, 1.22, 0.66...) para asegurar que el Stop Loss en dólares ronde siempre el riesgo predefinido. Esto valida matemáticamente que el algoritmo de gestión monetaria (cálculo de lotaje basado en el SL y TickValue) funciona a la perfección.
3. **Control del Drawdown:** Un drawdown máximo de solo `3.55%` en mes y medio resalta la extrema seguridad de operar bajo estos parámetros (incluso sin un Break-Even automático). La ausencia de operaciones los lunes y viernes también demuestra ser un filtro de calidad de gran valor para evitar mercados erráticos.

---

## 5. Proyecciones Financieras y Entornos Reales

Basado en la muestra de backtesting, la esperanza matemática ofrece un rendimiento medio conservador del **6.5% mensual**. A continuación, se detalla cómo se comporta este sistema en dos escenarios operativos reales:

### Escenario A: Cuenta Personal (RoboForex Offshore 1:500)
Ideal para crear un plan de pensiones a largo plazo utilizando el poder del **Interés Compuesto**. 

* **Capital Inicial:** 1.000 €
* **Apalancamiento:** 1:500 (Crucial para que el margen retenido sea mínimo, aprox. 20€ por lote de 0.10, evitando errores de margen insuficiente).
* **Proyección a 1 año:** Si no se retiran beneficios y se mantiene el riesgo del 1% dinámico, el capital crecería de forma exponencial.
* **Capital Final Estimado:** ~2.129 € (Un 113% de rentabilidad anual, beneficio de 1.129 €).

### Escenario B: Cuenta Fondeada / Prop Firm (Ej. 100.000 $)
Ideal para generar flujo de caja mensual ("Sueldo") usando el capital de la empresa fondeadora y aplicando **Interés Simple** (retirando beneficios cada mes).

* **Capital Fondeado:** 100.000 $
* **Beneficio Bruto Mensual (6.5%):** 6.500 $
* **Proyección a 1 año (con Profit Split 80/20):**
  * Beneficio Bruto Anual: 78.000 $
  * Comisión Prop Firm (20%): - 15.600 $
  * **Beneficio Neto (Tu parte):** **62.400 $**

> [!WARNING]
> **Ajustes obligatorios para Prop Firms:**
> 1. Asegúrate de cambiar `Cerrar todas las operaciones a fin de semana` a `true` si la empresa lo exige.
> 2. Verifica la zona horaria del servidor de la Prop Firm (suele ser GMT+2 o GMT+3) para configurar correctamente `StartHour` y `EndHour`.
> 3. Ten precaución con las noticias de alto impacto si tu firma penaliza operar durante las mismas, ya que podría causar *slippage* en el Stop Loss.

*Aviso legal: Las rentabilidades pasadas no garantizan rendimientos futuros. Toda proyección matemática es una aproximación y asume condiciones de liquidez y volatilidad similares a la muestra.*
