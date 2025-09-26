@echo off
setlocal enabledelayedexpansion

REM ============= CONFIGURAZIONE =============
set LINUX_USER=user
set PASSWORD=password
set REMOTE_FILE=/opt/ramdisk/exp/exp_tutto.json


set BASE_LOCAL_FOLDER=C:\Users\user\Desktop\ctrlNods\DATAFILE
set LOG_FOLDER=C:\Users\user\Desktop\ctrlNods\LOGS

REM Lista IP (aggiungi o rimuovi IP qui)

set IP_LIST=10.10.10.1 10.10.10.2  10.10.10.3  10.10.10.4  10.10.10.5  10.10.10.6  10.10.10.7  10.10.10.8
REM Crea cartella log se non esiste
if not exist "%LOG_FOLDER%" mkdir "%LOG_FOLDER%"

REM Data e ora per i file di log
set TIMESTAMP=%DATE:~-4%-%DATE:~3,2%-%DATE:~0,2%_%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%

echo.
echo ==========================================
echo INIZIO PROCESSO DOWNLOAD MULTIPLO
echo Data/Ora: %DATE% %TIME%
echo ==========================================
echo.

REM Ciclo per ogni IP nella lista
for %%i in (%IP_LIST%) do (
    echo.
    echo ------------------------------------------
    echo Processando IP: %%i
    echo ------------------------------------------
    
    REM Estrai le ultime 3 cifre dell'IP
    for /f "tokens=4 delims=." %%a in ("%%i") do set LAST_OCTET=%%a
	call :process_ip %%i !LAST_OCTET!
)

echo.
echo ==========================================
echo PROCESSO COMPLETATO
echo ==========================================
pause
goto :EOF

:process_ip
set CURRENT_IP=%1
set IP_SUFFIX=%2
set LOCAL_FILE=%BASE_LOCAL_FOLDER%\data_%IP_SUFFIX%.json
set PLINK_LOG=%LOG_FOLDER%\plink_%IP_SUFFIX%_%TIMESTAMP%.log
set PSCP_LOG=%LOG_FOLDER%\pscp_%IP_SUFFIX%_%TIMESTAMP%.log

echo.
echo IP: %CURRENT_IP%
echo Suffisso: %IP_SUFFIX%
echo File locale: %LOCAL_FILE%
echo Log plink: %PLINK_LOG%
echo Log pscp: %PSCP_LOG%
echo.

REM Accettazione host keys con log
echo [%TIME%] Accettazione host keys per %CURRENT_IP% >> "%PLINK_LOG%"

REM  CHIAVI ------------------------------------------
echo "DEBUG: echo y | plink -ssh %LINUX_USER%@%CURRENT_IP% -pw %PASSWORD% /opt/ramdisk/500_exp.sh" 
REM plink -ssh %LINUX_USER%@%CURRENT_IP% -pw %PASSWORD% /opt/ramdisk/500_exp.sh exit >> %PLINK_LOG% 2>&1


if %ERRORLEVEL% equ 0 (
    echo [%TIME%] Host keys accettate con successo per %CURRENT_IP% >> "%PLINK_LOG%"
    echo ✓ Host keys accettate per %CURRENT_IP%
) else (
    echo [%TIME%] ERRORE: Accettazione host keys fallita per %CURRENT_IP% >> "%PLINK_LOG%"
    echo ✗ ERRORE: Accettazione host keys fallita per %CURRENT_IP%
    goto :EOF
)

REM Download file con log
echo.
echo Scaricando da: %REMOTE_FILE%
echo           a: %LOCAL_FILE%
echo.

echo [%TIME%] Inizio download da %CURRENT_IP%:%REMOTE_FILE% >> "%PSCP_LOG%"

REM DOWNLOAD  ---------------------------------------
echo y | C:\Users\user\Desktop\ctrlNods\pscp -pw "%PASSWORD%" "%LINUX_USER%@%CURRENT_IP%:%REMOTE_FILE%" "%LOCAL_FILE%" >> "%PSCP_LOG%" 2>&1



if %ERRORLEVEL% equ 0 (
    echo [%TIME%] Download completato con successo per %CURRENT_IP% >> "%PSCP_LOG%"
    echo ✓ Download completato: %LOCAL_FILE%
    
    REM Verifica dimensione file
    if exist "%LOCAL_FILE%" (
        for %%F in ("%LOCAL_FILE%") do (
            echo [%TIME%] Dimensione file: %%~zF bytes >> "%PSCP_LOG%"
            echo   Dimensione file: %%~zF bytes
        )
    )
) else (
    echo [%TIME%] ERRORE: Download fallito per %CURRENT_IP% >> "%PSCP_LOG%"
    echo ✗ ERRORE: Download fallito per %CURRENT_IP%
)

echo.
goto :EOF