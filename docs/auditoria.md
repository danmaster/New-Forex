---
  Auditoría estricta — Experts/Asian_V2.0.mq4

  Entorno objetivo: MT4 ProCent RoboForex (EUR, 1:500, 5
  dígitos, NO swap-free, VPS Windows 24/5).
  Marco de revisión: Checklist del forex-ea-architect +
  sintaxis MQL4.

  ---
  Resumen ejecutivo

  El EA está globalmente bien estructurado y respeta las
  prácticas clave de tu checklist: pip multiplier dinámico,
  MagicNumber único, slippage explícito, lotaje 1% con
  TickValue, time-stop por minutos y velas, y resiliencia de
  cierres parciales con doble respaldo (comentario +
  memoria). El comportamiento SMC es coherente con V2.0.

  Hay 3 hallazgos críticos/altos que vale la pena arreglar  
  antes del siguiente deploy y varios de higiene media.
  Ninguno de ellos es un crash en backtest, pero dos son
  riesgos materiales en live contra RoboForex ProCent.

  Los 3 más urgentes:

  1. Time-stop del sweep SMC potencialmente inalcanzable
  (HIGH) — la lógica MaxCandlesOutside/MaxMinutesForReversal
  opera contra iBarShift(timeSwept*) que puede devolver
  valores no acotados si la orden quedó flotando varios
  días.
  2. IsTrendAligned es stub return true; (MEDIUM, no crítico
  por diseño documentado) — filtra entradas en silencio, no
  avisa al usuario.
  3. Reseteo de memoria de gestión al cambiar de día con
  HasActiveTrades()=true (MEDIUM) — g_mgmtBEDone puede
  quedar en estado inconsistente si el EA se reinicia con
  una operación viva de la sesión anterior.

  ---
  Hallazgos detallados

  🔴 HIGH — Time-stop SMC depende de iBarShift cuyo
  resultado no está acotado en live

  Dónde: Experts/Asian_V2.0.mq4:874 y :889
  int barsPassed = iBarShift(Symbol(), Period(),
  timeSweptHigh);
  if(barsPassed > MaxCandlesOutside || (Time[0] -
  timeSweptHigh > MaxMinutesForReversal * 60))

  Defecto: iBarShift devuelve -1 si la fecha no se encuentra
  (porque la profundidad del chart puede no llegar al
  momento del sweep original). Si el EA sobrevive a varios  
  fines de semana con la variable estática viva (cosa que
  puede pasar entre reinicios de VPS), barsPassed < 0 pero  
  en la rama if(sweptHigh) ya entraste por lo tanto no es
  catastrófico, pero: si barsPassed == 0 porque el sweep
  ocurrió en la vela actual/abierta, la comparación >
  MaxCandlesOutside ignora que ya pasó el umbral de minutos
  (Time[0] - timeSweptHigh puede ser 4 horas). La doble
  condición está unida por || lo que es correcto, pero no se
  valida barsPassed >= 0, así que si timeSweptHigh quedó
  residual de un día anterior y iBarShift devuelve -1, el EA
  mantiene sweptHigh=true indefinidamente hasta que
  MaxMinutesForReversal se cumpla.

  Escenario de fallo: Operación de viernes que arrastra al  
  lunes → timeSweptHigh queda con valor viejo, el lunes el  
  EA detecta una nueva ruptura bajísima en el día y como
  sweptHigh todavía es true (no se reseteó el viernes porque
  MaxEntryHour se cumplió), entra en posición de venta en
  una dirección incorrecta.

  Patch mínimo:
  // Solo considerar válido si barsPassed >= 0
  if(sweptHigh)
  {
     int barsPassed = iBarShift(Symbol(), Period(),
  timeSweptHigh);
     bool caducadoPorVelas = (barsPassed >= 0 && barsPassed
  > MaxCandlesOutside);
     bool caducadoPorTiempo = (Time[0] - timeSweptHigh >
  MaxMinutesForReversal * 60);
     if(barsPassed < 0 || caducadoPorVelas ||
  caducadoPorTiempo)
     {
        sweptHigh = false;
        patternFoundHigh = false;
        peakHigh = 0;
     }
     ...
  }

  ---
  🟡 MEDIUM — IsTrendAligned es un stub return true; sin log
  de aviso

  Dónde: Experts/Asian_V2.0.mq4:477-480
  bool IsTrendAligned(bool isBuy)
    {
     return true; // Filtro de tendencia eliminado (las EMAs
  arruinan el Judas Swing)
    }

  Defecto: La firma pública acepta un parámetro isBuy pero  
  lo ignora completamente. La documentación interna dice
  "Filtro eliminado por decisión del operador", lo cual es  
  válido. Pero (a) el input UseBreakEvenAt1R y la lógica de
  branches BE/trailing están diseñados como compatibles con
  un filtro que ya no existe, (b) cualquier persona que lea
  el código (incluido tú en 6 meses) verá la función y
  esperará que devuelva la dirección real.

  Escenario de fallo: Ninguno en comportamiento actual
  (siempre retorna true, ambas ramas pasan). Pero si en el  
  futuro se reintroduce el filtro, la firma bool + isBuy ya
  está acoplada.

  Patch mínimo: Renombrar a IsSweepAllowedByTrend(bool
  isBuy) con cuerpo trivial o eliminar la función y
  reemplazar las llamadas en :934 y :982 por un literal true
  con un comentario claro:
  // Filtro de tendencia macro DESHABILITADO por diseño
  (Judas Swing requiere operar contra el impulso).
  // Si se reactiva, reintroducir IsTrendAligned() con EMAs
  H1.

  Y en OnInit, añadir un Print que indique explícitamente
  que no hay filtro direccional, para que el log de arranque
  lo deje claro en cada deploy.

  ---
  🟡 MEDIUM — Reset de g_mgmt*y g_partialClosed* al cambiar
  de día solo ocurre si NO hay operaciones vivas

  Dónde: Experts/Asian_V2.0.mq4:743-748
  if(!HasActiveTrades())
    {
     g_partialClosedCount = 0; // Limpiar memoria de cierres
  parciales
     g_mgmtCount = 0;          // Limpiar memoria de gestión
  BreakEven/Trailing
    }

  Defecto: Condición correcta en términos de "no perder
  seguimiento de operaciones abiertas". Pero si el EA se
  reinicia con una operación viva (deploy, crash, recarga
  del VPS), g_mgmtTickets[] y g_partialClosedTickets[] se
  vacían en el siguiente cambio de día. Esa operación
  abierta de la sesión anterior pierde su memoria de riesgo
  para UseBreakEvenAt1R y pierde la marca de "ya
  parcialmente cerrada", con dos consecuencias:

  1. Si UseBreakEvenAt1R = true: ManageBreakEvenAt1R hace
  GetInitialRisk(ticket) y al no encontrarlo retorna -1, se
  hace continue (línea 232), y la operación nunca recibirá  
  BE/trailing hasta que se cierre.
  2. Si UsePartialClose = true: el ticket podrá recibir un  
  segundo cierre parcial aún si el broker ya aplicó el
  primero y MT4 generó un nuevo ticket que también coincide
  en MagicNumber + Símbolo. En ProCent, donde MODE_LOTSTEP  
  es 0.01, esto puede terminar acumulando dos parciales (90%
  del lote cerrado) sin querer.

  Escenario de fallo: Crash de MT4 en VPS un martes por la  
  noche con una posición abierta. Miércoles a las 02:00 el  
  EA arranca, llega al cambio de día, limpia memoria. Si la
  posición llega a 15 pips de beneficio y
  UsePartialClose=true, el EA cierra otro 50% — reduciendo  
  posición a 25% del lote original sin querer.

  Patch mínimo: Almacenar estos registros por ticket
  persistido (fichero .bin o global variables con prefijo
  SMC_PC_<ticket>) en lugar de arrays en memoria. Mínimo
  viable: añadir un barrido en OnInit() que, al arrancar,
  recorra OrdersTotal() y rehidrate
  g_mgmtTickets[]/g_partialClosedTickets[] desde el estado  
  actual.

  ---
  🟡 MEDIUM — Slippage hardcoded como literal 3 (no
  configurable) en todas las llamadas a OrderSend/OrderClose

  Dónde: :455, :706, :712, :964, :1012, :1086

  Defecto: Usan 3 directamente. Para majors en ProCent es
  razonable, pero (a) no es ajustable desde inputs (debería
  serlo para que el usuario pueda endurecerlo en noticias),
  (b) no está documentado en ningún comentario, (c) 2
  llamadas a OrderClose (líneas 706 y 712, dentro del cierre
  de fin de día) usan 3 con OrderLots() completos — esto
  significa que en momentos de spread alto (rollover,
  domingos) un cierre completo de posición puede fallar por
  slippage insuficiente sin reintento.

  Escenario de fallo: Viernes 22:59 con spread de 8 pips. El
  EA dispara el cierre de fin de día con slippage=3.
  OrderClose falla con error Off quotes. El EA loguea el
  error en :708 y sigue sin reintentar — la posición queda  
  viva durante el fin de semana con swap triple el
  miércoles.

  Patch mínimo:
  input int SlippagePoints = 3; // Slippage máximo permitido
  en points (3 ≈ ProCent majors)

  #define SLIPPAGE SlippagePoints
  Y reemplazar todos los 3 por SLIPPAGE. Para los cierres de
  fin de día, envolver en un loop de 3 reintentos con
  relectura del spread.

  ---
  🟡 MEDIUM — OrderModify no verifica OrderStopLoss() antes
  de mover en ManageBreakEvenAt1R cuando se acaba de salir  
  del breakeven

  Dónde: Experts/Asian_V2.0.mq4:259 y :280/:292

  Defecto:

