"""Offline, deterministic plan generation used as a safe baseline and test oracle."""

from __future__ import annotations

import re
from typing import Any, Dict, List, Sequence, Tuple

from .catalog import AssetCatalog
from .schema import PLAN_VERSION, compact_length, ensure_novel_length


def _scene_spans(text: str, max_scenes: int | None = None) -> List[Tuple[int, int]]:
    visible = compact_length(text)
    desired = max(2, min(6, int(round(visible / 360.0))))
    if max_scenes is not None:
        desired = max(2, min(desired, max_scenes))
    boundaries = [0]
    for match in re.finditer(r"[。！？!?](?:[”’\"']|\s)*|\n{2,}", text):
        boundaries.append(match.end())
    if boundaries[-1] != len(text):
        boundaries.append(len(text))
    spans: List[Tuple[int, int]] = []
    start = 0
    for scene_index in range(1, desired):
        ideal = int(len(text) * scene_index / desired)
        later = [point for point in boundaries if point > start + 30 and point >= ideal]
        earlier = [point for point in boundaries if point > start + 30 and point < ideal]
        if later:
            end = min(later, key=lambda point: point - ideal)
        elif earlier:
            end = max(earlier)
        else:
            end = ideal
        spans.append((start, end))
        start = end
    spans.append((start, len(text)))
    return [(start, end) for start, end in spans if end > start]


def _environment(chunk: str) -> str:
    if any(token in chunk for token in ("深夜", "夜", "月", "黑暗", "凌晨")):
        return "night"
    if any(token in chunk for token in ("黄昏", "傍晚", "落日", "夕阳")):
        return "dusk"
    if any(token in chunk for token in ("雨", "雾", "阴", "雪", "暴风")):
        return "overcast"
    return "day"


def _camera(chunk: str, index: int) -> Dict[str, Any]:
    if any(token in chunk for token in ("追", "奔跑", "冲", "逃", "赶")):
        preset, fov = "chase", 62.0
    elif any(token in chunk for token in ("秘密", "门后", "窥", "怀疑", "不安")):
        preset, fov = "peek", 48.0
    elif any(token in chunk for token in ("对峙", "争", "怒", "威胁")):
        preset, fov = "standoff", 48.0
    elif any(token in chunk for token in ("发现", "露出", "真相", "看见")):
        preset, fov = "reveal", 52.0
    elif any(token in chunk for token in ("说", "问", "回答", "沉默")):
        preset, fov = "intimate", 42.0
    else:
        preset, fov = ("epic_open", 58.0) if index == 0 else ("push", 55.0)
    return {"preset": preset, "fov": fov, "duration_seconds": 7.0}


def _character_names(chunk: str) -> List[str]:
    names: List[str] = []
    pattern = re.compile(r"(?<![\u4e00-\u9fff])([\u4e00-\u9fff]{2,3})(?=(?:握|走|跑|看|站|坐|说|问|答|抬|低|望|听))")
    for match in pattern.finditer(chunk):
        name = match.group(1)
        if name not in names and not any(token in name for token in ("时候", "然后", "他们", "自己", "远处", "这里")):
            names.append(name)
        if len(names) == 2:
            break
    return names or ["主角"]


def _scene_objects(chunk: str, catalog: AssetCatalog, index: int) -> List[Dict[str, Any]]:
    objects: List[Dict[str, Any]] = []
    for name_index, name in enumerate(_character_names(chunk)):
        objects.append({
            "kind": "figure",
            "label": name,
            "figure_type": "female" if any(token in name for token in ("她", "母", "姐")) else "standard",
            "pose": "站立",
            "placement": {"x": -1.2 + name_index * 2.4, "z": 0.0, "yaw": 0.0, "scale": 1.0},
        })
    preferred = catalog.infer_category(chunk)
    model = catalog.choose(chunk, preferred)
    if model:
        objects.append({
            "kind": "model",
            "label": model["label"],
            "asset_id": model["id"],
            "placement": {"x": 1.8, "z": 1.4, "yaw": 0.0, "scale": 2.0},
        })
    if preferred in {"road", "building", "house", "medieval"}:
        objects.append({
            "kind": "primitive",
            "label": "前景遮挡",
            "primitive": "panel",
            "placement": {"x": -2.8, "z": 2.4, "yaw": 18.0, "scale": 1.4},
        })
    else:
        objects.append({
            "kind": "primitive",
            "label": "场景体块",
            "primitive": "box",
            "placement": {"x": 0.0, "z": 2.8, "yaw": 0.0, "scale": 1.8},
        })
    if len(objects) < 2:
        objects.append({
            "kind": "primitive",
            "label": "构图参照",
            "primitive": "box",
            "placement": {"x": 2.0, "z": -1.5, "yaw": 0.0, "scale": 1.0},
        })
    return objects[:12]


def build_heuristic_plan(text: str, catalog: AssetCatalog, max_scenes: int | None = None) -> Dict[str, Any]:
    """Create a valid plan without a remote model or any filesystem side effects."""
    visible = ensure_novel_length(text)
    spans = _scene_spans(text, max_scenes)
    scenes = []
    for index, (start, end) in enumerate(spans):
        chunk = text[start:end]
        excerpt = re.sub(r"\s+", " ", chunk).strip()
        title = "场景%d：%s" % (index + 1, excerpt[:18] or "叙事段落")
        scenes.append({
            "id": "scene-%02d" % (index + 1),
            "title": title,
            "source_span": {"start": start, "end": end},
            "excerpt": excerpt[:160],
            "environment": _environment(chunk),
            "camera": _camera(chunk, index),
            "objects": _scene_objects(chunk, catalog, index),
            "narrative_beat": excerpt[:100],
        })
    return {
        "version": PLAN_VERSION,
        "source": {"visible_characters": visible},
        "scenes": scenes,
        "generator": "heuristic",
    }
