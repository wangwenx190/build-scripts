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
SET _VC_BAT_PATH=%VS2017INSTALLDIR%\VC\Auxiliary\Build\vcvarsall.bat
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Preview\Enterprise\VC\Auxiliary\Build\vcvarsall.bat
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Preview\Professional\VC\Auxiliary\Build\vcvarsall.bat
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Preview\Community\VC\Auxiliary\Build\vcvarsall.bat
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvarsall.bat
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat
REM IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat
REM IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Shared\14.0\VC\vcvarsall.bat
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=%VS140COMNTOOLS%..\..\VC\vcvarsall.bat
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=%VCINSTALLDIR%\vcvarsall.bat
IF NOT EXIST "%_VC_BAT_PATH%" SET _VC_BAT_PATH=
IF NOT EXIST "%_VC_BAT_PATH%" ECHO Cannot find [vcvarsall.bat], if you did't install vs in it's default location, please change this script && GOTO Fin
CALL "%_VC_BAT_PATH%" %_TARGET_ARCH%
REM IF NOT EXIST "cmake.exe" ECHO Cannot find cmake, please install it and add it's path to your environment variables && GOTO Fin
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
CD /D "%~dp0"
RD /S /Q %_OPENAL_SRC_DIR%
ECHO Build succeeded
GOTO Fin

:Fin
ENDLOCAL
PAUSE
EXIT /B
