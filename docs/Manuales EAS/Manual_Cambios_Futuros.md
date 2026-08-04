# Manual de Cambios Futuros

Este documento sirve como registro para memorizar los ajustes críticos que deben realizarse en los Expert Advisors (EAs) antes de migrar de una cuenta Demo a una cuenta Real, específicamente bajo regulaciones de bajo apalancamiento (ej. CySEC 1:30) y balances reducidos (ej. 1.000 €).

## Protocolo de Transición a Cuenta Real (RoboForex Offshore 1:500 - Capital: 1.000 €)

Al operar bajo la entidad global de RoboForex con apalancamiento alto (1:500), **se eliminan las restricciones de margen europeas**. Los Expert Advisors pueden funcionar a su máxima capacidad sin riesgo de que el bróker rechace las órdenes por "Margen Insuficiente" (Not enough money).

1. **Riesgo Dinámico (`RiskPercent`):**
   * **MANTENER en:** `1.0`
   * *Motivo:* Gracias al apalancamiento 1:500, puedes operar arriesgando el 1% (10 €) sin que te bloqueen fianza en exceso. No es necesario reducir las ganancias a la mitad.

2. **Stop Loss Mínimo (`MinSLPips`):**
   * **MANTENER en:** `5`
   * *Motivo:* El EA podrá calcular volúmenes altos para entradas de "francotirador" (stops ajustados) ya que el margen exigido por el bróker para esos lotes será mínimo.

3. **Asignación Estricta de Marcos Temporales (Timeframes):**
   * **Asian Breakout V1.02:** Debe estar adjunto EXCLUSIVAMENTE a un gráfico de **M5** (5 Minutos) para capturar manipulaciones institucionales rápidas.
   * **Anti-Asian Breakout:** Debe estar adjunto EXCLUSIVAMENTE a un gráfico de **M15** (15 Minutos) para seguir tendencias consolidadas.
   * *Motivo:* Tal como acordamos ayer para validar la sinergia de ambas estrategias en el entorno real, esta es la configuración óptima probada para evitar solapamientos.

4. **Configuración de Días de Operación (Filtro Semanal):**
   * **Asian Breakout V1.02:** Mantener operando solo **Martes, Miércoles y Jueves**. (Lunes y Viernes `false` debido a la alta tasa de trampas erráticas).
   * **Anti-Asian Breakout:** Operar **Lunes, Martes, Miércoles y Jueves**. (Solo Viernes `false` por baja liquidez para continuaciones).

---
*Nota registrada el 27 de Julio de 2026. Actualizada con los acuerdos de sinergia de Timeframes. Revisar este documento antes de activar el botón de Auto-Trading en la cuenta real.*
