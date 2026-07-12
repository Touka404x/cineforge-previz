"""Hermes-inspired orchestration: planner, deterministic policy gate, and independent reviews."""

from __future__ import annotations

from pathlib import Path
from typing import Any, Dict, Optional, Sequence

from .catalog import AssetCatalog
from .heuristic import build_heuristic_plan
from .provider import OpenAICompatibleProvider, ProviderConfig, ProviderError
from .schema import PlanError, ensure_novel_length, validate_plan


class PrevizAgent:
    """Create scene plans without granting the model any filesystem or process tools."""

    def __init__(self, catalog: AssetCatalog, provider_config: Optional[ProviderConfig] = None):
        self.catalog = catalog
        self.provider_config = provider_config or ProviderConfig.from_environment()
        self.provider = (
            OpenAICompatibleProvider(self.provider_config)
            if self.provider_config.enabled
            else None
        )

    @classmethod
    def from_catalog_path(
        cls, catalog_path: str | Path, provider_config: Optional[ProviderConfig] = None
    ) -> "PrevizAgent":
        return cls(AssetCatalog.from_path(catalog_path), provider_config)

    def analyze(self, text: str, max_scenes: Optional[int] = None) -> Dict[str, Any]:
        """Plan a novel excerpt and return a plan plus separated validation reports."""
        ensure_novel_length(text)
        if max_scenes is not None and not 2 <= max_scenes <= 6:
            raise PlanError("max_scenes 必须在 2 到 6 之间。")

        if self.provider:
            plan = self.provider.create_plan(
                text, self.catalog.candidates_for_prompt(text), max_scenes
            )
            planner = "openai-compatible"
        else:
            plan = build_heuristic_plan(text, self.catalog, max_scenes)
            planner = "heuristic"

        deterministic = self._deterministic_review(plan, text)
        if deterministic["approved"]:
            text_review = self._text_review(text, plan)
        else:
            text_review = {
                "status": "skipped",
                "approved": False,
                "issues": ["结构校验未通过，未将不安全计划发送给审阅器。"],
            }
        return {
            "planner": planner,
            "plan": plan,
            "validation": {"deterministic": deterministic, "text": text_review},
        }

    def verify(
        self,
        plan: Dict[str, Any],
        text: Optional[str] = None,
        image_paths: Optional[Sequence[str | Path]] = None,
    ) -> Dict[str, Any]:
        """Cross-check an existing plan with deterministic, textual, and optional visual passes."""
        deterministic = self._deterministic_review(plan, text)
        report: Dict[str, Any] = {"deterministic": deterministic}
        if text and deterministic["approved"]:
            report["text"] = self._text_review(text, plan)
        else:
            report["text"] = {"status": "not_requested", "approved": None, "issues": []}

        image_paths = image_paths or []
        if image_paths and deterministic["approved"]:
            if not self.provider:
                report["vision"] = {
                    "status": "not_configured",
                    "approved": None,
                    "issues": ["图像复核需要显式启用 PREVIZ_LLM_MODE=openai-compatible。"],
                }
            else:
                image_reports = []
                for image_path in image_paths:
                    try:
                        image_reports.append({
                            "path": str(image_path),
                            "result": self.provider.review_image(image_path, plan),
                        })
                    except ProviderError as exc:
                        image_reports.append({
                            "path": str(image_path),
                            "error": str(exc),
                        })
                report["vision"] = {"status": "completed", "images": image_reports}
        else:
            report["vision"] = {"status": "not_requested", "images": []}
        return report

    def list_assets(self, query: str = "", category: str = "", limit: int = 20) -> Dict[str, Any]:
        return {
            "catalog": self.catalog.summary(),
            "assets": self.catalog.search(query, category, limit),
        }

    def _deterministic_review(self, plan: Dict[str, Any], text: Optional[str]) -> Dict[str, Any]:
        errors = validate_plan(plan, self.catalog.asset_ids, text)
        return {"status": "completed", "approved": not errors, "issues": errors}

    def _text_review(self, text: str, plan: Dict[str, Any]) -> Dict[str, Any]:
        if not self.provider:
            return {
                "status": "not_configured",
                "approved": None,
                "issues": ["未配置模型审阅器；已执行确定性校验。"],
            }
        try:
            result = self.provider.review_text(text, plan)
            approved = bool(result.get("approved", False))
            issues = result.get("issues", [])
            if not isinstance(issues, list):
                issues = ["模型审阅结果的 issues 格式无效。"]
                approved = False
            return {"status": "completed", "approved": approved, "issues": issues}
        except ProviderError as exc:
            return {"status": "failed", "approved": None, "issues": [str(exc)]}
