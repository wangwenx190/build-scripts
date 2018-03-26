@ECHO OFF
COLOR
TITLE Configuring Qt
CLS
SETLOCAL
REM Qt version, default is 5.11.0
SET "_QT_VERSION=%1"
REM win32-clang-g++, win32-clang-msvc, win32-g++, win32-icc, win32-icc-k1om or win32-msvc, default is win32-msvc
SET "_QT_COMPILER=%2"
REM x86 or x64, default is x64
SET "_TARGET_ARCH=%3"
REM dll or lib, default is dll
SET "_BUILD_TYPE=%4"
REM debug, release or debug-and-release, default is release
SET "_COMP_MODE=%5"
REM Qt source code directory, default is ".\src"
SET "_ROOT=%6"
REM Qt install directory, default is ".\qt"
SET "_INSTALL_DIR=%7"
REM Extra configure parameters, default is empty
SET "_EXTRA_PARAMS=%8"
IF /I "%_QT_VERSION%" == "" SET "_QT_VERSION=5.11.0"
IF /I "%_ROOT%" == "" SET "_ROOT=%~dp0src"
IF /I "%_QT_COMPILER%" == "" SET "_QT_COMPILER=win32-msvc"
IF /I "%_TARGET_ARCH%" == "" SET "_TARGET_ARCH=x64"
IF /I "%_COMP_MODE%" == "" SET "_COMP_MODE=release"
IF /I "%_BUILD_TYPE%" == "" SET "_BUILD_TYPE=dll"
IF /I "%_INSTALL_DIR%" == "" SET "_INSTALL_DIR=%~dp0Qt_%_QT_VERSION%_%_QT_COMPILER%_%_TARGET_ARCH%_%_BUILD_TYPE%_%_COMP_MODE%"
IF EXIST "%_INSTALL_DIR%" RD /S /Q "%_INSTALL_DIR%"
SET "_COMP_MODE=-%_COMP_MODE%"
IF /I "%_BUILD_TYPE%" == "lib" (
    REM According to Qt official wiki, QWebEngine module cannot be compiled statically, so we have to skip it
    SET "_BUILD_TYPE=-static -static-runtime -skip qtwebengine"
) ELSE (
    REM If you want to compile QWebEngine, you have to change your system locale to English(United States)
    REM And don't forget to change it back after compiling Qt
    SET "_BUILD_TYPE=-shared"
)
SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Shared\14.0\VC\vcvarsall.bat"
SET "_QT_PLATFORM=-platform %_QT_COMPILER%"
IF /I "%_QT_COMPILER%" NEQ "win32-msvc" (
    IF /I "%_QT_COMPILER%" NEQ "win32-icc" (
        IF /I "%_QT_COMPILER%" NEQ "win32-icc-k1om" (
            IF /I "%_QT_COMPILER%" NEQ "win32-clang-msvc" (
                SET "_QT_PLATFORM=-xplatform %_QT_COMPILER% -device-option CROSS_COMPILE=x86_64-w64-mingw32-"
                SET "_EXTRA_PARAMS=-c++std c++1z %_EXTRA_PARAMS%"
            )
        )
    )
)
SET _CFG_PARAMS=-opensource -confirm-license %_COMP_MODE% %_BUILD_TYPE% %_QT_PLATFORM% -ltcg -plugin-manifests -silent -nomake examples -nomake tests -opengl dynamic -prefix "%_INSTALL_DIR%" %_EXTRA_PARAMS%
SET "_CFG_BAT=%_ROOT%\configure.bat"
REM If you don't have jom, use nmake instead, which is provided by Visual Studio.
REM nmake is very slow, I recommend you use jom, you can download the latest jom
REM from it's official download link:
REM download.qt.io/official_releases/jom/jom.zip
REM Remember to add it's path to your system path variables
REM or just put it into "src\gnuwin32\bin", this directory will be added to
REM the PATH variable temporarily during the compiling process.
SET "_JOM=nmake"
IF EXIST "jom.exe" SET "_JOM=jom"
TITLE Configure finished
CLS
ECHO The configuring process have finished successfully
ECHO Your configuration is:
ECHO ---------------------------------------
ECHO Compiler: %_QT_COMPILER%
ECHO Target architecture: %_TARGET_ARCH%
ECHO Source code directory: %_ROOT%
ECHO Install directory: %_INSTALL_DIR%
IF /I "%_QT_COMPILER%" == "win32-msvc" ECHO vcvarsall.bat: %_VC_BAT_PATH%
IF /I "%_QT_COMPILER%" == "win32-icc" ECHO vcvarsall.bat: %_VC_BAT_PATH%
IF /I "%_QT_COMPILER%" == "win32-icc-k1om" ECHO vcvarsall.bat: %_VC_BAT_PATH%
IF /I "%_QT_COMPILER%" == "win32-clang-msvc" ECHO vcvarsall.bat: %_VC_BAT_PATH%
ECHO Build tool: %_JOM%
ECHO Qt configure parameters: %_CFG_PARAMS%
ECHO ---------------------------------------
ECHO If everything is all right, press any key to generate the build script
ECHO If anything is wrong, please close this window and re-run it
ECHO Your build script will be saved to: %~dp0build.bat
PAUSE
SET "_BUILD_BAT=%~dp0build.bat"
IF EXIST "%_BUILD_BAT%" DEL /F /Q "%_BUILD_BAT%"
> "%_BUILD_BAT%" (
    @ECHO @ECHO OFF
    @ECHO COLOR
    @ECHO TITLE Building Qt from source code
    @ECHO CLS
    @ECHO SETLOCAL
    IF /I "%_QT_COMPILER%" == "win32-msvc" @ECHO CALL "%_VC_BAT_PATH%" %_TARGET_ARCH%
    IF /I "%_QT_COMPILER%" == "win32-icc" @ECHO CALL "%_VC_BAT_PATH%" %_TARGET_ARCH%
    IF /I "%_QT_COMPILER%" == "win32-icc-k1om" @ECHO CALL "%_VC_BAT_PATH%" %_TARGET_ARCH%
    IF /I "%_QT_COMPILER%" == "win32-clang-msvc" @ECHO CALL "%_VC_BAT_PATH%" %_TARGET_ARCH%
    @ECHO SET "_ROOT=%_ROOT%"
    @ECHO SET "PATH=%%_ROOT%%\qtbase\bin;%%_ROOT%%\gnuwin32\bin;%%PATH%%"
    @ECHO SET _ROOT=
    @ECHO CD /D "%_ROOT%"
    @ECHO CALL "%_CFG_BAT%" %_CFG_PARAMS%
    @ECHO IF %%ERRORLEVEL%% NEQ 0 GOTO ErrHappen
    @ECHO %_JOM%
    @ECHO IF %%ERRORLEVEL%% NEQ 0 GOTO ErrHappen
    @ECHO %_JOM% install
    @ECHO IF %%ERRORLEVEL%% NEQ 0 GOTO ErrHappen
    @ECHO ^> "%_INSTALL_DIR%\bin\qt.conf" ^(
    @ECHO     @ECHO [Paths]
    @ECHO     @ECHO Documentation=../../Docs/Qt-%_QT_VERSION%
    @ECHO     @ECHO Examples=../../Examples/Qt-%_QT_VERSION%
    @ECHO     @ECHO Prefix=..
    @ECHO ^)
    @ECHO ^> "%_INSTALL_DIR%\bin\qtenv2.bat" ^(
    @ECHO     @ECHO @echo off
    @ECHO     @ECHO echo Setting up environment for Qt usage...
    @ECHO     @ECHO set PATH=^%%%%~dp0;^%%%%PATH^%%%%
    @ECHO     @ECHO cd /D ^%%%%~dp0..
    @ECHO     @ECHO echo Remember to call vcvarsall.bat to complete environment setup!
    @ECHO ^)
    @ECHO TITLE Compiling process finished
    @ECHO ECHO Compiling process have finished successfully
    @ECHO ECHO All binaries have been installed to: %_INSTALL_DIR%
    @ECHO ECHO Press any key to exit this program
    @ECHO GOTO Fin
    @ECHO :ErrHappen
    @ECHO TITLE Compiling process aborted
    @ECHO ECHO Something wrong happened during the compiling process
    @ECHO ECHO and the process have aborted because of this
    @ECHO ECHO Please check the log file for more information
    @ECHO ECHO Press any key to exit this program
    @ECHO GOTO Fin
    @ECHO :Fin
    @ECHO ENDLOCAL
    @ECHO PAUSE
    @ECHO EXIT /B
)
CLS
ECHO Build script have been saved to: %_BUILD_BAT%
ECHO Press any key to run it, or you can close this window and run it manually
PAUSE
CALL "%_BUILD_BAT%"
GOTO Fin

:Fin
ENDLOCAL
PAUSE
EXIT /B
