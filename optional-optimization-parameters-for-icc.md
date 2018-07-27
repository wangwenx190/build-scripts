# Optional optimization parameters for ICC

### Notes

- The following parameters are for Windows platform only, if you are using Linux, you need change a little bit.
- ICC does **NOT** support "**/utf-8**", use "**-Qoption,cpp,--unicode_source_kind,"UTF-8"**" instead.

### Configuration file

<path_to_qt_source_code_directory>\\**qtbase\mkspecs\win32-icc\qmake.conf**

For example:
```text
C:\Qt\src\qtbase\mkspecs\win32-icc\qmake.conf
```

### Optimization parameters

1. Add "**-Ob2 -Oi -Ot -GT -Qftz -Qopt-matmul -Qunroll -Qparallel -Quse-intel-optimized-headers**" to "**QMAKE_CFLAGS_OPTIMIZE_FULL**":
   ```text
   QMAKE_CFLAGS_OPTIMIZE_FULL = -O3 -Ob2 -Oi -Ot -GT -Qftz -Qopt-matmul -Qunroll -Qparallel -Quse-intel-optimized-headers
   ```
2. Add "**QMAKE_CFLAGS_RELEASE**" and "**QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO**" below "**QMAKE_CFLAGS_OPTIMIZE_FULL**":
   ```text
   QMAKE_CFLAGS_RELEASE = $$QMAKE_CFLAGS_OPTIMIZE_FULL -MD
   QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO = $$QMAKE_CFLAGS_OPTIMIZE_FULL -Zi -MD
   ```

**NOTE**

Remember to enable **Link Time Code Generation (LTCG)**: pass "**-ltcg**" to "**configure.bat**" while you are configuring Qt.
