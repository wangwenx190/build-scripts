## [Suggestions are always welcome.](https://github.com/wangwenx190/build-scripts/issues)

## [win-build-openal.bat](/win-build-openal.bat)
A batch script to help you build OpenAL Soft from source code.

**Usage**
1. Download or clone source code of OpenAL Soft from https://github.com/kcat/openal-soft .
2. Extract it and open cmd or power shell.
3. CALL "Script file path" [Option1] [Option2] [Option3] [Option4]
   - Script file path: The relative/absolute path of the batch file
   - Option1: Target architecture, x86 or x64, default is x64
   - Option2: dll or lib, default is dll
   - Option3: OpenAL Soft source code dir
   - Option4: OpenAL Soft install dir

**Tested on**

Windows 10 + MSVC2017 + OpenAL Soft 1.19.1-git-c2da83d

## [win-setup-qt-env.bat](/win-setup-qt-env.bat)
A batch script to help you init Qt command line environment.

**Usage**: Put this script file in your Qt directory, then create a symbol link shortcut whose path is: `%comspec% /k "path_of_this_file" arch`. Eg: `%comspec% /k "C:\Qt\Qt5.12.0\5.12.0\msvc2017\win-setup-qt-env.bat" x64`.

## [win-build-mesa.bat](/win-build-mesa.bat)
A Windows batch script to help you compile the Mesa 3D Graphics Library from source code. You should install Visual Studio 2017, Windows 10 SDK, Python 2.7, [pywin32 for Python](https://github.com/mhammond/pywin32/releases), [flex and bison](https://sourceforge.net/projects/winflexbison/) and LLVM first.

**Usage**
1. Download Mesa source code package from https://mesa.freedesktop.org/archive/ . Eg: mesa-18.2.0-rc3.tar.xz
2. Extract it and open cmd or power shell.
3. CALL "Script file path" [Option1] [Option2] [Option3] [Option4]
   - Script file path: The relative/absolute path of the batch file
   - Option1: Target architecture, x86 or x64, default is x64
   - Option2: LLVM path
   - Option3: Mesa source code dir
   - Option4: Mesa install dir

**Tested on**

Windows 10 + MSVC2017 + LLVM 6.0.1 + Mesa 18.2.0rc3

## [win-build-llvm.bat](/win-build-llvm.bat)
A Windows batch script to help you compile LLVM/Clang from source code. You should install Visual Studio 2017, Windows 10 SDK, Python 2.7 and CMake first.

### Build LLVM without Clang(default)
1. Download LLVM source code package from http://releases.llvm.org/ . Eg: llvm-6.0.1.src.tar.xz
2. Extract it and open cmd or power shell.
3. CALL "Script file path" [Option1] [Option2] [Option3]
   - Script file path: The relative/absolute path of the batch file
   - Option1: Target architecture, x86 or x64, default is x64
   - Option2: LLVM source code dir
   - Option3: LLVM install dir

### Build full LLVM(including Clang)
1. Download LLVM source code package from http://releases.llvm.org/ and extract it.
2. Download Clang source code package(Eg: cfe-6.0.1.src.tar.xz), extract it and rename it to "**clang**", then move the directory to "**<LLVM_SRC_DIR>\tools**", which means Clang source code should be in "**<LLVM_SRC_DIR>\tools\clang**".
3. Download Extra Clang Tools source code package(Eg: clang-tools-extra-6.0.1.src.tar.xz), extract it and rename it to "**extra**", then move the directory to "**<CLANG_SRC_DIR>\tools**", which means Extra Clang Tools source code should be in "**<LLVM_SRC_DIR>\tools\clang\tools\extra**".
4. Download LLD linker source code package(Eg: lld-6.0.1.src.tar.xz), extract it and rename it to "**lld**", then move the directory to "**<LLVM_SRC_DIR>\tools**", which means LLD linker source code should be in "**<LLVM_SRC_DIR>\tools\lld**".
5. Download Polly Loop Optimizer source code package(Eg: polly-6.0.1.src.tar.xz), extract it and rename it to "**polly**", then move the directory to "**<LLVM_SRC_DIR>\tools**", which means Polly Loop Optimizer source code should be in "**<LLVM_SRC_DIR>\tools\polly**".
6. Open cmd or power shell and call this batch script. Command line arguements are the same as above.

**Tested on**

Windows 10 + MSVC2017 + LLVM/Clang 6.0.1

## [build-icu-with-icc.md](/build-icu-with-icc.md)
An instruction to help you compile ICU with Intel C++ Compiler (ICC) on Windows (include shared builds and static builds).

## [build-static-version-of-qt-with-icu-and-openssl-linked.md](/build-static-version-of-qt-with-icu-and-openssl-linked.md)
An instruction to help you compile static version of Qt with static ICU and static OpenSSL linked.

## [win-build-qt-msys2.md](/win-build-qt-msys2.md)
An instruction to help you compile Qt from source code on Windows through MSYS2.

## [win-build-qt.bat](/win-build-qt.bat)
A Windows batch script to help you compile Qt from source code. You should know that this batch script can only help you on configuring the compiler, it will not install anything to your system, you still have to install all the prerequisites manually before running it.

**Usage**
1. Download Qt source code package from http://download.qt.io/archive/qt/ . Eg: qt-everywhere-opensource-src-5.9.6.zip
2. Extract it and open cmd or power shell.
3. CALL "Script file path" [Option1] [Option2] [Option3] [Option4] [Option5] [Option6] [Option7] [Option8]
   - Script file path: The relative/absolute path of the batch file
   - Option1: Qt version, default is 5.11.0
   - Option2: Compiler, win32-clang-g++, win32-clang-msvc, win32-g++, win32-icc, win32-icc-k1om or win32-msvc, default is win32-msvc
   - Option3: Target architecture, x86 or x64, default is x64
   - Option4: Target file type, dll or lib, default is dll
   - Option5: Compile mode, debug, release or debug-and-release, default is release
   - Option6: Qt source code dir, default is ".\src"
   - Option7: Qt install dir, default is ".\qt"
   - Option8: Extra parameters you want to pass to the config program, default is empty
4. If all the prerequisites are installed correctly, the compiling process will start automatically and there is no more to do manually, the compiler will do all the rest things. The whole compiling process may take many hours, perhaps you should leave your computer and do some interesting things.
5. If you want to link Qt against [ICU](http://site.icu-project.org/) and [OpenSSL](https://www.openssl.org/) libraries, you will have to change the script file. Please add the following config parameters:
   - ICU:
     ```bat
     SET "_ICU_DIR=your icu dir path"
     SET "PATH=%_ICU_DIR%\bin;%PATH%"
     -icu -I "%_ICU_DIR%\include" -L "%_ICU_DIR%\lib"
     REM Add ICU_LIBS="-lsicudt -lsicuin -lsicuuc -lAdvapi32" to it
     REM if you are building static version of Qt
     ```
   - OpenSSL:
     ```bat
     SET "_OPENSSL_DIR=your openssl dir path"
     SET "PATH=%_OPENSSL_DIR%\bin;%PATH%"
     -openssl-linked -I "%_OPENSSL_DIR%\include" -L "%_OPENSSL_DIR%\lib"
     REM Add OPENSSL_LIBS="-llibcrypto -llibssl -lgdi32" to it
     REM if you are building static version of Qt
     REM If you want Qt to load OpenSSL dynamically
     REM instead of linking to it directly, use "-openssl"
     REM instead of "-openssl-linked"
     ```
   Note:
   - ICU will increase the size of your application for 20~30 MB, if you don't need it then do not link against it, that's also what the Qt Company already did.
   - If you are building static version of Qt, do not add ICU and OpenSSL's bin dirs to the path variable, because they do not exist.

Notes:
- **If you want to compile QWebEngine, you have to change your system locale to English(United States)** and don't forget to change it back after compiling Qt.
- According to Qt official wiki, **QWebEngine module cannot be compiled statically**.
- nmake(provided by VS) is very slow, I recommend you use [jom](https://download.qt.io/official_releases/jom/jom.zip).

*Example*
```bat
CALL "C:\Qt\Qt5.10.2\win-build-qt.bat" 5.10.2 win32-clang-g++ x86 lib debug-and-release "C:\Qt\Qt5.10.2\src" "C:\Qt\Qt5.10.2\5.10.2\clang_g++_static_64" -force-debug-info
```

**Tested on**

Windows 10 + MSVC 2017 + Qt 5.11.0/5.6.3

(Theoretically, this batch script only supports Qt 5.x and newer, it does NOT support Qt4 or any older versions)


## [win-deploy-qt.bat](/win-deploy-qt.bat)
A Windows batch script to help you deploy your Qt applications. This script is mainly designed for my personal use, but everyone can use it normally as well (if you don't have any special requirements).

**Usage**
1. Open cmd or power shell.
2. CALL "Script file path" [Option1] [Option2] [Option3] [Option4]
   - Script file path: The relative/absolute path of the batch file
   - Option1: The install directory's path of Qt (not the "bin" directory, it's the host directory)
   - Option2: The path of your application's executable file
   - Option3: The path of the directory of your application's executable file
   - Option4: The path of the directory of your .qml files if your application is a Qt Quick application, otherwise leave it empty

*Example*
```bat
CALL "C:\Code\MyApp\win-deploy-qt.bat" "C:\Qt\Qt5.11.0\5.11.0\msvc2017_64" "C:\Code\MyApp\bin64\release\app.exe" "C:\Code\MyApp\bin64\release" "C:\Code\MyApp\src\qml"
```

**Tested on**

Windows 10 + MSVC 2017 + Qt 5.11.0

(Theoretically, this batch script only supports Qt 5.x and newer)


## [win-build-openssl.bat](/win-build-openssl.bat)
A Windows batch script to help you build OpenSSL. You have to install [Perl](https://www.activestate.com/activeperl) before running this script.

**Usage**
1. Download OpenSSL source code package from https://www.openssl.org/source/ . Eg: openssl-1.0.2p.tar.gz
2. Extract it and open cmd or power shell.
3. CALL "Script file path" [Option1] [Option2] [Option3] [Option4] [Option5] [Option6] [Option7]
   - Script file path: The relative/absolute path of the batch file
   - Option1: OpenSSL version, 1.0.2 or 1.1.0, default is 1.1.0
   - Option2: Target architecture, x86 or x64, default is x64
   - Option3: Target file type, dll or lib, default is dll
   - Option4: Compile mode, debug, release or debug-and-release, default is release
   - Option5: OpenSSL source code dir, default is ".\src"
   - Option6: OpenSSL install dir, default is ".\openssl"
   - Option7: Extra parameters you want to pass to the config program, default is empty

*Example*
```bat
CALL "C:\openssl\1.0.2\win-build-openssl.bat" 1.0.2 x86 lib debug "C:\openssl\1.0.2\src" "C:\openssl\1.0.2\openssl"
```

**Tested on**

Windows 10 + MSVC 2017 + OpenSSL 1.0.2.x & 1.1.x

(Theoretically, this batch script only supports OpenSSL 1.0.2.x and 1.1.x)
