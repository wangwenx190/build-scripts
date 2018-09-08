@ECHO OFF
TITLE Qt command line environment
CLS
REM Usage: %comspec% /k "path_of_this_file"
SET "_ARCH=%1"
IF /I "%_ARCH%" == "" SET "_ARCH=x86"
SET "_VC_BAT_PATH=%VS2017INSTALLDIR%\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Preview\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Preview\Professional\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Preview\Community\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat"
REM IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
REM IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Shared\14.0\VC\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%VS140COMNTOOLS%..\..\VC\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET "_VC_BAT_PATH=%VCINSTALLDIR%\vcvarsall.bat"
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=
IF NOT EXIST "%_VC_BAT_PATH%" (
    ECHO Cannot find [vcvarsall.bat], if you did't install vs in it's default location, please change this script
    PAUSE
    EXIT /B
)
CALL "%_VC_BAT_PATH%" %_ARCH%
SET "_QT_DIR=%~dp0"
IF NOT EXIST "%_QT_DIR%bin\qmake.exe" SET "_QT_DIR=%~dp0.."
IF NOT EXIST "%_QT_DIR%\bin\qmake.exe" SET "_QT_DIR=%2"
IF NOT EXIST "%_QT_DIR%\bin\qmake.exe" (
    ECHO [ERROR] Cannot find Qt directory!
    PAUSE
    EXIT /B
)
IF EXIST "%_QT_DIR%\bin\qtenv2.bat" (
    CALL "%_QT_DIR%\bin\qtenv2.bat"
) ELSE (
    SET "PATH=%_QT_DIR%\bin;%_QT_DIR%;%PATH%"
)
CD /D "%_QT_DIR%"
CLS
ECHO --------------------------------------------
ECHO │   Qt command line environment is ready   │
ECHO --------------------------------------------
