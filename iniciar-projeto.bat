@echo off
setlocal enabledelayedexpansion
title Iniciar Projeto Vue
color 0A

echo ========================================
echo   Iniciando Projeto Vue.js
echo ========================================
echo.

if exist "package.json" goto CHECK_NODE
echo [ERRO] Arquivo package.json nao encontrado nesta pasta!
echo Este .bat precisa estar na RAIZ do projeto Vue.
echo Pasta atual: %cd%
echo.
echo Pressione qualquer tecla para fechar...
pause >nul
exit /b 1

:CHECK_NODE
where node >nul 2>nul
if errorlevel 1 goto NO_NODE
echo [OK] Node.js encontrado.
node -v
echo.
goto CHECK_NPM

:NO_NODE
echo [ERRO] Node.js nao foi encontrado no seu computador!
echo Instale em: https://nodejs.org/
echo.
echo Pressione qualquer tecla para fechar...
pause >nul
exit /b 1

:CHECK_NPM
where npm >nul 2>nul
if errorlevel 1 goto NO_NPM
echo [OK] npm encontrado.
call npm -v
echo.
goto CHECK_DEPS

:NO_NPM
echo [ERRO] npm nao foi encontrado!
echo.
echo Pressione qualquer tecla para fechar...
pause >nul
exit /b 1

:CHECK_DEPS
echo Verificando dependencias...
if exist "node_modules\.bin\vite.cmd" goto DEPS_OK
echo [INFO] Dependencias nao encontradas. Instalando...
echo Isso pode levar alguns minutos na primeira vez.
echo.
call npm install
if errorlevel 1 goto INSTALL_FAIL
echo.
echo [OK] Dependencias instaladas com sucesso!
echo.
goto START_SERVER

:INSTALL_FAIL
echo.
echo [ERRO] Falha ao instalar as dependencias.
echo Verifique sua conexao com a internet.
echo.
echo Pressione qualquer tecla para fechar...
pause >nul
exit /b 1

:DEPS_OK
echo [OK] Dependencias ja instaladas corretamente.
echo.

:START_SERVER
echo ========================================
echo   Iniciando servidor de desenvolvimento
echo ========================================
echo.
echo Para PARAR o servidor, feche esta janela ou pressione CTRL+C
echo.
call npm run dev

echo.
echo O servidor foi encerrado.
echo Pressione qualquer tecla para fechar esta janela...
pause >nul