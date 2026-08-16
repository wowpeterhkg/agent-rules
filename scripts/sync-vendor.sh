#!/bin/sh
# Sync book rulesets from the fork into vendor/books/ and rewrite the lockfile.
# One-directional: fork -> vendor. The fork stays clean for upstream pulls.
set -eu

FORK=${FORK:-https://github.com/wowpeter-idnerd/agent-rules-books.git}
UPSTREAM=${UPSTREAM:-https://github.com/ciembor/agent-rules-books.git}
REF=${REF:-main}

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT INT TERM HUP

echo "cloning $FORK@$REF"
git clone -q --depth 1 --branch "$REF" "$FORK" "$TMP/books"
SHA=$(git -C "$TMP/books" rev-parse HEAD)

mkdir -p "$ROOT/vendor/books"
# Released rulesets only: <book-slug>/<book-slug>{,.mini,.nano}.md
find "$TMP/books" -mindepth 2 -maxdepth 2 -name '*.md' \
  ! -path '*/_rule-workbench/*' ! -path '*/docs/*' ! -path '*/.git/*' \
  | while read -r f; do
      rel=${f#"$TMP/books/"}
      mkdir -p "$ROOT/vendor/books/$(dirname -- "$rel")"
      cp -- "$f" "$ROOT/vendor/books/$rel"
    done

cp -- "$TMP/books/LICENSE" "$ROOT/vendor/books/LICENSE" 2>/dev/null || true

python3 - "$ROOT" "$FORK" "$UPSTREAM" "$SHA" <<'PY'
import hashlib, json, pathlib, sys
root, fork, upstream, sha = sys.argv[1:5]
books = pathlib.Path(root) / "vendor" / "books"
files = {
    str(p.relative_to(books)): hashlib.sha256(p.read_bytes()).hexdigest()
    for p in sorted(books.rglob("*")) if p.is_file()
}
(pathlib.Path(root) / "vendor" / "books.lock.json").write_text(
    json.dumps({"fork": fork, "upstream": upstream, "commit": sha, "files": files},
               indent=2, sort_keys=True) + "\n", encoding="utf-8")
print(f"vendored {len(files)} files at {sha[:12]}")
PY
