本项目基于 Qt 样例二次开发

# Qt 媒体录制器

一个基于 Qt 6.8.3 和 FFmpeg 的多媒体录制应用程序，支持摄像头、屏幕和窗口录制。

## 功能特性

- ✅ **多源录制**：支持摄像头、屏幕和窗口三种视频源
- ✅ **音频录制**：同步录制系统音频
- ✅ **视频播放**：内置播放器支持录制视频回放
- ✅ **编码器设置**：可配置视频质量、编解码器和文件格式
- ✅ **元数据设置**：支持添加视频元数据信息
- ✅ **自定义保存路径**：使用 QSettings 持久化保存路径，下次启动自动恢复
- ✅ **文件名显示**：录制列表显示文件名而非完整 URL
- ✅ **默认屏幕源**：程序启动时默认显示屏幕捕获
- ✅ **中文界面**：所有界面元素已翻译为中文

## 技术栈

- **Qt 版本**：6.8.3
- **编译器**：MinGW 13.1.0 (GNU)
- **构建系统**：CMake 3.30.5
- **多媒体库**：Qt Multimedia (FFmpeg 7.1)
- **界面框架**：Qt Quick (QML)

## 项目结构

```
recorder/   录音机/
├── main.cpp                 # 应用入口，权限处理和设置注册
├── AppSettings.h             # 应用设置类（QSettings 持久化）
├── SavePathSettings.qml      # 保存路径设置界面
├── main.qml                 # 主窗口
├── main_no_permissions.qml   # 权限错误界面
├── MediaList.qml             # 录制列表显示
├── Controls.qml              # 控制面板
├── SettingsEncoder.qml        # 编码器设置
├── SettingsMetaData.qml      # 元数据设置
├── VideoSourceSelect.qml      # 视频源选择
├── AudioInputSelect.qml      # 音频输入选择
├── RecordButton.qml          # 录制按钮
├── StyleParameter.qml         # 样式参数
├── StyleRectangle.qml         # 样式矩形
├── SettingsSlider.qml          # 样式滑块
├── Style.qml                 # 全局样式
├── Playback.qml              # 视频播放
├── CMakeLists.txt           # CMake 构建配置
└── package.bat               # 打包脚本
```

## 编译和运行

### 环境要求

- Windows 10 或更高版本
- Qt 6.8.3 MinGW 64-bit
- CMake 3.16 或更高版本
- MinGW 13.1.0 编译器

### 编译步骤

```bash
# 1. 清理旧的构建文件
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue

# 2. 配置 CMake 项目
cmake -B build -DCMAKE_PREFIX_PATH="E:/Qt/6.8.3/mingw_64" `
    -DCMAKE_C_COMPILER="E:/Qt/Tools/mingw1310_64/bin/gcc.exe" `
    -DCMAKE_CXX_COMPILER="E:/Qt/Tools/mingw1310_64/bin/g++.exe" `
    -DCMAKE_MAKE_PROGRAM="E:/Qt/Tools/mingw1310_64/bin/mingw32-make.exe" `
    -G "MinGW Makefiles"

# 3. 编译项目
cmake --build build

# 4. 运行应用程序
.\build\recorder.exe
```

### 编译故障排除

如果遇到编译错误，请尝试以下步骤：

1. **CMAKE_CXX_COMPILER not set**：
   ```bash
   cmake -B build -DCMAKE_PREFIX_PATH="E:/Qt/6.8.3/mingw_64" `
       -DCMAKE_C_COMPILER="E:/Qt/Tools/mingw1310_64/bin/gcc.exe" `
       -DCMAKE_CXX_COMPILER="E:/Qt/Tools/mingw1310_64/bin/g++.exe" `
       -DCMAKE_MAKE_PROGRAM="E:/Qt/Tools/mingw1310_64/bin/mingw32-make.exe" `
       -G "MinGW Makefiles"
   ```

