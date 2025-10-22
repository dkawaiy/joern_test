# joern_test

这是一个用于演示和运行 Joern 静态代码分析任务的 Docker 镜像示例仓库。仓库提供了用于构建镜像的 `base.dockerfile` 与一个示例 Joern 脚本 `parse.sc`（用于把源代码解析并导出分析结果）。

本 README 将详细说明如何构建镜像、如何在容器中运行 Joern 脚本、如何挂载目录以便传入源代码并导出解析结果，以及常见的故障排查提示。

## 目录结构（仓库内文件）

- `base.dockerfile`：用于构建包含 Joern 运行环境的 Dockerfile。
- `parse.sc`：示例的 Joern 脚本（用于解析源代码并导出结果）。
- `README.md`：本文件。

## 先决条件

- 已安装 Docker（建议使用较新的 Docker Engine）。
- 有要进行解析的源代码目录（可在宿主机挂载到容器内）。

## 构建镜像

在仓库根目录执行以下命令来构建镜像（镜像名示例为 `joern_test:latest`）：

```bash
docker build -t joern_test:latest -f base.dockerfile .
```

如果你希望使用不同的标签或 Dockerfile 名称，请相应修改命令中的 `-t` 或 `-f` 参数。

## 启动容器挂载目录以传入代码与导出结果

通常我们会把宿主机上的源代码目录和一个输出目录挂载到容器内，方便脚本读取和写入解析结果：

```bash
docker run --rm -it \
  -v /path/to/your/code:/workspace/input \
  -v /path/to/output:/workspace/output \
  joern_test:latest
```

说明：
- `/workspace/input`：容器内的只读输入目录（把你的代码放到这里）。
- `/workspace/output`：容器内的输出目录（解析结果会写到这里）。

把路径替换为宿主机上的实际路径（例如 `$(pwd)/code` 等）。

## 在容器内运行 `parse.sc`（示例脚本）
在容器的终端
```
joern --script /workspace/parse.sc --param output=/workspace/output/test --param path=/workspace/input/test
```
