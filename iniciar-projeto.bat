@echo off
setlocal enabledelayedexpansion
title Iniciar Projeto Vue
color 0A

echo ========================================
echo   Iniciando Projeto Vue.js (Modo Usuario)
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
if errorlevel 1 goto INSTALL_PORTABLE_NODE
echo [OK] Node.js global encontrado.
node -v
echo.
goto CHECK_NPM

:INSTALL_PORTABLE_NODE
:: Define um diretório local dentro do perfil do usuário atual que não requer admin
set "LOCAL_NODE_DIR=%USERPROFILE%\NodeJS_Portable"
set "NODE_BIN_DIR=%LOCAL_NODE_DIR%\node-v20.11.1-win-x64"

:: Caso o Node portátil já tenha sido baixado em uma execução anterior, reutiliza-o
if exist "%NODE_BIN_DIR%\node.exe" (
    echo [INFO] Node.js portátil detectado no seu perfil de usuário.
    set "PATH=%NODE_BIN_DIR%;%PATH%"
    goto CHECK_NPM
)

echo [AVISO] Node.js nao foi encontrado no sistema e voce nao eh Administrador.
echo Iniciando o download da versao PORTATIL do Node.js LTS...
echo.

set "NODE_ZIP_URL=https://nodejs.org"
set "NODE_ZIP=%temp%\node_portable.zip"

echo Baixando o arquivo ZIP do Node.js (Aguarde)...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%NODE_ZIP_URL%', '%NODE_ZIP%')"
if errorlevel 1 goto DOWNLOAD_FAIL

echo Extraindo os arquivos no seu perfil de usuário...
if not exist "%LOCAL_NODE_DIR%" mkdir "%LOCAL_NODE_DIR%"
powershell -Command "Expand-Archive -Path '%NODE_ZIP%' -DestinationPath '%LOCAL_NODE_DIR%' -Force"

:: Remove o arquivo temporário baixado
del "%NODE_ZIP%" 2>nul

:: Aplica o caminho do Node portátil na sessão atual do terminal
set "PATH=%NODE_BIN_DIR%;%PATH%"

where node >nul 2>nul
if errorlevel 1 goto INSTALL_FAIL_NODE

echo [OK] Node.js portatil configurado com sucesso!
node -v
echo.
goto CHECK_NPM

:DOWNLOAD_FAIL
echo [ERRO] Nao foi possivel baixar o Node.js. Verifique sua internet.
echo.
pause
exit /b 1

:INSTALL_FAIL_NODE
echo [ERRO] Falha ao configurar a versao portatil do Node.js.
echo.
pause
exit /b 1

:CHECK_NPM
where npm >nul 2>nul
if errorlevel 1 goto NO_NPM
echo [OK] npm encontrado.
call npm -v
echo.
goto CHECK_DEPS

:NO_NPM
echo [ERRO] O comando npm nao foi reconhecido.
echo.
echo Pressione qualquer tecla para fechar...
pause >nul
exit /b 1

:CHECK_DEPS
echo Verificando dependencias do projeto...
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
echo [ERRO] Falha ao instalar as dependencias do projeto.
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
