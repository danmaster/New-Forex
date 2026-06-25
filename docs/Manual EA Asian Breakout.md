# Manual EA Asian Breakout SMC - Auto

## 1. Naturaleza del Expert Advisor (EA)
El **Asian Breakout SMC - Auto** es un sistema de trading algorítmico diseñado bajo los principios de *Smart Money Concepts* (SMC). Su objetivo principal es capitalizar la liquidez que se acumula por encima y por debajo de los rangos de consolidación que típicamente ocurren durante la sesión asiática (Tokio).

La premisa central del EA es que, al comenzar la sesión de Londres o Nueva York, las instituciones financieras ("Smart Money") manipularán el precio para barrer los *stop losses* (liquidez) dejados por los traders minoristas en los extremos de la caja asiática, antes de revertir el precio en la dirección de la tendencia principal. A este movimiento se le conoce como el "Judas Swing" o "Sweep".

## 2. Operatividad
El flujo lógico de ejecución del EA es el siguiente:

1. **Definición de la Caja:** Durante el horario de Tokio (típicamente 01:00 - 07:00 Hora Madrid), el EA marca el máximo y el mínimo alcanzado, formando la "Caja Asiática".
2. **Validación:** Comprueba que la caja tenga un tamaño saludable (entre 10 y 50 pips por defecto) para evitar consolidaciones demasiado estrechas o rangos ya expandidos.
3. **Filtro de Tendencia:** Verifica el estado del mercado en una temporalidad mayor (H1) utilizando dos Medias Móviles Exponenciales (EMAs de 50 y 200 periodos). Solo se permiten compras si la tendencia general es alcista, y ventas si es bajista.
4. **Detección del "Sweep":** Una vez finalizada la sesión asiática, el EA espera pacientemente a que el precio rompa (barra) el máximo o el mínimo de la caja.
5. **Gatillo de Entrada:** Si el precio barre el máximo y cierra nuevamente por debajo del nivel de la caja (falsa ruptura), y la tendencia es bajista, ejecuta una venta (Short). Si barre el mínimo y cierra por encima, y la tendencia es alcista, ejecuta una compra (Long).
6. **Gestión de la Operación:** Establece automáticamente el Stop Loss protegiendo el extremo del barrido (con un margen de pips de seguridad) y proyecta un Take Profit basado en un Ratio Riesgo:Beneficio fijo (por defecto 1:3). El lotaje se calcula dinámicamente para arriesgar únicamente un porcentaje fijo del capital en cada operación.

## 3. Parámetros de Configuración

### Ajustes de Sesión (Hora Madrid)
*   **Tokio (Asia):** `01:00 - 07:00` (Periodo de formación de la caja de liquidez).
*   **Europa (Londres):** `09:00 - 17:00` (Suele darse la expansión inicial).
*   **Nueva York:** `14:00 - 23:00` (Volatilidad adicional o continuaciones).

### Filtro de Días
*   **Operar Lunes - Viernes:** Interruptores individuales (ON/OFF) para habilitar o deshabilitar la operativa según el día de la semana. *(Ver sección de Análisis Empírico)*.

### Gestión de Riesgo
*   **Riesgo por operación (%):** Porcentaje del capital de la cuenta que se perderá si la operación toca Stop Loss. El lote se ajusta dinámicamente.
*   **Max Operaciones por Día:** Limita el número de trades diarios para evitar sobreoperar (Overtrading).
*   **Tamaño Mín/Máx Caja Asia (pips):** Filtra condiciones de mercado no óptimas.
*   **Esperar Cierre de Vela M5:** Exige que la vela de 5 minutos cierre confirmando la vuelta hacia el interior de la caja antes de disparar la entrada.

### Objetivos y Stop Loss
*   **Ratio R:R Fijo:** Multiplicador para el Take Profit (Ej: `3.0` significa que se busca ganar 3 veces lo arriesgado).
*   **Activar TP Fijo:** Habilita el cálculo estático del Take Profit en lugar de dejar la operación correr indefinidamente.
*   **Margen SL (pips):** Pips extra que se añaden al punto más extremo del barrido para evitar que el spread cierre la operación prematuramente.
*   **SL Mínimo (pips):** Protege contra Stop Losses irrisoriamente pequeños que podrían ser barridos por ruido del mercado.

### Filtro Tendencia
*   **Activar Filtro EMA:** Habilita la validación de dirección en H1.
*   **EMA Rápida (50) / Lenta (200):** Periodos para determinar la tendencia mayor.

---

## 4. Análisis Empírico: El Filtro de Días Operativos

Durante el proceso de validación histórica de la estrategia en TradingView (Mayo - Junio 2026), se llevó a cabo una optimización fundamental basada en el comportamiento del mercado según los días de la semana.

### El Escenario Inicial (Operando todos los días)
Al someter el sistema a pruebas continuas de lunes a viernes asumiendo un **riesgo del 2%** por operación, los resultados mostraron lo siguiente:
*   **Win Rate:** ~38%
*   **Drawdown Máximo:** 11.40%
*   **Rentabilidad:** +12.31%
*   **Diagnóstico:** Aunque la expectativa matemática era positiva (Profit Factor de 1.64), el sistema era inestable. Con un Win Rate inferior al 40%, las rachas perdedoras (5-6 pérdidas consecutivas) eran muy frecuentes, lo que sumado a un riesgo alto (2%), generó un Drawdown superior al 11%. **Esta configuración invalidaba el uso del EA en Pruebas de Fondeo (Prop Firms)**, cuyo límite máximo suele rondar el 8%-10%.

### El Hallazgo Analítico (Eliminando Lunes y Viernes)
Se observó que los barridos de liquidez (sweeps) durante los lunes (cuando el mercado aún está acomodando volumen) y los viernes (cierres de posiciones semanales y menor interés institucional en nuevas tendencias) producían una alta tasa de señales falsas.

**La corrección:** Se implementó un filtro en el código (`isTradingDay`) para operar exclusivamente los **Martes, Miércoles y Jueves**, y paralelamente se redujo el **riesgo por operación al 1%** para priorizar la protección del capital.

### Resultados tras la Optimización
*   **Win Rate:** 50.00%
*   **Drawdown Máximo:** 2.60%
*   **Profit Factor:** 2.756
*   **Rentabilidad:** +7.98%

**Conclusión Operativa:**
Filtrar los días lunes y viernes demostró ser el "Santo Grial" para esta estrategia. Al limpiar el ruido de mercado de esos días, la tasa de acierto saltó al 50%. Teniendo en cuenta que el sistema busca ganancias de 1:3, ganar el 50% de las veces genera una curva de capital extremadamente eficiente (Profit Factor casi 3). El Drawdown se redujo dramáticamente de un peligroso 11.4% a un inofensivo 2.6%, **haciendo que el EA sea perfecto y altamente recomendable para superar y gestionar cuentas financiadas (Prop Firms)**.
