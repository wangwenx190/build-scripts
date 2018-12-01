:: Currently, "OpenAL" refers to "OpenAL Soft"
:: GitHub: https://github.com/kcat/openal-soft
:: The original OpenAL from Creative Labs is no
:: longer maintained, I guess.
@ECHO OFF
COLOR
TITLE Building OpenAL
CLS
SETLOCAL
SET _TARGET_ARCH=%1
SET _BUILD_TYPE=%2
SET _OPENAL_SRC_DIR=%3
SET _OPENAL_INST_DIR=%4
IF "%_TARGET_ARCH%" == "" SET _TARGET_ARCH=x64
IF "%_BUILD_TYPE%" == "" SET _BUILD_TYPE=dll
SET _VS_DEV_CMD_PATH=
SET _VS_2017_PATH=
FOR /f "delims=" %%A IN ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -property installationPath -latest -requires Microsoft.Component.MSBuild Microsoft.VisualStudio.Component.VC.Tools.x86.x64') DO SET _VS_2017_PATH=%%A
SET _VS_DEV_CMD_PATH=%_VS_2017_PATH%\Common7\Tools\VsDevCmd.bat
IF NOT EXIST "%_VS_DEV_CMD_PATH%" ECHO Cannot find [VsDevCmd.bat], if you did't install VS2017 in it's default location, please change this script && GOTO Fin
SET _VS_ARCH=%_TARGET_ARCH%
IF /I "%_TARGET_ARCH%" == "x64" SET _VS_ARCH=amd64
CALL "%_VS_DEV_CMD_PATH%" -no_logo -arch=%_VS_ARCH%
IF "%_OPENAL_SRC_DIR%" == "" SET _OPENAL_SRC_DIR=%~dp0openal-src
IF "%_OPENAL_INST_DIR%" == "" (
    IF /I "%_TARGET_ARCH%" == "x64" (
        SET _OPENAL_INST_DIR=%~dp0openal64
    ) ELSE (
        SET _OPENAL_INST_DIR=%~dp0openal
    )
)
IF EXIST %_OPENAL_INST_DIR% RD /S /Q %_OPENAL_INST_DIR%
SET _CMAKE_TOOLCHAIN_HOST=
IF /I "%_TARGET_ARCH%" == "x64" (
    SET _TARGET_ARCH= Win64
    SET _CMAKE_TOOLCHAIN_HOST= -Thost=x64
) ELSE (
    SET _TARGET_ARCH=
)
IF /I "%_BUILD_TYPE%" == "lib" (
    SET _BUILD_TYPE= -DLIBTYPE=STATIC
) ELSE (
    SET _BUILD_TYPE=
)
SET _CMAKE_CMD=-G "Visual Studio 15 2017%_TARGET_ARCH%"%_CMAKE_TOOLCHAIN_HOST% -DALSOFT_BUILD_ROUTER=ON -DALSOFT_REQUIRE_WINMM=ON -DALSOFT_REQUIRE_DSOUND=ON -DALSOFT_REQUIRE_WASAPI=ON -DALSOFT_EMBED_HRTF_DATA=YES -DALSOFT_UTILS=OFF -DALSOFT_EXAMPLES=OFF -DALSOFT_TESTS=OFF%_BUILD_TYPE% -DCMAKE_INSTALL_PREFIX=%_OPENAL_INST_DIR% ..
CD /D %_OPENAL_SRC_DIR%
IF EXIST build RD /S /Q build
MD build
CD build
cmake %_CMAKE_CMD%
IF %ERRORLEVEL% NEQ 0 ECHO Something wrong happened, please check the log file && GOTO Fin
msbuild /p:Configuration=Release INSTALL.vcxproj
IF %ERRORLEVEL% NEQ 0 ECHO Something wrong happened, please check the log file && GOTO Fin
CD /D "%_OPENAL_SRC_DIR%"
RD /S /Q build
ECHO Build succeeded
GOTO Fin

:Fin
ENDLOCAL
PAUSE
EXIT /B
