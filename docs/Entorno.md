# Entorno de Operaciones Forex

Este documento detalla la configuraciÃ³n y el entorno utilizado para esta nueva etapa en las operaciones de Forex.

## Datos de Inicio
- **Fecha de inicio:** 15 de Junio de 2026

## MetodologÃ­a y Aprendizaje
- **GuÃ­as Principales:** Lecciones en YouTube de Alex Ruiz y Yuri Rabassa.
- **Canales de YouTube:** 
  - Alex Ruiz: [https://www.youtube.com/@AlexRuiiz](https://www.youtube.com/@AlexRuiiz)
  - Yuri Rabassa: [https://www.youtube.com/@YuriRabassa](https://www.youtube.com/@YuriRabassa)
- **GestiÃ³n de Recursos:** Los videos de las lecciones se irÃ¡n descargando y guardando localmente en la carpeta `/Estrategias`.

## Infraestructura TÃ©cnica
- **Entorno de EjecuciÃ³n:** Las aplicaciones utilizadas para operar se encuentran alojadas y se ejecutan de forma remota en servidores de **Contabo**.
- **Acceso a Contabo:**
  - **URL:** [https://my.contabo.com/](https://my.contabo.com/)
  - **Usuario/Login:** `dan@arteywebcreaciones.com`
  - **ContraseÃ±a:** `NQ65m7o9TbRd`
- **Acceso al Servidor Windows (VPS):**
  - **IP (Escritorio Remoto):** `62.169.20.253`
  - **Sistema Operativo:** Windows Server 2022 Datacenter Edition
  - **Usuario RDP:** `Administrator`
  - **ContraseÃ±a:** `Viena62020%`
  - **VNC (Emergencias):** `161.97.97.234:63150`

## Cuentas de Trading
- **Plataforma:** MetaTrader 4 (MT4)
- **Broker:** Skilling
- **Tipo de Cuenta:** Demo
- **Servidor:** `SkillingLimited-Demo`
- **NÃºmero de Cuenta (Login):** `7016509`
- **Identificador de Cliente:** `customer-499277`

### SincronizaciÃ³n Horaria (Broker vs Madrid)
**La Regla de Oro:** Skilling utiliza la configuraciÃ³n estÃ¡ndar *New York Close* (GMT+3 en verano, GMT+2 en invierno). Dado que EspaÃ±a continental (Madrid) cambia sus relojes a la par (GMT+2 en verano, GMT+1 en invierno), la diferencia horaria es matemÃ¡ticamente constante todo el aÃ±o: **Hora del Broker = Hora de Madrid + 1 hora**.

Para evitar confusiones con indicadores externos, la **Tabla de la Verdad** oficial para la configuraciÃ³n de horarios en MetaTrader 4 es la siguiente:

| SesiÃ³n | Apertura (Broker) | Cierre (Broker) | Hora Madrid equivalente |
| :--- | :--- | :--- | :--- |
| **Tokio (AsiÃ¡tica)** | `02:00` | `08:00` | 01:00 a 07:00 |
| **Europea** | `09:00` | `18:00` | 08:00 a 17:00 |
| **Nueva York** | `14:00` | `23:00` | 13:00 a 22:00 |

*Nota tÃ©cnica: Tanto el indicador `AsianBox.mq4` como el EA `AsianBreakout_100D.mq4` tienen estos horarios de Broker integrados por defecto como `StartHour` y `EndHour`.*

## Herramientas de AnÃ¡lisis
- **Plataforma:** [TradingView](https://es.tradingview.com/)
- **Email:** `rhood20@hotmail.com`
- **Usuario:** `grandanmaster`
- **ContraseÃ±a:** *(Pendiente de confirmar)*

### Indicadores Clave (TradingView)
- **FXN - Asian Session Range** (creado por RobMinty): Utilizado en la *Estrategia de los 100 DÃ³lares* para identificar el rango de consolidaciÃ³n asiÃ¡tico (grÃ¡ficos de 5m). *ConfiguraciÃ³n recomendada: Desactivar las sesiones de Londres y Nueva York para dejar Ãºnicamente visible la caja asiÃ¡tica.*

## Billeteras y GestiÃ³n de Capital

### Skrill
- **Email:** `dan@arteywebcreaciones.com`
- **ContraseÃ±a:** `@2026%Robinh00d`
- **Saldo Actual:** 5,00 EUR
- **Estado de Cuenta:** No verificado (LÃ­mite de cuenta: 250 EUR). *Nota: Skrill indica que no hay necesidad de verificar la cuenta en este momento. Probablemente se pedirÃ¡ la verificaciÃ³n al superar ciertos lÃ­mites de depÃ³sito.*

### PayPal
- **Email:** *(Privado / Pendiente)*
- **ContraseÃ±a:** *(Oculta por privacidad)*

## AutomatizaciÃ³n y Herramientas
- **Python y Scripts:** Este entorno cuenta con herramientas y scripts en Python (como `yt-dlp` y los archivos en la carpeta `/scripts/`) diseÃ±ados para automatizar tareas. Esto nos permite extraer fÃ¡cilmente las listas de videos de YouTube y descargar el material directamente a nuestra carpeta local (`/Estrategias`).

## PrÃ³ximos Pasos / Tareas Pendientes
- **Diario de Trading AutomÃ¡tico:** Crear un script en Python que permita registrar y analizar de manera automatizada las operaciones diarias (Trading Journal) para medir el rendimiento de las estrategias.

