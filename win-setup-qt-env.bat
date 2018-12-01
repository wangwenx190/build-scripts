@ECHO OFF
TITLE Qt command line environment
CLS
REM Usage: %comspec% /k "path_of_this_file" arch
REM Eg: %comspec% /k "C:\Qt\Qt5.12.0\5.12.0\msvc2017\win-setup-qt-env.bat" x64
SET _TARGET_ARCH=%1
IF /I "%_TARGET_ARCH%" == "" SET _TARGET_ARCH=x64
SET _VS_DEV_CMD_PATH=
SET _VS_2017_PATH=
FOR /f "delims=" %%A IN ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -property installationPath -latest -requires Microsoft.Component.MSBuild Microsoft.VisualStudio.Component.VC.Tools.x86.x64') DO SET _VS_2017_PATH=%%A
SET _VS_DEV_CMD_PATH=%_VS_2017_PATH%\Common7\Tools\VsDevCmd.bat
IF NOT EXIST "%_VS_DEV_CMD_PATH%" (
    ECHO Cannot find [VsDevCmd.bat], if you did't install vs in it's default location, please change this script
    PAUSE
    EXIT /B
)
SET _VS_ARCH=%_TARGET_ARCH%
IF /I "%_TARGET_ARCH%" == "x64" SET _VS_ARCH=amd64
CALL "%_VS_DEV_CMD_PATH%" -no_logo -arch=%_VS_ARCH%
SET _QT_DIR=%~dp0
IF NOT EXIST "%_QT_DIR%bin\qmake.exe" SET _QT_DIR=%~dp0..
IF NOT EXIST "%_QT_DIR%\bin\qmake.exe" SET _QT_DIR=%2
IF NOT EXIST "%_QT_DIR%\bin\qmake.exe" (
    ECHO [ERROR] Cannot find Qt directory!
    PAUSE
    EXIT /B
)
IF EXIST "%_QT_DIR%\bin\qtenv2.bat" (
    CALL "%_QT_DIR%\bin\qtenv2.bat"
) ELSE (
    SET PATH=%_QT_DIR%\bin;%_QT_DIR%;%PATH%
)
CD /D "%_QT_DIR%"
CLS
ECHO =====================================================
ECHO =   Qt command line environment(%_TARGET_ARCH%) is ready       =
ECHO =====================================================
