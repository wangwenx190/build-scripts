@ECHO OFF
COLOR
TITLE Building OpenSSL
CLS
SETLOCAL
SET "_TARGET_ARCH=%1"
SET "_BUILD_TYPE=%2"
SET "_COMP_MODE=%3"
SET "_SRC_DIR=%4"
SET "_INSTALL_DIR=%5"
IF /I "%_TARGET_ARCH%" == "" SET "_TARGET_ARCH=x64"
IF /I "%_BUILD_TYPE%" == "" SET "_BUILD_TYPE=dll"
IF /I "%_COMP_MODE%" == "" SET "_COMP_MODE=release"
IF /I "%_SRC_DIR%" == "" SET "_SRC_DIR=%~dp0src"
IF /I "%_INSTALL_DIR%" == "" SET "_INSTALL_DIR=%~dp0openssl_%_BUILD_TYPE%_%_COMP_MODE%_%_TARGET_ARCH%"
SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Shared\14.0\VC\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=
IF NOT EXIST "%_VC_BAT_PATH%" ECHO Cannot find [vcvarsall.bat], if you did't install vs in it's default location, please change this script && GOTO Fin
CALL "%_VC_BAT_PATH%" %_TARGET_ARCH%
IF /I "%_COMP_MODE%" NEQ "release" SET "_TARGET_ARCH=debug-%_TARGET_ARCH%"
CD /D "%_SRC_DIR%"
IF /I "%_TARGET_ARCH%" == "x64" (
    perl Configure VC-WIN64A no-asm enable-static-engine --prefix="%_INSTALL_DIR%"
    CALL "%_SRC_DIR%\ms\do_win64a.bat"
) ELSE (
    perl Configure VC-WIN32 -DUNICODE -D_UNICODE no-asm enable-static-engine --prefix="%_INSTALL_DIR%"
    CALL "%_SRC_DIR%\ms\do_ms.bat"
)
IF /I "%_BUILD_TYPE%" == "dll" (
    nmake -f "%_SRC_DIR%\ms\ntdll.mak"
    nmake -f "%_SRC_DIR%\ms\ntdll.mak" test
    nmake -f "%_SRC_DIR%\ms\ntdll.mak" install
) ELSE (
    nmake -f "%_SRC_DIR%\ms\nt.mak"
    nmake -f "%_SRC_DIR%\ms\nt.mak" test
    nmake -f "%_SRC_DIR%\ms\nt.mak" install
)
IF %ERRORLEVEL% NEQ 0 ECHO Something wrong happened, please check the log file && GOTO Fin
ECHO Build succeeded
GOTO Fin

:Fin
ENDLOCAL
PAUSE
EXIT /B
