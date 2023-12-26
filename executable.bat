@echo off
echo Verificando Node.js...

node -v > nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
  echo No se ha encontrado Node.js. Por favor, instale Node.js.
  exit
)

echo Node.js esta instalado.

echo Verificando modulos...
IF NOT EXIST "node_modules" (
  echo Instalando modulos...
  npm install
)

echo Ejecutando proyecto...
npm run dev
