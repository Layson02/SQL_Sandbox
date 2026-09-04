@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

sc query "MSSQL$SQLEXPRESS" | find /i "RUNNING" >nul 2>&1

if %errorlevel% equ 0 (
    echo ===========================================
    echo   SQL Server esta ATIVO. Finalizando servicos...
    echo ===========================================
    net stop "MSSQL$SQLEXPRESS" /y
    net stop "SQLBrowser" /y
    echo.
    echo Servicos parados com sucesso!
) else (
    echo ===========================================
    echo   SQL Server esta PARADO. Iniciando servicos...
    echo ===========================================
    net start "MSSQL$SQLEXPRESS"
    net start "SQLBrowser"
    echo.
    echo Servicos iniciados com sucesso!
)

timeout /t 3