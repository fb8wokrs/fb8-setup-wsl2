@REM -*- encoding: cp932-dos -*-
@echo WSL2 のセットアップを行います。
PowerShell -Command "Set-ExecutionPolicy Bypass -Scope Process; %~dp0scripts\setup.ps1"
@echo 何かキーを押すとこのウィンドウを閉じます。
@pause > NUL
