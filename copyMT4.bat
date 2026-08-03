@echo off
echo Iniciando la copia de EAs e Indicadores a las terminales MT4...
echo.

:: Definir rutas de origen
set "SOURCE_EXPERTS=C:\Users\rhood\Desktop\New-Forex\Experts"
set "SOURCE_INDICATORS=C:\Users\rhood\Desktop\New-Forex\Indicators"

:: Definir rutas de destino para RoboForex
set "ROBO_EXPERTS=C:\Program Files (x86)\RoboForex MT4 Terminal\MQL4\Experts"
set "ROBO_INDICATORS=C:\Program Files (x86)\RoboForex MT4 Terminal\MQL4\Indicators"

:: Definir rutas de destino para Skilling
set "SKILLING_EXPERTS=C:\Program Files (x86)\Skilling MT4 Terminal\MQL4\Experts"
set "SKILLING_INDICATORS=C:\Program Files (x86)\Skilling MT4 Terminal\MQL4\Indicators"

:: Copiar a RoboForex
echo Copiando a RoboForex...
if exist "%SOURCE_EXPERTS%" (
    xcopy /Y /Q /E "%SOURCE_EXPERTS%\*.*" "%ROBO_EXPERTS%\"
    echo  - Experts copiados.
) else (
    echo  - Carpeta Experts de origen no encontrada.
)

if exist "%SOURCE_INDICATORS%" (
    xcopy /Y /Q /E "%SOURCE_INDICATORS%\*.*" "%ROBO_INDICATORS%\"
    echo  - Indicators copiados.
) else (
    echo  - Carpeta Indicators de origen no encontrada.
)

echo.
:: Copiar a Skilling
echo Copiando a Skilling...
if exist "%SOURCE_EXPERTS%" (
    xcopy /Y /Q /E "%SOURCE_EXPERTS%\*.*" "%SKILLING_EXPERTS%\"
    echo  - Experts copiados.
)
if exist "%SOURCE_INDICATORS%" (
    xcopy /Y /Q /E "%SOURCE_INDICATORS%\*.*" "%SKILLING_INDICATORS%\"
    echo  - Indicators copiados.
)

echo.
echo Proceso de copia completado.
pause
