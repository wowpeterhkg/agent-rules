#!/usr/bin/env python3
"""Merge airules SessionStart hooks into a Claude Code settings.json.

Idempotent. Never overwrites unrelated keys. Refuses to touch a file it cannot parse.

    merge_settings.py <settings.json> <absolute-airules-path> [install|uninstall]

The hook command MUST be an absolute path: desktop and IDE surfaces launched from the
Dock or Finder do not inherit the shell PATH, so `airules` alone would not resolve.
"""

from __future__ import annotations

import json
import os
import shutil
import sys
import tempfile

MARK = "hook-session-start"  # ownership marker; only entries containing it are ours
EVENTS = ("startup", "resume", "clear", "compact")


def drop_ours(entries):
    out = []
    for entry in entries or []:
        if not isinstance(entry, dict):
            out.append(entry)
            continue
        inner = [h for h in entry.get("hooks", []) if MARK not in str((h or {}).get("command", ""))]
        if inner:
            entry = dict(entry)
            entry["hooks"] = inner
            out.append(entry)
        elif not entry.get("hooks"):
            out.append(entry)
    return out


def main() -> int:
    if len(sys.argv) < 3:
        print(__doc__, file=sys.stderr)
        return 2
    path, binpath = sys.argv[1], sys.argv[2]
    mode = sys.argv[3] if len(sys.argv) > 3 else "install"

    if mode == "install" and not os.path.isabs(binpath):
        print(f"refusing: hook command must be absolute, got {binpath!r}", file=sys.stderr)
        return 2

    try:
        with open(path, encoding="utf-8") as fh:
            data = json.load(fh)
    except FileNotFoundError:
        data = {}
    except (json.JSONDecodeError, UnicodeDecodeError) as exc:
        print(f"refusing to touch {path}: not valid JSON ({exc})", file=sys.stderr)
        return 1
    if not isinstance(data, dict):
        print(f"refusing to touch {path}: top level is not an object", file=sys.stderr)
        return 1

    hooks = data.get("hooks", {})
    if not isinstance(hooks, dict):
        print(f"refusing to touch {path}: .hooks is not an object", file=sys.stderr)
        return 1

    entries = drop_ours(hooks.get("SessionStart", []))
    if mode == "install":
        for event in EVENTS:
            entries.append(
                {
                    "matcher": event,
                    "hooks": [
                        {
                            "type": "command",
                            "command": f"{binpath} hook-session-start --event {event}",
                            "timeout": 5,
                        }
                    ],
                }
            )

    if entries:
        hooks["SessionStart"] = entries
    else:
        hooks.pop("SessionStart", None)
    if hooks:
        data["hooks"] = hooks
    else:
        data.pop("hooks", None)

    directory = os.path.dirname(os.path.abspath(path)) or "."
    os.makedirs(directory, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=directory, prefix=".settings.airules.")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as fh:
            json.dump(data, fh, indent=2, ensure_ascii=False)
            fh.write("\n")
        if os.path.exists(path):
            shutil.copymode(path, tmp)
        os.replace(tmp, path)
    except BaseException:
        if os.path.exists(tmp):
            os.unlink(tmp)
        raise
    return 0


if __name__ == "__main__":
    sys.exit(main())
