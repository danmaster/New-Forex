# Plan de Implementación: EA Quick Flip Scalper

Este documento detalla el plan para desarrollar un Expert Advisor (EA) en MQL4 (MetaTrader 4) que automatice completamente la estrategia "Quick Flip Scalper".

## ¿Necesita indicadores?

**Sí.** La estrategia requiere explícitamente un indicador y cálculos de acción del precio:
1. **Indicador ATR (Average True Range):** Necesita leer el ATR de 14 periodos en temporalidad **Diaria (1D)** para obtener el valor de volatilidad.
2. **Cálculo de Acción del Precio (Price Action):** Aunque no es un indicador clásico, el EA necesita memoria interna para registrar el Alto y Bajo de la **primera vela de 15 minutos** y detectar patrones de velas (Martillo y Envolvente) en la **temporalidad de 5 minutos**.

## Preguntas Abiertas (Por favor, responde esto)

Necesito que aclares estos puntos antes de comenzar a programar el EA:
1. **Hora de Apertura:** La estrategia ocurre en los primeros 90 minutos de la "apertura del mercado". ¿Cuál es la hora exacta de apertura en el reloj de tu bróker (Server Time) que deseas usar? (Ej: 16:30 para índices de EE. UU. en horario europeo).
2. **Gestión de Riesgo:** ¿Qué porcentaje de tu cuenta deseas arriesgar por operación (ej. 1%) o prefieres un lotaje fijo?
3. **Visualización:** ¿Quieres que el EA dibuje en el gráfico la caja del rango de 15 minutos para que puedas ver visualmente lo que está haciendo?

## Cambios Propuestos

### Expert Advisor (MQL4)
Se creará un nuevo archivo `Quick_Flip_Scalper.mq4` en tu carpeta `Experts` con la siguiente lógica:
- **Inputs:** `HoraApertura`, `MinutosApertura`, `RiskPercent`, `ATR_Period` (14 por defecto).
- **Fase 1 (0-15 min):** El EA espera a que cierre la vela de 15 minutos de la apertura. Registra el `High` y `Low`.
- **Fase 2 (Filtro ATR):** Calcula el tamaño de la vela de 15m. Si es `>= ATR_Diario * 0.25`, la estrategia sigue activa. Si no, desactiva el trading por el día.
- **Fase 3 (15-90 min):** En temporalidad de 5 minutos, el EA busca salidas de la zona de 15m y evalúa patrones de reversión (Martillo o Envolvente) en el lado opuesto de la ruptura.
- **Fase 4 (Ejecución):** Abre la orden (compra/venta) con Stop Loss en el extremo del patrón y Take Profit en el borde opuesto de la caja de 15m. Calcula automáticamente el lotaje según el Stop Loss y el riesgo.
