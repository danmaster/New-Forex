# Entorno Operativo: RoboForex (Entidad Global)

Este documento detalla la estructura de cuentas activas en RoboForex y define el entorno de software necesario para el despliegue de los Expert Advisors (EAs).

## 1. Análisis de Cuentas Actuales

Según tu panel de control, posees 4 cuentas con diferentes propósitos y plataformas. Aquí tienes el significado de cada una:

| Número de Cuenta | Tipo de Cuenta | Apalancamiento | Divisa | Plataforma / Software | Propósito / Significado |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **92001348** | R StocksTrader Demo | 1:20 | - | R StocksTrader | Cuenta de demostración de la plataforma nativa de RoboForex para operar acciones reales y ETFs. **NO es válida para nuestros EAs.** |
| **34091279** | MT4 ProCent 4 | **1:500** | EUR | MetaTrader 4 (MT4) | Cuenta *Cent* real en euros. Al depositar 1.000€, el balance se mostrará como 100.000 céntimos. |
| **47023999** | MT4 ProCent 7 | **1:500** | EUR | MetaTrader 4 (MT4) | Exactamente igual a la anterior (actualmente tiene 0.0066 EUR residuales). Cuenta Cent lista para usar. |
| **30018406** | Partner (Afiliado) | 1:100 | USD | Panel Web | Cuenta interna (billetera) para recibir comisiones si recomiendas el broker a otras personas (IB). No se usa para operar en el mercado. |

## 2. ¿Cuál utilizarás para tu Cuenta Real de 1.000 €?

Debes utilizar obligatoriamente una de tus cuentas **MT4 ProCent** (por ejemplo, la `34091279` o la `47023999`).

*   **¿Por qué?:** Al ser cuentas de centavos (Cent), fraccionan tu capital x100, permitiendo que el EA calcule el lotaje con un nivel de micro-precisión brutal. Combinado con el apalancamiento 1:500, el robot jamás sufrirá ahogos por falta de margen al usar Stop Loss ajustados (5 pips) y arriesgando tu 1% deseado.

## 3. Sistemas de Software Necesarios

Tus cuentas operan exclusivamente bajo este entorno tecnológico:

1.  **Software de Ejecución Principal:**
    * **MetaTrader 4 (MT4):** Es el estándar de la industria. Tus robots (archivos `.mq4` / `.ex4`) fueron programados nativamente para el ecosistema de MT4. **Es de suma importancia que sepas que tus robots NO funcionarán en MetaTrader 5 (MT5)** ni en la plataforma web *R StocksTrader*.
2.  **Sistema Operativo:**
    * La terminal de MT4 de RoboForex se debe ejecutar en **Windows** (el cual ya utilizas).
3.  **Entorno de Operación 24/5 (VPS):**
    * Puesto que la estrategia *Asian Breakout* y *Anti-Asian Breakout* vigila sesiones de madrugada y de Nueva York de forma ininterrumpida, deberías instalar este MetaTrader 4 de RoboForex en un **VPS (Servidor Privado Virtual) con Windows**. Esto mantendrá al software operativo las 24 horas del día de lunes a viernes, ajeno a si apagas tu ordenador local o se corta tu internet.

---

## 4. Estado de la Cuenta 47023999 (Validación)

Según el análisis de tu ficha de cliente, esta será la cuenta principal a utilizar, ya que cumple con todos los requisitos operativos y de seguridad:

*   **Identidad y Seguridad:** Tu cuenta está **Verificada (Sí)** y tu teléfono también (**Sí**). Esto garantiza que no tendrás bloqueos al momento de realizar retiros.
*   **Entidad Legal:** Estás operando bajo **RoboForex Ltd (licencia No. 9759600)**, que es la entidad global (Offshore en Belice), lo que nos da acceso al apalancamiento 1:500.
*   **Swap-Free (Libre de Swap): No.** 
    *   *Importante para el EA:* Esto significa que el bróker te cobrará (o pagará) comisiones de *Swap* si mantienes posiciones abiertas de un día para otro (después del rollover nocturno). Como nuestro *Asian Breakout* a veces arrastra operaciones al día siguiente, debemos estar preparados para que se descuenten unos céntimos de coste operativo.
*   **Balance Actual:** 0.66 EUR centavos. Lista para recibir tu primer depósito de 1.000 €.

---
*Nota: Este documento ha sido elaborado para estandarizar tu entorno de trading algorítmico y preparar tu inminente salto a Real.*
