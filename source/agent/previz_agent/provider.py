"""Optional OpenAI-compatible provider. It is dormant until explicitly enabled."""

from __future__ import annotations

import base64
import json
import os
import re
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List

from .prompts import plan_messages, text_review_messages, vision_review_prompt


class ProviderError(RuntimeError):
    pass


@dataclass(frozen=True)
class ProviderConfig:
    mode: str = "heuristic"
    base_url: str = ""
    model: str = ""
    api_key: str = ""
    timeout_seconds: int = 75

    @classmethod
    def from_environment(cls) -> "ProviderConfig":
        return cls(
            mode=os.getenv("PREVIZ_LLM_MODE", "heuristic").strip().lower(),
            base_url=os.getenv("PREVIZ_LLM_BASE_URL", "").strip(),
            model=os.getenv("PREVIZ_LLM_MODEL", "").strip(),
            api_key=os.getenv("PREVIZ_LLM_API_KEY", "").strip(),
            timeout_seconds=int(os.getenv("PREVIZ_LLM_TIMEOUT", "75")),
        )

    @property
    def enabled(self) -> bool:
        return self.mode == "openai-compatible"


class OpenAICompatibleProvider:
    """Small HTTP adapter that works with local or hosted Chat Completions endpoints."""

    def __init__(self, config: ProviderConfig):
        if not config.enabled:
            raise ProviderError("远程模型未启用。")
        if not config.base_url or not config.model:
            raise ProviderError("PREVIZ_LLM_BASE_URL 和 PREVIZ_LLM_MODEL 必须同时设置。")
        self.config = config

    def create_plan(self, text: str, assets: List[Dict[str, Any]], max_scenes: int | None) -> Dict[str, Any]:
        return self._chat_json(plan_messages(text, assets, max_scenes))

    def review_text(self, text: str, plan: Dict[str, Any]) -> Dict[str, Any]:
        return self._chat_json(text_review_messages(text, plan))

    def review_image(self, image_path: str | Path, plan: Dict[str, Any]) -> Dict[str, Any]:
        path = Path(image_path)
        suffix = path.suffix.lower()
        mime = {".png": "image/png", ".jpg": "image/jpeg", ".jpeg": "image/jpeg", ".webp": "image/webp"}.get(suffix)
        if not mime or not path.is_file():
            raise ProviderError("图像复核仅接受存在的 PNG/JPEG/WebP 文件。")
        encoded = base64.b64encode(path.read_bytes()).decode("ascii")
        messages = [
            {"role": "system", "content": "你是白模预演图像审阅员，只输出 JSON。"},
            {"role": "user", "content": [
                {"type": "text", "text": vision_review_prompt(plan)},
                {"type": "image_url", "image_url": {"url": "data:%s;base64,%s" % (mime, encoded)}},
            ]},
        ]
        return self._chat_json(messages)

    def _chat_json(self, messages: List[Dict[str, Any]]) -> Dict[str, Any]:
        payload = {
            "model": self.config.model,
            "messages": messages,
            "temperature": 0.2,
            "response_format": {"type": "json_object"},
        }
        data = self._request(payload)
        try:
            content = data["choices"][0]["message"]["content"]
        except (KeyError, IndexError, TypeError) as exc:
            raise ProviderError("模型响应缺少 choices[0].message.content。") from exc
        if not isinstance(content, str):
            raise ProviderError("模型响应不是文本 JSON。")
        return _extract_json(content)

    def _request(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        url = self.config.base_url.rstrip("/") + "/chat/completions"
        headers = {"Content-Type": "application/json"}
        if self.config.api_key:
            headers["Authorization"] = "Bearer " + self.config.api_key
        request = urllib.request.Request(
            url,
            data=json.dumps(payload, ensure_ascii=False).encode("utf-8"),
            headers=headers,
            method="POST",
        )
        try:
            with urllib.request.urlopen(request, timeout=self.config.timeout_seconds) as response:
                return json.loads(response.read().decode("utf-8"))
        except (urllib.error.URLError, urllib.error.HTTPError, json.JSONDecodeError) as exc:
            raise ProviderError("模型端点调用失败: %s" % exc) from exc


def _extract_json(content: str) -> Dict[str, Any]:
    fenced = re.search(r"```(?:json)?\s*(\{.*\})\s*```", content, re.DOTALL)
    candidate = fenced.group(1) if fenced else content.strip()
    try:
        result = json.loads(candidate)
    except json.JSONDecodeError as exc:
        raise ProviderError("模型没有返回有效 JSON。") from exc
    if not isinstance(result, dict):
        raise ProviderError("模型 JSON 根节点必须是对象。")
    return result
