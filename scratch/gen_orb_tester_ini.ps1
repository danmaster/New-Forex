param(
    [Parameter(Mandatory=$true)][string]$SetFile,
    [Parameter(Mandatory=$true)][string]$OutFile
)
$set = @{}
Get-Content $SetFile | ForEach-Object { if ($_ -match '^(.+)=(.+)$') { $set[$matches[1]] = $matches[2] } }
$order = @(
 @{s='General_Settings=--- AJUSTES GENERALES ---'}, 'MagicNumber','UseDynamicLot','RiskPercent','FixedLotSize','InpSendPush','OnlyNasdaq',
 @{s='Session_Settings=--- VENTANA ORB (hora del broker) ---'}, 'SessionStartHour','SessionStartMinute','OrbMinutes','OrbTF','BreakoutTF',
 @{s='Days_Settings=--- FILTRO DE DIAS ---'}, 'TradeMonday','TradeTuesday','TradeWednesday','TradeThursday','TradeFriday',
 @{s='Range_Settings=--- FILTROS DEL RANGO ---'}, 'MinRangePips','MaxRangePips','MinSLPips','MaxEntryHour',
 @{s='Target_Settings=--- OBJETIVO Y GESTION ---'}, 'UsePartialClose','PartialClosePercent','TP1Ratio','TP2Ratio','UseAutoBreakEven','BreakEvenActivation','BreakEvenExtraPips','UseTrailingStop','TrailingPips','MaxTradesPerDay','CloseAtEndOfDay','EndOfDayHour',
 @{s='Trend_Settings=--- FILTRO DE TENDENCIA ---'}, 'UseTrendFilter','TrendTF','FastEMAPeriod','SlowEMAPeriod',
 @{s='AlexFilters_Settings=--- MEJORA ALEX: FILTROS RVol + VWAP ---'}, 'UseRVolFilter','MinRVol','RVolDays','UseVWAPFilter',
 @{s='News_Settings=--- NEWS FILTER (API) ---'}, 'UseNewsFilter','MinsBeforeNews','MinsAfterNews','FilterHighImpact','FilterMedImpact',
 @{s='Visual_Settings=--- VISUAL ---'}, 'DrawORBBox'
)
$lines = @('<common>','positions=1','deposit=10000','currency=USD','fitnes=0','genetic=0','</common>','','<inputs>')
foreach ($item in $order) {
  if ($item -is [hashtable]) { $lines += $item['s']; continue }
  $v = $set[$item]
  if ($null -eq $v) { Write-Output "WARNING: $item no encontrado"; continue }
  $lines += "$item=$v"; $lines += "$item,F=0"; $lines += "$item,1=$v"; $lines += "$item,2=0"; $lines += "$item,3=0"
}
$lines += '</inputs>'; $lines += ''; $lines += '<limits>'
$lines += 'balance_enable=0','balance=200.00','profit_enable=0','profit=10000.00','marginlevel_enable=0','marginlevel=30.00','maxdrawdown_enable=0','maxdrawdown=70.00','consecloss_enable=0','consecloss=5000.00','conseclossdeals_enable=0','conseclossdeals=10.00','consecwin_enable=0','consecwin=10000.00','consecwindeals_enable=0','consecwindeals=30.00','</limits>'
$content = $lines -join "`r`n"
Set-Content -Path $OutFile -Value $content -Encoding UTF8
Write-Output "Generado: $OutFile ($($lines.Count) lineas)"
