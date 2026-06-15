# Entorno de Operaciones Forex

Este documento detalla la configuración y el entorno utilizado para esta nueva etapa en las operaciones de Forex.

## Datos de Inicio
- **Fecha de inicio:** 15 de Junio de 2026

## Metodología y Aprendizaje
- **Guías Principales:** Lecciones en YouTube de Alex Ruiz y Yuri Rabassa.
- **Canales de YouTube:** 
  - Alex Ruiz: [https://www.youtube.com/@AlexRuiiz](https://www.youtube.com/@AlexRuiiz)
  - Yuri Rabassa: [https://www.youtube.com/@YuriRabassa](https://www.youtube.com/@YuriRabassa)
- **Gestión de Recursos:** Los videos de las lecciones se irán descargando y guardando localmente en la carpeta `/Estrategias`.

## Infraestructura Técnica
- **Entorno de Ejecución:** Las aplicaciones utilizadas para operar se encuentran alojadas y se ejecutan de forma remota en servidores de **Contabo**.
- **Acceso a Contabo:**
  - **URL:** [https://my.contabo.com/](https://my.contabo.com/)
  - **Usuario/Login:** `dan@arteywebcreaciones.com`
  - **Contraseña:** `NQ65m7o9TbRd`
- **Acceso al Servidor Windows (VPS):**
  - **IP (Escritorio Remoto):** `62.169.20.253`
  - **Sistema Operativo:** Windows Server 2022 Datacenter Edition
  - **Usuario RDP:** `Administrator`
  - **Contraseña:** `Viena62020%`
  - **VNC (Emergencias):** `161.97.97.234:63150`

## Cuentas de Trading
- **Plataforma:** MetaTrader 4 (MT4)
- **Broker:** Skilling
- **Tipo de Cuenta:** Demo
- **Servidor:** `SkillingLimited-Demo`
- **Número de Cuenta (Login):** `7016509`
- **Identificador de Cliente:** `customer-499277`

## Herramientas de Análisis
- **Plataforma:** [TradingView](https://es.tradingview.com/)
- **Email:** `rhood20@hotmail.com`
- **Usuario:** `grandanmaster`
- **Contraseña:** *(Pendiente de confirmar)*

### Indicadores Clave (TradingView)
- **FXN - Asian Session Range** (creado por RobMinty): Utilizado en la *Estrategia de los 100 Dólares* para identificar el rango de consolidación asiático (gráficos de 5m). *Configuración recomendada: Desactivar las sesiones de Londres y Nueva York para dejar únicamente visible la caja asiática.*

## Billeteras y Gestión de Capital

### Skrill
- **Email:** `dan@arteywebcreaciones.com`
- **Contraseña:** `@2026%Robinh00d`
- **Saldo Actual:** 5.00 EUR
- **Estado de Cuenta:** No verificado (Límite de cuenta: 250 EUR). *Nota: Skrill indica que no hay necesidad de verificar la cuenta en este momento. Probablemente se pedirá la verificación al superar ciertos límites de depósito.*

### PayPal
- **Email:** *(Privado / Pendiente)*
- **Contraseña:** *(Oculta por privacidad)*

## Automatización y Herramientas
- **Python y Scripts:** Este entorno cuenta con herramientas y scripts en Python (como `yt-dlp` y los archivos en la carpeta `/scripts/`) diseñados para automatizar tareas. Esto nos permite extraer fácilmente las listas de videos de YouTube y descargar el material directamente a nuestra carpeta local (`/Estrategias`).

## Próximos Pasos / Tareas Pendientes
- **Diario de Trading Automático:** Crear un script en Python que permita registrar y analizar de manera automatizada las operaciones diarias (Trading Journal) para medir el rendimiento de las estrategias.
