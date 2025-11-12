# build-java-tdlib

构建 TDLib 的 Java/JNI 绑定，支持 Windows / macOS / Linux，并在创建版本标签时将构建产物自动发布到 GitHub Releases。

**仓库目标**
- 跨平台构建 TDLib（包含 JNI 原生库与 Java 绑定）。
- 通过 GitHub Actions 在打 tag 后自动打包并上传到 Release 页。

## 本地构建

你可以在本地使用脚本快速构建对应该平台的产物：

- Linux：`/bin/bash build-linux.sh`
- macOS：`/bin/bash build-macos.sh`
- Windows（Git Bash 或 WSL）：`/bin/bash build-windows.sh`

脚本会：
- 克隆 `td` 源码并完成依赖安装/配置。
- 生成并安装 JNI + Java 示例到仓库根目录的 `tdlib/`。

构建完成后，`tdlib/` 目录即为可分发目录（其中包含原生库与 Java 绑定）。

## CI 与发布

本仓库已配置 GitHub Actions，以在创建版本标签后自动构建并发布产物：

- `Linux` 与 `macOS`：当创建以 `v` 开头的标签（例如 `v1.0.0`）时触发。
- `Windows`：当创建匹配 `v*-windows` 的标签（例如 `v1.0.0-windows`）时触发。
- 两端均有每月定时任务以保持产物更新。

工作流会在构建完成后打包 `tdlib/` 为压缩文件，并上传到对应标签的 Release。

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

## 如何触发与验证

- 创建并推送标签以触发工作流：
  - Linux/macOS：`git tag v1.0.0 && git push origin v1.0.0`
  - Windows：`git tag v1.0.0-windows && git push origin v1.0.0-windows`
- 等待 CI 完成后，打开 GitHub Releases 页面查看是否存在对应的 `tar.gz` 资产。

## 定制与调整

- 统一标签模式：如果希望 Windows 也使用 `v*`，可将 `.github/workflows/windows.yml` 中的触发规则改为与其他两端一致。
- 压缩格式：当前使用 `tar.gz`，如需改为 `zip` 可在三个工作流中将打包命令替换为 `zip` 并调整扩展名。
- 文件命名：如需自定义产物命名，可修改工作流中的 `TAR_NAME` 组装逻辑。

## 常见问题

- 权限问题：工作流已设置 `permissions: contents: write`，并使用默认 `GITHUB_TOKEN` 发布 Release。
- 目录未找到：若脚本未生成 `tdlib/`，工作流会回退查找 `td/tdlib/`；如仍失败，请检查构建日志与依赖安装是否成功。
- Windows 打包：工作流在 Windows Runner 上使用 `bash` + `tar`，无需额外安装；如使用 PowerShell，希望使用 `zip`，可按“定制与调整”修改。

---

如需增加校验和文件、签名或多产物上传（分别打包 `lib/`、`include/` 等），请提出需求，我可以进一步完善工作流与文档。
