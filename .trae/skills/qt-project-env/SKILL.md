---
name: "qt-project-env"
description: "Provides Qt 6.8.3 multimedia recorder project environment details. Invoke when setting up build environment, configuring Qt, or working with this specific Qt project."
---

# Qt Project Environment

## Project Overview

This is a Qt 6.8.3 multimedia recorder application built with CMake.

## Environment Details

### Project Location
- **Path**: `e:\Qt\project\recorder`
- **Build System**: CMake
- **CMake Version**: 3.30.5
- **CMake Path**: `E:\Qt\Tools\CMake_64\bin\cmake.exe`
- **CMake Minimum Version**: 3.16

### Qt Configuration
- **Qt Version**: 6.8.3
- **Qt Installation Path**: `E:\Qt\6.8.3`
- **Qt Prefix**: `E:/Qt/6.8.3/mingw_64`
- **QMake Version**: 3.1
- **Compiler**: MinGW 64-bit (GNU 13.1.0)
- **Compiler Path**: `E:/Qt/Tools/mingw1310_64/bin/g++.exe`
- **Make Program**: `E:/Qt/Tools/mingw1310_64/bin/mingw32-make.exe`
- **Build Directory**: `build/`

### Qt Components Required
```cmake
find_package(Qt6 REQUIRED COMPONENTS Core Multimedia Quick)
```

### Linked Libraries
- `Qt6::Core`
- `Qt6::Multimedia`
- `Qt6::Quick`

## Project Structure

### Source Files
- `main.cpp` - Application entry point with permission handling

### QML Files
- `main.qml` - Main application window
- `main_no_permissions.qml` - Error screen when permissions denied
- `MediaList.qml` - Media list display
- `AudioInputSelect.qml` - Audio input selection
- `VideoSourceSelect.qml` - Video source selection
- `RecordButton.qml` - Recording button
- `Controls.qml` - Control panel
- `StyleParameter.qml` - Style parameters
- `StyleRectangle.qml` - Styled rectangle
- `SettingsMetaData.qml` - Metadata settings
- `SettingsEncoder.qml` - Encoder settings
- `StyleSlider.qml` - Styled slider
- `Style.qml` - Global styles
- `Playback.qml` - Media playback

### Platform Files
- `android/AndroidManifest.xml` - Android manifest
- `Info.plist.in` - macOS Info.plist template

## Build Commands

### Clean Build Directory
```bash
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
```

### Configure
```bash
cmake -B build -DCMAKE_PREFIX_PATH="E:/Qt/6.8.3/mingw_64" -DCMAKE_C_COMPILER="E:/Qt/Tools/mingw1310_64/bin/gcc.exe" -DCMAKE_CXX_COMPILER="E:/Qt/Tools/mingw1310_64/bin/g++.exe" -DCMAKE_MAKE_PROGRAM="E:/Qt/Tools/mingw1310_64/bin/mingw32-make.exe" -G "MinGW Makefiles"
```

### Build
```bash
cmake --build build
```

### Run
```bash
.\build\recorder.exe
```

### Build Troubleshooting

If you encounter build errors, try these steps:

1. **Clean build directory**:
   ```bash
   Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
   ```

2. **Reconfigure with full paths**:
   ```bash
   cmake -B build -DCMAKE_PREFIX_PATH="E:/Qt/6.8.3/mingw_64" -DCMAKE_C_COMPILER="E:/Qt/Tools/mingw1310_64/bin/gcc.exe" -DCMAKE_CXX_COMPILER="E:/Qt/Tools/mingw1310_64/bin/g++.exe" -DCMAKE_MAKE_PROGRAM="E:/Qt/Tools/mingw1310_64/bin/mingw32-make.exe" -G "MinGW Makefiles"
   ```

3. **Common errors**:
   - `CMAKE_MAKE_PROGRAM is not set`: Specify the full path to mingw32-make.exe
   - `CMAKE_CXX_COMPILER not set`: Specify the full path to g++.exe
   - `could not load cache`: Delete the build directory and reconfigure

## Runtime Warnings

The application may show QML style warnings during startup:

```
QML StyleRectangle: The current style does not support customization of this control
```

These warnings are informational and do not affect functionality. They occur because the native Windows style doesn't support background customization. The application still works correctly despite these warnings.

## Permissions

The application requires:
- Camera permission
- Microphone permission

These are handled in `main.cpp` using `QPermission` API.

## Application Features

- Video recording from camera/screen/window
- Audio recording
- Media playback
- Encoder settings configuration
- Metadata settings
- Media list management
