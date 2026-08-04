# 《失踪的拾光者》· 部署指南

游戏是**一个零依赖的单 HTML 文件**（`index.html`），不请求任何外部资源，不依赖数据库或服务器逻辑。任何静态托管平台都能直接运行。

## 一、本地预览（最快）

双击 `启动本地预览.bat`，浏览器会自动打开 `http://localhost:8000`。

也可以手动运行：

```bash
node serve.js
```

然后访问 `http://localhost:8000`。

## 二、部署到公网（免费方案，任选其一）

### 方案 A：Netlify Drop（最省事，30 秒上线）

1. 打开 https://app.netlify.com/drop
2. 把整个文件夹（至少包含 `index.html`）拖进页面
3. 自动生成一个 `https://xxx.netlify.app` 链接，直接可玩

### 方案 B：GitHub Pages（推荐，方便后续更新）

1. 在 GitHub 新建仓库（如 `mystery-game`），把 `index.html` 上传
2. 仓库 Settings → Pages → Source 选择分支（main）+ 根目录
3. 等待 1-2 分钟，访问 `https://你的用户名.github.io/mystery-game/`

> 把 `index.html` 放在仓库根目录即可，无需任何构建步骤。

### 方案 C：Vercel / Cloudflare Pages

- Vercel：导入仓库或直接拖拽文件夹到 vercel.com/new
- Cloudflare Pages：Dashboard → Workers & Pages → 创建 → 直接上传文件夹

两种都无需配置，选中 `index.html` 为入口即可。

## 三、注意事项

- **存档**：游戏进度存在浏览器的 `localStorage`，按域名隔离。换域名 = 新存档，同域名刷新/重开不丢进度。
- **域名隔离**：正式上线建议用独立域名或独立子路径，避免存档与其它页面互相干扰。
- **自定义域名**：所有平台都支持绑定自己的域名，按平台文档在 DNS 加一条 CNAME 即可。
- **二次开发**：剧情、线索、结局都定义在 `index.html` 的 `SITES` / `CLUES` / `ENDINGS` 数据里，想加第二季内容只需在数据区新增站点和线索。

## 四、文件说明

| 文件 | 用途 |
| --- | --- |
| `index.html` | 游戏本体（唯一需要部署的文件） |
| `serve.js` / `启动本地预览.bat` | 本地预览用，部署时可不带 |
| `.build-parts/` | 分块源码，改游戏后重新合并用，部署时可忽略 |
