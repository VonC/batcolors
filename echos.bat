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
call:compute_prefix_stack %1
if not "%NOCOLORS%"=="" goto:oknc
if exist "echos_pre.txt" ( call:msg "echos_pre.txt" "   %ASCII27%[42;97m    %ASCII27%[0m  " )
echo %ASCII27%[42;97m OK    %ASCII27%[0m: %prefix_stack%%~1%
if exist "echos_post.txt" ( call:msg "echos_post.txt" "   %ASCII27%[42;97m    %ASCII27%[0m  " )
call:unstack
goto:check_echo_state
:oknc
if exist "echos_pre.txt" ( call:msg "echos_pre.txt" "       %ASCII27%[0m  " )
echo  OK    : %prefix_stack%%~1% 1>&2
if exist "echos_post.txt" ( call:msg "echos_post.txt" "       %ASCII27%[0m  " )
call:unstack
goto:check_echo_state

:info
if defined ECHOS_OFF goto:check_echo_state
call:compute_prefix_stack %1
if not "%NOCOLORS%"=="" goto:infonc
if exist "echos_pre.txt" ( call:msg "echos_pre.txt" "     %ASCII27%[106;30m  %ASCII27%[0m  " )
echo %ASCII27%[106;30m INFO  %ASCII27%[0m: %prefix_stack%%~1%
if exist "echos_post.txt" ( call:msg "echos_post.txt" "     %ASCII27%[106;30m  %ASCII27%[0m  " )
call:unstack
goto:check_echo_state
:infonc
if exist "echos_pre.txt" ( call:msg "echos_pre.txt" "       %ASCII27%[0m  " )
echo  INFO  : %prefix_stack%%~1% 1>&2
if exist "echos_post.txt" ( call:msg "echos_post.txt" "       %ASCII27%[0m  " )
call:unstack
goto:check_echo_state

:warning
if defined ECHOS_OFF goto:check_echo_state
call:compute_prefix_stack %1
if not "%NOCOLORS%"=="" goto:warningnc
if exist "echos_pre.txt" ( call:msg "echos_pre.txt" "     %ASCII27%[103;30m  %ASCII27%[0m  " )
echo %ASCII27%[103;30m WARN  %ASCII27%[0m: %prefix_stack%%~1%
if exist "echos_post.txt" ( call:msg "echos_post.txt" "     %ASCII27%[103;30m  %ASCII27%[0m  " )
call:unstack
goto:check_echo_state
:warningnc
if exist "echos_pre.txt" ( call:msg "echos_pre.txt" "       %ASCII27%[0m  " )
echo  WARN  : %prefix_stack%%~1% 1>&2
if exist "echos_post.txt" ( call:msg "echos_post.txt" "       %ASCII27%[0m  " )
call:unstack
goto:check_echo_state

:task
if defined ECHOS_OFF goto:check_echo_state
call:compute_prefix_stack %1
if not "%NOCOLORS%"=="" goto:tasknc
if exist "echos_pre.txt" ( call:msg "echos_pre.txt" "     %ASCII27%[103;30m  %ASCII27%[0m  " )
echo %ASCII27%[106;30m TASK%ASCII27%[0m%ASCII27%[103;30m=^>%ASCII27%[0m: %prefix_stack%%~1%
if exist "echos_post.txt" ( call:msg "echos_post.txt" "     %ASCII27%[103;30m  %ASCII27%[0m  " )
call:unstack
goto:check_echo_state
:tasknc
if exist "echos_pre.txt" ( call:msg "echos_pre.txt" "       %ASCII27%[0m  " )
echo  TASK=^>: %prefix_stack%%~1% 1>&2
if exist "echos_post.txt" ( call:msg "echos_post.txt" "       %ASCII27%[0m  " )
call:unstack
goto:check_echo_state

:error
if defined ECHOS_OFF goto:check_echo_state
call:compute_prefix_stack %1
if not "%NOCOLORS%"=="" goto:errornc
if exist "echos_pre.txt" ( call:msg   "echos_pre.txt" "      %ASCII27%[101;97m %ASCII27%[0m  " )
echo %ASCII27%[101;97m ERROR %ASCII27%[0m: %prefix_stack%%prefix%%~1% 1>&2
if exist "echos_post.txt" ( call:msg "echos_post.txt" "      %ASCII27%[101;97m %ASCII27%[0m  " )
call:unstack
goto:check_echo_state
:errornc
if exist "echos_pre.txt" ( call:msg "echos_pre.txt" "       %ASCII27%[0m  " )
echo  ERROR : %prefix_stack%%~1% 1>&2
if exist "echos_post.txt" ( call:msg "echos_post.txt" "       %ASCII27%[0m  " )
call:unstack
goto:check_echo_state

:fatal
if not "%NOCOLORS%"=="" goto:fatalnc
call:compute_prefix_stack %1
if exist "echos_pre.txt" ( call:msg "echos_pre.txt" "       %ASCII27%[41;97m%~2 %ASCII27%[0m  " )
rem %Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor Red ERROR: %1
echo %ASCII27%[41;97m FATAL %~2 %ASCII27%[0m: %prefix_stack%%~1% 1>&2
if exist "echos_post.txt" ( call:msg "echos_post.txt" "       %ASCII27%[41;97m%~2 %ASCII27%[0m  " )
call:unstack
call :ExitBatch %2
goto:eof
:fatalnc
if exist "echos_pre.txt" ( call:msg "echos_pre.txt" "         " )
echo  FATAL %~2 : %prefix_stack%%~1% 1>&2
if exist "echos_post.txt" ( call:msg "echos_post.txt" "         " )
call:unstack
call :ExitBatch %2
goto:eof

:check_echo_state
call:reset_pre_post_var_and_file
if "%ECHO_STATE%"=="ON" (@echo on)
goto:eof

:compute_prefix_stack
if not defined ECHOS_STACK (
  if defined CURRENT_SCRIPT (
    set "prefix_stack=[%CURRENT_SCRIPT%] "
  ) else (
    set "prefix_stack="
  )
  goto:eof
)
call:read_stack
call:compute_stack_warning "%~1"
set "echos_stack_spaces="
if %echos_stack_list_count% gtr 1 (
  for /L %%i in (2,1,%echos_stack_list_count%) do (
    set "echos_stack_spaces=!echos_stack_spaces!  "
  )
)
set "prefix_stack=%echos_stack_spaces%"
set "echos_stack_warning="
if defined echos_stack_warning_no_stack (
  set "echos_stack_warning=X"
  if not defined NOCOLORS ( set "echos_stack_warning=%ASCII27%[103;31m!echos_stack_warning!%ASCII27%[0m" )
  %CHECK_DEBUG_ECHOS% echo 01 echos_stack_warning='!echos_stack_warning!' 01 NOCOLORS='%NOCOLORS%'
)
if defined echos_stack_warning_legacy_stack (
  set "echos_stack_warning=L"
  %CHECK_DEBUG_ECHOS% echo 020 echos_stack_warning='!echos_stack_warning!' 020 NOCOLORS='%NOCOLORS%'
  if not defined NOCOLORS ( set "echos_stack_warning=%ASCII27%[106;31m!echos_stack_warning!%ASCII27%[0m" )
  %CHECK_DEBUG_ECHOS% echo 02 echos_stack_warning='!echos_stack_warning!' 02 NOCOLORS='%NOCOLORS%'
)
if defined echos_stack_warning_wrong_stack (
  if not defined NOCOLORS ( set "echos_stack_warning=%ASCII27%[101;33mW%ASCII27%[0m!echos_stack_warning!" )
)
%CHECK_DEBUG_ECHOS% echo 11 echos_stack_warning='%echos_stack_warning%' 11
if defined echos_stack_warning ( set "prefix_stack=%prefix_stack%%echos_stack_warning% "
%CHECK_DEBUG_ECHOS% echo 22 echos_stack_warning='%echos_stack_warning%' 22 )
if defined echos_last_stack ( set "prefix_stack=%prefix_stack%⁅%echos_last_stack%⁆ ")

%CHECK_DEBUG_ECHOS% echo echos_stack_warning='%echos_stack_warning%', prefix_stack='%prefix_stack%', echos_stack_list='%echos_stack_list%', echos_last_stack='%echos_last_stack%', echos_stack_spaces='%echos_stack_spaces%', echos_stack_list_count='%echos_stack_list_count%'
goto:eof

:stack
if not defined ECHOS_STACK ( goto:eof )
call:read_stack
rem set "ECHOS_STACK"
if not defined echos_stack_list (
  set "echos_stack_list=%~1"
) else (
  if not "%echos_last_stack%"=="%~1" (
    set "echos_stack_list=%echos_stack_list%/%~1"
    set "echos_last_stack=%~1"
    set /a echos_stack_list_count+=1
  )
)
echo %echos_stack_list%>"%echos_stack_file%"
%CHECK_DEBUG_ECHOS% echo :stack '%~1' added to echos_stack_list='%echos_stack_list%' in echos_stack_file '%echos_stack_file%': echos_last_stack='%echos_last_stack%', echos_stack_list_count='%echos_stack_list_count%'
goto:eof

:empty_stack
if not defined ECHOS_STACK ( goto:eof )
%CHECK_DEBUG_ECHOS% echo :empty_stack
set "echos_stack_list="
set "echos_last_stack="
set "echos_stack_list_count=0"
del %echos_stack_file% 2>NUL
verify >nul
goto:eof

:pre
for %%i in (%*) do (
    echo %%~i>> echos_pre.txt
)
goto:eof

:post
for %%i in (%*) do (
    echo %%~i>> echos_post.txt
)
goto:eof

:reset_pre_post_var_and_file
if exist "echos_pre.txt"  ( del "echos_pre.txt" )
if exist "echos_post.txt"  ( del "echos_post.txt" )
goto:eof

:unstack
:: nothing to unstack if ECHOS_STACK is not set
if not defined ECHOS_STACK ( goto:eof )
::
:: unstack the last element of the read stack
::
call:read_stack
if not defined echos_stack_list ( call:empty_stack & goto:eof )
if not "%~1"=="" (
  :: if a param is provided, only unstack if what is unstacked is the param. If not, return immediately
  if not "%~1"=="%echos_last_stack%" ( goto:eof )
)
if "%echos_stack_list%"=="%echos_last_stack%" ( call:empty_stack & goto:eof )

set "tokens_count=1"
set /a echos_stack_list_count-=1
set "echos_stack_list_new="
:read_new_stack_loop
for /F "delims=/ tokens=1*" %%a in ("%echos_stack_list%") do (
  if not defined echos_stack_list_new (
    set "echos_stack_list_new=%%a"
  ) else (
    set "echos_stack_list_new=!echos_stack_list_new!/%%a"
  )
  set /a tokens_count+=1
  if "%tokens_count%"=="%echos_stack_list_count%" (
    set "echos_last_stack=%%a"
    goto:read_new_stack_break
  )
  set "echos_stack_list=%%b"
  goto:read_new_stack_loop
)
:read_new_stack_break
set "echos_stack_list=%echos_stack_list_new%"
%CHECK_DEBUG_ECHOS% echo :unstack echos_stack_list='%echos_stack_list%', echos_last_stack='%echos_last_stack%', echos_stack_list_count='%echos_stack_list_count%'
echo %echos_stack_list%>%echos_stack_file%
verify >nul
goto:eof

:read_stack
if not defined ECHOS_STACK ( goto:eof )
call:get_stack_filename
set "echos_stack_list="
set "echos_stack_list_count=0"
set "echos_last_stack="
if not exist "%echos_stack_file%" goto:eof
for /f "tokens=* delims=" %%a in ('type "%echos_stack_file%"') do (
  set "echos_stack_list=%%a"
)
set "echos_stack_list_tmp=%echos_stack_list%"
:read_stack_loop
for /F "delims=/ tokens=1*" %%a in ("%echos_stack_list_tmp%") do (
  set "echos_last_stack=%%a"
  set /a echos_stack_list_count+=1
  if not "%%b"=="" (
    set "echos_stack_list_tmp=%%b"
    goto:read_stack_loop
  )
)
if not defined echos_last_stack ( set "echos_last_stack=%echos_stack_list%" )
%CHECK_DEBUG_ECHOS% echo :read_stack echos_stack_list='%echos_stack_list%', echos_last_stack='%echos_last_stack%', echos_stack_list_count='%echos_stack_list_count%'
goto:eof

:compute_stack_warning
if not defined ECHOS_STACK ( goto:eof )
set "echos_stack_warning_no_stack="
set "echos_stack_warning_wrong_stack="
set "echos_stack_warning_legacy_stack="
set "echos_stack_warning_msg=%~1"
if not defined echos_stack_warning_msg ( goto:eof )
:echos_stack_warning_loop
if "%echos_stack_warning_msg%"=="" ( goto:echos_stack_warning_break )
if "%echos_stack_warning_msg:~0,1%"==" " (
  set "echos_stack_warning_msg=%echos_stack_warning_msg:~1%"
  goto:echos_stack_warning_loop
)
:echos_stack_warning_break
if "%echos_stack_warning_msg:~0,1%"=="[" (
  set "echos_stack_warning_legacy_stack=1"
) else ( if not defined echos_last_stack ( set "echos_stack_warning_no_stack=1" ) )
rem if not "%echos_stack_ba%"=="%echos_last_stack%" ( set "echos_stack_warning_wrong_stack=1" )

%CHECK_DEBUG_ECHOS% echo :compute_stack_warning echos_stack_warning_no_stack='%echos_stack_warning_no_stack%', echos_stack_warning_legacy_stack='%echos_stack_warning_legacy_stack%'
rem , echos_stack_warning_wrong_stack='%echos_stack_warning_wrong_stack%'
goto:eof

:get_stack_filename
if not defined ECHOS_STACK ( goto:eof )
for %%i in ("%~dp0") do SET "echos_stack_dir=%%~fi"
set "echos_stack_file=%~nx0"
set "echos_stack_file=%echos_stack_file:.bat=.stack%"
set "echos_stack_file=%echos_stack_dir%\%echos_stack_file%"
goto:eof

:test
echo C:\Users\vonc\prgs\senv\batcolors^>echos.bat
set "CHECK_DEBUG_ECHOS=echo %DEBUG_ECHOS% | findstr /C:true >nul &&
set "ECHOS_STACK="
set "NOCOLORS="
set FATALNOEXIT=1
call:ok "Result matches what was expected"
call:info "Describe what is about to be done"
call:warning "Result was not expected, but non-blocking"
call:task "Result means you need to take action"
call:error "Result is wrong"
call:fatal "Program must stop and exit" 1
echo ---- ENV VARS ----
call:post "  Only FATAL messages will still be displayed."
call:info "setting ECHOS_OFF=[any value] means no OK, INFO, WARNING, TASK, or ERROR messages will be displayed."
call:info "setting ECHO_STATE=ON allows for `@echo on` to persists after a batcolor echo"
call:info "setting FATALNOEXIT=1 allows for a fatal call to not exit the current batch script"
call:info "setting NOCOLORS=1 allows for ASCII output without ASCII escape color codes"
call:info "setting ECHOS_STACK=true means messages are indented based on callstack order
echo ---- NOCOLORS=1 ----
set NOCOLORS=1
call:ok "(no colors) Result matches what was expected"
call:info "(no colors) Describe what is about to be done"
call:warning "(no colors) Result was not expected, but non-blocking"
call:task "(no colors) Result means you need to take action"
call:error "(no colors) Result is wrong"
call:fatal "(no colors) The program must exit and stop" 2
echo ---- PRE and POST MSG VARS ----
set "NOCOLORS="
call:set_pre_post_example_FILE "OK"
call:ok "An OK message with a prefix and a post message" && echo.
echo ---- NOCOLORS=1 with PRE and POST MSG ----
set "NOCOLORS=1"
set "FATALNOEXIT="
endlocal
call "echos_macros.bat" unset
set "NOCOLORS=1"
set "FATALNOEXIT="
call:set_pre_post_example_FILE "FATAL"
call:fatal "A FATAL message (no colors) with a prefix and a post message" 1
echo alldone
goto:eof

rem https://stackoverflow.com/questions/10534911/how-can-i-exit-a-batch-file-from-within-a-function/10537432
rem => https://stackoverflow.com/questions/3227796/exit-batch-script-from-inside-a-function/25474648#25474648


:ExitBatch - Cleanly exit batch processing, regardless how many CALLs
@echo off
set "CHECK_DEBUG_ECHOS="
if defined echos_standalone (
  if exist "%echos_standalone%" (
    del "%echos_standalone%"
  )
)
call:reset_pre_post_var_and_file
set "NOCOLORS="
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
  if "%%a"=="_" ( echo.%msg_prefix% ) else (
    echo.%msg_prefix%%%a
  )
)
goto:eof

:set_pre_post_example_FILE
set "level=%~1"
call:pre "PRE '%level%' line 1: Write a multi-line message in a file 'echos_pre.txt' or 'echos_post.txt'"
call:pre "PRE '%level%' line 2: Or use the ％_pre％ and ％_post％ macros to write those files for you."
call:pre "PRE '%level%' line 3: '_' means empty line. Example of empty line:"
call:pre _
call:post _
call:post "POST '%level%' line 2: line 1 was '_', so empty"
call:post "POST '%level%' line 3: 'echos_pre.txt'  means the lines are displayed BEFORE the '%level%' message"
call:post "POST '%level%' line 4: 'echos_post.txt' means the lines are displayed AFTER  the '%level%' message"
call:post "POST '%level%' line 5: The files 'echos_pre/post.txt' are deleted right after the ％_ok/info/...％ call"
goto:eof