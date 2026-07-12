# 小说自动预演

## 使用方式

1. 用 Godot `4.7.0` 打开 `source/project.godot`，或运行 `RUN_SOURCE.bat`。
2. 点击顶部的“AI 预演”。
3. 粘贴 1000-2000 字中文小说原文，点击“生成场景计划”。
4. 阅读场景数量、对象数量和镜头预设摘要。
5. 点击“应用到新工程”，生成的每个场景会成为一个独立段落。切换底部段落时，只显示对应的白模场景组。
6. 在布景、拍摄和时间线中继续人工调整，再按常规方式保存或导出。

应用计划会创建一个新工程，因此不会与当前场景混合。请先保存正在编辑的工程。

## 生成内容

- 2-6 个连续场景，每段保留原文范围。
- 为每段分配白天、黄昏、夜晚或阴天环境。
- 本地模型目录中的建筑、道路、载具、家具、自然物件等；没有合适模型时用基础体补位。
- 白模人物、简单站位和命名。
- 预制镜头类型、焦距、段落时长和相机关键帧。

导入器只接受已登记的本地模型 id。未知模型、未知相机预设、范围不连续、对象数量异常或数值异常都会在导入前被拒绝。

## 可选模型配置

不做任何配置时，系统使用本地规则拆分和匹配，不联网。若希望用本机或远程的 OpenAI Chat Completions 兼容模型做更细的语义规划，先在启动 Godot 的同一个 PowerShell 中设置：

```powershell
$env:PREVIZ_LLM_MODE = "openai-compatible"
$env:PREVIZ_LLM_BASE_URL = "http://127.0.0.1:8000/v1"
$env:PREVIZ_LLM_MODEL = "your-model-id"
.\RUN_SOURCE.bat
```

端点要求认证时再额外设置 `PREVIZ_LLM_API_KEY`。环境变量不会被写入工程文件。

## MCP 与图像复核

MCP 可给支持 stdio MCP 的 Agent 宿主调用。复制 `source/agent/MCP_CONFIG.example.json` 的结构并替换路径，然后启动服务或让宿主自行启动：

```powershell
.\RUN_MCP_SERVER.bat
```

要做视觉交叉验证，先从 Godot 导出当前视角 PNG，再将 PNG 和计划传给 `validate_scene_plan` MCP 工具或 `previz_agent.py verify --image`。视觉复核是可选项，且只有显式配置支持图像输入的兼容模型后才会执行。完整工具表和安全边界见 [MCP 与 Agent 手册](MCP_AGENT_HANDBOOK.md)。
