## msvc reduce qt binary file size

**IMPORTANT NOTE**: file size ≈ performance, so reduce file size ≈ reduce performance, so it's not recommended to reduce Qt binary file size.

- Optimize for size instead of speed
   ```bat
   call configure.bat -optimize-size
   ```
   or change `qtbase\mkspecs\common\msvc-desktop.conf`
   ```bat
   QMAKE_CFLAGS_OPTIMIZE = -O1 -Os
   ```

- Enable link time code generation
   ```bat
   call configure.bat -ltcg
   ```

- Disable RTTI

   change `qtbase\mkspecs\common\msvc-desktop.conf`
   ```bat
   QMAKE_CXXFLAGS_RTTI_ON =
   ```

- Use [VC-LTL](https://github.com/Chuyu-Team/VC-LTL) to reduce MSVCRT library size

- Disable C/C++ exception

   change `qtbase\mkspecs\common\msvc-desktop.conf`
   ```bat
   QMAKE_CXXFLAGS_STL_ON =
   QMAKE_CXXFLAGS_EXCEPTIONS_ON =
   ```

- Use [UPX](https://github.com/upx/upx/releases) to compress binary files
   ```bat
   upx --best "*.dll"
   ```
   or
   ```bat
   upx --ultra-brute "*.dll"
   ```
