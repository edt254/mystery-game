# 部署状态与操作手册（Codex 专用）

> ⚠️ 用户下次说「部署上线 / 更新游戏」时，**先读本文件**，按下方「更新流程」执行，不要凭记忆操作。

## 一、当前部署状态（2026-08-04 记录）

| 平台 | 状态 | 地址 |
| --- | --- | --- |
| GitHub Pages | ✅ 已上线 | https://edt254.github.io/mystery-game/ |
| Vercel | ✅ 已上线 | https://mystery-game-sand.vercel.app |

- 游戏本体：`D:\codexdm\index.html`（单文件，约 96KB，当前版本 v1.0，已提交）
- GitHub 仓库：`edt254/mystery-game`（分支 main，本地 `D:\codexdm` 已关联 origin）
- Vercel 项目：`mystery-game`（projectId `prj_6LERyIQP7aJNcE4yEUMGlfsTbOwX`，团队/scope `lub3`）
- 两个平台均已关闭访问限制，公开可玩；Vercel 是国内备用入口（github.io 国内可能无法直连）

## 二、更新流程（改完 `index.html` 之后）

### 1. GitHub Pages（自动）

```bash
cd D:\codexdm
git add index.html
git commit -m "更新说明"
git push origin main
```

- 推送后 1-2 分钟，https://edt254.github.io/mystery-game/ 自动更新
- 本环境 Git 凭据已存（GitHub token 在 credential store 里），直接 push 即可
- 若 push 报鉴权错误：向用户要新的 GitHub token（保存为 `D:\codexdm\github-token.txt`，用后删除）

### 2. Vercel（目前是手动部署，未接 Git 联动）

方式 A（推荐，一劳永逸）：让用户到 Vercel 后台把项目连上 GitHub——
`mystery-game` 项目 → Settings → Git → Connect，选 `edt254/mystery-game`。
连接后 `git push` 会自动触发 Vercel 部署，无需 token。

方式 B（没连 Git 时，用 CLI）：

```bash
cd D:\codexdm
npx --yes vercel@latest deploy . --token <TOKEN> --yes --prod --name mystery-game
```

- token：让用户到 https://vercel.com/account/tokens 创建（名称随意），保存为本地 txt 文件（如 `D:\codexdm\vercel-token.txt`），**不要粘贴到聊天**；用后删除文件
- `.vercelignore` 已排除 `*.txt`、`.build-parts/`、`.git/` 等，token 不会被上传
- 部署后必须验证：https://mystery-game-sand.vercel.app 返回 200 且内容包含「失踪的拾光者」

## 三、踩过的坑（务必记住）

1. **Vercel 新项目默认开启 Deployment Protection**（`ssoProtection: all_except_custom_domains`），未登录访问只会返回 Vercel 鉴权/404 页，看起来像部署失败。
   关闭方法：
   `PATCH https://api.vercel.com/v9/projects/<projectId>`，body：`{"ssoProtection":null}`
2. **Vercel API 手工上传会得到空部署**（POST /v13/deployments 带 `files` 字段时文件会丢失），必须用官方 CLI 部署。
3. 本机网络不稳定：调用 GitHub/Vercel API 需 `[Net.ServicePointManager]::SecurityProtocol = Tls12` + 重试；直接 `Invoke-WebRequest` 抓 vercel.app 偶尔被代理干扰，失败时用 CLI 的 `vercel curl` 或重试确认。
4. PowerShell 的 `Sort-Object` 是文化排序：合并 `.build-parts` 时必须用**显式顺序数组**（`09b-fix` 必须排在 `09-engine1` 之后才会生效）。
5. 游戏存档在浏览器 `localStorage`（key `mystery_save_v1`，字段 `chapter:1`）。改 `chapter` 会清空所有玩家旧存档；小更新不要动它。

## 四、本地开发与测试

- 最终产物：`D:\codexdm\index.html`（单文件，直接改它即可；改完重新测试再部署）
- 分块源码：`D:\codexdm\.build-parts\`。若本环境 apply_patch 更新功能故障，需先改 part 文件再按显式顺序合并：
  `01-head` → `02-shell` → `03-core` → `04-data1` → `05-data2` → `06-sites1` → `07-sites2` → `08-sites3` → `09-engine1` → `09b-fix` → `09d-mailgate` → `10-engine2`
- 测试：`node .build-parts\test-harness4.js .build-parts\mystery_check.js`（当前 28 项全过）
- 语法检查：先提取 `<script>` 内容到临时 js，再 `node --check`
- 本地预览：双击 `启动本地预览.bat`，或 `node serve.js` 后访问 http://localhost:8000

## 五、凭据与安全

- GitHub token：原文件已删除，凭据存于本环境 git credential store；仓库 `.gitignore` 已忽略 token 文件
- Vercel token：原文件已删除；建议用户去后台删除 `codex-deploy` token，下次更新时临时创建
- 规则：**token 绝不写入聊天、绝不提交仓库**；token 文件必须同时加入 `.gitignore` 与 `.vercelignore`

## 六、当前待办

- [ ] 按用户反馈修复游戏 bug、调整玩法（改完 `index.html` 后按第二节流程更新两个平台）

## v2 改版状态（2026-08-04）
- 已完成：桌面仿真（窗口管理/任务栏/通知）、新增 10 站点（共 22）、29 条线索、章节卡+任务日志、反应式叙事、代号身份、分章节氛围、雨巷时钟冻结
- 测试：
ode .build-parts\test-harness6.js .build-parts\mystery_check.js（28 项全过）
- 待办：Vercel 更新需用户临时提供 token（或先在 Vercel 后台连接 GitHub）；GitHub Pages 推 main 自动更新

## v3 深化改版（2026-08-05）
- 已完成：双向互动（论坛发帖/聊天室输入/回信/暗线会话）、2 个中间抉择点、三级提示系统、证据组合（3 组）、误导惩罚、桌面细节（右键菜单/开始菜单/图标拖拽/引导便签/开机音/通知音）、三人物支线、任务栏性能优化、大字号、favicon/meta
- 线索：29 → 36；结局判定与关键线索不变
- 测试：
ode .build-parts\test-harness7.js .build-parts\mystery_check.js（19 项全过）
