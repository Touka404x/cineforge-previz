"""The small, explicit contract shared by the agent, MCP server, and Godot importer."""

from __future__ import annotations

import re
from typing import Any, Dict, Iterable, List


MIN_NOVEL_CHARS = 1000
MAX_NOVEL_CHARS = 2000
PLAN_VERSION = 1

PRIMITIVES = {"box", "sphere", "cylinder", "panel", "ramp"}
FIGURE_TYPES = {"standard", "female", "child", "large"}
ENVIRONMENTS = {"day", "dusk", "night", "overcast"}
CAMERA_PRESETS = {
    "static_shot", "push", "pull", "rise", "lower", "truck_left", "truck_right",
    "push_rise", "pull_rise", "pan_up", "pan_down", "pan_left", "pan_right",
    "zoom_in", "zoom_out", "dolly_zoom", "orbit90", "orbit180", "orbit_rise",
    "orbit_fall", "orbit_push", "dream_orbit", "bullet_time", "spiral",
    "follow_left", "follow_right", "follow_push", "low_push", "shoulder_push",
    "pov", "handheld", "rise_top", "top_fall", "god_view", "flyover", "low_pass",
    "dive", "hero_intro", "menace", "epic_open", "intimate", "standoff", "reveal",
    "peek", "dutch", "barrel_roll", "chase", "fg_sweep",
}


class PlanError(ValueError):
    """Raised when source input or a generated scene plan is unsafe to apply."""


def compact_length(text: str) -> int:
    """Count visible characters so line wrapping does not affect the input guard."""
    return len(re.sub(r"\s+", "", text))


def ensure_novel_length(text: str) -> int:
    count = compact_length(text)
    if count < MIN_NOVEL_CHARS or count > MAX_NOVEL_CHARS:
        raise PlanError(
            "小说原文需要在 %d 到 %d 个非空白字符之间，当前为 %d。"
            % (MIN_NOVEL_CHARS, MAX_NOVEL_CHARS, count)
        )
    return count


def scene_plan_schema() -> Dict[str, Any]:
    """A portable JSON Schema used in prompts and exposed through MCP."""
    return {
        "type": "object",
        "required": ["version", "source", "scenes"],
        "properties": {
            "version": {"type": "integer", "const": PLAN_VERSION},
            "source": {
                "type": "object",
                "required": ["visible_characters"],
                "properties": {"visible_characters": {"type": "integer"}},
            },
            "scenes": {
                "type": "array",
                "minItems": 2,
                "maxItems": 6,
                "items": {
                    "type": "object",
                    "required": [
                        "id", "title", "source_span", "environment", "camera", "objects"
                    ],
                },
            },
        },
    }


def _number(value: Any) -> bool:
    return isinstance(value, (int, float)) and not isinstance(value, bool)


def _array_of_numbers(value: Any, size: int) -> bool:
    return isinstance(value, list) and len(value) == size and all(_number(item) for item in value)


def validate_plan(
    plan: Dict[str, Any],
    known_asset_ids: Iterable[str],
    source_text: str | None = None,
) -> List[str]:
    """Return every reason a plan must not be imported into the scene.

    This validator intentionally rejects unknown fields only where they affect Godot. The
    model may still attach explanatory metadata without gaining the ability to execute it.
    """
    errors: List[str] = []
    assets = set(known_asset_ids)
    if not isinstance(plan, dict):
        return ["计划根节点必须是对象。"]
    if plan.get("version") != PLAN_VERSION:
        errors.append("计划版本必须为 %d。" % PLAN_VERSION)
    source = plan.get("source")
    if not isinstance(source, dict):
        errors.append("缺少 source 元数据。")
    elif not isinstance(source.get("visible_characters"), int):
        errors.append("source.visible_characters 必须为整数。")
    elif source_text is not None and source["visible_characters"] != compact_length(source_text):
        errors.append("计划与原文的字符计数不一致。")

    scenes = plan.get("scenes")
    if not isinstance(scenes, list) or not 2 <= len(scenes) <= 6:
        return errors + ["scenes 必须包含 2 到 6 个场景。"]

    seen_ids = set()
    previous_end = 0
    for index, scene in enumerate(scenes):
        prefix = "场景 %d" % (index + 1)
        if not isinstance(scene, dict):
            errors.append(prefix + "必须是对象。")
            continue
        scene_id = scene.get("id")
        if not isinstance(scene_id, str) or not scene_id.strip() or scene_id in seen_ids:
            errors.append(prefix + "的 id 缺失或重复。")
        else:
            seen_ids.add(scene_id)
        if not isinstance(scene.get("title"), str) or not scene["title"].strip():
            errors.append(prefix + "缺少标题。")
        span = scene.get("source_span")
        if not isinstance(span, dict) or not isinstance(span.get("start"), int) or not isinstance(span.get("end"), int):
            errors.append(prefix + "缺少有效的 source_span。")
        else:
            start, end = span["start"], span["end"]
            if start != previous_end or end <= start:
                errors.append(prefix + "的原文范围必须连续且非空。")
            if source_text is not None and end > len(source_text):
                errors.append(prefix + "的原文范围超出输入。")
            previous_end = end
        environment = scene.get("environment")
        if environment not in ENVIRONMENTS:
            errors.append(prefix + "使用了未知环境预设。")
        camera = scene.get("camera")
        if not isinstance(camera, dict):
            errors.append(prefix + "缺少相机定义。")
        else:
            if camera.get("preset") not in CAMERA_PRESETS:
                errors.append(prefix + "使用了未知相机预设。")
            duration = camera.get("duration_seconds")
            if not _number(duration) or not 3.0 <= float(duration) <= 20.0:
                errors.append(prefix + "的时长必须为 3 到 20 秒。")
            fov = camera.get("fov")
            if not _number(fov) or not 15.0 <= float(fov) <= 100.0:
                errors.append(prefix + "的焦距参数必须为 15 到 100。")

        objects = scene.get("objects")
        if not isinstance(objects, list) or not 2 <= len(objects) <= 12:
            errors.append(prefix + "必须有 2 到 12 个建模对象。")
            continue
        for object_index, item in enumerate(objects):
            item_prefix = "%s 的对象 %d" % (prefix, object_index + 1)
            if not isinstance(item, dict):
                errors.append(item_prefix + "必须是对象。")
                continue
            kind = item.get("kind")
            if kind not in {"model", "figure", "primitive"}:
                errors.append(item_prefix + "使用了不允许的 kind。")
            if not isinstance(item.get("label"), str) or not item["label"].strip():
                errors.append(item_prefix + "缺少 label。")
            placement = item.get("placement")
            if not isinstance(placement, dict):
                errors.append(item_prefix + "缺少 placement。")
            else:
                for key in ("x", "z", "yaw", "scale"):
                    if not _number(placement.get(key)):
                        errors.append(item_prefix + ".placement.%s 必须为数字。" % key)
                if _number(placement.get("scale")) and not 0.1 <= float(placement["scale"]) <= 8.0:
                    errors.append(item_prefix + "的缩放必须在 0.1 到 8 之间。")
            if kind == "model" and item.get("asset_id") not in assets:
                errors.append(item_prefix + "引用了不在本地目录中的模型。")
            if kind == "primitive" and item.get("primitive") not in PRIMITIVES:
                errors.append(item_prefix + "引用了不允许的基础体。")
            if kind == "figure" and item.get("figure_type", "standard") not in FIGURE_TYPES:
                errors.append(item_prefix + "引用了不允许的人物类型。")

    if source_text is not None and previous_end != len(source_text):
        errors.append("场景原文范围没有覆盖完整输入。")
    return errors
