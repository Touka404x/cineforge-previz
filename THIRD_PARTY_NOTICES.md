# 上游与第三方声明

本仓库是 [Work-Fisher/cineforge-previz](https://github.com/Work-Fisher/cineforge-previz) 的非官方衍生版本。上游作品版权归 CineForge 所有；上游来源、署名、衍生关系和品牌边界见根目录 [NOTICE](NOTICE)。

业务源码作为衍生作品按 `CC BY-NC-SA 4.0` 发布，但该许可证不会覆盖随项目使用的引擎、编码器、字体和素材。使用或再分发这些内容前，请阅读各自的条款。

## Godot Engine

- 用途：应用运行时与工程格式。
- 版本：`4.7.0`。
- 许可证：MIT。
- 上游：[godotengine/godot](https://github.com/godotengine/godot)。
- 许可证正文：`third_party/licenses/GODOT-MIT.txt`。

## FFmpeg

- 用途：将本地渲染结果编码为 H.264 MP4。
- 许可证：GPLv3，详见 `third_party/licenses/FFMPEG-GPLv3.txt`。
- 上游：[FFmpeg](https://github.com/FFmpeg/FFmpeg)。
- Windows 运行包使用的构建与对应源码信息见 `third_party/FFMPEG_BUILD_INFO.md`。

再次分发包含 FFmpeg 的运行包时，请自行确认并履行适用的 GPLv3 义务。

## MiSans 字体

- 文件：`source/fonts/MiSans-Regular.ttf`、`source/fonts/MiSans-Demibold.ttf`。
- 官方许可：[MiSans 下载与许可说明](https://hyperos.mi.com/font/en/download/)。
- 许可协议存档：`third_party/licenses/MiSans-License-Agreement.pdf`。

## 模型与图片素材

上游项目将其 3D 模型素材标识为 Kenney 3D Assets，并说明其采用 [CC0 1.0](https://kenney.nl)。本仓库中的模型、缩略图和运镜预览仍可能同时受上游来源、原始素材和其他独立条款约束；提交或再分发前，请确认每项素材的授权范围和署名要求。
