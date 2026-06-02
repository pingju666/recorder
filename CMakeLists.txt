# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
#
# Media Recorder - Modern UI with Fluent WinUI3 Theme
# =====================================================

cmake_minimum_required(VERSION 3.16)

project(recorder LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT DEFINED INSTALL_EXAMPLESDIR)
    set(INSTALL_EXAMPLESDIR "examples")
endif()

set(INSTALL_EXAMPLEDIR "${INSTALL_EXAMPLESDIR}/multimedia/video/recorder")

# ========== Qt Packages ==========
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Multimedia
    Quick
    Svg              # For SVG icon support (optional but recommended)
)

# ========== Source Files ==========
qt_add_executable(recorder
    AppSettings.h
    main.cpp
)

qt_add_ios_ffmpeg_libraries(recorder)

# ========== QML Resource Files ==========
set(resource_files
    # Main entry
    "main.qml"
    "main_no_permissions.qml"
    "qmldir"

    # Style & Theme System
    "Style.qml"
    "StyleRectangle.qml"
    "StyleParameter.qml"
    "StyleSlider.qml"

    # UI Components
    "RecordButton.qml"
    "Controls.qml"
    "Playback.qml"
    "MediaList.qml"
    "AppIcon.qml"

    # Settings Panels
    "VideoSourceSelect.qml"
    "AudioInputSelect.qml"
    "SettingsEncoder.qml"
    "SavePathSettings.qml"
    "SettingsMetaData.qml"

    # Icon Resources (SVG)
    "resources/icons/app-icon.svg"
)

# ========== Resource Bundle ==========
qt_add_resources(recorder "recorder"
    PREFIX
        "/"
    FILES
        ${resource_files}
)

# ========== Link Libraries ==========
target_link_libraries(recorder PRIVATE
    Qt6::Core
    Qt6::Multimedia
    Qt6::Quick
    Qt6::Svg          # SVG support for icons
)

# ========== Platform-Specific Settings ==========
set_target_properties(recorder PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist.in
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android

    # Windows-specific: set application icon
    WIN32_EXECUTABLE TRUE
)

# ========== Windows Icon Configuration ==========
if(WIN32)
    # Set the application icon for Windows executable
    # Note: You need to create a .rc file or use a .ico file
    # The icon can be generated from the SVG using an external tool
    set_target_properties(recorder PROPERTIES
        OUTPUT_NAME "recorder"
    )

    # Optional: Create resource file for Windows icon
    # if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/resources/icons/app-icon.ico")
    #     configure_file(
    #         "${CMAKE_CURRENT_SOURCE_DIR}/resources/icons/icon.rc.in"
    #         "${CMAKE_BINARY_DIR}/icon.rc"
    #     )
    #     target_sources(recorder PRIVATE "${CMAKE_BINARY_DIR}/icon.rc")
    # endif()
endif()

# ========== macOS Icon Configuration ==========
if(APPLE)
    set_target_properties(recorder PROPERTIES
        MACOSX_BUNDLE_ICON_FILE "app-icon"
        MACOSX_BUNDLE_GUI_IDENTIFIER "com.qt.recorder"
    )
endif()

# ========== Installation ==========
install(TARGETS recorder
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)

# ========== Install Icon Resources ==========
if(UNIX AND NOT APPLE)
    install(FILES resources/icons/app-icon.svg
        DESTINATION "${INSTALL_EXAMPLEDIR}/icons"
    )
endif()
