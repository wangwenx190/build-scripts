@ECHO OFF
COLOR
TITLE Deploying application
CLS
SETLOCAL EnableDelayedExpansion
SET "_QT_DIR=%1"
IF /I "%_QT_DIR%" == "" ECHO Qt install dir not found && GOTO Fin
SET "_EXE_FILE=%2"
IF /I "%_EXE_FILE%" == "" ECHO Application exe not found && GOTO Fin
SET "_APP_DIR=%3"
IF /I "%_APP_DIR%" == "" ECHO Application dir not found && GOTO Fin
IF /I "%4" == "" (
    SET _DEP_PARAMS=--plugindir "%_APP_DIR%\plugins" --force --compiler-runtime "%_EXE_FILE%"
) ELSE (
    SET _DEP_PARAMS=--dir "%_APP_DIR%\qml" --libdir "%_APP_DIR%" --plugindir "%_APP_DIR%\plugins" --force --qmldir "%_QT_DIR%\qml" --compiler-runtime "%_EXE_FILE%"
)
SET "PATH=%_QT_DIR%\bin;%PATH%"
IF EXIST "%_APP_DIR%\plugins" RD /S /Q "%_APP_DIR%\plugins"
IF EXIST "%_APP_DIR%\qml" RD /S /Q "%_APP_DIR%\qml"
IF EXIST "%_APP_DIR%\translations" RD /S /Q "%_APP_DIR%\translations"
IF EXIST "%_APP_DIR%\languages" RD /S /Q "%_APP_DIR%\languages"
IF EXIST "%_APP_DIR%\Qt*.dll" DEL /F /Q "%_APP_DIR%\Qt*.dll"
IF EXIST "%_APP_DIR%\qt.conf" DEL /F /Q "%_APP_DIR%\qt.conf"
windeployqt %_DEP_PARAMS%
IF EXIST "%_APP_DIR%\qml\translations" (
    MOVE /Y "%_APP_DIR%\qml\translations" "%_APP_DIR%\languages"
) ELSE (
    IF EXIST "%_APP_DIR%\translations" (
        CD /D "%_APP_DIR%"
        REN "translations" "languages"
    )
)
IF EXIST "%_APP_DIR%\plugins\platforms" (
    IF EXIST "%_APP_DIR%\plugins\platforms\qwindowsd.dll" (
        COPY /Y "%_QT_DIR%\plugins\platforms\qdirect2dd.dll" "%_APP_DIR%\plugins\platforms\qdirect2dd.dll"
        COPY /Y "%_QT_DIR%\plugins\platforms\qminimald.dll" "%_APP_DIR%\plugins\platforms\qminimald.dll"
        COPY /Y "%_QT_DIR%\plugins\platforms\qoffscreend.dll" "%_APP_DIR%\plugins\platforms\qoffscreend.dll"
        COPY /Y "%_QT_DIR%\plugins\platforms\qwebgld.dll" "%_APP_DIR%\plugins\platforms\qwebgld.dll"
    )
    IF EXIST "%_APP_DIR%\plugins\platforms\qwindows.dll" (
        COPY /Y "%_QT_DIR%\plugins\platforms\qdirect2d.dll" "%_APP_DIR%\plugins\platforms\qdirect2d.dll"
        COPY /Y "%_QT_DIR%\plugins\platforms\qminimal.dll" "%_APP_DIR%\plugins\platforms\qminimal.dll"
        COPY /Y "%_QT_DIR%\plugins\platforms\qoffscreen.dll" "%_APP_DIR%\plugins\platforms\qoffscreen.dll"
        COPY /Y "%_QT_DIR%\plugins\platforms\qwebgl.dll" "%_APP_DIR%\plugins\platforms\qwebgl.dll"
    )
)
IF %ERRORLEVEL% NEQ 0 ECHO Something wrong happened, deploying process aborted && GOTO Fin
SET "_CONF_FILE=%_APP_DIR%\qt.conf"
ECHO [Paths]>"%_CONF_FILE%"
ECHO Prefix=.>>"%_CONF_FILE%"
ECHO Binaries=.>>"%_CONF_FILE%"
ECHO Libraries=.>>"%_CONF_FILE%"
ECHO Plugins=plugins>>"%_CONF_FILE%"
ECHO Imports=imports>>"%_CONF_FILE%"
ECHO Qml2Imports=qml>>"%_CONF_FILE%"
ECHO Translations=languages>>"%_CONF_FILE%"
TITLE Finished
CLS
ECHO Deploying process have completed successfully
ECHO Press any key to exit this batch script
GOTO Fin

:Fin
ENDLOCAL
PAUSE
EXIT /B
