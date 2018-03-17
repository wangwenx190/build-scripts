@ECHO OFF
COLOR
TITLE Building Qt from source code
SETLOCAL EnableDelayedExpansion
CLS
REM x86 or x64, default is x64
SET "_TARGET_ARCH=%1"
REM dll or lib, default is dll
SET "_BUILD_TYPE=%2"
REM debug, release or debug-and-release, default is release
SET "_COMP_MODE=%3"
REM Qt source code directory, default is ".\src"
SET "_ROOT=%4"
REM Qt install directory, default is ".\qt"
SET "_INSTALL_DIR=%5"
REM Extra configure parameters, default is empty
SET "_EXTRA_PARAMS=%6"
IF /I "%_ROOT%" == "" SET "_ROOT=%~dp0src"
IF NOT EXIST "%_ROOT%" ECHO Qt source code directory not found. Cannot continue compiling. && GOTO Fin
IF /I "%_TARGET_ARCH%" == "" SET "_TARGET_ARCH=x64"
IF /I "%_COMP_MODE%" == "" SET "_COMP_MODE=release"
IF /I "%_BUILD_TYPE%" == "" SET "_BUILD_TYPE=dll"
IF /I "%_INSTALL_DIR%" == "" SET "_INSTALL_DIR=%~dp0qt-%_BUILD_TYPE%-%_COMP_MODE%-%_TARGET_ARCH%"
IF EXIST "%_INSTALL_DIR%" RD /S /Q "%_INSTALL_DIR%"
MD "%_INSTALL_DIR%"
IF /I "%_COMP_MODE%" == "debug" (
    SET "_COMP_MODE=-%_COMP_MODE%"
) ELSE (
    SET "_COMP_MODE=-%_COMP_MODE% -strip"
)
IF /I "%_BUILD_TYPE%" == "lib" (
REM According to Qt official wiki, QWebEngine module cannot be compiled statically, so we have to skip it
    SET "_BUILD_TYPE=-static -static-runtime -skip qtwebengine"
) ELSE (
REM If you want to compile QWebEngine, you have to changed your system locale to English(United States)
    SET "_BUILD_TYPE=-shared"
)
SET _CFG_PARAMS=-opensource -confirm-license %_COMP_MODE% %_BUILD_TYPE% -platform win32-msvc -ltcg -plugin-manifests -mp -silent -nomake examples -nomake tests -opengl dynamic -prefix "%_INSTALL_DIR%" %_EXTRA_PARAMS%
CALL "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" %_TARGET_ARCH%
SET "PATH=%_ROOT%\qtbase\bin;%_ROOT%\gnuwin32\bin;%PATH%"
SET "_CFG_BAT=%_ROOT%\configure.bat"
CD /D "%_ROOT%"
SET "_ROOT="
CALL "%_CFG_BAT%" %_CFG_PARAMS%
REM If you don't have jom, use nmake instead, which is provided by Visual Studio.
REM nmake is very slow, I recommend you use jom, you can download the latest jom
REM from it's official download link:
REM download.qt.io/official_releases/jom/jom.zip
REM Remember to add it's path to your system path variables
REM or just put it into "src\gnuwin32\bin", this directory will be added to
REM the PATH variable temporarily during the compiling stage.
SET "_JOM=nmake"
IF EXIST "jom.exe" SET "_JOM=jom"
%_JOM% && %_JOM% install
GOTO Fin

:Fin
ENDLOCAL
PAUSE
EXIT /B
