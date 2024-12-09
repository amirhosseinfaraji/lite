@echo off
SET STRUCTURIZR_BUILD_NUMBER=%1
SET STRUCTURIZR_UI_DIR=..\structurizr-ui
SET STRUCTURIZR_LITE_DIR=.

REM Remove old static directory
IF EXIST "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static" (
    rd /s /q "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static"
)

REM Recreate the static directory
mkdir "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static"

REM JavaScript
mkdir "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static\js"
robocopy "%STRUCTURIZR_UI_DIR%\src\js" "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static\js" *.* /E

REM If build number is provided, rename structurizr*.js files, except structurizr-embed.js
IF NOT "%STRUCTURIZR_BUILD_NUMBER%"=="" (
    FOR %%f IN ("%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static\js\structurizr*.js") DO (
        echo %%~nxf | findstr /i "structurizr-embed.js" >nul
        IF ERRORLEVEL 1 (
            REM No match found, rename the file
            rename "%%f" "%%~nf-%STRUCTURIZR_BUILD_NUMBER%%%~xf"
        ) ELSE (
            echo Skipping %%f
        )
    )
)

REM CSS
mkdir "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static\css"
robocopy "%STRUCTURIZR_UI_DIR%\src\css" "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static\css" *.* /E

REM Images
mkdir "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static\img"
robocopy "%STRUCTURIZR_UI_DIR%\src\img" "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static\img" *.* /E

REM Bootstrap icons
mkdir "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static\bootstrap-icons"
robocopy "%STRUCTURIZR_UI_DIR%\src\bootstrap-icons" "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static\bootstrap-icons" *.* /E

REM HTML (offline exports)
mkdir "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static\html"
copy "%STRUCTURIZR_UI_DIR%\src\html\*.*" "%STRUCTURIZR_LITE_DIR%\src\main\resources\static\static\html"

REM JSP fragments
robocopy "%STRUCTURIZR_UI_DIR%\src\fragments" "%STRUCTURIZR_LITE_DIR%\src\main\webapp\WEB-INF\fragments" *.* /E
REM Remove dsl directory
IF EXIST "%STRUCTURIZR_LITE_DIR%\src\main\webapp\WEB-INF\fragments\dsl" (
    rd /s /q "%STRUCTURIZR_LITE_DIR%\src\main\webapp\WEB-INF\fragments\dsl"
)

REM JSP
robocopy "%STRUCTURIZR_UI_DIR%\src\jsp" "%STRUCTURIZR_LITE_DIR%\src\main\webapp\WEB-INF\jsp" *.* /E
del "%STRUCTURIZR_LITE_DIR%\src\main\webapp\WEB-INF\jsp\review.jsp"
del "%STRUCTURIZR_LITE_DIR%\src\main\webapp\WEB-INF\jsp\review-create.jsp"

REM Java
mkdir "%STRUCTURIZR_LITE_DIR%\src\main\java\com\structurizr\util"
copy "%STRUCTURIZR_UI_DIR%\src\java\com\structurizr\util\DslTemplate.java" "%STRUCTURIZR_LITE_DIR%\src\main\java\com\structurizr\util\"