2. **CMAKE_MAKE_PROGRAM not set**：
   ```bash
   cmake -B build -DCMAKE_PREFIX_PATH="E:/Qt/6.8.3/mingw_64" `
       -DCMAKE_C_COMPILER="E:/Qt/Tools/mingw1310_64/bin/gcc.exe" `
       -DCMAKE_CXX_COMPILER="E:/Qt/Tools/mingw1310_64/bin/g++.exe" `
       -DCMAKE_MAKE_PROGRAM="E:/Qt/Tools/mingw1310_64/bin/mingw32-make.exe" `
       -G "MinGW Makefiles"
   ```

3. **could not load cache**：
   ```bash
   Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
   ```

## 打包和部署

### 自动打包

项目包含一个自动打包脚本 `package.bat`，它会：

1. 清理旧的发布目录
2. 复制可执行文件到发布目录
3. 使用 windeployqt 工具自动部署 Qt 依赖
4. 复制所有必需的 DLL 和插件
5. 创建 README 文件

### 运行打包脚本

```bash
.\package.bat
```

### 关键参数说明

打包脚本使用了 `--qmldir %PROJECT_DIR%` 参数，这对于 QML 项目至关重要：

- `--qmldir`：指定 QML 文件所在的项目源码目录
- `%PROJECT_DIR%`：自动获取当前项目目录（使用 `%~dp0`）

这个参数解决了 QML 项目运行时"模块未安装"的问题。

### 发布目录内容

打包完成后，`release` 目录包含：

- **可执行文件**：`recorder.exe`
- **Qt 核心 DLL**：
  - Qt6Core.dll
  - Qt6Gui.dll
  - Qt6Qml.dll
  - Qt6Quick.dll
  - Qt6QuickTemplates2.dll
  - Qt6Multimedia.dll
  - Qt6QuickLayouts.dll
  - Qt6QuickControls.dll
  - Qt6OpenGL.dll
  - Qt6Pdf.dll
  - Qt6Svg.dll
  - Qt6VirtualKeyboard.dll
  - Qt6QmlMeta.dll
  - Qt6QmlModels.dll
  - Qt6QmlWorkerScript.dll
  - Qt6Quick3DUtils.dll
- **FFmpeg DLL**：
  - avcodec-61.dll
  - avformat-61.dll
  - avutil-59.dll
  - swresample-5.dll
  - swscale-7.dll
- **MinGW 运行时 DLL**：
  - libgcc_s_seh-1.dll
  - libstdc++-6.dll   - libstdc -6.dll
  - libwinpthread-1.dll
- **插件目录**：
  - `platforms/` - 平台插件（qwindows.dll）
  - `multimedia/` - 多媒体插件（ffmpegmediaplugin.dll, windowsmediaplugin.dll）
  - `styles/` - 样式插件（qmodernwindowsstyle.dll）
  - `imageformats/` - 图像格式插件（qgif.dll, qico.dll, qjpeg.dll 等）
  - `qml/` - QML 相关文件
  - `Qt/labs/` - Qt 实验室模块

### 分发说明

将整个 `release` 文件夹复制到目标计算机即可运行应用程序。

首次运行时需要授予摄像头和麦克风权限。

### Windows 10/11 提示

如果 Windows 10/11 阻止应用程序运行：

1. 右键点击 `release` 文件夹
2. 选择"属性"
3. 切换到"兼容性"选项卡
4. 勾选"解除锁定"
5. 点击"应用"

## 使用说明

### 基本操作

1. **启动程序**：双击 `recorder.exe`
2. **选择视频源**：点击下拉菜单选择摄像头、屏幕或窗口
3. **开始录制**：点击录制按钮
4. **停止录制**：再次点击录制按钮
5. **查看录制列表**：点击"录制列表"按钮
6. **播放视频**：点击列表项上的播放按钮
7. **打开设置**：点击"设置"按钮
8. **设置保存路径**：在设置面板中点击"浏览..."选择文件夹

### 高级功能