- En :259, OrderModify(ticket, OrderOpenPrice(), newSL,
  OrderTakeProfit(), 0, clrBlue) — al pasar a BE, no se
  verifica que el cambio sea estrictamente necesario (por
  ejemplo si ya estaba en BE por una intervención manual).  
- En :280/:292 (trailing tras BE), la condición newSL -
  OrderStopLoss() > Point *2 solo aplica cuando OrderType()
  == OP_BUY. Para SELL la condición simétrica
  OrderStopLoss() - newSL > Point* 2 ya existe (:290), lo  
  cual está bien, pero en :290 usa || con OrderStopLoss() ==
  0 que permite mover el SL hacia abajo aunque ya haya SL
  válido y no mejore — esto es deseable cuando el SL es 0
  (caso fresh), pero indeseable si el SL ya está por debajo
  del nuevo. Está protegido por la rama bid-orden>trailing  
  previa, pero vale la pena documentar.

  Escenario de fallo: Si tras una intervención manual el SL
  está bien colocado, el EA lo ignora y puede degradarlo.
  Probabilidad baja, pero presente.

  Patch mínimo: Añadir log informativo cuando OrderModify
  realmente modifica, y un Print que indique "sin cambio (SL
  ya estaba por encima)" para auditoría.

  ---
  🟢 LOW — HasActiveTrades() itera OrdersTotal() aunque ya  
  haya encontrado una activa

  Dónde: Experts/Asian_V2.0.mq4:573-586

  Defecto: El bucle retorna en la primera activa (correcto),
  pero llama dentro de OnTick y dentro del reset diario. En
  sesiones tranquilas con 0 operaciones, son 2× iteraciones
  de OrdersTotal() por tick. No es crítico, pero son
  perceptibles en símbolos con tick frequency alto.

  Patch mínimo: Cachear en una variable global bool
  hasActiveChecked, refrescada solo al final de OnTick.
  Funcionalmente igual, ~50% menos llamadas en simbólico.

  ---
  🟢 LOW — currentDay se asigna dos veces en el reset diario

  Dónde: Experts/Asian_V2.0.mq4:732-749

  Defecto: if(currentDay != currentSessionDay) se evalúa
  dentro del bloque if(currentHour >= EndHour && currentHour
  < MaxEntryHour). Si el cambio de día ocurre durante la
  franja 02:00–08:00 (zona muerta del EA), no se resetea
  hasta la siguiente sesión. Funcionalmente la lógica SMC
  solo arranca tras EndHour, así que no rompe nada, pero
  sweptHigh/sweptLow retienen información residual del día  
  previo si hubiera.

  Escenario de fallo: Ninguno directo porque el bloque SMC  
  solo ejecuta tras EndHour y lastBarTime se evalúa de
  nuevo. Pero un Print adicional clarificaría el orden de
  eventos.

  Patch mínimo: Subir el reset diario a OnTick sin guard de
  horario, con un Print que indique el reset. Mantener el
  resto de la lógica SMC dentro del guard.

  ---
  🟢 LOW — UseBreakEvenAt1R y UseAutoBreakEven son
  mutuamente excluyentes pero no se valida en OnInit

  Dónde: Experts/Asian_V2.0.mq4:46-49

  Defecto: El código en OnTick:678-686 ya gestiona la
  exclusión (línea IF/ELSE), pero un usuario podría activar
  ambos sin leer el código y perder de vista cuál se está
  aplicando. Solo se imprime el aviso cuando
  UseBreakEvenAt1R = true en :127. Falta el simétrico.

  Patch mínimo: Añadir en OnInit:
  if(UseAutoBreakEven && UseBreakEvenAt1R)
     Print("ATENCION: Ambos modos de BE activos. Solo se
  aplicara 'UseBreakEvenAt1R' (ignora
  'UseAutoBreakEven').");

  ---
  🟢 LOW — News filter basado en GlobalVariableCheck puede  
  fallar si News_Fetcher.mq4 no está cargado

  Dónde: Experts/Asian_V2.0.mq4:1144-1169

  Defecto: Si el indicador News_Fetcher.mq4 no está
  corriendo en el chart, las global variables no existen y  
  IsNewsTime() retorna false. Silenciosamente desactiva el  
  filtro. No es un bug (es la semántica del filtro), pero un
  Print en OnInit confirmaría al operador que el filtro
  está enlazado o, alternativamente, lo desactivaría
  explícitamente.

  Patch mínimo:
  if(UseNewsFilter && !GlobalVariableCheck("SMC_News_High")
  && !GlobalVariableCheck("SMC_News_Med"))
     Print("ALERTA: News_Fetcher.mq4 no detectada en chart.
  Filtro de noticias DESACTIVADO.");

  ---
  🟢 LOW — Bid < sl (línea 962) y Ask > sl (línea 1010) son
  chequeos válidos pero no usan stopLevel

  Dónde: Experts/Asian_V2.0.mq4:962 y :1010

  Defecto: Antes de OrderSend, el código valida que el
  precio no haya atravesado el SL, pero no consulta
  MarketInfo(Symbol(), MODE_STOPLEVEL). En pares exóticos o
  eventos puntuales, el broker puede rechazar la orden por  
  Invalid stops sin reintento. Riesgo bajo para majors en
  ProCent, no despreciable para XAUUSD.

  Patch mínimo:
  double stopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL) *
  Point;
  if(sl + stopLevel > /* ... */) { /* ajustar */ }

  ---
  Verificación del checklist que SÍ está bien cubierta

  Confirmo positivamente que en este archivo:

  Ítem del checklist: Pip = (Digits == 3 || Digits == 5) ?  
  10

- Point : Point
  Estado: ✅ Correcto
  Línea(s): :132
  ────────────────────────────────────────
  Ítem del checklist: MagicNumber único en input y filtrado
  en TODAS las funciones de gestión
  Estado: ✅ Correcto
  Línea(s): :21, usado en :226, :317, :370, :433, :491,
  :526,
  :551, :579, :702, :964, :1012, :1086
  ────────────────────────────────────────
  Ítem del checklist: Lotaje dinámico sobre AccountBalance()

  × RiskPercent con MODE_TICKVALUE y MODE_TICKSIZE/Point
  Estado: ✅ Correcto
  Línea(s): :140-163
  ────────────────────────────────────────
  Ítem del checklist: MaxTradesPerDay con reset por clave
  YEAR*10000+MONTH*100+DAY
  Estado: ✅ Correcto (FIX bug3)
  Línea(s): :106-109, :512, :690
  ────────────────────────────────────────
  Ítem del checklist: Time-stop SMC por minutos y velas
  (MaxMinutesForReversal, MaxCandlesOutside)
  Estado: ✅ Presente, pero con el HIGH de arriba
  Línea(s): :69-70, :874-875, :889-890
  ────────────────────────────────────────
  Ítem del checklist: Partial-close con doble respaldo
  (comentario + ticket registry)
  Estado: ✅ Robusto
  Línea(s): :91-92, :436-437, :459-463
  ────────────────────────────────────────
  Ítem del checklist: #property strict
  Estado: ✅ Presente
  Línea(s): :9
  ────────────────────────────────────────
  Ítem del checklist: Inputs agrupados con header strings
  estilo "--- X ---"
  Estado: ✅ Consistente con el proyecto
  Línea(s): :12, :26, :33, :37, :41, :45, :51, :63
  ────────────────────────────────────────
  Ítem del checklist: SendNotification solo si InpSendPush  
  Estado: ✅ Correcto
  Línea(s): :465, :969, :1017, :1093
  ────────────────────────────────────────
  Ítem del checklist: Comentarios en español en Print,
  lógica
  en inglés
  Estado: ✅ Consistente
  Línea(s): múltiples
  ────────────────────────────────────────
  Ítem del checklist: IsTrendAligned deshabilitado con
  justificación
  Estado: ✅ Documentado
  Línea(s): :479
  ────────────────────────────────────────
  Ítem del checklist: Filtro de noticias con
  GlobalVariableCheck + MinsBeforeNews/MinsAfterNews
  Estado: ✅ Funcional
  Línea(s): :1144-1169
  ────────────────────────────────────────
  Ítem del checklist: Sin MathRand/MathSrand en decisiones  
  Estado: ✅ Ausente
  Línea(s): —
  ────────────────────────────────────────
  Ítem del checklist: Sin I/O en OnTick (objetos creados,
  pero solo si IsNewsTime)
  Estado: ✅ Aceptable
  Línea(s): :1129
  ────────────────────────────────────────
  Ítem del checklist: Indicadores manejados vía
  iHighest/iLowest (nativos, no requiere handles)
  Estado: ✅ No aplica handles aquí
  Línea(s): :794-795
  ────────────────────────────────────────
  Ítem del checklist: GetLastError() logueado en TODAS las  
  llamadas de OrderModify/OrderClose/OrderSend
  Estado: ✅ Consistente
  Línea(s): :281, :293, :330, :346, :383, :399, :496, :708,
  :714, :974, :1022, :1099
  ────────────────────────────────────────
  Ítem del checklist: NormalizeDouble(..., Digits) antes de
  cada precio pasado al servidor
  Estado: ✅ Consistente
  Línea(s): :248, :253, :277, :289, :324, :339, :376, :392,
  :951, :959, :999, :1007, :1057, :1068, :1075-1077
  ────────────────────────────────────────
  Ítem del checklist: Validación Bid < sl (sell) y Ask > sl
  (buy) antes de OrderSend
  Estado: ✅ Presente
  Línea(s): :962, :1010

  ---
  Inputs del checklist faltantes / sospechosos (higiene
  separada)

  Estos no son bugs pero faltan para paridad con el
  checklist del subagente:

- ❌ No hay input SlippagePoints — slippage hardcoded como
  3 en código (mencionado arriba).
- ❌ No hay input TimeZoneBroker — la lógica de sesión usa
  Hour() directamente, asumiendo que el servidor MT4 está
  en el huso del broker. Funciona para Skilling/RoboForex
  ProCent, pero deja la portabilidad fuera del control del  
  usuario.
- ⚠️ WaitCandleClose existe en input (:18) pero el código
  siempre evalúa al cierre (mensaje explícito en :117). El  
  input no hace nada — debería eliminarse o documentarse
  mejor en OnInit.
- ⚠️ HoursToLookBack existe (:65) pero nunca se
  referencia. Mensaje correcto en OnInit:120, pero el input
  no debería estar visible.
- ⚠️ CloseAtEndOfDay (:58) y la franja 23:00 hardcoded en
  :693 están acoplados. Si el usuario quiere cerrar a las
  22:00, no puede. Sugiero añadir EndOfDayCloseHour.

  ---
  Lo que NO tocar

  Estas piezas son deliberadas del diseño del EA y deben
  preservarse en cualquier refactor:

  1. La coexistencia UseBreakEvenAt1R / UseAutoBreakEven +  
  ManageTrailingStop en líneas :218-407 — es una evolución  
  histórica bien mantenida con un IF/ELSE explícito en
  OnTick:678-686 que previene pisarse.
  2. El reset doble de g_partialClosedCount y g_mgmtCount en
  :743-748 con HasActiveTrades() — la guarda es deliberada,
  no la quites; solo añade persistencia (HIGH arriba).
  3. IsTrendAligned devolviendo true hardcodeado — es una
  decisión de diseño documentada en el comentario :479. Si  
  se reactiva el filtro, debe ser un cambio explícito.
  4. La función DrawNewsLine y la integración con
  News_Fetcher.mq4 vía global variables — funciona, está
  aislado, no debería tener dependencias adicionales.
  5. La dedup con seenTimes[] / seenTypes[] en
  GetTradesTodayCount — tiene dos arrays de 100 elementos
  que cubren el caso de cierres parciales que generan
  tickets extra en historial con la misma OpenTime+Type. Es
  correcta y merece un comentario en :514-518.
  6. Pip = (Digits == 3 \|\| Digits == 5) ? 10.0 *Point :  
  1.0* Point — perfecto, no tocar.

  ---
  Veredicto

  El EA es production-ready en sus cimientos. Los 4
  hallazgos HIGH/MEDIUM (time-stop SMC, falta de input de
  slippage, reset de memoria con operaciones vivas,
  IsTrendAligned stub) son mejoras recomendables antes de
  subirlo a VPS, no son bloqueantes de deploy. Las LOW son  
  de higiene y pueden agruparse en una v2.001.

  Si quieres, te aplico los parches HIGH/MEDIUM en orden,
  con sus tests asociados en Strategy Tester antes de
  pasarlo a Pine. Dime qué versión priorizar.
