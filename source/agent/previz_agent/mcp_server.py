"""A dependency-free stdio implementation of the focused CineForge MCP server.

The server deliberately exposes only planning and read-only catalog capabilities.  It never
offers shell, generic filesystem, network, or project-writing tools to a model client.
"""

from __future__ import annotations

import json
import os
import sys
from pathlib import Path
from typing import Any, Dict, Optional

from .orchestrator import PrevizAgent
from .schema import PlanError, scene_plan_schema


SERVER_NAME = "cineforge-previz-agent"
SERVER_VERSION = "1.0.0"
PROTOCOL_VERSION = "2025-06-18"
CATALOG_URI = "previz://catalog"


class McpServer:
    def __init__(self, agent: PrevizAgent):
        self.agent = agent

    def handle(self, request: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        request_id = request.get("id")
        method = request.get("method")
        if not isinstance(method, str):
            return self._error(request_id, -32600, "请求缺少 method。")
        if method == "notifications/initialized":
            return None
        try:
            result = self._dispatch(method, request.get("params") or {})
        except (PlanError, ValueError, KeyError) as exc:
            return self._error(request_id, -32602, str(exc))
        except Exception as exc:  # Keep malformed client calls from terminating stdio.
            return self._error(request_id, -32603, "服务器错误: %s" % exc)
        if request_id is None:
            return None
        return {"jsonrpc": "2.0", "id": request_id, "result": result}

    def _dispatch(self, method: str, params: Dict[str, Any]) -> Dict[str, Any]:
        if method == "initialize":
            return {
                "protocolVersion": PROTOCOL_VERSION,
                "capabilities": {"tools": {"listChanged": False}, "resources": {}, "prompts": {}},
                "serverInfo": {"name": SERVER_NAME, "version": SERVER_VERSION},
                "instructions": "只使用预演规划工具；生成计划后由用户在 Godot 中确认导入。",
            }
        if method == "tools/list":
            return {"tools": self._tools()}
        if method == "tools/call":
            return self._call_tool(params)
        if method == "resources/list":
            return {"resources": [{
                "uri": CATALOG_URI,
                "name": "CineForge local asset catalog",
                "description": "Read-only list of locally bundled models.",
                "mimeType": "application/json",
            }]}
        if method == "resources/read":
            if params.get("uri") != CATALOG_URI:
                raise ValueError("未知资源。")
            payload = self.agent.list_assets(limit=100)
            return {"contents": [{
                "uri": CATALOG_URI,
                "mimeType": "application/json",
                "text": json.dumps(payload, ensure_ascii=False),
            }]}
        if method == "prompts/list":
            return {"prompts": [{
                "name": "novel-to-previz",
                "description": "将 1000-2000 字中文小说片段转换为可导入的白模预演计划。",
                "arguments": [{"name": "novel", "description": "1000-2000 字小说原文", "required": True}],
            }]}
        if method == "prompts/get":
            if params.get("name") != "novel-to-previz":
                raise ValueError("未知提示模板。")
            novel = str((params.get("arguments") or {}).get("novel", ""))
            return {"description": "先规划，后在 Godot 确认导入。", "messages": [{
                "role": "user",
                "content": {"type": "text", "text": "请调用 analyze_novel，输入如下原文：\n" + novel},
            }]}
        raise ValueError("不支持的方法: " + method)

    def _tools(self) -> list[Dict[str, Any]]:
        return [
            {
                "name": "list_assets",
                "description": "只读检索本地 CineForge 模型目录，不下载、不修改任何文件。",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "query": {"type": "string"},
                        "category": {"type": "string"},
                        "limit": {"type": "integer", "minimum": 1, "maximum": 100},
                    },
                },
            },
            {
                "name": "analyze_novel",
                "description": "把 1000-2000 字小说原文拆为场景并映射到本地白模资产；只返回计划，不写工程。",
                "inputSchema": {
                    "type": "object",
                    "required": ["text"],
                    "properties": {
                        "text": {"type": "string", "minLength": 1000, "maxLength": 4000},
                        "max_scenes": {"type": "integer", "minimum": 2, "maximum": 6},
                    },
                },
            },
            {
                "name": "validate_scene_plan",
                "description": "对既有计划执行确定性校验，并在显式启用模型时执行文本/图像交叉复核。",
                "inputSchema": {
                    "type": "object",
                    "required": ["plan"],
                    "properties": {
                        "plan": scene_plan_schema(),
                        "text": {"type": "string"},
                        "image_paths": {"type": "array", "items": {"type": "string"}, "maxItems": 6},
                    },
                },
            },
        ]

    def _call_tool(self, params: Dict[str, Any]) -> Dict[str, Any]:
        name = params.get("name")
        arguments = params.get("arguments") or {}
        if name == "list_assets":
            result = self.agent.list_assets(
                str(arguments.get("query", "")),
                str(arguments.get("category", "")),
                int(arguments.get("limit", 20)),
            )
        elif name == "analyze_novel":
            result = self.agent.analyze(
                str(arguments.get("text", "")),
                arguments.get("max_scenes"),
            )
        elif name == "validate_scene_plan":
            plan = arguments.get("plan")
            if not isinstance(plan, dict):
                raise ValueError("plan 必须是 JSON 对象。")
            image_paths = self._approved_image_paths(list(arguments.get("image_paths", [])))
            result = self.agent.verify(
                plan,
                str(arguments["text"]) if "text" in arguments else None,
                image_paths,
            )
        else:
            raise ValueError("未知工具: %s" % name)
        return {"content": [{"type": "text", "text": json.dumps(result, ensure_ascii=False)}]}

    @staticmethod
    def _approved_image_paths(image_paths: list[str]) -> list[str]:
        """Keep MCP clients from turning a verification call into arbitrary file access."""
        if not image_paths:
            return []
        allowed = os.getenv("PREVIZ_ALLOWED_IMAGE_DIR", "").strip()
        if not allowed:
            raise ValueError("MCP 图像复核要求显式设置 PREVIZ_ALLOWED_IMAGE_DIR。")
        allowed_path = Path(allowed).resolve()
        if not allowed_path.is_dir():
            raise ValueError("PREVIZ_ALLOWED_IMAGE_DIR 不是有效目录。")
        approved = []
        for value in image_paths:
            path = Path(value).resolve()
            try:
                path.relative_to(allowed_path)
            except ValueError as exc:
                raise ValueError("图像必须位于 PREVIZ_ALLOWED_IMAGE_DIR 内。") from exc
            if path.suffix.lower() not in {".png", ".jpg", ".jpeg", ".webp"}:
                raise ValueError("图像复核只接受 PNG/JPEG/WebP。")
            approved.append(str(path))
        return approved

    @staticmethod
    def _error(request_id: Any, code: int, message: str) -> Dict[str, Any]:
        return {"jsonrpc": "2.0", "id": request_id, "error": {"code": code, "message": message}}


def serve(agent: PrevizAgent) -> None:
    """Run a newline-delimited JSON-RPC transport on stdin/stdout."""
    server = McpServer(agent)
    for line in sys.stdin:
        if not line.strip():
            continue
        try:
            request = json.loads(line)
            if not isinstance(request, dict):
                raise ValueError("请求必须是 JSON 对象。")
            response = server.handle(request)
        except (json.JSONDecodeError, ValueError) as exc:
            response = McpServer._error(None, -32700, "无效 JSON-RPC: %s" % exc)
        if response is not None:
            sys.stdout.write(json.dumps(response, ensure_ascii=False) + "\n")
            sys.stdout.flush()
