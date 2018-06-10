# Optional optimization parameters for MSVC compiler

### IMPORTANT note

Only for MSVC compiler, **NOT** compatible with Intel C++ Compiler (ICC)

### Configuration file

<path_to_qt_source_code_directory>\\**qtbase\mkspecs\common\msvc-desktop.conf**

For example:
```text
C:\Qt\src\qtbase\mkspecs\common\msvc-desktop.conf
```

### Optimization parameters

Add "**-Ob2 -Oi -Ot -Oy- -GT**" to "**QMAKE_CFLAGS_OPTIMIZE**"

For example:
```text
QMAKE_CFLAGS_OPTIMIZE = -O2 -Ob2 -Oi -Ot -Oy- -GT
```

If there is no "QMAKE_CFLAGS_OPTIMIZE" in "msvc-desktop.conf", you can add these parameters to "**QMAKE_CFLAGS_RELEASE**" and "**QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO**"

For example:
```text
QMAKE_CFLAGS_RELEASE = -O2 -Ob2 -Oi -Ot -Oy- -GT -MD
QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO = -O2 -Ob2 -Oi -Ot -Oy- -GT -Zi -MD
```

And enable **Link Time Code Generation (LTCG)**: pass "**-ltcg**" to "**configure.bat**" while you are configuring Qt.

**NOTE**

Some old Qt versions don't have "QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO" in "msvc-desktop.conf", it's all right, just ignore it.
