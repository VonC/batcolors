@echo off
setlocal Disabledelayedexpansion

REM *** Defining all macros, once
call "%~dp0\echo_macros.bat"

call :test1
call :test2
call :test3

echo This line shouldn't be visible, because the last fatal error should exit the batch
exit /b

:test1
echo Test1
set "NOCOLORS="
set FATALNOEXIT=1

%$echo_ok% "Special chars &|<>^! Text"
%$echo_info% "It should work with "quotes", too"
%$echo_warning% "The percent sign %% has to be doubled"
echo(
exit /b

:test2
echo Test2
set "NOCOLORS="
set FATALNOEXIT=1
%$define_prefixed_echo% my_colored_echo "43;30" "****"
%my_colored_echo% "this is my own macro"
echo(
exit /b

:test3
echo Test3
set "NOCOLORS="
set FATALNOEXIT=1

%$echo_ok% "Result matches what was expected"
%$echo_info% "Describe what is about to be done"
%$echo_warning% "Result was not expected, but non-blocking"
%$echo_error% "Result is wrong"
%$echo_fatal% 2 "Program must stop and exit"
echo ---- NOCOLORS=1 ----
set NOCOLORS=1
set FATALNOEXIT=
%$echo_ok% "(no colors) Result matches what was expected"
%$echo_info% "(no colors) Describe what is about to be done"
%$echo_warning% "(no colors) Result was not expected, but non-blocking"
%$echo_error% "(no colors) Result is wrong"
%$echo_fatal% 4 "(no colors) The program must exit and stop"
goto:eof
