# AiStatus

AiStatus 是一款 macOS 菜单栏状态灯，用来观察本机 Codex/GPT 和 Claude Code 是否正在处理任务。它面向长时间等待 AI 输出的本地工作流：一眼看见任务是否还在跑，需要时手动开启防休眠，并在会话结束时收到桌面通知。

## 功能概览

- **菜单栏状态灯**：默认蓝灯表示检测到 GPT 或 Claude 正在使用，默认绿灯表示两者都空闲。
- **会话标题列表**：菜单中展示 GPT/Claude 的活跃会话和闲置会话标题。
- **结束通知**：当 GPT/Claude 会话从活跃变为闲置时，桌面通知提示结束的是哪个会话。
- **颜色偏好**：可以分别配置运行时灯颜色和空闲时灯颜色。
- **保持 Mac 活跃**：菜单里可以开启“保持 Mac 活跃（防休眠）”，阻止系统和显示器因空闲进入睡眠。
- **本地优先**：只解析运行状态和用于展示的会话标题，不复制完整会话正文。

## 检测来源

AiStatus 只读取本机文件，不依赖远程账号：

- GPT/Codex：读取 `~/.codex/sessions` 的 `task_started` / `task_complete` 事件。
- GPT/Codex 会话标题：读取 `~/.codex/session_index.jsonl`。
- Claude Code：读取 `~/.claude/projects` 的 Claude Code JSONL 事件；最近用户/工具循环未出现 `assistant:end_turn` 时视为运行中。

## 本地运行

```bash
swift run AiStatus
```

项目要求 macOS 13+，Swift Package 配置见 `Package.swift`。

## 打包成菜单栏 App

```bash
Scripts/build-app.sh
open dist/AiStatus.app
```

默认使用 ad-hoc 签名，适合本机使用或发给信任用户测试。若要使用 Developer ID 证书签名：

```bash
SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)" Scripts/build-app.sh
```

## 打包成 DMG

```bash
Scripts/build-dmg.sh
```

脚本会生成：

- `dist/AiStatus-0.1.0.dmg`
- `dist/AiStatus-0.1.0.dmg.sha256`

DMG 内包含 `Install Guide.html`。如果用户首次打开时看到“Apple 无法验证是否包含可能危害 Mac 的恶意软件”，安装说明会引导用户进入“系统设置 → 隐私与安全性 → 仍要打开”。

面向互联网公开下载时，建议使用 Developer ID 证书签名并公证：

```bash
SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)" \
NOTARY_PROFILE="your-notarytool-profile" \
Scripts/build-dmg.sh
```

## 落地下载页

落地页位于 `site/`，采用接近 Claude/Anthropic 的暖色纸感风格：米白背景、炭黑主按钮、陶土橙强调色、细边框、8px 圆角和轻量进入动画。

页面内容包括：

- 首屏产品介绍和 DMG 下载按钮
- AiStatus 菜单栏状态面板预览
- 菜单栏状态灯、会话标题、防休眠、结束通知四个卖点
- 本地解析和隐私说明
- DMG 安装步骤
- 非 Apple 认证证书导致 Gatekeeper 拦截时的“系统设置 → 隐私与安全性 → 仍要打开”图文说明
- SHA-256 校验展示和复制按钮
- 中英文双语切换，用户选择会保存在浏览器本地

本地预览：

```bash
python3 -m http.server 4173 --directory site
open http://127.0.0.1:4173/
```

当前公开预览地址：

```text
http://aistatus.ssdwgg.site/
```

下载地址：

```text
http://aistatus.ssdwgg.site/downloads/AiStatus-0.1.0.dmg
```

> 注意：如果要正式公开推广，建议为 `aistatus.ssdwgg.site` 配置匹配的 HTTPS 证书，并使用 Developer ID 签名/公证后的 DMG。

## 部署落地页

复制部署配置示例：

```bash
cp .env.deploy.example .env.deploy.local
```

填写 `.env.deploy.local`：

```dotenv
DEPLOY_SSH_HOST=your-server-public-ip
DEPLOY_SSH_USER=root
DEPLOY_SSH_PORT=22
DEPLOY_SSH_KEY=~/.ssh/tencent-cloud.pem
DEPLOY_REMOTE_DIR=/www/wwwroot/ryw_yun_project/aistatus/
```

同步静态资源到服务器：

```bash
set -a
source .env.deploy.local
set +a

ssh -i "$DEPLOY_SSH_KEY" -p "$DEPLOY_SSH_PORT" \
  -o StrictHostKeyChecking=accept-new \
  -o IdentitiesOnly=yes \
  "$DEPLOY_SSH_USER@$DEPLOY_SSH_HOST" \
  "mkdir -p '$DEPLOY_REMOTE_DIR'"

rsync -avz --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \
  -e "ssh -i '$DEPLOY_SSH_KEY' -p '$DEPLOY_SSH_PORT' -o StrictHostKeyChecking=accept-new -o IdentitiesOnly=yes" \
  site/ "$DEPLOY_SSH_USER@$DEPLOY_SSH_HOST:$DEPLOY_REMOTE_DIR"
```

`.env.deploy.local` 包含本机部署信息和私钥路径，已在 `.gitignore` 中忽略，不要提交。

## 验证

运行单元测试：

```bash
swift test
```

校验 DMG：

```bash
Scripts/build-dmg.sh
cd site/downloads
shasum -a 256 -c AiStatus-0.1.0.dmg.sha256
```

检查落地页本地资源引用：

```bash
python3 - <<'PY'
from html.parser import HTMLParser
from pathlib import Path

root = Path("site")

class Parser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.refs = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        for key in ("href", "src"):
            value = attrs.get(key)
            if value and not value.startswith(("http://", "https://", "#", "mailto:", "tel:")):
                self.refs.append(value)

parser = Parser()
parser.feed((root / "index.html").read_text())
missing = []

for ref in parser.refs:
    path = ref.split("#", 1)[0].split("?", 1)[0]
    if path and not (root / path).exists():
        missing.append(ref)

if missing:
    raise SystemExit("Missing refs: " + ", ".join(missing))

print("All local href/src references exist")
PY
```

## 项目结构

```text
.
├── Package.swift
├── Resources/
│   ├── AppIcon.icns
│   ├── AppIcon.png
│   └── Info.plist
├── Scripts/
│   ├── build-app.sh
│   ├── build-dmg.sh
│   └── generate-icon.py
├── Sources/
│   ├── AiStatus/
│   └── CodexStatusCore/
├── Tests/
│   └── CodexStatusCoreTests/
└── site/
    ├── assets/
    ├── downloads/
    ├── index.html
    ├── script.js
    └── styles.css
```
