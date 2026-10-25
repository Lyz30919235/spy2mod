# 参考资料与学习路由

## 教程来源与本地副本

来源：[SlayTheSpire2ModdingTutorials](https://github.com/GlitchedReme/SlayTheSpire2ModdingTutorials)。固定提交及本地相对目录以 [references.lock.json](../../references.lock.json) 为准，使用 [下载脚本](../../scripts/Get-Tutorial.ps1) 取得或核验。

本机副本位于 `references/SlayTheSpire2ModdingTutorials`，作为独立 Git 仓库保留上游信息，并由本项目忽略。用户要求下载到当前文件夹，本轮不向桌面交付副本。当前未确认教程的再分发许可，公共仓库保存来源和路由。

README 标注支持 `public-beta`；基础库对比表注明日期 `2026-07-16`。以下链接用于按任务查找，不能视为必读清单或当前 API 的保证。

## 任务路由

| 任务 | 教程位置 | 本项目落点 |
| --- | --- | --- |
| 准备环境和入口 | [Basics：环境配置](https://github.com/GlitchedReme/SlayTheSpire2ModdingTutorials/tree/master/Basics/01%20-%20%E7%8E%AF%E5%A2%83%E9%85%8D%E7%BD%AE) | [RUNBOOK.md](RUNBOOK.md)、`scripts/`、`src/Spy2Mod/` |
| 安装模组、查看日志 | [Basics：安装、看源码、修改](https://github.com/GlitchedReme/SlayTheSpire2ModdingTutorials/tree/master/Basics/02%20-%20%E5%AE%89%E8%A3%85%E3%80%81%E7%9C%8B%E6%BA%90%E7%A0%81%E3%80%81%E4%BF%AE%E6%94%B9) | [RUNBOOK.md](RUNBOOK.md) 的部署和加载检查 |
| 选择内容基础库 | [Basics：选择基础库](https://github.com/GlitchedReme/SlayTheSpire2ModdingTutorials/tree/master/Basics/03%20-%20%E9%80%89%E6%8B%A9%E5%9F%BA%E7%A1%80%E5%BA%93) | 相关内容任务确认后更新清单及依赖 |
| 添加卡牌、遗物、人物等 | [BaseLib](https://github.com/GlitchedReme/SlayTheSpire2ModdingTutorials/tree/master/BaseLib)、[RitsuLib](https://github.com/GlitchedReme/SlayTheSpire2ModdingTutorials/tree/master/RitsuLib) | 仅在选择对应基础库后读取命中主题 |
| 制作美术、动画和特效 | [Visuals](https://github.com/GlitchedReme/SlayTheSpire2ModdingTutorials/tree/master/Visuals) | 资源任务确认后再建立资源及导出映射 |
| 处理版本迁移 | [Migrations](https://github.com/GlitchedReme/SlayTheSpire2ModdingTutorials/tree/master/Migrations) | 版本发生变化并涉及兼容时按需读取 |

## 工具下载依据

工具地址和校验值保存于 [toolchain.json](../../toolchain.json)，来源为 Microsoft 的 [.NET 9 发布元数据](https://builds.dotnet.microsoft.com/dotnet/release-metadata/9.0/releases.json) 以及 Godot 官方 [4.5.1 发布资产](https://github.com/godotengine/godot/releases/tag/4.5.1-stable)。实际安装与验证结果只写入 [NOW.md](NOW.md)。
