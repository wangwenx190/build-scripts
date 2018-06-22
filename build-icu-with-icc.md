# Build ICU with ICC

## IMPORTANT Notes

- **For Windows platform and VS developers ONLY !!!**
- You have to install [Visual Studio](https://www.visualstudio.com/downloads/), [Intel C++ Compiler](https://software.intel.com/en-us/c-compilers) and [MSYS2](http://www.msys2.org/) (only for static builds) first.

## Shared library

1. [Download ICU source code package](http://site.icu-project.org/download)  and extract it to anywhere you like.
2. Open "**<path_to_icu_source_code_directory>\source\allinone\allinone.sln**" with Visual Studio.
3. Switch to Intel C++ Compiler.
4. Replace "**/utf-8**" with "**-Qoption,cpp,--unicode_source_kind,"UTF-8"**" in **[Property->C/C++->Command line]** (if there is no "/utf-8", it's OK, just add the latter one).
5. Build the solution.

## Static library

1. [Download ICU source code package](http://site.icu-project.org/download)  and extract it to anywhere you like.
2. Open "**<path_to_icu_source_code_directory>\source\runConfigureICU**", replace all "**cl**" with "**icl**", "**-MD**" with "**-MT**".
3. Open "**<path_to_icu_source_code_directory>\source\config\mh-msys-msvc**" and do the following changes:
   - find "**ifeq ($(ENABLE_RELEASE),1)**", add "**CFLAGS+=-O3 -Ob2 -Oi -Ot -GT -Qipo -DU_RELEASE=1#M#**" below it and change "**CPPFLAGS+=-DU_RELEASE=1#M#**" to "**CPPFLAGS+=-O3 -Ob2 -Oi -Ot -GT -Qipo -DU_RELEASE=1#M#**".
   - find "**ifeq ($(ENABLE_DEBUG),1)**", add "**CFLAGS+=-Od -Qno-ipo -D_DEBUG=1#M#**" below it and change "**CPPFLAGS+=-D_DEBUG=1#M#**" to "**CPPFLAGS+=-Od -Qno-ipo -D_DEBUG=1#M#**".
   - find "**CFLAGS+=-GF -nologo -utf-8**" and change it to "**CFLAGS+=-GF -nologo -Zc:wchar_t -Qprec -Zm200 -Zc:strictStrings -FS -Qoption,cpp,--unicode_source_kind,"UTF-8"**".
   - find "**CXXFLAGS+=-GF -nologo -EHsc -Zc:wchar_t -utf-8**" and change it to "**CXXFLAGS+=-GF -nologo -EHsc -Zc:wchar_t -Qprec -Zm200 -Zc:forScope -FS -Zc:referenceBinding -Zc:strictStrings -Zc:throwingNew -Zc:rvalueCast -Zc:inline -Qstd=c++11 -Qoption,cpp,--unicode_source_kind,"UTF-8"**".
   - replace all "**LINK.EXE**" with "**xilink**", "**LIB.EXE**" with "**xilib**".
4. Open cmd shell, execute the following commands:
   ```bat
   rem the following paths may be different from your's, just for example
   call "C:\Program Files (x86)\IntelSWTools\compilers_and_libraries\windows\bin\ipsxe-comp-vars.bat" ia32 vs2017
   rem to build 64-bit icu: call "C:\Program Files (x86)\IntelSWTools\compilers_and_libraries\windows\bin\ipsxe-comp-vars.bat" intel64 vs2017
   call "C:\msys64\msys2_shell.cmd" -mingw32 -use-full-path
   rem to build 64-bit icu: call "C:\msys64\msys2_shell.cmd" -mingw64 -use-full-path
   ```
   Then execute the following commands:
   ```bash
   cd <path_to_icu_source_code_directory>/source
   ./runConfigureICU MSYS/MSVC --enable-static --disable-shared --prefix=$PWD/../../icu4c-x86-static-icc
   make -j4 && make install
   ```
