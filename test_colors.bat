@echo off
setlocal enabledelayedexpansion

rem https://stackoverflow.com/questions/112055/what-does-d0-mean-in-a-windows-batch-file
for %%i in ("%~dp0.") do SET "script_dir=%%~fi"
set script_dir=%script_dir%\..
@echo %script_dir%

call %script_dir%\batcolors\echos_macros.bat

%_ok% "test msg"
%_info% "test msg"
%_warning% "test msg"
%_error% "test msg"
%_fatal% "test msg and terminate" 3
echo done