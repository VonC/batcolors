@echo off
setlocal enabledelayedexpansion
rem https://stackoverflow.com/questions/7712661/windows-bat-cmd-function-library-in-own-file
rem https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
rem https://superuser.com/questions/749561/batch-file-change-color-of-specific-part-of-text
rem https://stackoverflow.com/questions/10534911/how-can-i-exit-a-batch-file-from-within-a-function
rem https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line
rem https://stackoverflow.com/questions/28810194/how-to-pass-a-list-of-strings-to-a-batch-script-as-a-parameter

set ASCII27=
rem set ASCII27=← 
if "%1"=="" ( goto :test )
call %*
exit /b

:ok
if defined ECHOS_OFF goto:check_echo_state
if not "%NOCOLORS%"=="" goto:oknc
if defined ECHOS_PRE_FILE ( call:msg "%ECHOS_PRE_FILE%" "   %ASCII27%[42;97m    %ASCII27%[0m  " )
echo %ASCII27%[42;97m OK    %ASCII27%[0m: %~1%
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "   %ASCII27%[42;97m    %ASCII27%[0m  " )
goto:check_echo_state
:oknc
if defined ECHOS_PRE_FILE ( call:msg "%ECHOS_PRE_FILE%" "       %ASCII27%[0m  " )
echo  OK    : %~1% 1>&2
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "       %ASCII27%[0m  " )
goto:check_echo_state

:info
if defined ECHOS_OFF goto:check_echo_state
if not "%NOCOLORS%"=="" goto:infonc
if defined ECHOS_PRE_FILE ( call:msg "%ECHOS_PRE_FILE%" "     %ASCII27%[106;30m  %ASCII27%[0m  " )
echo %ASCII27%[106;30m INFO  %ASCII27%[0m: %~1%
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "     %ASCII27%[106;30m  %ASCII27%[0m  " )
goto:check_echo_state
:infonc
if defined ECHOS_PRE_FILE ( call:msg "%ECHOS_PRE_FILE%" "       %ASCII27%[0m  " )
echo  INFO  : %~1% 1>&2
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "       %ASCII27%[0m  " )
goto:check_echo_state

:warning
if defined ECHOS_OFF goto:check_echo_state
if not "%NOCOLORS%"=="" goto:warningnc
if defined ECHOS_PRE_FILE ( call:msg "%ECHOS_PRE_FILE%" "     %ASCII27%[103;30m  %ASCII27%[0m  " )
echo %ASCII27%[103;30m WARN  %ASCII27%[0m: %~1%
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "     %ASCII27%[103;30m  %ASCII27%[0m  " )
goto:check_echo_state
:warningnc
if defined ECHOS_PRE_FILE ( call:msg "%ECHOS_PRE_FILE%" "       %ASCII27%[0m  " )
echo  WARN  : %~1% 1>&2
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "       %ASCII27%[0m  " )
goto:check_echo_state

