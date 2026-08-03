const fs = require('fs');
let file = fs.readFileSync('c:/Users/rhood/Desktop/New-Forex/Experts/Asian_V2.5.mq4', 'utf8');

file = file.replace(/DinÃ¡mico/g, 'Dinamico');
file = file.replace(/operaciÃ³n/g, 'operacion');
file = file.replace(/NotificaciÃ³n/g, 'Notificacion');
file = file.replace(/MÃ³vil/g, 'Movil');
file = file.replace(/TamaÃ±o/g, 'Tamano');
file = file.replace(/MÃ­nimo/g, 'Minimo');
file = file.replace(/MÃ¡ximo/g, 'Maximo');
file = file.replace(/mÃ¡xima/g, 'maxima');
file = file.replace(/MÃ¡x\./g, 'Max.');
file = file.replace(/AutomÃ¡tico/g, 'Automatico');
file = file.replace(/reversiÃ³n/g, 'reversion');
file = file.replace(/RectÃ¡ngulo/g, 'Rectangulo');
file = file.replace(/después/g, 'despues');
file = file.replace(/despuÃ©s/g, 'despues');
file = file.replace(/dÃ­a/g, 'dia');
file = file.replace(/dÃ­gitos/g, 'digitos');
file = file.replace(/aÃ±os/g, 'anos');
file = file.replace(/diseÃ±o/g, 'diseno');
file = file.replace(/diseÃ±ado/g, 'disenado');
file = file.replace(/evalÃºa/g, 'evalua');
file = file.replace(/seÃ±ales/g, 'senales');
file = file.replace(/estÃ¡/g, 'esta');
file = file.replace(/patrÃ³n/g, 'patron');
file = file.replace(/FallÃ³/g, 'Fallo');
file = file.replace(/opciÃ³n/g, 'opcion');
file = file.replace(/OpciÃ³n/g, 'Opcion');
file = file.replace(/simetrÃ­a/g, 'simetria');

// DST LOGIC INJECTION
const dstLogic = `
//+------------------------------------------------------------------+
//| Auto DST (Daylight Saving Time) Checker                          |
//| Returns true if current server time is in US DST                 |
//+------------------------------------------------------------------+
bool IsUSADST(datetime time)
  {
   int year = TimeYear(time);
   int month = TimeMonth(time);
   
   if(month < 3 || month > 11) return false;
   if(month > 3 && month < 11) return true;
   
   // Calcular el segundo domingo de marzo
   datetime march1 = StringToTime(IntegerToString(year) + ".03.01");
   int dayOfWeekMar1 = TimeDayOfWeek(march1);
   int secondSundayMar = 15 - dayOfWeekMar1; // if 0 (Sunday) -> 15. Wait.
   if(dayOfWeekMar1 == 0) secondSundayMar = 8;
   else secondSundayMar = 15 - dayOfWeekMar1;
   
   // Calcular el primer domingo de noviembre
   datetime nov1 = StringToTime(IntegerToString(year) + ".11.01");
   int dayOfWeekNov1 = TimeDayOfWeek(nov1);
   int firstSundayNov = 8 - dayOfWeekNov1;
   if(dayOfWeekNov1 == 0) firstSundayNov = 1;
   else firstSundayNov = 8 - dayOfWeekNov1;
   
   int day = TimeDay(time);
   
   if(month == 3)
     {
      if(day > secondSundayMar) return true;
      if(day == secondSundayMar && TimeHour(time) >= 2) return true;
      return false;
     }
     
   if(month == 11)
     {
      if(day < firstSundayNov) return true;
      if(day == firstSundayNov && TimeHour(time) < 2) return true;
      return false;
     }
     
   return false;
  }
`;

const onTickOld = `//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {`;

const onTickNew = dstLogic + `
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   int adjustedStartHour = StartHour;
   int adjustedEndHour = EndHour;
   int adjustedMaxEntry = MaxEntryHour;
   
   if(IsUSADST(TimeCurrent()))
     {
      adjustedStartHour = StartHour + 1;
      if(adjustedStartHour > 23) adjustedStartHour -= 24;
      adjustedEndHour = EndHour + 1;
      if(adjustedEndHour > 23) adjustedEndHour -= 24;
      adjustedMaxEntry = MaxEntryHour + 1;
      if(adjustedMaxEntry > 23) adjustedMaxEntry -= 24;
     }
`;

file = file.replace(onTickOld, onTickNew);
file = file.replace(/StartHour/g, 'adjustedStartHour');
file = file.replace(/int adjustedadjustedStartHour/g, 'int adjustedStartHour');
file = file.replace(/adjustedadjustedStartHour = adjustedStartHour \+ 1/g, 'adjustedStartHour = StartHour + 1');

file = file.replace(/EndHour/g, 'adjustedEndHour');
file = file.replace(/int adjustedadjustedEndHour/g, 'int adjustedEndHour');
file = file.replace(/adjustedadjustedEndHour = adjustedEndHour \+ 1/g, 'adjustedEndHour = EndHour + 1');

file = file.replace(/MaxEntryHour/g, 'adjustedMaxEntry');
file = file.replace(/int adjustedadjustedMaxEntry/g, 'int adjustedMaxEntry');
file = file.replace(/adjustedadjustedMaxEntry = adjustedMaxEntry \+ 1/g, 'adjustedMaxEntry = MaxEntryHour + 1');

fs.writeFileSync('c:/Users/rhood/Desktop/New-Forex/Experts/Asian_V2.5.mq4', file, 'utf8');
console.log('Success');
