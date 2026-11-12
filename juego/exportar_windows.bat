@echo off
rem Crea el .exe de Rifts & Gears en la carpeta builds\windows.
rem Antes, una sola vez: abre Godot > Editor > Gestionar plantillas de exportacion > Descargar e instalar.
rem Si Godot esta en otra carpeta, cambia la ruta de la linea de abajo.

set GODOT=%USERPROFILE%\Documents\Apps_Instaladas\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe

cd /d "%~dp0"
if not exist "builds\windows" mkdir "builds\windows"
if not exist "builds\macos" mkdir "builds\macos"

echo Creando la version de Windows...
"%GODOT%" --headless --path . --export-release "Windows" "builds\windows\RiftsAndGears.exe"

echo Creando la version de macOS...
"%GODOT%" --headless --path . --export-release "macOS" "builds\macos\RiftsAndGears.zip"

echo.
echo Listo. Mira la carpeta builds.
pause
