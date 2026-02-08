@echo off
chcp 65001 >nul
echo ========================================
echo    Qt Media Recorder Packaging Tool
echo ========================================
echo.

REM Set variables
set QT_DIR=E:\Qt\6.8.3\mingw_64
set BUILD_DIR=build
set DEPLOY_DIR=release
set EXE_NAME=recorder.exe
set PROJECT_DIR=%~dp0

echo [1/5] Cleaning old deploy directory...
if exist %DEPLOY_DIR% (
    echo Removing old deploy directory...
    rmdir /s /q %DEPLOY_DIR%
)

echo [2/5] Creating deploy directory...
mkdir %DEPLOY_DIR%

echo [3/5] Copying executable...
copy %BUILD_DIR%\%EXE_NAME% %DEPLOY_DIR%\

echo [4/5] Running windeployqt with --qmldir parameter...
echo This is CRITICAL for QML projects!
%QT_DIR%\bin\windeployqt.exe --release --no-translations --no-system-d3d-compiler --no-opengl-sw --qmldir %PROJECT_DIR% %DEPLOY_DIR%\%EXE_NAME%

echo [5/5] Copying additional Qt runtime DLLs...
copy %QT_DIR%\bin\Qt6Multimedia.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\Qt6QuickLayouts.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\Qt6QuickControls.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\Qt6OpenGL.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\Qt6Pdf.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\Qt6Svg.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\Qt6VirtualKeyboard.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\Qt6QmlMeta.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\Qt6QmlModels.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\Qt6QmlWorkerScript.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\Qt6Quick3DUtils.dll %DEPLOY_DIR%\ 2>nul

echo [6/5] Copying FFmpeg DLLs...
copy %QT_DIR%\bin\avcodec-61.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\avformat-61.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\avutil-59.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\swresample-5.dll %DEPLOY_DIR%\ 2>nul
copy %QT_DIR%\bin\swscale-7.dll %DEPLOY_DIR%\ 2>nul

echo [7/5] Copying MinGW runtime DLLs...
copy E:\Qt\Tools\mingw1310_64\bin\libgcc_s_seh-1.dll %DEPLOY_DIR%\ 2>nul
copy E:\Qt\Tools\mingw1310_64\bin\libstdc++-6.dll %DEPLOY_DIR%\ 2>nul
copy E:\Qt\Tools\mingw1310_64\bin\libwinpthread-1.dll %DEPLOY_DIR%\ 2>nul

echo [8/5] Copying plugins...
xcopy %QT_DIR%\plugins\platforms\qwindows.dll %DEPLOY_DIR%\platforms\ /I /Y 2>nul
xcopy %QT_DIR%\plugins\multimedia\*.dll %DEPLOY_DIR%\multimedia\ /I /Y 2>nul
xcopy %QT_DIR%\plugins\styles\qmodernwindowsstyle.dll %DEPLOY_DIR%\styles\ /I /Y 2>nul
xcopy %QT_DIR%\plugins\imageformats\*.dll %DEPLOY_DIR%\imageformats\ /I /Y 2>nul

echo [9/5] Creating README file...
(
echo Media Recorder > %DEPLOY_DIR%\README.txt
echo. >> %DEPLOY_DIR%\README.txt
echo ======================================== >> %DEPLOY_DIR%\README.txt
echo           Media Recorder >> %DEPLOY_DIR%\README.txt
echo ======================================== >> %DEPLOY_DIR%\README.txt
echo. >> %DEPLOY_DIR%\README.txt
echo Usage: >> %DEPLOY_DIR%\README.txt
echo 1. Double click recorder.exe to launch the program >> %DEPLOY_DIR%\README.txt
echo 2. Grant camera and microphone permissions on first run >> %DEPLOY_DIR%\README.txt
echo. >> %DEPLOY_DIR%\README.txt
echo System Requirements: >> %DEPLOY_DIR%\README.txt
echo - Windows 10 or higher >> %DEPLOY_DIR%\README.txt
echo. >> %DEPLOY_DIR%\README.txt
echo Features: >> %DEPLOY_DIR%\README.txt
echo - Supports camera, screen, and window recording >> %DEPLOY_DIR%\README.txt
echo - Supports audio recording >> %DEPLOY_DIR%\README.txt
echo - Supports video playback >> %DEPLOY_DIR%\README.txt
echo - Supports encoder and metadata settings >> %DEPLOY_DIR%\README.txt
echo - Supports custom save path >> %DEPLOY_DIR%\README.txt
echo - Displays file names in media list >> %DEPLOY_DIR%\README.txt
echo - Shows screen as default video source on startup >> %DEPLOY_DIR%\README.txt
echo. >> %DEPLOY_DIR%\README.txt
echo Version Info: >> %DEPLOY_DIR%\README.txt
echo - Qt 6.8.3 >> %DEPLOY_DIR%\README.txt
echo - FFmpeg 7.1 >> %DEPLOY_DIR%\README.txt
echo. >> %DEPLOY_DIR%\README.txt
echo ======================================== >> %DEPLOY_DIR%\README.txt
)

echo.
echo [10/10] Packaging complete!
echo.
echo Deploy directory: %DEPLOY_DIR%
echo Executable: %DEPLOY_DIR%\%EXE_NAME%
echo.
echo You can now copy the entire 'release' folder to distribute the application.
echo.
echo ========================================
echo Tips:
echo - For Windows 10/11, right-click the 'release' folder and select "Properties"
echo - Check "Unblock" if Windows blocks the application
echo - Copy the entire folder to target computer for distribution
echo ========================================
echo.
pause
