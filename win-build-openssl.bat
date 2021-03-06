@ECHO OFF
COLOR
TITLE Building OpenSSL
CLS
SETLOCAL
SET "_OPENSSL_VERSION=%1"
SET "_TARGET_ARCH=%2"
SET "_BUILD_TYPE=%3"
SET "_COMP_MODE=%4"
SET "_SRC_DIR=%5"
SET "_INSTALL_DIR=%6"
SET "_EXTRA_PARAMS=%7"
IF /I "%_OPENSSL_VERSION%" == "" SET "_OPENSSL_VERSION=1.1.0"
IF /I "%_TARGET_ARCH%" == "" SET "_TARGET_ARCH=x64"
IF /I "%_BUILD_TYPE%" == "" SET "_BUILD_TYPE=dll"
IF /I "%_COMP_MODE%" == "" SET "_COMP_MODE=release"
IF /I "%_SRC_DIR%" == "" SET "_SRC_DIR=%~dp0src"
IF /I "%_INSTALL_DIR%" == "" SET "_INSTALL_DIR=%~dp0OpenSSL_%_OPENSSL_VERSION%_%_BUILD_TYPE%_%_COMP_MODE%_%_TARGET_ARCH%"
SET _VS_DEV_CMD_PATH=
SET _VS_2017_PATH=
FOR /f "delims=" %%A IN ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -property installationPath -latest -requires Microsoft.Component.MSBuild Microsoft.VisualStudio.Component.VC.Tools.x86.x64') DO SET _VS_2017_PATH=%%A
SET _VS_DEV_CMD_PATH=%_VS_2017_PATH%\VC\Auxiliary\Build\vcvarsall.bat
IF NOT EXIST "%_VS_DEV_CMD_PATH%" ECHO Cannot find [vcvarsall.bat], if you did't install VS2017 in it's default location, please change this script && GOTO Fin
CALL "%_VS_DEV_CMD_PATH%" %_TARGET_ARCH%
CD /D "%_SRC_DIR%"
SET "_PLATFORM=VC-WIN64A"
IF /I "%_TARGET_ARCH%" NEQ "x64" SET "_PLATFORM=VC-WIN32"
IF /I "%_COMP_MODE%" NEQ "release" (
    IF /I "%_OPENSSL_VERSION%" == "1.0.2" (
        SET "_PLATFORM=debug-%_PLATFORM%"
    ) ELSE (
        SET "_PLATFORM=%_PLATFORM% --debug"
    )
)
IF EXIST "%_INSTALL_DIR%" RD /S /Q "%_INSTALL_DIR%"
SET _CFG_PARAMS=Configure %_PLATFORM% no-asm enable-static-engine --prefix="%_INSTALL_DIR%" %_EXTRA_PARAMS%
IF /I "%_TARGET_ARCH%" NEQ "x64" SET _CFG_PARAMS=%_CFG_PARAMS% -DUNICODE -D_UNICODE
IF /I "%_OPENSSL_VERSION%" NEQ "1.0.2" (
    IF /I "%_BUILD_TYPE%" NEQ "dll" SET _CFG_PARAMS=%_CFG_PARAMS% no-shared
    REM IF /I "%_BUILD_TYPE%" NEQ "lib" SET _CFG_PARAMS=%_CFG_PARAMS% enable-md2 enable-rc5 enable-heartbeats
)
perl %_CFG_PARAMS%
IF /I "%_OPENSSL_VERSION%" == "1.0.2" (
    IF /I "%_TARGET_ARCH%" == "x64" (
        CALL "%_SRC_DIR%\ms\do_win64a.bat"
    ) ELSE (
        CALL "%_SRC_DIR%\ms\do_ms.bat"
    )
)
SET "_OPENSSL_BAT_FILE=%_SRC_DIR%\ms\ntdll.mak"
IF /I "%_BUILD_TYPE%" NEQ "dll" SET "_OPENSSL_BAT_FILE=%_SRC_DIR%\ms\nt.mak"
IF /I "%_OPENSSL_VERSION%" == "1.0.2" (
    nmake -f "%_OPENSSL_BAT_FILE%"
    nmake -f "%_OPENSSL_BAT_FILE%" test
    nmake -f "%_OPENSSL_BAT_FILE%" install
) ELSE (
    nmake
    nmake test
    nmake install
)
IF %ERRORLEVEL% NEQ 0 ECHO Something wrong happened, please check the log file && GOTO Fin
ECHO Build succeeded
GOTO Fin

:Fin
ENDLOCAL
PAUSE
EXIT /B
