## msvc reduce qt binary file size

**IMPORTANT NOTE**: file size ≈ performance, so reduce file size ≈ reduce performance, so it's not recommended to reduce Qt binary file size.

- Optimize for size instead of speed
   ```bat
   call configure.bat -optimize-size
   ```

- Enable link time code generation
   ```bat
   call configure.bat -ltcg
   ```

- Disable RTTI
   ```bat
   call configure.bat -no-rtti
   ```

- Use shared MSVCRT library(-MD, default)

- Disable C/C++ exception

- Use [UPX](https://github.com/upx/upx/releases) to compress binary files
   ```bat
   upx --best "*.dll"
   ```
   or
   ```bat
   upx --ultra-brute "*.dll"
   ```
