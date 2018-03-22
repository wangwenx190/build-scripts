@ECHO OFF
COLOR
TITLE Deploying application
CLS
SETLOCAL
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
windeployqt %_DEP_PARAMS%
IF EXIST "%_APP_DIR%\qml\translations" (
    IF EXIST "%_APP_DIR%\languages" RD /S /Q "%_APP_DIR%\languages"
    MD "%_APP_DIR%\languages"
    COPY /Y "%_APP_DIR%\qml\translations\*" "%_APP_DIR%\languages"
    RD /S /Q "%_APP_DIR%\qml\translations"
) ELSE (
    IF EXIST "%_APP_DIR%\translations" (
        CD /D "%_APP_DIR%"
        REN "translations" "languages"
    )
)
IF %ERRORLEVEL% NEQ 0 ECHO Something wrong happened, deploying process aborted && GOTO Fin
SET "_CONF_FILE=%_APP_DIR%\qt.conf"
IF EXIST "%_CONF_FILE%" DEL /F /Q "%_CONF_FILE%"
ECHO [Paths]>"%_CONF_FILE%"
ECHO Binaries=.>>"%_CONF_FILE%"
ECHO Libraries=.>>"%_CONF_FILE%"
ECHO Plugins=plugins>>"%_CONF_FILE%"
ECHO Imports=imports>>"%_CONF_FILE%"
ECHO Qml2Imports=qml>>"%_CONF_FILE%"
ECHO Translations=languages>>"%_CONF_FILE%"
ECHO Deployment completed, press any key to exit this batch script
GOTO Fin

:Fin
ENDLOCAL
PAUSE
EXIT /B
