## build-qt.bat

A Windows batch script file to compile Qt from source code. You must know that this batch script can only help you on configuring the compiler, it will not install anything to your system, you still have to install all the prerequisites manually before you run it.

**Usage**

1. Open cmd or power shell
2. CALL script-file-path ARCH(x86 or x64, default is x64) TYPE(dll or lib, default is dll) MODE(debug, release or debug-and-release, default is release) SRC-DIR(Qt source code dir, default is ".\src") INSTALL-DIR(Qt install dir, default is ".\qt") EXTRA-PARAMS(Extra parameters you want to pass to the config program, default is empty)

*Example*

```bat
CALL "C:\Qt\build-qt.bat" x64 dll release "C:\Qt\src" "C"\Qt\msvc2017_64"
```

**Tested on**

Windows 10 + MSVC 2017 + Qt 5.11.0

(Theoretically, this batch script supports Qt 5.7.x and newer.)
