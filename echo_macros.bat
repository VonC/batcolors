@echo off
REM *** Trampoline jump for function calls of the form ex. "C:\:libraryFunction:\..\libThisLibraryName.cmd"
FOR /F "tokens=3 delims=:" %%L in ("%~0") DO goto :%%L

if "" == "!!" (
    echo Only call this %~nx0 with DisableDelayedExpansion
    call :ExitBatch 1
)

rem https://stackoverflow.com/questions/7712661/windows-bat-cmd-function-library-in-own-file
rem https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
rem https://superuser.com/questions/749561/batch-file-change-color-of-specific-part-of-text
rem https://stackoverflow.com/questions/10534911/how-can-i-exit-a-batch-file-from-within-a-function
rem https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line
rem https://stackoverflow.com/questions/28810194/how-to-pass-a-list-of-strings-to-a-batch-script-as-a-parameter

call :define_prefixed_echo "$echo_ok" "42;97"       " OK    "
call :define_prefixed_echo "$echo_info" "106;30"    " INFO  "
call :define_prefixed_echo "$echo_warning" "103;30" " WARN  "
call :define_prefixed_echo "$echo_error" "101;97"   " ERROR "
call :define_fatal_echo    "$echo_fatal" "41;97"    " FATAL "

call :define_trampoline $define_prefixed_echo :define_prefixed_echo
exit /b

::: Defines a macro, that calls a function in this file
:define_trampoline <macro_name> <function_name>
set ^"%~1=call "%~d0\:%2:\..\%~pnx0""
exit /b

::: Creates an echo macro, the macro can be used by
::: <macro_name> "My text to display"
:define_prefixed_echo <macro_name> <color_code> "<prefix_string>"

REM *** This creates a variable that is used to define multi line macros
REM *** Only two characters are in \n "<caret><linefeed>"
(set \n=^^^
%= empty, do not remove this=%
)

REM *** defining the macro
REM *** The first FOR creates the ASCII-ESCAPE character (0x1B) in the %%E parameter
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do ^
set ^"%~1=for %%# in (1 2) do if %%#==2 (%\n%
    setlocal EnableDelayedExpansion%\n%
    for /F "tokens=* delims== " %%2 in ("!argv!") do (%\n%
%=         *** remove the local variable "argv" =% %\n%
        endlocal%\n%
        endlocal%\n%
        if defined NOCOLORS (%\n%
            echo(%~3%%~2%\n%
        ) ELSE (%\n%
            echo(%%E[%~2m%~3%%E[0m: %%~2%\n%
        )%\n%
    )%\n%
) else setlocal DisableDelayedExpansion ^& set argv= "
exit /b

::: Creates a fatal echo macro, the macro can be used by
::: <macro_name> <exitcode> "My fatal text to display"
::: if the variable FATALNOEXIT is defined, the batch file will be exited
:define_fatal_echo <macro_name> <color_code> "<prefix_string>"
(set \n=^^^
%= empty, do not remove this=%
)

for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do ^
set ^"%~1=for %%# in (1 2) do if %%#==2 (%\n%
    setlocal EnableDelayedExpansion%\n%
    for /F "tokens=1,* delims== " %%1 in ("!argv!") do (%\n%
        if "%%1" NEQ "0" IF NOT "%%1" GTR "0" IF NOT "%%1" LSS "0" (%\n%
            echo not a number%\n%
        ) ELSE (%\n%
            %= param1 is a number =% %\n%
            echo IS A NUMBER%\n%
        )%\n%
%=         *** remove the local variable "argv" =% %\n%
        endlocal%\n%
        endlocal%\n%
        if defined NOCOLORS (%\n%
            echo(%~3%%1%%~2%\n%
        ) ELSE (%\n%
            echo(%%E[%~2m%~3%%1%%E[0m: %%~2%\n%
        )%\n%
        if not defined FATALNOEXIT (%\n%
            call "%~d0\:ExitBatch:\..\%~pnx0" %\n%
        )%\n%
    )%\n%
) else setlocal DisableDelayedExpansion ^& set argv= "
exit /b



rem https://stackoverflow.com/questions/10534911/how-can-i-exit-a-batch-file-from-within-a-function/10537432
rem => https://stackoverflow.com/questions/3227796/exit-batch-script-from-inside-a-function/25474648#25474648
:ExitBatch - Cleanly exit batch processing, regardless how many CALLs
@echo off
if not "%FATALNOEXIT%"=="" goto:eof
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
