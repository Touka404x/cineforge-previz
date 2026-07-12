"""Read-only access to the Godot model catalog."""

from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, Iterable, List


KEYWORD_CATEGORIES = (
    (("车", "巴士", "卡车", "摩托", "骑"), "vehicle"),
    (("站", "桥", "路", "街", "巷", "追", "驶"), "road"),
    (("屋", "房", "室内", "门", "窗", "家", "店", "楼"), "house"),
    (("城堡", "王座", "骑士", "村", "中世纪"), "medieval"),
    (("桌", "椅", "床", "柜", "厨房", "客厅"), "furniture"),
    (("树", "林", "山", "河", "草", "雨", "野外", "营地"), "nature"),
)


@dataclass(frozen=True)
class AssetCatalog:
    path: Path
    categories: List[Dict[str, Any]]
    models: List[Dict[str, Any]]

    @classmethod
    def from_path(cls, path: str | Path) -> "AssetCatalog":
        resolved = Path(path).resolve()
        data = json.loads(resolved.read_text(encoding="utf-8"))
        if not isinstance(data, dict) or not isinstance(data.get("models"), list):
            raise ValueError("模型目录格式无效: %s" % resolved)
        return cls(resolved, list(data.get("categories", [])), list(data["models"]))

    @property
    def asset_ids(self) -> Iterable[str]:
        return (str(model["id"]) for model in self.models if "id" in model)

    def summary(self) -> Dict[str, Any]:
        return {
            "catalog_path": str(self.path),
            "model_count": len(self.models),
            "categories": [
                {"key": category.get("key"), "label": category.get("cn")}
                for category in self.categories
            ],
        }

    def search(self, query: str = "", category: str = "", limit: int = 20) -> List[Dict[str, Any]]:
        normalized = query.strip().lower()
        terms = [term for term in re.split(r"\s+", normalized) if term]
        ranked = []
        for model in self.models:
            if category and model.get("cat") != category:
                continue
            haystack = " ".join(
                (str(model.get("id", "")), str(model.get("cn", "")), str(model.get("cat", "")))
            ).lower()
            score = 0
            for term in terms:
                if term in haystack:
                    score += 12 + len(term)
                else:
                    score -= 1
            if normalized and score <= 0:
                continue
            ranked.append((score, model))
        ranked.sort(key=lambda item: (-item[0], str(item[1].get("id", ""))))
        return [self._public_asset(model) for _, model in ranked[:max(1, min(limit, 100))]]

    def choose(self, narrative: str, preferred_category: str = "") -> Dict[str, Any] | None:
        category = preferred_category or self.infer_category(narrative)
        matches = self.search(narrative, category, 1)
        if not matches and category:
            matches = self.search("", category, 1)
        if not matches:
            matches = self.search("", "", 1)
        return matches[0] if matches else None

    def candidates_for_prompt(self, narrative: str, limit: int = 40) -> List[Dict[str, Any]]:
        category = self.infer_category(narrative)
        candidates = self.search(narrative, category, limit)
        if len(candidates) < min(limit, 12):
            seen = {asset["id"] for asset in candidates}
            for asset in self.search("", category, limit):
                if asset["id"] not in seen:
                    candidates.append(asset)
                if len(candidates) >= limit:
                    break
        return candidates[:limit]

    @staticmethod
    def infer_category(narrative: str) -> str:
        for words, category in KEYWORD_CATEGORIES:
            if any(word in narrative for word in words):
                return category
        return "building"

    @staticmethod
    def _public_asset(model: Dict[str, Any]) -> Dict[str, Any]:
        return {
            "id": str(model.get("id", "")),
            "label": str(model.get("cn", model.get("id", ""))),
            "category": str(model.get("cat", "")),
            "size": list(model.get("aabb", [])),
        }
