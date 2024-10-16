@echo off
rem https://ss64.com/nt/syntax-macros.html


if "%1"=="export" ( goto:start_bc )
if "%1"=="unset" ( goto:unset )

if not "%1"=="" (
    call:unset
    setlocal enabledelayedexpansion
)
if "%script_dir%"=="" (
    call:unset
    setlocal enabledelayedexpansion
)
:start_bc
for %%i in ("%~dp0.") do SET "batdir=%%~fi"
rem @echo "batdir='%batdir%'"

set _ok=call "%%batdir%%\echos.bat" :ok
set _info=call "%%batdir%%\echos.bat" :info
set _warning=call "%%batdir%%\echos.bat" :warning
set _task=call "%%batdir%%\echos.bat" :task
set _error=call "%%batdir%%\echos.bat" :error
set _fatal=call "%%batdir%%\echos.bat" :fatal

if "%1"=="" ( goto:eof )
if "%1"=="export" ( goto:eof )

for %%i in ("%~dp0.") do SET "batdir=%%~fi"
echo %batdir%
%_ok% "test msg"
%_info% "test msg"
%_warning% "test msg"
%_task% "test msg"
%_error% "test msg"
%_fatal% "test msg" 3
echo all done macros
goto:eof

:unset
set "_error="
set "_fatal="
set "_info="
set "_ok="
set "_task="
set "_warning="
