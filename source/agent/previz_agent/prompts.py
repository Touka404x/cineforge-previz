"""Prompts kept separate from transport and application code for auditability."""

from __future__ import annotations

import json
from typing import Any, Dict, List

from .schema import scene_plan_schema


SYSTEM_PROMPT = """你是影视预演规划 Agent。你只输出 JSON，不写 Markdown。
把小说原文拆为 2-6 个连续场景；每个场景必须引用给定资产目录中的模型 id，或使用允许的基础体/人物。
不能编造 asset_id，不能输出代码、命令、文件路径、网络地址或执行指令。场景的 source_span 必须从 0 连续覆盖到原文末尾。
输出会被严格校验，校验失败将被拒绝导入。"""


def plan_messages(text: str, assets: List[Dict[str, Any]], max_scenes: int | None) -> List[Dict[str, str]]:
    instruction = {
        "task": "将下列小说原文转为 CineForge 白模预演计划。",
        "max_scenes": max_scenes or 6,
        "schema": scene_plan_schema(),
        "allowed_models": assets,
        "novel": text,
    }
    return [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": json.dumps(instruction, ensure_ascii=False)},
    ]


def text_review_messages(text: str, plan: Dict[str, Any]) -> List[Dict[str, str]]:
    payload = {
        "task": "审阅场景计划是否覆盖原文、是否把关键人物/动作/空间关系遗漏。只返回 JSON。",
        "result_schema": {"approved": "boolean", "issues": "string[]"},
        "novel": text,
        "plan": plan,
    }
    return [
        {"role": "system", "content": "你是严格的影视预演审阅员，只输出 JSON。"},
        {"role": "user", "content": json.dumps(payload, ensure_ascii=False)},
    ]


def vision_review_prompt(plan: Dict[str, Any]) -> str:
    return json.dumps({
        "task": "检查这张白模预览图是否与场景计划相符。只指出可观察到的缺失、遮挡、构图或物体错误。",
        "result_schema": {"approved": "boolean", "issues": "string[]"},
        "plan": plan,
    }, ensure_ascii=False)
