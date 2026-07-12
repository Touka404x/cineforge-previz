#!/usr/bin/env python3
"""Validate repository completeness, security constraints, and source hygiene."""

from __future__ import annotations

import hashlib
import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "source"

EXPECTED_COUNTS = {
    ".gd": 12,
    ".glb": 385,
    ".png": 445,
}

REQUIRED_FILES = (
    "project.godot",
    "main.tscn",
    "models_index.json",
    "scripts/auth_client.gd",
    "scripts/export_manager.gd",
    "scripts/figure_lib.gd",
    "scripts/fly_camera.gd",
    "scripts/frame_overlay.gd",
    "scripts/main.gd",
    "scripts/novel_agent_runner.gd",
    "scripts/scene_manager.gd",
    "scripts/timeline_panel.gd",
    "scripts/translate_gizmo.gd",
    "scripts/ui_theme.gd",
    "scripts/updater.gd",
)

REQUIRED_LEGAL_FILES = (
    "LICENSE",
    "NOTICE",
    "THIRD_PARTY_NOTICES.md",
)

NETWORK_RULES = {
    "HTTP request node": re.compile(r"\bHTTPRequest\b"),
    "HTTP client": re.compile(r"\bHTTPClient\b"),
    "WebSocket": re.compile(r"\bWebSocketPeer\b"),
    "TCP client": re.compile(r"\bStreamPeerTCP\b"),
    "UDP client": re.compile(r"\bPacketPeerUDP\b"),
    "ENet client": re.compile(r"\bENetMultiplayerPeer\b"),
    "URL literal": re.compile(r"https?://", re.IGNORECASE),
    "device identifier": re.compile(r"OS\.get_unique_id\s*\("),
    "external browser": re.compile(r"OS\.shell_open\s*\("),
    "download target": re.compile(r"\bdownload_file\b"),
    "authorization header": re.compile(r"\bAuthorization\b"),
}

SECRET_RULES = {
    "private key": re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
    "GitHub token": re.compile(r"\bgh[pousr]_[A-Za-z0-9_]{30,}\b"),
    "AWS access key": re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
    "JWT": re.compile(r"\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b"),
}

BANNED_SUFFIXES = {".exe", ".dll", ".msi", ".pck", ".zip", ".7z"}
GENERATED_SUFFIXES = {".gdc", ".ctex", ".scn", ".fontdata"}
TEXT_SUFFIXES = {".gd", ".godot", ".tscn", ".json", ".md", ".txt", ".py", ".yml", ".yaml", ".bat"}


def fail(errors: list[str], message: str) -> None:
    errors.append(message)


def code_without_comments(text: str) -> str:
    return "\n".join(line.split("#", 1)[0] for line in text.splitlines())


def main() -> int:
    errors: list[str] = []

    if not SOURCE.is_dir():
        print(f"ERROR: missing source directory: {SOURCE}", file=sys.stderr)
        return 1

    for relative in REQUIRED_FILES:
        path = SOURCE / relative
        if not path.is_file() or path.stat().st_size == 0:
            fail(errors, f"missing or empty required file: source/{relative}")

    for relative in REQUIRED_LEGAL_FILES:
        path = ROOT / relative
        if not path.is_file() or path.stat().st_size == 0:
            fail(errors, f"missing or empty required legal file: {relative}")

    license_text = (ROOT / "LICENSE").read_text(encoding="utf-8")
    notice_text = (ROOT / "NOTICE").read_text(encoding="utf-8")
    if "Attribution-NonCommercial-ShareAlike 4.0 International" not in license_text:
        fail(errors, "LICENSE must contain CC BY-NC-SA 4.0")
    if "Work-Fisher/cineforge-previz" not in notice_text:
        fail(errors, "NOTICE must retain the upstream source attribution")

    source_files = [path for path in SOURCE.rglob("*") if path.is_file()]
    for suffix, expected in EXPECTED_COUNTS.items():
        actual = sum(path.suffix.lower() == suffix for path in source_files)
        if actual != expected:
            fail(errors, f"unexpected {suffix} count: expected {expected}, found {actual}")

    for path in ROOT.rglob("*"):
        if not path.is_file() or ".git" in path.parts:
            continue
        relative = path.relative_to(ROOT).as_posix()
        suffix = path.suffix.lower()
        if suffix in BANNED_SUFFIXES:
            fail(errors, f"binary/release artifact must not be committed: {relative}")
        if suffix in GENERATED_SUFFIXES or path.name == "project.binary":
            fail(errors, f"generated Godot artifact must not be committed: {relative}")
        if path.stat().st_size > 100 * 1024 * 1024:
            fail(errors, f"file exceeds GitHub's 100 MiB Git limit: {relative}")

    for path in SOURCE.rglob("*"):
        if not path.is_file() or path.suffix.lower() not in TEXT_SUFFIXES:
            continue
        relative = path.relative_to(ROOT).as_posix()
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            fail(errors, f"text file is not valid UTF-8: {relative}")
            continue

        if path.suffix.lower() in {".gd", ".godot", ".tscn"}:
            code = code_without_comments(text)
            for label, pattern in NETWORK_RULES.items():
                if pattern.search(code):
                    fail(errors, f"{label} found in {relative}")

            absolute_path = re.compile(r"(?<![A-Za-z])[A-Za-z]:[\\/]")
            if absolute_path.search(code):
                fail(errors, f"host absolute path found in {relative}")

        for label, pattern in SECRET_RULES.items():
            if pattern.search(text):
                fail(errors, f"possible {label} found in {relative}")

    for path in SOURCE.rglob("*.json"):
        try:
            json.loads(path.read_text(encoding="utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError) as exc:
            fail(errors, f"invalid JSON in {path.relative_to(ROOT).as_posix()}: {exc}")

    updater = (SOURCE / "scripts/updater.gd").read_text(encoding="utf-8")
    auth = (SOURCE / "scripts/auth_client.gd").read_text(encoding="utf-8")
    if 'manifest_url: = ""' not in updater:
        fail(errors, "updater manifest URL must remain empty")
    if 'base_url: = ""' not in auth:
        fail(errors, "account service base URL must remain empty")

    if errors:
        print("Project audit FAILED:", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
        return 1

    digest = hashlib.sha256((SOURCE / "scripts/main.gd").read_bytes()).hexdigest().upper()
    print("Project audit passed")
    print(f"  source files: {len(source_files)}")
    print(f"  GDScript: {EXPECTED_COUNTS['.gd']}")
    print(f"  GLB models: {EXPECTED_COUNTS['.glb']}")
    print(f"  PNG assets: {EXPECTED_COUNTS['.png']}")
    print(f"  main.gd SHA-256: {digest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
