## build-qt.bat
A Windows batch script to compile Qt from source code. You must know that this batch script can only help you on configuring the compiler, it will not install anything to your system, you still have to install all the prerequisites manually before you run it.

**Usage**
1. Open cmd or power shell.
2. CALL "Script file path" [Option1] [Option2] [Option3] [Option4] [Option5] [Option6]
   - Script file path: the relative/absolute path of the batch file
   - Option1: target arch, x86 or x64, default is x64
   - Option2: target file type, dll or lib, default is dll
   - Option3: compile mode, debug, release or debug-and-release, default is release
   - Option4: Qt source code dir, default is ".\src"
   - Option5: Qt install dir, default is ".\qt"
   - Option6: Extra parameters you want to pass to the config program, default is empty
3. If all the prerequisites are installed correctly, the compiling process will start automatically and there is no more to do manually, the compiler will do all the rest things. The whole compiling process may take many hours, perhaps you should leave your computer and do some interesting things.
4. If you want to link Qt against [ICU](http://site.icu-project.org/) and [OpenSSL](https://www.openssl.org/) libraries, you will have to change the script file. Please add the following config parameters:
   - ICU:
     ```bat
     -icu ICU_PREFIX="%_ICU_DIR%" ICU_LIBS_DEBUG="-licudtd -licuind -licuucd" ICU_LIBS_RELEASE="-licudt -licuin -licuuc"
     ```
   - OpenSSL:
     ```bat
     -openssl-linked OPENSSL_PREFIX="%_OPENSSL_DIR%" OPENSSL_LIBS_DEBUG="-lssleay32d -llibeay32d" OPENSSL_LIBS_RELEASE="-lssleay32 -llibeay32"
     ```
   Notes:
   - "%_ICU_DIR%" and "%_OPENSSL_DIR%" are the directories that contain "bin", "lib" and "include" directories of ICU and OpenSSL, remember to set them in the batch script.
   - ICU will increase the size of your application for about 40MB, if you don't need it then do not link against it, that's also what the Qt Company already did.

Notes:
- **If you want to compile QWebEngine, you have to change your system locale to English(United States)** and don't forget to change it back after compiling Qt.
- According to Qt official wiki, **QWebEngine module cannot be compiled statically**.
- nmake(provided by VS) is very slow, I recommend you use [jom](https://download.qt.io/official_releases/jom/jom.zip).

*Example*
```bat
CALL "C:\Qt\build-qt.bat" x86 lib debug-and-release "C:\Qt\src" "C:\Qt\msvc2017_Static_64" -force-debug-info
```

**Tested on**

Windows 10 + MSVC 2017 + Qt 5.11.0

(Theoretically, this batch script supports Qt 5.7.x and newer.)

## win-deploy-qt.bat
A Windows batch script to help you deploy your Qt applications. This script is mainly designed for my personal use, but everyone can use it normally as well (if you don't have any special requirements).

**Usage**
1. Open cmd or power shell.
2. CALL "Script file path" [Option1] [Option2] [Option3] [Option4]
   - Script file path: the relative/absolute path of the batch file
   - Option1: The install directory's path of Qt (not the "bin" directory, it's the host directory)
   - Option2: The path of your application's executable file
   - Option3: The path of the directory of your application's executable file
   - Option4: If your application is not an Qt Quick application, leave this option empty

*Example*
```bat
CALL "C:\Code\MyApp\win-deploy-qt.bat" "C:\Qt\Qt5.11.0\5.11.0\msvc2017_64" "C:\Code\MyApp\bin64\release\app.exe" "C:\Code\MyApp\bin64\release" qml(or anything else you like)
```
