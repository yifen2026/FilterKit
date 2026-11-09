# FilterKit 0.0.1

面向 RootHide / Rootless / Rootful 越狱环境的 ElleKit 插件管理器。0.0.1 是重新建立的只读基础版本，不复用旧版业务实现。

## 当前功能
- 展示系统版本、设备型号、进程 UID/GID 和可执行文件路径。
- 从可执行文件路径尝试发现 `.jbroot-*`。这只是当前设备的发现策略，不代表完整 RootHide API 适配。
- 扫描已知 ElleKit 插件目录中的 dylib 和同名 plist，并展示解析到的 Filter 字典。
- 只读操作，不修改系统目录。

## 当前边界
- FilterKitProbe 数据显示 App 进程为 mobile (501)，不能直接写入 jbroot 的系统插件目录；安装、启停和卸载必须在后续版本设计受控特权通道。
- `jbroot()`、`rootfs()`、`jbrand()` 在 Probe 中仅发现符号可用，尚未调用；0.0.1 不将其伪装为已验证能力。
- IPC 候选目录尚未验证。Probe 报告中 `/var/run` 不可写，因此本版本不创建 Socket。
- Theos 编译环境尚未验证；请以 CI 构建结果为准。

## 构建

```sh
make clean
THEOS_PACKAGE_SCHEME=roothide make package
# 或 rootless / rootful
```

GitHub Actions 可通过 workflow_dispatch 选择 scheme。
