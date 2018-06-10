# How to build static version of Qt with ICU and OpenSSL

**For Windows and VS developers ONLY !!!**

**You have to install [Active Perl](https://www.activestate.com/activeperl/downloads), [Python 2](https://www.python.org/downloads/windows/) and [Visual Studio](https://www.visualstudio.com/downloads/) first.**

## Build static version of ICU

32-bit example:
1. [Download the newest MSYS2](http://www.msys2.org/) and install it. I assume you have installed it to it's default location "C:\msys64".
2. Open *MSYS2 MSYS* and execute the following commands:
   ```bash
   pacman -Syu
   ```
   Close the bash window forcely and open *MSYS2 MSYS* again, execute the following commands:
   ```bash
   pacman -Su
   ```
3. Open *MSYS2 MinGW 32-bit* and execute the following commands:
   ```bash
   pacman -S $MINGW_PACKAGE_PREFIX-make
   ```
4. Rename "C:\msys64\usr\bin\link.exe" to "link.exe.bak" (only if you have this file), "C:\msys64\mingw32\bin\mingw32-make.exe" to "make.exe".
5. [Download the latest ICU source code package](http://site.icu-project.org/) and extract it to anywhere you like. I assume you have extract it to "C:\ICU".
6. Open cmd shell and execute the following commands (I assume you have installed VS2017 Community to it's default localtion):
   ```bat
   call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
   set MSYS2_PATH_TYPE=inherit
   C:\msys64\msys2_shell.cmd -mingw32
   ```
   Then execute the following commands:
   ```bash
   cd /c/icu/source
   ./runConfigureICU --enable-static --disable-shared --prefix=$PWD/../icu4c-static CFLAGS=-MT CXXFLAGS=-MT
   make -j4 && make install
   ```

## Build static version of OpenSSL

[Just use the script I offered.](https://github.com/wangwenx190/build-scripts/blob/master/win-build-openssl.bat)

## Build static version of Qt

1. [Use the script I offered to generate the batch script file.](https://github.com/wangwenx190/build-scripts/blob/master/win-build-qt.bat)
2. Open the generated *.bat* file, change or add the following lines:
   ```bat
   SET "_ICU_DIR=C:\ICU\icu4c-static"
   SET "_OPENSSL_DIR=C:\OpenSSL\openssl-static"
   SET "PATH=%_ICU_DIR%\bin;%_OPENSSL_DIR%\bin;%PATH%"
   CALL "configure.bat" -icu ICU_PREFIX="%_ICU_DIR%" ICU_LIBS="-lsicudt -lsicuin -lsicuio -lsicutest -lsicutu -lsicuuc -lAdvapi32" -openssl-linked OPENSSL_PREFIX="%_OPENSSL_DIR%" OPENSSL_LIBS="-llibcrypto -llibssl -lgdi32"
   ```
3. You may have some compiler errors while compiling Qt, it's OK, just rerun the batch script.
