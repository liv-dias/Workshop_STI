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
if errorlevel 1 goto INSTALL_NODE
echo [OK] Node.js encontrado.
node -v
echo.
goto CHECK_NPM

:INSTALL_NODE
echo [AVISO] Node.js nao foi encontrado no seu computador.
echo Iniciando o download e instalacao automatica (Node.js LTS)...
echo.

:: Define a URL do instalador MSI oficial do Node.js e o nome do arquivo temporário
set "NODE_URL=https://nodejs.org"
set "NODE_MSI=%temp%\node_install.msi"

echo Baixando o instalador do Node.js...
powershell -Command "(New-Object Net.WebClient).DownloadFile('%NODE_URL%', '%NODE_MSI%')"
if errorlevel 1 goto DOWNLOAD_FAIL

echo Instalando o Node.js em segundo plano...
echo (Uma janela de permissao de Administrador pode aparecer)
:: Roda o MSI de forma silenciosa e espera a conclusão
start /wait msiexec /i "%NODE_MSI%" /quiet /qn /norestart

:: Remove o arquivo temporário
del "%NODE_MSI%" 2>nul

:: Atualiza as variáveis de ambiente na sessão atual do CMD sem precisar fechar a janela
for /f "tokens=2*" %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v Path') do set "syspath=%%b"
for /f "tokens=2*" %%a in ('reg query "HKCU\Environment" /v Path') do set "userpath=%%b"
set "PATH=%syspath%;%userpath%"

:: Re-checa se agora o Node funciona
where node >nul 2>nul
if errorlevel 1 goto INSTALL_FAIL_NODE

echo [OK] Node.js instalado e configurado com sucesso!
node -v
echo.
goto CHECK_NPM

:DOWNLOAD_FAIL
echo [ERRO] Nao foi possivel baixar o instalador do Node.js.
echo Verifique sua conexao ou baixe manualmente em: https://nodejs.org/
echo.
pause
exit /b 1

:INSTALL_FAIL_NODE
echo [ERRO] A instalacao automatica falhou ou requer reinicio do computador.
echo Tente instalar manualmente em: https://nodejs.org/
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
echo [ERRO] O comando npm nao foi reconhecido, mesmo com o Node instalado.
echo Tente reiniciar o computador e rodar este script novamente.
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
