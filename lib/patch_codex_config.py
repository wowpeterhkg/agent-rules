#!/usr/bin/env python3
"""Patch ~/.codex/config.toml inside a managed block. Idempotent.

    patch_codex_config.py <config.toml> [install|uninstall]

Only keys inside the managed block are touched; everything else in the file is
preserved byte-for-byte. No TOML library required — the block is line-delimited.
"""

from __future__ import annotations

import os
import sys
import tempfile

BEGIN = "# >>> airules managed block >>>"
END = "# <<< airules managed block <<<"

BLOCK = f"""{BEGIN}
# Codex shares one byte budget across the global AGENTS.md and every project
# AGENTS.md it loads. The default (32768) is tight once projects have their own.
project_doc_max_bytes = 65536
{END}"""


def strip_block(text: str) -> str:
    out, skipping = [], False
    for line in text.splitlines(keepends=True):
        if line.strip() == BEGIN:
            skipping = True
            continue
        if line.strip() == END:
            skipping = False
            continue
        if not skipping:
            out.append(line)
    return "".join(out)


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr)
        return 2
    path = sys.argv[1]
    mode = sys.argv[2] if len(sys.argv) > 2 else "install"

    try:
        with open(path, encoding="utf-8") as fh:
            text = fh.read()
    except FileNotFoundError:
        text = ""
    except UnicodeDecodeError as exc:
        print(f"refusing to touch {path}: not readable as UTF-8 ({exc})", file=sys.stderr)
        return 1

    body = strip_block(text).rstrip()
    if mode == "install":
        # Top-level keys must precede any [table]; put the block first.
        new = BLOCK + ("\n\n" + body if body else "") + "\n"
    else:
        new = (body + "\n") if body else ""

    if not new.strip() and mode != "install":
        if os.path.exists(path):
            os.unlink(path)
        return 0

    directory = os.path.dirname(os.path.abspath(path)) or "."
    os.makedirs(directory, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=directory, prefix=".config.airules.")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as fh:
            fh.write(new)
        os.replace(tmp, path)
    except BaseException:
        if os.path.exists(tmp):
            os.unlink(tmp)
        raise
    return 0


if __name__ == "__main__":
    sys.exit(main())