#### 编码器设置
- **质量**：极低/低/正常/高/极高
- **音频编解码器**：AAC / MP3 / FLAC / Vorbis
- **视频编解码器**：H.264 / H.265 / HEVC / VP9 / AV1 / MPEG-4
- **文件格式**：MP4 / MKV / MOV / AVI

#### 元数据设置
支持添加以下元数据字段：
- 标题（Title）
- 作者（Author）
- 评论（Comment）
- 描述（Description）
- 流派（Genre）
- 出版商（Publisher）
- 版权（Copyright）
- 日期（Date）

### 权限要求

应用程序需要以下权限才能正常工作：

- 📷 **摄像头权限**：用于视频录制
- 🎤 **麦克风权限**：用于音频录制

首次启动时，系统会提示授予这些权限。

## 开发历程

### 第一阶段：界面翻译
- 将所有 QML 界面文件从英文翻译为中文
- 涉及主窗口、控制面板、设置面板、视频源选择等

### 第二阶段：功能增强
- 实现了保存路径持久化功能（使用 QSettings）
- 创建了 AppSettings 类和 SavePathSettings 组件
- 添加了文件夹选择对话框
- 集成到主设置面板

### 第三阶段：默认视频源
- 修改了 VideoSourceSelect.qml
- 启动时自动选择屏幕捕获作为默认视频源
- 用户无需手动切换即可开始录制

### 第四阶段：媒体列表优化
- 实现了文件名提取功能（从 URL 中提取文件名）
- 移除了缩略图生成功能以节省资源
- 添加了 getFileName() 函数处理路径分隔符

### 第五阶段：编译配置修复
- 解决了 CMake 配置错误
- 添加了显式的编译器和 Make 程序路径
- 确保使用 MinGW 工具链

### 第六阶段：打包脚本完善
- 创建了自动打包脚本 package.bat
- 使用 windeployqt 工具进行依赖部署
- 添加了 --qmldir 参数解决 QML 项目部署问题
- 手动复制所有必需的 DLL 和插件
- 创建了详细的 README 文件

### 第七阶段：应用测试
- 成功编译并运行应用程序
- 验证了所有功能正常工作
- 确认打包后的应用可以独立运行

## 已知问题

### QML 样式警告

启动时可能会看到以下警告：

```
QML StyleRectangle: The current style does not support customization of this control
```

这些警告是信息性的，不影响程序功能。它们出现是因为原生 Windows 样式不支持背景自定义。

### 打包问题解决

如果打包后的应用程序无法运行，请检查：

1. **Qt 模块 DLL 缺失**：确保所有 Qt DLL 都已复制
2. **FFmpeg DLL 版本**：确保使用正确的版本号（avcodec-61.dll, avformat-61.dll 等）
3. **插件目录**：确保所有插件子目录都已创建
4. **QML 文件**：使用 --qmldir 参数指定项目目录

## 贡献指南

欢迎贡献代码改进！以下是改进建议：

### 界面优化
- 实现真正的视频首帧缩略图生成（当前使用静态图标）
- 添加更多编码器选项
- 改进错误提示和用户反馈
- 优化 QML 样式以减少警告

### 功能扩展
- 添加视频编辑功能
- 实现批量录制
- 添加云存储支持
- 实现视频转码功能
- 添加字幕叠加功能

### 代码质量
- 重构代码以提高可维护性
- 添加单元测试
- 改进错误处理
- 使用现代 C++ 特性

## 许可证

本项目采用 Qt 许可协议。

- Qt 框架：LGPLv3
- FFmpeg：LGPLv2.1 或更高版本

## 联系方式

如有问题或建议，请通过以下方式联系：

- 📧 提交 Issue：在项目仓库创建 Issue
- 💬 讨论：在 Discussions 中交流想法
- 📧 邮件：发送邮件至项目维护者

## 致谢

感谢所有为 Qt 多媒体框架做出贡献的开发者！
