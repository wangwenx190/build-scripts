@ECHO OFF
COLOR
TITLE Building Mesa
CLS
SETLOCAL
SET _TARGET_ARCH=%1
SET LLVM=%2
SET _MESA_SRC_DIR=%3
SET _MESA_INST_DIR=%4
IF "%_TARGET_ARCH%" == "" SET _TARGET_ARCH=x64
IF "%LLVM%" == "" SET LLVM=%~dp0llvm
IF "%_MESA_SRC_DIR%" == "" SET _MESA_SRC_DIR=%~dp0mesa-src
IF "%_MESA_INST_DIR%" == "" SET _MESA_INST_DIR=%~dp0mesa-%_TARGET_ARCH%
pip install -U setuptools
pip install -U wheel
pip install -U scons
pip install -U mako
SET _VS_DEV_CMD_PATH=
SET _VS_2017_PATH=
FOR /f "delims=" %%A IN ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -property installationPath -latest -requires Microsoft.Component.MSBuild Microsoft.VisualStudio.Component.VC.Tools.x86.x64') DO SET _VS_2017_PATH=%%A
SET _VS_DEV_CMD_PATH=%_VS_2017_PATH%\VC\Auxiliary\Build\vcvarsall.bat
IF NOT EXIST "%_VS_DEV_CMD_PATH%" ECHO Cannot find [vcvarsall.bat], if you did't install VS2017 in it's default location, please change this script && GOTO Fin
CALL "%_VS_DEV_CMD_PATH%" %_TARGET_ARCH%
IF EXIST "%_MESA_SRC_DIR%\win_flex_bison" SET "PATH=%_MESA_SRC_DIR%\win_flex_bison;%PATH%"
IF EXIST "%_MESA_SRC_DIR%\..\win_flex_bison" SET "PATH=%_MESA_SRC_DIR%\..\win_flex_bison;%PATH%"
CD /D %_MESA_SRC_DIR%
IF /I "%_TARGET_ARCH%" == "x64" SET _TARGET_ARCH=x86_64
scons build=release platform=windows machine=%_TARGET_ARCH% libgl-gdi
IF %ERRORLEVEL% NEQ 0 ECHO Something wrong happened, please check the log file && GOTO Fin
IF EXIST %_MESA_INST_DIR% RD /S /Q %_MESA_INST_DIR%
MD %_MESA_INST_DIR%
COPY /Y "%_MESA_SRC_DIR%\build\windows-%_TARGET_ARCH%\gallium\targets\libgl-gdi\opengl32.dll" "%_MESA_INST_DIR%\opengl32sw.dll"
CD /D "%~dp0"
RD /S /Q %_MESA_SRC_DIR%
ECHO Build succeeded
GOTO Fin

:Fin
ENDLOCAL
PAUSE
EXIT /B
