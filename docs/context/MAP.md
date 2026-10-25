# 项目映射

核验日期：2026-10-26（Asia/Shanghai）。对象与范围：本轮基础模组源码、参考副本、工具配置和本机游戏位置关系。

## 目录与职责

项目根目录以 Git 顶层目录或用户明确指定的工作目录识别；不记录个人设备绝对路径。

| 相对位置 | 用途与关系 |
| --- | --- |
| `AGENTS.md`、`PROJECT_INDEX.md`、`README.md` | 根目录协作入口；详细职责由 [项目索引](../../PROJECT_INDEX.md) 路由。 |
| `docs/context/` | 当前状态、映射、操作、决策与风险的专题权威文件。 |
| `docs/context/history/` | 有价值的历史归档及其索引，按需追溯。 |
| `src/Spy2Mod/Scripts/Entry.cs`、`Entry.cs.uid` | 模组初始化入口及 Godot 生成的稳定脚本标识，当前输出加载日志。 |
| `src/Spy2Mod/Spy2Mod.csproj`、`project.godot` | C# 编译配置及 Godot 编辑器工程；使用本机游戏程序集引用。 |
| `src/Spy2Mod/Spy2Mod.json` | 模组 ID、版本、兼容下限、依赖及资源标志的权威清单。 |
| `scripts/` | 教程下载、工具安装、本机配置、构建部署、无界面加载检查及编辑器入口。 |
| `references.lock.json` | 教程仓库、固定提交和本地副本相对目录的权威配置。 |
| `toolchain.json`、`global.json` | 工具下载来源、固定哈希及 .NET SDK 选择；工具更新须保持 SDK 选择与工具定义一致。 |
| `nuget.config`、`.tools/nuget-feed/` | 基础工程只使用经过校验的 Godot 工具包自带 NuGet 包；配置脚本准备本机包源。 |
| `references/`、`.tools/` | 参考仓库和便携工具，仅存本机，Git 忽略。 |
| `.local/settings.json` | 本机游戏目录、dotnet 和 Godot 可执行文件的实际路径，Git 忽略；格式见 [配置示例](../../local.settings.example.json)。 |
| `artifacts/Spy2Mod/`、`artifacts/smoke/` | 本机模组产物和加载检查日志，Git 忽略。 |
| `.gitignore` | 私人配置、凭据文件和临时文件的基础忽略模式；不能代替提交前检查。 |
| `.gitattributes` | Markdown 及本轮 Git 配置文本使用 LF 换行。 |

## 版本与远端

- 模组版本及兼容下限由 [Spy2Mod.json](../../src/Spy2Mod/Spy2Mod.json) 管理；构建脚本将清单版本传给编译器，版本字符串使用三段语义版本。
- Git：项目根目录已初始化，工作分支为 `main`，`origin` 指向下述仓库的 HTTPS Git 地址。
- GitHub：[Lyz30919235/spy2mod](https://github.com/Lyz30919235/spy2mod)，可见性为公共（元数据 `private=false`、`visibility=public`），默认分支为 `main`。
- 本地提交身份使用该 GitHub 账号及其 noreply 地址，只配置于本仓库，避免将私人邮箱写入公开提交。
- 本地与远端提交对应关系：执行 [RUNBOOK.md](RUNBOOK.md) 中的实时查询；不在此缓存易过期的 HEAD。

## 运行、配置与部署

- 游戏位置由 `.local/settings.json` 的 `GameDir` 管理。当前为 Windows Steam 安装，游戏程序集位于 `GameDir/data_sts2_windows_x86_64/`，部署目录为 `GameDir/mods/Spy2Mod/`。
- 本机工具由 `toolchain.json` 指向 `.tools/` 内的便携目录；不将个人设备绝对路径写入公开文件，不改系统 PATH。
- 构建中间结果进入 `artifacts/build/`，可部署文件进入 `artifacts/Spy2Mod/`；部署只复制本模组 DLL 和 JSON，并核对 SHA256。
- 当前工程使用游戏原生模组入口，尚未引入 BaseLib 或 RitsuLib。新增玩法内容时再按 [基础库选择入口](REFERENCES.md) 确认依赖。
