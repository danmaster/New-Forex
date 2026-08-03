# Comparativa de Expert Advisors (EAs Activos)

Actualmente, el repositorio cuenta con dos algoritmos operativos y validados en la carpeta `/Experts`. Ambos nacen de los mismos principios de **Smart Money Concepts (SMC)** y del análisis del "Rango Asiático", pero abordan el mercado con filosofías operativas completamente opuestas y complementarias.

---

## 1. Perfil Técnico de los EAs

| Característica | Asian Breakout (V1.016) | Anti-Asian Breakout (V1.018) |
| :--- | :--- | :--- |
| **Filosofía Estratégica** | Reversión a la media / "Fade the breakout" | Continuación de Tendencia / Momentum |
| **Marco Temporal (TF)** | **M5** (Búsqueda de precisión milimétrica) | **M15** (Búsqueda de confirmación estructural) |
| **Patrón Buscado** | Judas Swing (Manipulación / Caza de liquidez) | Ruptura genuina + Amago (Pullback) a favor de tendencia |
| **Filtro Direccional** | Ninguno (Opera contra el impulso inicial de rotura) | **EMA 50 y 200 en H1** (Filtro institucional) |
| **Tasa de Acierto (Win Rate)** | Media (~50%) | **Muy Alta (~77%)** |
| **Ratio Riesgo/Beneficio** | Fijo **1:3** (Altamente asimétrico) | Dinámico (Trailing Stop de 15 pips) |
| **Drawdown (Estrés)** | Moderado (Normal sufrir rachas de S/L) | **Bajísimo** (Muy pocos S/L gracias al filtro de tendencias) |
| **Restricción Horaria** | Todo el día (Reversiones pueden ocurrir en NY) | **Max 18:00** (Evita el "ruido" tardío tras las sesiones) |

---

## 2. Análisis del Comportamiento Operativo

### Asian Breakout V1.016 (El Cazador de Trampas)
Este EA asume que la rotura inicial de la caja asiática es falsa en la mayoría de los casos. Espera a que los traders *retail* compren la ruptura, para luego entrar en la dirección contraria junto al dinero institucional (Smart Money).
- **Punto Fuerte:** Cuando acierta, el ratio de beneficio es enorme (1:3 fijo o más). Una sola operación ganadora recupera tres pérdidas.
- **Punto Débil:** Obliga a tener una psicología fuerte, ya que tolerará rachas perdedoras del 50%. A veces el precio rompe y no vuelve, tocando el Stop Loss.

### Anti-Asian Breakout V1.018 (El Seguidor de Instituciones)
Este EA asume que cuando el mercado rompe con fuerza y está alineado con la tendencia macro (EMAs de H1), la rotura es real. Espera un pequeño amago de regreso a la caja (Pullback) para asustar, y entra a favor de la tendencia.
- **Punto Fuerte:** Su altísima tasa de aciertos (casi 80%). Su curva de capital es casi una línea recta hacia arriba. Protege el capital rápidamente con Auto Break-Even y Trailing Stop.
- **Punto Débil:** Si el mercado entra en consolidación o rango lateral en H1, no operará. Renuncia a grandes ganancias (Take Profits fijos masivos) en favor de asegurar capital contantemente.

---

## 3. Conclusiones y Sinergias (Portfolio)

El gran valor de tener ambos EAs en la misma cuenta radica en su **correlación negativa a nivel estratégico**:

1. **Cuando el mercado está en rango (Días lentos):** El *Asian Breakout* brillará capturando las falsas roturas y devolviendo el precio al centro de la caja, mientras que el *Anti-Asian* permanecerá desactivado (bloqueado por las EMAs o esperando un Momentum que nunca llega).
2. **Cuando hay noticias o fuerte tendencia macro (Días explosivos):** El *Asian Breakout* probablemente sufrirá un Stop Loss (ya que la ruptura no será falsa), pero el *Anti-Asian* capturará todo ese movimiento direccional, recuperando la pérdida del primero y sacando la cuenta a flote con grandes beneficios gracias al Trailing Stop.

### Recomendación de Despliegue (Live)
- **Riesgo:** Asignar **1% de riesgo dinámico** a cada uno es perfectamente seguro, ya que matemáticamente es muy difícil que ambos EAs ejecuten operaciones perdedoras simultáneamente en la misma dirección. (Si uno falla asumiendo falsedad, el otro gana asumiendo tendencia).
- **Entorno:** Ambos deben ejecutarse en el mismo VPS 24/5. 
- **Gestión:** Mantener la V1.018 con el filtro de las 18:00 para asegurar que el componente tendencial (el que aporta la estabilidad a la cuenta) mantenga el Drawdown general del portafolio en niveles mínimos.
