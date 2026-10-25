# spy2mod

## 项目用途

《杀戮尖塔2》模组开发工程。当前范围是可加载的基础工程，模组入口输出初始化日志；玩法内容待后续需求确认。源码及清单位于 [src/Spy2Mod](src/Spy2Mod/Spy2Mod.csproj)。

## 基本使用

在项目根目录的 PowerShell 中执行：

```powershell
.\scripts\Get-Tutorial.ps1
.\scripts\Install-Tools.ps1
.\scripts\Configure-Local.ps1
.\scripts\Build-Mod.ps1 -Deploy
.\scripts\Smoke-Test.ps1
```

工具下载自官方地址并核对固定哈希，配置脚本自动寻找 Steam 游戏目录。下载、工具、本机配置和产物均留在忽略目录；首次运行条件及网络备用选项见 [RUNBOOK.md](docs/context/RUNBOOK.md)。

使用 `.\scripts\Open-Editor.ps1` 打开 Godot 工程。教程本地副本位于 `references/SlayTheSpire2ModdingTutorials`，其来源、固定版本及学习路线见 [参考资料](docs/context/REFERENCES.md)。

当前实际验证结果及未完成项见 [NOW.md](docs/context/NOW.md)，命令列出不代表已经执行成功。

## 文档入口

[PROJECT_INDEX.md](PROJECT_INDEX.md) 按任务路由到唯一权威来源。目录、版本和配置关系见 [MAP.md](docs/context/MAP.md)，已知验证缺口见 [RISKS.md](docs/context/RISKS.md)。
