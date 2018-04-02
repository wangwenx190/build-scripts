## Build Qt with MSYS2
The steps of using MSYS and MinGW/MinGW-w64 are quite similar to MSYS2 so I will only write about how to use MSYS2 to build Qt from source code.

### Step 1: Prepare MSYS2
1. Download MSYS2 from it's [official website](http://www.msys2.org/) (http://www.msys2.org/) and install it.
2. Run MSYS2 shell command prompt (default location: "C:\msys64\msys2_shell.cmd" -msys)
3. Update MSYS2 core components (if you have not done it yet):
   ```text
   pacman -Syu
   ```
4. Exit out from MSYS2-shell (just close the shell window forcely), restart MSYS2-shell, then run below command, to complete rest of other components update:
   ```text
   pacman -Su
   ```
5. Exit out of MSYS2-shell, restart MSYS2-shell, then you are ready to use MSYS2-shell.

**Note**

For MSYS and MinGW/MinGW-w64, just download the latest packages and extract them to anywhere you like.

### Step 2: Install required components
1. If you want to use ANGLE or if you want Qt to load OpenGL dynamically, download Microsoft DirectX SDK June 2010 from it's [official website](http://www.microsoft.com/en-us/download/details.aspx?id=6812) (http://www.microsoft.com/en-us/download/details.aspx?id=6812) and install it. You have to install the old SDK above, the newest SDK inside the Windows 10 SDK is not supported.
2. Start MSYS2-shell. Run/execute below commands to load MinGW-w64 SEH (64bit/x86_64) posix and Dwarf-2 (32bit/i686) posix toolchains & related other tools, dependencies & components from MSYS2 REPO:
   ```text
   pacman -S base-devel git mercurial cvs wget p7zip
   pacman -S perl ruby python2 mingw-w64-i686-toolchain mingw-w64-x86_64-toolchain
   ```
   **Notes**

   - The i686 (32bit) toolchain loads into "/c/msys64/mingw32/bin" ("C:\msys64\mingw32\bin") directory location, and, x86_64 (64bit) toolchain loads into "/c/msys64/mingw64/bin" ("C:\msys64\mingw64\bin") directory. Perl, Ruby, Python, OpenSSL etc loads into "/c/msys64/usr/bin" ("C:\msys64\usr\bin") directory.
   - For MSYS and MinGW/MinGW-w64, you will have to download and install these softwares above from their official websites.

### Step 3: Build Qt
1. Start MSYS2 shell command prompt and run below commands:
   ```text
   cd /c/Qt/Qt5.11.0/src
   windows2unix() { local pathPcs=() split pathTmp IFS=\;; read -ra split <<< "$*"; for pathTmp in "${split[@],}"; do pathPcs+=( "/${pathTmp//+([:\\])//}" ); done; echo "${pathPcs[*]}"; }; systemrootP=$(windows2unix "$SYSTEMROOT"); export PATH="$PWD/qtbase/bin:$PWD/gnuwin32/bin:/c/msys64/mingw64/bin:/c/msys64/usr/bin:$PATH"
   ```
   **Notes**

   - Remember to change "/c/Qt/Qt5.11.0/src" to the path of your Qt source code directory and you should change "\\" to "/", "C:\\" to "/c/", "D:\\" to "/d/" (etc) as well.
   - For MSYS and MinGW/MinGW-w64, the commands are the same with MSYS2 and remember to add perl, python and ruby's paths to the PATH variable.
2. Run below commands to configure Qt:
   ```text
   ./configure -opensource -confirm-license -release -static -static-runtime -skip qtwebengine -platform win32-g++ -opengl dynamic -qt-sqlite -qt-zlib -qt-libjpeg -qt-libpng -qt-freetype -qt-pcre -qt-harfbuzz -nomake examples -nomake tests -prefix $PWD/../dist -silent
   ```
   **Notes**

   - If you want to build the debug version of Qt, use "-debug" instead of "-release" or if you want to build both debug and release versions of Qt, use "-debug-and-release" instead of "-release".
   - If you want to build the shared version of Qt, use "-shared" instead of "-static -static-runtime".
   - If you want Qt to load OpenGL dynamically, use "-opengl dynamic" (highly recommended, but need Microsoft DirectX SDK June 2010 to build ANGLE), if you want Qt to use ANGLE only, use "-opengl es2" (Windows only, also need Microsoft DirectX SDK June 2010), if you want Qt to use Desktop OpenGL only, use "-opengl desktop" (no need of ANGLE, so no need of Microsoft DirectX SDK June 2010 as well).
   - **If you want to build QWebEngine, you have to change your system locale to English(United States)** and don't forget to change it back after building Qt.
   - According to Qt official wiki, **QWebEngine module cannot be compiled statically**, so you have skip it using "-skip qtwebengine" when you are building the static version of Qt.
   - --prefix=The target directory the compiled binaries should be copied to.
3. If the configuration process above finished successfully, run below commands to build Qt and copy the compiled binaries to the target directory:
   ```text
   make -j n && make install
   ```
   **Note**

   - "make -j n" where "n" is the number of the CPU cores your PC has.
   - Remember to put "qt.conf" and "qtenv2.bat" to the "bin" directory. You can create new files if you cannot find the original files in "src/qtbase/bin".
   - For MSYS and MinGW/MinGW-w64, use "mingw32-make" instead of "make".
