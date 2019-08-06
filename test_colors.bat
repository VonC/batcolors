@echo off
setlocal enabledelayedexpansion

rem https://stackoverflow.com/questions/112055/what-does-d0-mean-in-a-windows-batch-file
for %%i in ("%~dp0.") do SET "script_dir=%%~fi"
set script_dir=%script_dir%\..
@echo %script_dir%

call %script_dir%\batcolors\echos_macros.bat

set NOCOLORS=
set FATALNOEXIT=1
%_ok% "Result matches what was expected"
%_info% "Describe what is about to be done"
%_warning% "Result was not expected, but non-blocking"
%_error% "Result is wrong"
%_fatal% "Program must stop and exit" 1
echo ---- NOCOLORS=1 ----
set NOCOLORS=1
set FATALNOEXIT=
%_ok% "(no colors) Result matches what was expected"
%_info% "(no colors) Describe what is about to be done"
%_warning% "(no colors) Result was not expected, but non-blocking"
%_error% "(no colors) Result is wrong"
%_fatal% "(no colors) The program must exit and stop" 2

REM final echo should not be displayed:
echo All done