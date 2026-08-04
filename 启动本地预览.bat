@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo 正在启动本地预览服务...
start "" http://localhost:8000
node serve.js
pause
