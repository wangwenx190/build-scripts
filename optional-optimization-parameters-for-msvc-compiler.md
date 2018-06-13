# Optional optimization parameters for MSVC compiler

### Notes

1. Intel C++ Compiler (ICC) uses MSVC compiler as it's backend on Windows platform, so you can also use these parameters in ICC.
2. If you are using ICC, you can use the highest optimization level: **O3**.

### Configuration file

<path_to_qt_source_code_directory>\\**qtbase\mkspecs\common\msvc-desktop.conf**

For example:
```text
C:\Qt\src\qtbase\mkspecs\common\msvc-desktop.conf
```

### Optimization parameters

Add "**-Ob2 -Oi -Ot -GT**" to "**QMAKE_CFLAGS_OPTIMIZE**"

For example:
```text
QMAKE_CFLAGS_OPTIMIZE = -O2 -Ob2 -Oi -Ot -GT
```

If there is no "QMAKE_CFLAGS_OPTIMIZE" in "msvc-desktop.conf", you can add these parameters to "**QMAKE_CFLAGS_RELEASE**" and "**QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO**"

For example:
```text
QMAKE_CFLAGS_RELEASE = -O2 -Ob2 -Oi -Ot -GT -MD
QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO = -O2 -Ob2 -Oi -Ot -GT -Zi -MD
```

**NOTES**

- Remember to enable **Link Time Code Generation (LTCG)**: pass "**-ltcg**" to "**configure.bat**" while you are configuring Qt.
- Some old Qt versions don't have "QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO" in "msvc-desktop.conf", it's all right, just ignore it.
