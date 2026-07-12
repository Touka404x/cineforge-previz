# 3D 白模预演

> **非官方衍生版本**，基于 [CineForge Previz](https://github.com/Work-Fisher/cineforge-previz) 源码二次开发。
>
> 本仓库按 **[CC BY-NC-SA 4.0](LICENSE)** 发布：允许在署名、注明改动并以相同协议分享的前提下进行非商业使用、修改和再分发；不允许商业使用。本项目不是 CineForge 或“创剧”的官方产品，也不受其背书或认可。

![3D 白模预演场景示例](docs/images/preview.png)

## 上游署名与授权

- **上游项目**：[Work-Fisher/cineforge-previz](https://github.com/Work-Fisher/cineforge-previz)
- **上游版权**：Copyright 2026 CineForge ([github.com/Work-Fisher](https://github.com/Work-Fisher))
- **本仓库性质**：基于上游源码的非官方衍生版本；工程组织、运行方式和公开文档可能与上游不同。
- **品牌说明**：`CineForge` 和“创剧”仅用于说明源码来源与署名，不代表官方关系、赞助或授权。

完整署名、改动说明和品牌边界见 [NOTICE](NOTICE)。第三方组件与素材的独立条款见 [第三方声明](THIRD_PARTY_NOTICES.md)。

## 它能做什么

| 模块 | 能力 |
| --- | --- |
| 场景搭建 | 添加白模人物、基础几何体、建筑、道路、家具、载具与自然物件 |
| 物体编辑 | 选择、多选、复制、分组、重命名、显隐、颜色和三轴变换 |
| 人物与调度 | 多种身体类型、姿势预设、群众阵列和物体动画 |
| 虚拟相机 | 自由飞行、焦距、画幅、透视视图和构图辅助 |
| 镜头设计 | 预制运镜、相机关键帧、物体关键帧、自动机位点和手持效果 |
| 时间线 | 多段落编排、轨道、播放头、循环播放和段落连播 |
| AI 预演 | 输入 1000-2000 字小说，自动拆场、匹配本地资产、建立场景组和相机关键帧 |
| MCP | 通过本地 stdio MCP 服务提供资产检索、小说规划和计划复核工具 |
| 输出 | JSON 工程、PNG 静帧和 H.264 MP4 视频 |

## 获取与启动

### Windows 运行包

请使用本仓库随后按当前许可证重新发布的运行包。现有历史运行包已从公开下载中撤下，以便先完成许可证和署名更新。

### 从源码运行

准备：

- Godot Engine `4.7.0`
- Windows 10 或 Windows 11 x64
- FFmpeg，仅导出 MP4 时需要
- Python `3.9+`，仅使用 AI 预演或 MCP 时需要

```powershell
git clone https://github.com/Touka404x/cineforge-previz.git
cd cineforge-previz
.\RUN_SOURCE.bat
```

`RUN_SOURCE.bat` 会在已安装的 Godot 4.7 中打开 `source/project.godot`。也可以直接用 Godot 打开该工程并运行主场景。

## 基本工作流

1. 在“布景”模式添加人物、模型或基础几何体，调整位置、旋转、缩放和颜色。
2. 切换到“拍摄”模式，设置构图、焦距、画幅和环境。
3. 为相机和物体记录关键帧，或在镜头库中预览并套用预制运镜。
4. 在时间线中检查段落衔接、动作和节奏。
5. 保存 JSON 工程，导出 PNG 静帧或 MP4 视频。

使用 AI 预演时，点击顶栏“AI 预演”，粘贴 1000-2000 字小说原文。应用先生成并校验计划；确认后才会新建工程，为每个场景创建可见性隔离的场景组、段落和相机关键帧。详细的 Agent、MCP 和图像交叉复核流程见 [MCP 与 Agent 手册](docs/MCP_AGENT_HANDBOOK.md) 与 [小说预演指南](docs/NOVEL_TO_PREVIZ.md)。

常用快捷键：`W/A/S/D` 移动相机，右键拖动转向，`K` 记录相机关键帧，`J` 记录物体关键帧，`Space` 播放或暂停，`Ctrl+S` 保存工程。

## 分享你的预演

本工具是桌面应用，不提供项目上传、网页托管或公开链接功能。完成镜头后，可导出 PNG 或 MP4，再通过你自己的视频平台、网盘或协作工具分享给团队成员。

请注意：分享本工具本身、修改版或其源码时，仍须遵守 `CC BY-NC-SA 4.0` 的署名、非商业和相同方式共享条件。

## 工程与输出

- **工程文件**：JSON，保存场景、段落、关键帧、相机与环境设置。
- **静帧输出**：PNG，不包含编辑器界面。
- **视频输出**：1920x1080 H.264 MP4；导出时由本地 Godot 渲染和 FFmpeg 编码完成。

## 项目结构

```text
source/                 Godot 工程、脚本、模型、缩略图和预览素材
source/agent/           本地小说预演 Agent、stdio MCP 服务器和单元测试
docs/                   架构与数据说明
third_party/            第三方许可证与声明
NOTICE                  上游署名、衍生说明与品牌边界
RUN_SOURCE.bat          源码工程启动入口
RUN_MCP_SERVER.bat      本地 MCP stdio 服务入口
```

代码结构和数据流见 [架构文档](docs/ARCHITECTURE.md)，数据处理方式见 [数据与网络说明](docs/PRIVACY_AND_NETWORK.md)。

## 参与项目

- 使用问题或功能建议请通过 GitHub Issues 提交，详情见 [支持说明](SUPPORT.md)。
- 愿意参与开发时，请阅读 [贡献指南](CONTRIBUTING.md)。
- 安全问题请遵循 [安全策略](SECURITY.md) 私下报告。

## 许可证

本仓库作为上游项目的衍生版本，整体按 [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](LICENSE) 提供：

- 可以非商业地使用、修改和分享。
- 再分发时必须保留 [NOTICE](NOTICE) 中的上游署名，标明改动，并继续使用 CC BY-NC-SA 4.0 或兼容协议。
- 不得将 `CineForge` 或“创剧”品牌用于暗示本项目获得官方认可或背书。
- Godot、FFmpeg、字体和素材等组件适用各自的许可条款，详见 [第三方声明](THIRD_PARTY_NOTICES.md)。
