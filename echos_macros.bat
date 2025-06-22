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

set "_ok=@echo off & call:call_echos_stack 2>NUL & call "%%batdir%%\echos.bat" :ok"
set "_info=@echo off & call:call_echos_stack 2>NUL & call "%%batdir%%\echos.bat" :info"
set "_warning=@echo off & call:call_echos_stack 2>NUL & call "%%batdir%%\echos.bat" :warning"
set "_warn=@echo off & call:call_echos_stack 2>NUL & call "%%batdir%%\echos.bat" :warning"
set "_task=@echo off & call:call_echos_stack 2>NUL & call "%%batdir%%\echos.bat" :task"
set "_error=@echo off & call:call_echos_stack 2>NUL & call "%%batdir%%\echos.bat" :error"
set "_fatal=@echo off & call:call_echos_stack 2>NUL & call "%%batdir%%\echos.bat" :fatal"
set "_stack=@echo off & call:call_echos_stack"
set "_stack_call=@echo off & call:call_echos_stack & call"
set "_unstack=@echo off & call "%%batdir%%\echos.bat" :unstack"
set "_pre=@echo off & call "%%batdir%%\echos.bat" :pre"
set "_post=@echo off & call "%%batdir%%\echos.bat" :post"

set "CHECK_DEBUG_ECHOS=echo %DEBUG_ECHOS% | findstr /C:true >nul &&

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
set "_warn="
set "_stack="
set "_unstack="
set "echos_last_stack="
set "echos_nx="
set "echos_stack_list="
set "echos_stack_spaces="
set "count="
set "prefix="
set "CHECK_DEBUG_ECHOS="
set "DEBUG_ECHOS="
set "_stack_call="
set "ECHOS_POST_FILE="
set "ECHOS_PRE_FILE="
set "ECHOS_STACK="
set "echos_stack_dir="
set "echos_stack_emptied="
set "echos_stack_file="
set "echos_stack_list_count="
set "echos_stack_warning="
set "echos_stack_warning_msg="
set "echos_stack_warning_no_stack="
set "batdir="
set "_pre="
set "_post="
goto:eof

