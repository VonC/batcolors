@echo off
setlocal enabledelayedexpansion
rem https://stackoverflow.com/questions/7712661/windows-bat-cmd-function-library-in-own-file
rem https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
rem https://superuser.com/questions/749561/batch-file-change-color-of-specific-part-of-text
rem https://stackoverflow.com/questions/10534911/how-can-i-exit-a-batch-file-from-within-a-function
rem https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line
rem https://stackoverflow.com/questions/28810194/how-to-pass-a-list-of-strings-to-a-batch-script-as-a-parameter

@SET ASCII27=
rem @SET ASCII27=← 
if "%1"=="" ( goto :test )
call %*
exit /b

:ok
echo %ASCII27%[42;97m OK    %ASCII27%[0m: %~1%
goto:eof

:info
echo %ASCII27%[106;30m INFO  %ASCII27%[0m: %~1%
goto:eof

:warning
echo %ASCII27%[103;30m WARN  %ASCII27%[0m: %~1%
goto:eof

:error
echo %ASCII27%[101;97m ERROR %ASCII27%[0m: %~1% 1>&2
goto:eof

:fatal
rem %Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor Red ERROR: %1
echo %ASCII27%[41;97m FATAL %~2 %ASCII27%[0m: %~1% 1>&2
call :ExitBatch %2
goto:eof

:test
call:ok "role name expected"
call:info "role name expected"
call:warning "role name expected"
call:error "role name expected"
call:fatal "role name expected" 1
echo ok
goto:eof

rem https://stackoverflow.com/questions/10534911/how-can-i-exit-a-batch-file-from-within-a-function/10537432
rem => https://stackoverflow.com/questions/3227796/exit-batch-script-from-inside-a-function/25474648#25474648


:ExitBatch - Cleanly exit batch processing, regardless how many CALLs
@echo off
if not exist "%temp%\ExitBatchYes.txt" call :buildYes
call :CtrlC <"%temp%\ExitBatchYes.txt" 1>nul 2>&1
:CtrlC
cmd /c exit -1073741510%1
goto:eof

:buildYes - Establish a Yes file for the language used by the OS
pushd "%temp%"
set "yes="
copy nul ExitBatchYes.txt >nul
for /f "delims=(/ tokens=2" %%Y in (
  '"copy /-y nul ExitBatchYes.txt <nul"'
) do if not defined yes set "yes=%%Y"
echo %yes%>ExitBatchYes.txt
popd
exit /b
