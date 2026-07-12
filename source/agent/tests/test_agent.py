from __future__ import annotations

import json
import os
import sys
import unittest
from pathlib import Path
from unittest.mock import patch

AGENT_ROOT = Path(__file__).resolve().parents[1]
if str(AGENT_ROOT) not in sys.path:
    sys.path.insert(0, str(AGENT_ROOT))

from previz_agent.mcp_server import McpServer
from previz_agent.orchestrator import PrevizAgent
from previz_agent.schema import PlanError


ROOT = Path(__file__).resolve().parents[3]
CATALOG = ROOT / "source" / "models_index.json"
SAMPLE = ("夜色压在旧街上，林舟握着湿透的信封，沿着积水的路面快步向前。远处的巴士站空无一人，霓虹灯在雨幕里忽明忽暗。" * 20)[:1200]


class PrevizAgentTests(unittest.TestCase):
    def setUp(self) -> None:
        self.agent = PrevizAgent.from_catalog_path(CATALOG)

    def test_heuristic_plan_is_valid_and_covers_input(self) -> None:
        result = self.agent.analyze(SAMPLE)
        plan = result["plan"]
        self.assertTrue(result["validation"]["deterministic"]["approved"])
        self.assertEqual(plan["scenes"][0]["source_span"]["start"], 0)
        self.assertEqual(plan["scenes"][-1]["source_span"]["end"], len(SAMPLE))
        self.assertTrue(all(item["kind"] in {"model", "figure", "primitive"}
                            for scene in plan["scenes"] for item in scene["objects"]))

    def test_rejects_input_outside_requested_length(self) -> None:
        with self.assertRaises(PlanError):
            self.agent.analyze("太短" * 50)

    def test_unknown_model_cannot_pass_policy_gate(self) -> None:
        plan = self.agent.analyze(SAMPLE)["plan"]
        for item in plan["scenes"][0]["objects"]:
            if item["kind"] == "model":
                item["asset_id"] = "not/a/local-model"
                break
        result = self.agent.verify(plan, SAMPLE)
        self.assertFalse(result["deterministic"]["approved"])
        self.assertTrue(any("本地目录" in issue for issue in result["deterministic"]["issues"]))

    def test_mcp_exposes_read_only_catalog_and_plan_tool(self) -> None:
        server = McpServer(self.agent)
        listing = server.handle({"jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": {}})
        names = {tool["name"] for tool in listing["result"]["tools"]}
        self.assertEqual(names, {"list_assets", "analyze_novel", "validate_scene_plan"})
        response = server.handle({
            "jsonrpc": "2.0", "id": 2, "method": "tools/call",
            "params": {"name": "analyze_novel", "arguments": {"text": SAMPLE}},
        })
        content = response["result"]["content"][0]["text"]
        self.assertTrue(json.loads(content)["validation"]["deterministic"]["approved"])

    def test_mcp_requires_explicit_image_directory_for_visual_review(self) -> None:
        server = McpServer(self.agent)
        plan = self.agent.analyze(SAMPLE)["plan"]
        with patch.dict(os.environ, {"PREVIZ_ALLOWED_IMAGE_DIR": ""}):
            response = server.handle({
                "jsonrpc": "2.0", "id": 4, "method": "tools/call",
                "params": {"name": "validate_scene_plan", "arguments": {
                    "plan": plan, "image_paths": ["preview.png"],
                }},
            })
        self.assertEqual(response["error"]["code"], -32602)


if __name__ == "__main__":
    unittest.main()
