# 操作手册

本文件记录方法及前置条件，步骤本身不构成执行授权。执行结果的权威入口为 [NOW.md](NOW.md)，远端及分支位置见 [MAP.md](MAP.md)。

## 操作前定位

先确认用户指定的项目根目录及适用规则；进入 Git 仓库后可用以下只读命令核对范围：

```powershell
git rev-parse --show-toplevel
git status --short
git remote -v
```

未初始化的目录运行 Git 仓库查询会失败，不将该失败解释为业务代码故障。

## 文档改动检查

前置条件：已按 [项目规则](../../AGENTS.md) 确认改动范围，修改前读取过目标部分。

1. 仅列出本次新建、修改及直接关联的文件；确认规则、路由、使用说明和专题职责覆盖，未知信息标注“待核实”。
2. 检查每类事实只有一个权威来源，摘要及链接不复制专题正文；核对所有本次涉及的相对链接及标题锚点，不能只检查路径存在。
3. 检查差异中的秘密、私人绝对路径、无关改动、矛盾状态和被覆盖内容；不要打开凭据文件来“验证”它们。
4. 暂存前查看目标文件差异；新文件还应直接检查内容。暂存后运行 `git diff --cached --check` 与 `git diff --cached --stat`，并检查暂存差异。
5. 在 [NOW.md](NOW.md) 中原位记录核验日期、对象、范围及结果。文档检查通过不等于业务测试通过。

## Git 与公共仓库同步

前置条件：具有当前任务的修改与公开同步授权；Git 可用；提交身份和 GitHub 认证可用；将上传的内容允许公开。

- 如果目录尚无 Git 仓库，在确认根目录后使用 `git init -b main`。已有仓库不重复初始化、不重建历史。
- 如果尚无远端，先创建并确认归属正确的 GitHub 公共空仓库，再使用实际地址配置 `origin`。已有同名仓库先核验归属与内容，不覆盖。
- 仅明确暂存本次文件：使用 `git add -- <本次文件路径...>`，不要直接暂存未审查的整个工作区。
- 完成本次检查后，使用说明具体变更的消息提交，再执行推送。已有远端分歧先查看原因，不自动强推。

以下命令以已核验 `origin` 与本地 `main` 为前提。这里是操作方法，实际执行状态见 [NOW.md](NOW.md)，不能将示例视为成功证据：

```powershell
git push -u origin main
git rev-parse HEAD
git ls-remote --exit-code origin refs/heads/main
git status --short
```

核验要求：查询 GitHub 仓库元数据确认公开；比较本地 HEAD 与远端 `refs/heads/main` 的完整提交值；确认本次改动已提交。上传失败时保留本地提交，并在 [NOW.md](NOW.md) 记录具体阻塞，不编造成功状态。

## 业务运行、构建与测试

前置条件：Windows、PowerShell 7、Git、已安装的 Steam 版《杀戮尖塔2》，以及当前任务允许的本机安装或部署范围。以下为方法，实际执行结果以 [NOW.md](NOW.md) 为准。

### 初次准备

在项目根目录执行：

```powershell
.\scripts\Get-Tutorial.ps1
.\scripts\Install-Tools.ps1
.\scripts\Configure-Local.ps1
```

- 教程脚本使用 `references.lock.json` 固定的提交；已有副本的远端不符或存在本地改动时停止，避免覆盖批注。
- 工具脚本使用 `toolchain.json` 中的官方地址，校验完整 ZIP 的哈希后解压，运行版本查询。已有完整缓存会复用；校验失败的文件不得安装。
- 下载连接受现有代理影响时，可用 `Install-Tools.ps1 -NoProxy` 对单次请求直连，不改变系统代理。该选项不是成功证据；传输中断时保留诊断并重新获取完整、校验通过的缓存。
- 配置脚本寻找 Steam App `2868840`，确认游戏程序集及工具存在后写入 `.local/settings.json`。自动定位失败时可传 `-GameDir '<游戏根目录>'`；带占位符的命令仅是备用方法，本轮不据此声称执行过。
- 配置脚本还将 Godot 自带的 NuGet 包复制到 `.tools/nuget-feed/`；基础工程按 `nuget.config` 使用本机包源。将来接入内容基础库时，再按对应依赖要求补充包源。
- 本机路径仅留在忽略配置中；更新工具版本须同步检查 `global.json`、工程 SDK 和工具包之间的兼容关系。

### 构建与部署

```powershell
.\scripts\Build-Mod.ps1
.\scripts\Build-Mod.ps1 -Deploy
```

第一条构建并整理本机产物；第二条还将本模组复制到游戏 `mods/Spy2Mod/` 并比较文件 SHA256。已有同名部署目录必须含本模组清单，否则停止。部署后重新启动游戏才会载入新 DLL。

当前入口只有初始化日志，清单声明不影响玩法、无 PCK。后续添加资源或玩法时，必须据实际情况更新资源标志、依赖和 `affects_gameplay`；资源包导出及内容基础库接入尚无本项目执行证据。

### 游戏加载检查

```powershell
.\scripts\Smoke-Test.ps1
```

游戏应已关闭且本模组已部署。脚本以无界面、关闭 Steam 初始化的模式启动实际游戏，限定运行帧数；证据留在 `artifacts/smoke/`。只有退出成功且日志出现 `[Spy2Mod] initialized;`，才判定初始化检查通过。

若遇首次模组启用提示或加载失败，先检查该次日志；需要交互时在游戏界面处理对应提示并重启，不直接修改或复制存档。无界面初始化、图形界面、实际对局及用户验收分别记录。

### 打开编辑器

```powershell
.\scripts\Open-Editor.ps1
```

脚本为当前子进程设置便携 .NET 路径和本机包缓存，打开 Godot .NET 编辑器；源码目录映射见 [MAP.md](MAP.md)。Godot 工程用于源码和资源编辑，运行入口为游戏模组加载器。编辑器入口是否实际执行见 [NOW.md](NOW.md)。
