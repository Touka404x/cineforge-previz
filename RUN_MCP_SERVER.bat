@echo off
setlocal

set "ROOT=%~dp0"
set "PREVIZ_ASSET_CATALOG=%ROOT%source\models_index.json"

where python >nul 2>nul
if errorlevel 1 (
  echo Python 3.9 or newer was not found.
  pause
  exit /b 1
)

python "%ROOT%source\agent\previz_agent.py" mcp --catalog "%PREVIZ_ASSET_CATALOG%"
exit /b %errorlevel%