:task
if defined ECHOS_OFF goto:check_echo_state
if not "%NOCOLORS%"=="" goto:tasknc
if defined ECHOS_PRE_FILE ( call:msg "%ECHOS_PRE_FILE%" "     %ASCII27%[103;30m  %ASCII27%[0m  " )
echo %ASCII27%[106;30m TASK%ASCII27%[0m%ASCII27%[103;30m=^>%ASCII27%[0m: %~1%
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "     %ASCII27%[103;30m  %ASCII27%[0m  " )
goto:check_echo_state
:tasknc
if defined ECHOS_PRE_FILE ( call:msg "%ECHOS_PRE_FILE%" "       %ASCII27%[0m  " )
echo  TASK=^>: %~1% 1>&2
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "       %ASCII27%[0m  " )
goto:check_echo_state

:error
if defined ECHOS_OFF goto:check_echo_state
if not "%NOCOLORS%"=="" goto:errornc
if defined ECHOS_PRE_FILE ( call:msg   "%ECHOS_PRE_FILE%" "      %ASCII27%[101;97m %ASCII27%[0m  " )
echo %ASCII27%[101;97m ERROR %ASCII27%[0m: %~1% 1>&2
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "      %ASCII27%[101;97m %ASCII27%[0m  " )
goto:check_echo_state
:errornc
if defined ECHOS_PRE_FILE ( call:msg "%ECHOS_PRE_FILE%" "       %ASCII27%[0m  " )
echo  ERROR : %~1% 1>&2
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "       %ASCII27%[0m  " )
goto:check_echo_state

:fatal
if not "%NOCOLORS%"=="" goto:fatalnc
if defined ECHOS_PRE_FILE ( call:msg "%ECHOS_PRE_FILE%" "      %ASCII27%[41;97m %ASCII27%[0m  " )
rem %Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor Red ERROR: %1
echo %ASCII27%[41;97m FATAL %~2 %ASCII27%[0m: %~1% 1>&2
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "      %ASCII27%[41;97m %ASCII27%[0m  " )
call :ExitBatch %2
goto:eof
:fatalnc
if defined ECHOS_PRE_FILE ( call:msg "%ECHOS_PRE_FILE%" "       %ASCII27%[0m  " )
echo  FATAL %~2 : %~1% 1>&2
if defined ECHOS_POST_FILE ( call:msg "%ECHOS_POST_FILE%" "       %ASCII27%[0m  " )
call :ExitBatch %2
goto:eof

:check_echo_state
if "%ECHO_STATE%"=="ON" (@echo on)
goto:eof

:test
set NOCOLORS=
set FATALNOEXIT=1
call:ok "Result matches what was expected"
call:info "Describe what is about to be done"
call:warning "Result was not expected, but non-blocking"
call:task "Result means you need to take action"
call:error "Result is wrong"
call:fatal "Program must stop and exit" 1
echo ---- ENV VARS ----
call:info "setting ECHOS_OFF=[any value] means no OK, INFO, WARNING, TASK, or ERROR messages will be displayed. Only FATAL messages."
call:info "setting ECHO_STATE=ON allows for `@echo on` to persists after a batcolor echo"
call:info "setting FATALNOEXIT=1 allows for a fatal call to not exit the current batch script"
call:info "setting NOCOLORS=1 allows for ASCII output without ASCII escape color codes"
echo ---- NOCOLORS=1 ----
set NOCOLORS=1
call:ok "(no colors) Result matches what was expected"
call:info "(no colors) Describe what is about to be done"
call:warning "(no colors) Result was not expected, but non-blocking"
call:task "(no colors) Result means you need to take action"
call:error "(no colors) Result is wrong"
call:fatal "(no colors) The program must exit and stop" 2
echo ---- PRE and POST MSG VARS ----
set NOCOLORS=
call:set_pre_post_example_FILE "OK"
call:ok "An OK message with a prefix and a post message" && echo.
echo ---- NOCOLORS=1 with PRE and POST MSG ----
set NOCOLORS=1
set FATALNOEXIT=
call:set_pre_post_example_FILE "FATAL"
call:fatal "A FATAL message (no colors) with a prefix and a post message" 1
echo alldone
goto:eof

rem https://stackoverflow.com/questions/10534911/how-can-i-exit-a-batch-file-from-within-a-function/10537432
rem => https://stackoverflow.com/questions/3227796/exit-batch-script-from-inside-a-function/25474648#25474648


:ExitBatch - Cleanly exit batch processing, regardless how many CALLs
@echo off
if defined echos_standalone (
  if exist "%echos_standalone%" (
    del "%echos_standalone%"
  )
)
if exist echo_pre.txt del echo_pre.txt
if exist echo_post.txt del echo_post.txt
if not "%FATALNOEXIT%"=="" goto:eof
if not exist "%temp%\ExitBatchYes.txt" call :buildYes
call :CtrlC <"%temp%\ExitBatchYes.txt" 1>nul 2>&1
:CtrlC
cmd /c exit -1073741510%1
goto:eof

:buildYes - Establish a Yes file for the language used by the OS
pushd "%temp%"
set "yes="
if exist ExitBatchYes.txt (
  del ExitBatchYes.txt
)
copy nul ExitBatchYes.txt >nul
for /f "delims=(/ tokens=2" %%Y in (
  '"copy /-y nul ExitBatchYes.txt <nul"'
) do if not defined yes set "yes=%%Y"
echo %yes%>ExitBatchYes.txt
popd
exit /b

:msg
set "msg_file=%~1"
set "msg_prefix=%~2"
REM for each line in the file, echo the prefix and the line
for /f "tokens=*" %%a in ('type "%msg_file%"') do (
  if "%%a"=="_" ( echo %msg_prefix% ) else (
    echo %msg_prefix%%%a 
  )
)
goto:eof

:set_pre_post_example_FILE
set "level=%~1"
(
echo PRE '%level%' line 1: Write a multi-line message in a file 'xxx.txt'
echo PRE '%level%' line 2: the name of that file is yours to chose
echo PRE '%level%' line 3: '_' means empty line
echo _
) > "echo_pre.txt"
set "ECHOS_PRE_FILE=echo_pre.txt"
(
echo _
echo POST '%level%' line 1: then set ECHOS_PRE_FILE variable  to that file full pathname
echo POST '%level%' line 2: and / or ECHOS_POST_FILE variable to that file full pathname
echo POST '%level%' line 3: depending on where you want the message to appear
) > "echo_post.txt"
set "ECHOS_POST_FILE=echo_post.txt"
goto:eof