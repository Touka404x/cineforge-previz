"""Command line entry point used by Godot, tests, and MCP clients."""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Sequence

from .mcp_server import serve
from .orchestrator import PrevizAgent
from .schema import PlanError


def _configure_stdio() -> None:
    """MCP is UTF-8 JSON-RPC even when the parent Windows console is legacy encoded."""
    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, "reconfigure"):
            stream.reconfigure(encoding="utf-8")


def _default_catalog() -> Path:
    return Path(os.getenv("PREVIZ_ASSET_CATALOG", Path(__file__).parents[2] / "models_index.json"))


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="CineForge 本地小说预演 Agent")
    subparsers = parser.add_subparsers(dest="command", required=True)

    plan = subparsers.add_parser("plan", help="生成场景计划")
    plan.add_argument("--input", required=True, help="UTF-8 小说文本文件")
    plan.add_argument("--output", required=True, help="结果 JSON 文件")
    plan.add_argument("--catalog", default=str(_default_catalog()))
    plan.add_argument("--max-scenes", type=int, default=None)

    verify = subparsers.add_parser("verify", help="交叉验证现有计划")
    verify.add_argument("--plan", required=True)
    verify.add_argument("--text", default="")
    verify.add_argument("--image", action="append", default=[])
    verify.add_argument("--catalog", default=str(_default_catalog()))

    catalog = subparsers.add_parser("catalog", help="搜索模型目录")
    catalog.add_argument("--query", default="")
    catalog.add_argument("--category", default="")
    catalog.add_argument("--limit", type=int, default=20)
    catalog.add_argument("--catalog", default=str(_default_catalog()))

    mcp = subparsers.add_parser("mcp", help="启动 stdio MCP 服务")
    mcp.add_argument("--catalog", default=str(_default_catalog()))
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    _configure_stdio()
    args = _parser().parse_args(argv)
    try:
        agent = PrevizAgent.from_catalog_path(args.catalog)
        if args.command == "plan":
            text = Path(args.input).read_text(encoding="utf-8")
            result = agent.analyze(text, args.max_scenes)
            output = Path(args.output)
            output.parent.mkdir(parents=True, exist_ok=True)
            output.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
            print("已生成 %d 个场景: %s" % (len(result["plan"]["scenes"]), output))
            return 0
        if args.command == "verify":
            plan = json.loads(Path(args.plan).read_text(encoding="utf-8"))
            if isinstance(plan, dict) and isinstance(plan.get("plan"), dict):
                plan = plan["plan"]
            text = Path(args.text).read_text(encoding="utf-8") if args.text else None
            print(json.dumps(agent.verify(plan, text, args.image), ensure_ascii=False, indent=2))
            return 0
        if args.command == "catalog":
            print(json.dumps(agent.list_assets(args.query, args.category, args.limit), ensure_ascii=False, indent=2))
            return 0
        if args.command == "mcp":
            serve(agent)
            return 0
    except (OSError, json.JSONDecodeError, PlanError, ValueError) as exc:
        print("错误: %s" % exc, file=sys.stderr)
        return 2
    return 2
