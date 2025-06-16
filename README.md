# shcolors

Levels of color used in a Linus shell (bash) script

Type `./echos` in the root folder of this repository, and you get a demo:

![Linux level colors](shcolors.png)

## Description

Add log-level-like colored headers to your script output:

## Usage

Clone `batcolors` (branch linux) into your script project and:

```sh
git clone -b linux --single-branch -- https://github.com/VonC/batcolors.git shcolors
```

Then, in your script, add the following lines at the top:

```sh
source ./shcolors/echos.sh
```

Then, use the following macros in your script:

```bash
ok      "Result matches what was expected"
info    "Describe what is about to be done"
task    "Describe what must be done, to be checked later"
warning "Result was not expected, but non-blocking"
error   "Result is wrong"
fatal   "Program must stop and exit" 1

# final echo should not be displayed:
echo done
```

`error` will not exit your script, while `fatal` will.  
Any line *after* `fatal` will not be executed (unless `FATALNOEXIT` is set. See below)

### NOCOLORS

If you do not want [ANSI escape code](https://en.wikipedia.org/wiki/ANSI_escape_code), simply `set NOCOLORS=1`.

Then unset it (`set NOCOLORS=`), and the next `ok/info/...` call will display colors again.

### ECHOS_OFF

Setting `ECHOS_OFF=1` will disable all echos (no OK, INFO, WARNING, TASK or ERROR message), except the FATAL one.

Then unset it (`set ECHOS_OFF=`), and the next `ok/info/...` call will display messages again.

### FATALNOEXIT

If you don't want to exit on a `fatal` call, `set FATALNOEXIT=1` first.

Then, unset it (`set FATALNOEXIT=`), and the next `fatal` call will exit the script.

### PRE-POST multi-line messages

If you want to display a multi-line message, use `pre` and `pro` macros to define multiline pre or post messages

```bat
post POST INFO line 1: Write a post-message after the INFO message
post POST INFO line 2
info My INFO message with post lines
```

You can use both `pre` and `post` macros to display lines before *and* after an `ok/info/...`

Or use the file `echos_pre.txt` or  `echos_post.txt` or both: it will be deleted right after the next `ok/info/...`.

```bash
(
echo PRE OK line 1: Write a multi-line message in a file 'xxx.txt'
echo PRE OK line 2: the name of that file is yours to chose
echo PRE OK line 3: '_' means empty line
echo _
) > "echos_pre.txt"
ok " An OK message with prefix lines"
REM The 'echos_pre.txt' file is automatically deleted after any ok%, info%, warning%,... call
```

## `[Script name prefix]`

When running your scripts with their own `call_echos_stack` function, you will see the script name in the output, as in this example:

```bash
 OK    : [init.bat] Submodule already initialized
 OK    : [senv.bat] project 'cplx' senv activated [local preserved]: PRJ_DIR='C:\Users\VonC\git\cplx'
 INFO  : [t_build.bat] build_params for build: ''
 INFO  : [t_build.bat] build_params for update-version (rel for 'make release'): ''
 TASK=>: [update-version.bat] Must get version from 'C:\Users\VonC\git\cplx\version.txt'
 OK    : [update-version.bat] version '0.2.0-SNAPSHOT' found in 'C:\Users\VonC\git\cplx\version.txt'
 ```

## Callstack ("Stack")

If you use `set "ECHOS_STACK=true"`, those same script-name prefixed message will be displayed with indentation reflecting the callstack.

Example:

```bash
 OK    :   ⁅init.bat⁆ Submodule already initialized
 OK    : ⁅senv.bat⁆ project 'cplx' senv activated [local preserved]: PRJ_DIR='C:\Users\VonC\git\cplx'
 INFO  : ⁅t_build.bat⁆ build_params for build: ''
 INFO  : ⁅t_build.bat⁆ build_params for update-version (rel for 'make release'): ''
 TASK=>:   ⁅update-version.bat⁆ Must get version from 'C:\Users\VonC\git\cplx\version.txt'
 OK    :   ⁅update-version.bat⁆ version '0.2.0-SNAPSHOT' found in 'C:\Users\VonC\git\cplx\version.txt'
 INFO  :   ⁅update-version.bat⁆ is_snapshot='1', is_release='', version_release='0.2.0'
```

## License: MIT

[LICENSE](LICENSE)
