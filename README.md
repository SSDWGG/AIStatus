# AiStatus

macOS 菜单栏状态灯，用来观察本机 GPT/Codex 和 Claude Code 是否正在处理任务。

- 默认蓝灯：检测到 GPT 或 Claude 正在使用
- 默认绿灯：GPT 和 Claude 都空闲
- GPT 检测源：`~/.codex/sessions` 的 `task_started` / `task_complete`，会话标题来自 `~/.codex/session_index.jsonl`
- Claude 检测源：`~/.claude/projects` 的 Claude Code JSONL 事件，最近用户/工具循环未出现 `assistant:end_turn` 时视为运行中
- 菜单里可以分别配置运行时灯颜色和空闲时灯颜色
- 菜单里可以开启“保持 Mac 活跃（防休眠）”，阻止系统因空闲进入睡眠
- 当 GPT/Claude 会话从活跃变为闲置时，桌面通知会提示结束的是哪个会话

## 运行

```bash
swift run AiStatus
```

## 打包成菜单栏 App

```bash
Scripts/build-app.sh
open dist/AiStatus.app
```

这个 App 只解析运行状态和用于展示的会话标题，不复制完整会话正文。菜单里可以看到 GPT/Claude 各自最近事件对应的会话标题，以及活跃会话、闲置会话的标题列表。
