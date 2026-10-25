# 当前状态

核验日期：2026-10-26（Asia/Shanghai）。对象与范围：教程下载、本机工具、基础工程构建部署、无界面初始化及图形主菜单；未开始实际对局。

## 当前目标与进展

本轮目标已完成：教程下载到当前项目，工具、基础工程、部署及实际加载均已验证，基础工程源码已同步到公共仓库。最新提交是否同步以实时 Git 引用为准。

| 工作项 | 当前事实与证据 |
| --- | --- |
| 教程 | 已完整下载到当前项目的 `references/`，独立副本远端、固定提交及工作区已核验；配置权威为 [references.lock.json](../../references.lock.json)，学习入口见 [REFERENCES.md](REFERENCES.md)。 |
| 本轮兼容目标 | 本机 Steam `public-beta`，实际游戏 `v0.111.0`，运行配置为 .NET 9；其他游戏版本与 Steam 联机模式待核实。 |
| 工具 | 便携 .NET SDK 与 Godot .NET 已安装，完整工具包分别通过官方 SHA512、SHA256 校验，版本查询通过；版本及下载定义见 [toolchain.json](../../toolchain.json)。 |
| 编译与部署 | Debug 构建通过，0 警告、0 错误；DLL 与 JSON 已部署到游戏 `mods/Spy2Mod/`，两份文件的 SHA256 与本机产物一致。清单见 [Spy2Mod.json](../../src/Spy2Mod/Spy2Mod.json)。 |
| 无界面加载 | 实际游戏输出 `[Spy2Mod] initialized; version=0.1.0.0; gameplay changes=none.`，退出码 0，证明入口被执行；退出阶段的引擎诊断另见下文。 |
| 图形加载 | OpenGL 图形界面进入主菜单，右下角显示加载 1 个模组，悬停显示 `Spy2Mod 基础工程`；截图对应首次构建，最终 DLL 已另行通过无界面加载复核。已正常结束本轮测试游戏进程。 |
| 编辑工程 | Godot `--headless --editor --quit` 导入工程通过，退出码 0。图形编辑器交互尚未单独验证。 |
| 当前功能范围 | 原生入口及加载日志已实现；具体玩法待用户后续确认，尚未引入内容基础库。实际对局和用户验收尚未进行。 |
| 本轮交付检查 | 27 个本轮文件、9 份 Markdown 的 64 处本地链接、6 个 PowerShell 脚本语法、JSON/XML 及版本配置一致性检查通过；读写规则各 7 条完整，差异格式检查通过。基础工程首轮提交已核验公开同步，最新版本核验方法见 [RUNBOOK.md](RUNBOOK.md)。 |

## 阻塞与下一步

- 基础工程准备及加载无未解决阻塞；后续变更继续遵循项目规则进行检查、提交、推送及远端核验。
- 无界面及 OpenGL 退出日志存在引擎资源未释放诊断；首次未执行模组入口时也出现类似现象。当前尚未完成归因，不能声称运行日志完全无错误；相关边界见 [RISKS.md](RISKS.md)。
- 工具直传曾提前断开，已通过续传取得完整官方校验通过的缓存；后续可复用本机缓存。遇网络问题仍须坚持完整哈希校验。
- 后续任务可从首张卡牌、遗物或人物需求开始；涉及内容时再确认基础库，涉及资源时再配置资源包导出。不自动扩展为玩法制作或工坊发布。

## 证据入口

- 最终 DLL 加载证据：本机 `artifacts/smoke/20261026-002748-result.json` 及同前缀日志；首次构建的图形证据为 `artifacts/gui-test/loaded-game.log`、`artifacts/gui-test/Spy2Mod-loaded.png`。这些文件可能包含机器信息，保持 Git 忽略，不复制原始日志到公共仓库。
- 版本证据：[基础工程首轮提交](https://github.com/Lyz30919235/spy2mod/commit/d53488d3cc81f0191514d772ec54f4bdc9e6e9dd)。当前版本使用 Git 提交记录并按 [RUNBOOK.md](RUNBOOK.md) 实时比较本地与远端引用，不以历史上传结果代替当前核验。
- 已确认约定：[DECISIONS.md](DECISIONS.md)。历史仅在有必要归档时进入 [历史索引](history/README.md)。
