# Reglas y Configuraciones del Entorno Forex

## [MUY IMPORTANTE] Diferencia Horaria de Servidores (Skilling vs Local)
Cuando se realicen pruebas o configuraciones (backtesting o en vivo) con el broker **Skilling**, se debe tener en cuenta que el servidor del broker tiene **una hora más** respecto a la hora local. 

**Impacto en los EAs (Ej: Asian Breakout):**
- Si la estrategia estipula cerrar posiciones o detener operativas a una hora concreta (por ejemplo, las 12:00 locales), en los parámetros del EA (como `MaxTradeHour`) se debe configurar **sumando 1 hora** (ej. a las 13:00).
- **Regla General para Skilling:** `Hora del Servidor = Hora Local + 1`.

Siempre que revises logs de backtesting o modifiques parámetros horarios, ten en cuenta este desfase del servidor de Skilling para evitar cierres prematuros de la operativa.
