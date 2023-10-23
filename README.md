# batcolors
Levels of color used in a Windows bat script

Type `echos` or `echos.bat` in the root folder of this repository, and you get a demo:

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

%_ok%      "Result matches what was expected"
%_info%    "Describe what is about to be done"
%_warning% "Result was not expected, but non-blocking"
%_error%   "Result is wrong"
%_fatal%   "Program must stop and exit" 1

REM final echo should not be displayed:
echo done
```

`%_error%` will not exit your script, while `%_fatal%` will.  
Any line *after* `%_fatal%` will not be executed (unless `FATALNOEXIT` is set. See below)


### NOCOLORS

If you do not want [ANSI escape code](https://en.wikipedia.org/wiki/ANSI_escape_code), simply `set NOCOLORS=1`.

Then unset it (`set NOCOLORS=`), and the next `%_ok/info/...%` call will display colors again.

### FATALNOEXIT

If you don't want to exit on a `%_fatal%` call, `set FATALNOEXIT=1` first.

Then, unset it (`set FATALNOEXIT=`), and the next `%_fatal%` call will exit the script.

### export

If you use `call %script_dir%\batcolors\echos_macros.bat export` (with the `export` parameter), it keeps the current context, and does not use `setlocal enabledelayedexpansion`.

Useful when the script is supposed to be called by another one (which has already called `echos_macros.bat`), but you want to call/test that script in standalone:

```bat
if "%script_dir%"=="" (
    for %%i in ("%~dp0.") do SET "script_dir=%%~fi"
    call !script_dir!\batcolors\echos_macros.bat export
)
```

- if not called in standalone, then `script_dir` would not be empty: no need to call `echos_macros.bat` again)
- if called in standalone, then `script_dir` would be empty: call `echos_macros.bat`, again to export its macro definitions in your current content.

### set "ECHO_STATE=ON"

If your script includes a `@echo on`, having `ECHO_STATE=ON` first will make sure the colored echo does not reset the echo mode, keeping it ON.

```bat
cmd /V /C "set "ECHO_STATE=ON" && call your_script.bat"
```

## License: MIT

[LICENSE](LICENSE)
