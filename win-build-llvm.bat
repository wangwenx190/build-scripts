@ECHO OFF
COLOR
TITLE Building LLVM
CLS
SETLOCAL
SET _TARGET_ARCH=%1
SET _LLVM_SRC_DIR=%2
SET _LLVM_INST_DIR=%3
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
IF "%_LLVM_SRC_DIR%" == "" SET _LLVM_SRC_DIR=%~dp0llvm.src
IF "%_LLVM_INST_DIR%" == "" (
    IF /I "%_TARGET_ARCH%" == "x64" (
        SET _LLVM_INST_DIR=%~dp0llvm64
    ) ELSE (
        SET _LLVM_INST_DIR=%~dp0llvm
    )
)
IF EXIST %_LLVM_INST_DIR% RD /S /Q %_LLVM_INST_DIR%
SET _CMAKE_TOOLCHAIN_HOST=
IF /I "%_TARGET_ARCH%" == "x64" (
    SET _TARGET_ARCH= Win64
    SET _CMAKE_TOOLCHAIN_HOST=-Thost=x64
) ELSE (
    SET _TARGET_ARCH=
)
SET _CMAKE_CMD=-G "Visual Studio 15%_TARGET_ARCH%" %_CMAKE_TOOLCHAIN_HOST% -DLLVM_USE_CRT_RELEASE=MT -DLLVM_USE_CRT_DEBUG=MTd -DCMAKE_INSTALL_PREFIX=%_LLVM_INST_DIR% .
CD /D %_LLVM_SRC_DIR%
cmake %_CMAKE_CMD%
IF %ERRORLEVEL% NEQ 0 ECHO Something wrong happened, please check the log file && GOTO Fin
msbuild /p:Configuration=Release INSTALL.vcxproj
IF %ERRORLEVEL% NEQ 0 ECHO Something wrong happened, please check the log file && GOTO Fin
CD /D "%~dp0"
RD /S /Q %_LLVM_SRC_DIR%
ECHO Build succeeded
GOTO Fin

:Fin
ENDLOCAL
PAUSE
EXIT /B
