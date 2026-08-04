# Manual de Despliegue VPS: Asian & Anti-Asian V2.0 (Filtro de Noticias)

Este documento detalla los pasos exactos para replicar el entorno de operaciones V2.0 en un servidor remoto (VPS), asegurando que el filtro de noticias (SMC) funcione correctamente y no bloquee el terminal.

## Fase 1: Preparación de Archivos
1. **Copiar las EAs:** Copia los archivos `Asian_V2.0.mq4` y `Anti_Asian_V2.0.mq4` desde tu entorno local al VPS.
2. **Ubicación EAs:** En el MT4 del VPS, ve a `Archivo > Abrir carpeta de datos`. Pega las EAs en la ruta `MQL4/Experts`.
3. **Copiar el Indicador:** Consigue el archivo `FFCal.ex4` (el mismo que usaste en local).
4. **Ubicación Indicador:** En la misma carpeta de datos del MT4, pega `FFCal.ex4` en la ruta `MQL4/Indicators`.

## Fase 2: Configuración de Permisos en MT4 (CRÍTICO)
Para que el filtro de noticias pueda conectarse a internet sin usar DLLs externas, debes darle permiso a MT4:
1. En el menú superior de MT4, ve a **Herramientas > Opciones** (Tools > Options) o presiona `Ctrl+O`.
2. Ve a la pestaña **Asesores Expertos** (Expert Advisors).
3. Asegúrate de tener marcada la casilla **"Permitir WebRequest para las siguientes URL"**.
4. Haz doble clic en el símbolo `+` verde y añade exactamente esta URL:
   `http://www.forexfactory.com`
   *(Añade también las URLs adicionales que indique el creador de tu versión de FFCal, por si acaso).*
5. Haz clic en **Aceptar**.

## Fase 3: Compilación y Activación
1. Abre **MetaEditor** en el VPS.
2. Abre los archivos `Asian_V2.0.mq4` y `Anti_Asian_V2.0.mq4`.
3. Presiona **F7** para compilar ambos. Asegúrate de que no haya errores (0 errors) en el registro inferior.
4. Vuelve al terminal de MT4 y abre la ventana **Navegador** (Ctrl+N). Haz clic derecho en "Asesores Expertos" y selecciona **Actualizar**.

## Fase 4: Despliegue en Gráficos
1. Abre un gráfico de **EURUSD en M5**. Arrastra la EA `Asian_V2.0`.
2. Abre un gráfico de **EURUSD en M15**. Arrastra la EA `Anti_Asian_V2.0`.
3. Al arrastrarlos, en la pestaña de parámetros de entrada, revisa la sección **--- NEWS FILTER (API) ---**:
   - `UseNewsFilter` = `true`
   - `FilterHighImpact` = `true` (Bloquea Rojas)
   - `FilterMedImpact` = `false` (Permite Naranjas)
   - *Ajusta los minutos antes/después según tu preferencia (Por defecto: 30/30).*

## ⚠️ Preguntas Frecuentes

**¿Debo arrastrar el indicador FFCal al gráfico?**
*Operativamente:* **NO es necesario**. Los EAs V2.0 usan la función `iCustom` para ejecutar FFCal de forma invisible en la memoria RAM, sin necesidad de que esté dibujado en el gráfico.
*Visualmente:* **SÍ PUEDES hacerlo**. Si arrastras FFCal al gráfico, NO perjudicará en absolutamente nada al EA. Simplemente verás los textos del indicador (calendario) en tu pantalla, lo cual es muy útil para confirmar visualmente que está leyendo las noticias correctamente y para ver los próximos eventos.

**¿Cómo sé que las líneas del EA funcionan?**
El EA solo dibujará las líneas verticales de noticias en el gráfico durante sus **horas operativas** (después de cerrar la caja asiática). Si es fin de semana, de madrugada, o no hay noticias rojas agendadas, no verás la línea para no sobrecargar tu gráfico con objetos innecesarios.

**¿Cómo audito bloqueos?**
Revisa la pestaña **Expertos** (Experts) en el Terminal de MT4. Si el EA frena un trade por una noticia, imprimirá el mensaje: `"SMC Entrada Bloqueada: Filtro de Noticias activo."`
