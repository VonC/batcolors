# batcolors

Levels of color used in a Windows bat script

Rewritten by [Jan Erik](https://github.com/jeb-de) using his [/true/ macros technique, with parameters appended](https://www.dostips.com/forum/viewtopic.php?f=3&t=2518#p11362).

This after reading [PavDub](https://stackoverflow.com/users/6671104/pavdub)'s [answer](https://stackoverflow.com/a/59874436/6309) on "How to echo with different colors in the Windows command line", followed by a [quick chat](https://chat.stackoverflow.com/transcript/206508).

![BAT level colors](/batcolors.png)

## Description

Add log-level-like colored headers to your script output:

## Usage

Clone `batcolors` into your bat script project and:

```bat
@echo off
setlocal enabledelayedexpansion

rem https://stackoverflow.com/questions/112055/what-does-d0-mean-in-a-windows-batch-file
for %%i in ("%~dp0.") do SET "script_dir=%%~fi"
set script_dir=%script_dir%\..
@echo %script_dir%

call %script_dir%\batcolors\echos_macros.bat

%$echo_ok%      "Result matches what was expected"
%$echo_info%    "Describe what is about to be done"
%$echo_warning% "Result was not expected, but non-blocking"
%$echo_error%   "Result is wrong"
%$echo_fatal%   1 "Program must stop and exit"

REM final echo should not be displayed:
echo done
```

`%$echo_error%` will not exit your script, while `%$echo_fatal%` will.  
Any line *after* `%$echo_fatal%` will not be executed (unless `FATALNOEXIT` is set. See below)

### NOCOLORS

If you do not want [ANSI escape code](https://en.wikipedia.org/wiki/ANSI_escape_code), simply `set NOCOLORS=1`.

Then unset it (`set NOCOLORS=`), and the next `%$echo_ok/info/...%` call will display colors again.

### FATALNOEXIT

If you don't want to exit on a `%$echo_fatal%` call, `set FATALNOEXIT=1` first.

Then, unset it (`set FATALNOEXIT=`), and the next `%$echo_fatal%` call will exit the script.

## License: MIT

[LICENSE](LICENSE)
