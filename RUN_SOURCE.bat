@echo off
setlocal

set "PROJECT_DIR=%~dp0source"

if defined GODOT_BIN if exist "%GODOT_BIN%" (
  set "GODOT_EXE=%GODOT_BIN%"
  goto run
)

for %%G in (godot4.exe godot.exe Godot_v4.7-stable_win64.exe) do (
  where %%G >nul 2>nul
  if not errorlevel 1 (
    set "GODOT_EXE=%%G"
    goto run
  )
)

echo Godot 4.7 was not found.
echo Install Godot or set GODOT_BIN to the full editor path.
pause
exit /b 1

:run
start "" "%GODOT_EXE%" --editor --path "%PROJECT_DIR%"
exit /b 0
