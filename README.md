# build-tdlib

构建 TDLib 的 Java/JNI 绑定，支持 Windows / macOS / Linux

版本发布 https://github.com/all4fun/build-tdlib/releases

**仓库目标**
- 跨平台构建 TDLib（包含 JNI 原生库与 Java 绑定）。
- 通过 GitHub Actions 自动打包上传到 Release 页。

## 本地构建

你可以在本地使用脚本快速构建对应该平台的产物：

- Linux：`/bin/bash build-linux.sh`
- macOS：`/bin/bash build-macos.sh`
- Windows（Git Bash 或 WSL）：`/bin/bash build-windows.sh`

脚本功能：
- 克隆 `td` 源码并完成依赖安装/配置。
- 生成并安装 JNI + Java 示例到仓库根目录的 `tdlib/`。

构建完成后，`tdlib/` 目录即为可分发目录（其中包含原生库与 Java 绑定）。

## CI 与发布

本仓库已配置 GitHub Actions，以在创建版本标签后自动构建并发布产物

## 发布产物

每个平台会上传一个压缩包，命名规则：

- `tdlib-<OS>-<ARCH>.tar.gz`
  - 示例：`tdlib-Linux-x86_64.tar.gz`、`tdlib-macOS-arm64.tar.gz`、`tdlib-Windows-x86_64.tar.gz`

压缩包内容：
- `tdlib/` 目录（来自示例 Java 的安装产物），包含：
  - 原生 JNI 库（如 `libtdjni.*` / `tdjni.dll`）。
  - Java 绑定与示例组件（来自 TDLib 示例安装）。

## 使用示例

在你的项目中解压发布包，并确保 JVM 能加载原生库：

- 将 `tdlib/` 放入项目资源或部署目录。
- 启动时设置 `java.library.path` 指向原生库所在目录，或在应用初始化时调用 `System.loadLibrary("tdjni")`。
- 按照 TDLib Java 示例的用法创建并使用 `Client`、`TdApi` 等。

示例启动参数：
- `java -Djava.library.path=./tdlib/lib -jar your-app.jar`

注意：具体子目录结构可能随 TDLib 版本而变动，建议根据解压后的 `tdlib/` 结构调整路径。

