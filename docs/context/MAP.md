# 项目映射

核验日期：2026-10-25（Asia/Shanghai）。对象与范围：初始根目录、本轮文档结构及 Git/GitHub 位置，不包含业务环境探测。

## 目录与职责

项目根目录以 Git 顶层目录或用户明确指定的工作目录识别；不记录个人设备绝对路径。

| 相对位置 | 用途与关系 |
| --- | --- |
| `AGENTS.md`、`PROJECT_INDEX.md`、`README.md` | 根目录协作入口；详细职责由 [项目索引](../../PROJECT_INDEX.md) 路由。 |
| `docs/context/` | 当前状态、映射、操作、决策与风险的专题权威文件。 |
| `docs/context/history/` | 有价值的历史归档及其索引，按需追溯。 |
| `.gitignore` | 私人配置、凭据文件和临时文件的基础忽略模式；不能代替提交前检查。 |
| `.gitattributes` | Markdown 及本轮 Git 配置文本使用 LF 换行。 |

## 版本与远端

- 应用版本、版本号规则：待核实。
- Git：项目根目录已初始化，工作分支为 `main`，`origin` 指向下述仓库的 HTTPS Git 地址。
- GitHub：[Lyz30919235/spy2mod](https://github.com/Lyz30919235/spy2mod)，可见性为公共（元数据 `private=false`、`visibility=public`），默认分支为 `main`。
- 本地提交身份使用该 GitHub 账号及其 noreply 地址，只配置于本仓库，避免将私人邮箱写入公开提交。
- 本地与远端提交对应关系：执行 [RUNBOOK.md](RUNBOOK.md) 中的实时查询；不在此缓存易过期的 HEAD。

## 运行、配置与部署

业务源码入口、依赖清单、业务配置、构建输出、部署及安装位置：待核实。本轮未建立这些映射，不能据此推断运行环境。
