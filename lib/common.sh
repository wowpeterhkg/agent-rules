# shellcheck shell=sh
# Shared helpers. POSIX sh only — teammates may be on Linux/WSL, and macOS ships
# openrsync and BSD userland, so no GNU-only flags anywhere in this file.

AIRULES_LINK_MODE=${AIRULES_LINK_MODE:-link}

log()  { printf '%s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
die()  { printf 'error: %s\n' "$*" >&2; exit 2; }
have() { command -v "$1" >/dev/null 2>&1; }

# abspath <path> — portable; realpath(1) is not universally present.
abspath() {
  _ap_d=$(dirname -- "$1")
  _ap_b=$(basename -- "$1")
  ( CDPATH= cd -- "$_ap_d" 2>/dev/null && printf '%s/%s\n' "$(pwd -P)" "$_ap_b" )
}

state_file() { printf '%s/state.json\n' "$AIRULES_STATE"; }

state_init() {
  mkdir -p "$AIRULES_STATE" || die "cannot create $AIRULES_STATE"
  [ -f "$(state_file)" ] || printf '{"version":null,"repo":null,"mode":"link","owned":[],"behind":0,"last_check":0}\n' > "$(state_file)"
}

# state_get <key> [default]
state_get() {
  [ -f "$(state_file)" ] || { printf '%s\n' "${2:-}"; return 0; }
  AIRULES_K=$1 AIRULES_D=${2:-} python3 - "$(state_file)" <<'PY' 2>/dev/null || printf '%s\n' "${2:-}"
import json, os, sys
try:
    d = json.load(open(sys.argv[1], encoding="utf-8"))
except Exception:
    d = {}
v = d.get(os.environ["AIRULES_K"], os.environ.get("AIRULES_D", ""))
print("" if v is None else v)
PY
}

# state_set <key> <value> [<key> <value> ...]  — values are stored as JSON scalars
state_set() {
  state_init
  AIRULES_KV=$(printf '%s\n' "$@") python3 - "$(state_file)" <<'PY'
import json, os, sys
path = sys.argv[1]
try:
    data = json.load(open(path, encoding="utf-8"))
except Exception:
    data = {}
items = [x for x in os.environ["AIRULES_KV"].split("\n") if x != ""]
for k, v in zip(items[0::2], items[1::2]):
    if v.isdigit():
        data[k] = int(v)
    else:
        data[k] = v
tmp = path + ".tmp"
with open(tmp, "w", encoding="utf-8") as fh:
    json.dump(data, fh, indent=2)
    fh.write("\n")
os.replace(tmp, path)
PY
}

# state_record <kind> <path> — append to the ownership ledger (deduped)
state_record() {
  AIRULES_KIND=$1 AIRULES_PATH=$2 python3 - "$(state_file)" <<'PY'
import json, os, sys
path = sys.argv[1]
try:
    data = json.load(open(path, encoding="utf-8"))
except Exception:
    data = {}
owned = [o for o in data.get("owned", []) if o.get("path") != os.environ["AIRULES_PATH"]]
owned.append({"kind": os.environ["AIRULES_KIND"], "path": os.environ["AIRULES_PATH"]})
data["owned"] = sorted(owned, key=lambda o: o["path"])
tmp = path + ".tmp"
with open(tmp, "w", encoding="utf-8") as fh:
    json.dump(data, fh, indent=2)
    fh.write("\n")
os.replace(tmp, path)
PY
}

state_owned_paths() {
  [ -f "$(state_file)" ] || return 0
  python3 - "$(state_file)" <<'PY' 2>/dev/null || true
import json, sys
try:
    d = json.load(open(sys.argv[1], encoding="utf-8"))
except Exception:
    d = {}
for o in d.get("owned", []):
    print(o.get("path", ""))
PY
}

state_owns() { state_owned_paths | grep -Fxq -- "$1"; }

# backup <path> — snapshot anything we are about to displace. No-op if absent.
backup() {
  [ -e "$1" ] || [ -L "$1" ] || return 0
  mkdir -p "$BACKUP_DIR" || return 1
  _bk_key=$(printf '%s' "${1#"$HOME"/}" | tr '/' '_')
  cp -RP -- "$1" "$BACKUP_DIR/$_bk_key" 2>/dev/null || return 1
  printf '%s\t%s\n' "$1" "$BACKUP_DIR/$_bk_key" >> "$BACKUP_DIR/index.tsv"
}

# link_managed <src-in-repo> <dst-in-home>
# Idempotent. Backs up anything it displaces. Atomic replace. Records ownership.
link_managed() {
  _lm_src=$1
  _lm_dst=$2
  [ -e "$_lm_src" ] || { warn "missing build artifact: $_lm_src"; return 1; }
  _lm_dir=$(dirname -- "$_lm_dst")
  [ -d "$_lm_dir" ] || mkdir -p -- "$_lm_dir" || return 1

  if [ "$AIRULES_LINK_MODE" = copy ]; then
    if [ -f "$_lm_dst" ] && cmp -s -- "$_lm_src" "$_lm_dst"; then
      state_record copy "$_lm_dst"; return 0
    fi
    state_owns "$_lm_dst" || backup "$_lm_dst"
    rm -rf -- "$_lm_dst.airules.$$"
    cp -RP -- "$_lm_src" "$_lm_dst.airules.$$" || return 1
    rm -rf -- "$_lm_dst"
    mv -f -- "$_lm_dst.airules.$$" "$_lm_dst" || return 1
    state_record copy "$_lm_dst"
    return 0
  fi

  if [ -L "$_lm_dst" ]; then
    _lm_cur=$(readlink -- "$_lm_dst")
    case $_lm_cur in
      /*) _lm_abs=$_lm_cur ;;
      *)  _lm_abs=$_lm_dir/$_lm_cur ;;
    esac
    if [ "$(abspath "$_lm_abs")" = "$(abspath "$_lm_src")" ]; then
      state_record link "$_lm_dst"; return 0        # already correct
    fi
    state_owns "$_lm_dst" || backup "$_lm_dst"      # foreign link: preserve first
  elif [ -e "$_lm_dst" ]; then
    backup "$_lm_dst"
  fi

  # ln -sf onto a symlink-to-a-directory creates the link INSIDE it. Link to a
  # temp name and mv over instead.
  rm -rf -- "$_lm_dst.airules.$$"
  ln -s -- "$(abspath "$_lm_src")" "$_lm_dst.airules.$$" || return 1
  rm -rf -- "$_lm_dst"
  mv -f -- "$_lm_dst.airules.$$" "$_lm_dst" || { rm -rf -- "$_lm_dst.airules.$$"; return 1; }
  state_record link "$_lm_dst"
}

# managed_block_insert <file> <payload-file> — idempotent fenced block in a .md file
MB_BEGIN="<!-- >>> airules managed block >>> -->"
MB_END="<!-- <<< airules managed block <<< -->"

managed_block_insert() {
  _mb_file=$1
  _mb_payload=$2
  mkdir -p "$(dirname -- "$_mb_file")"
  AIRULES_B="$MB_BEGIN" AIRULES_E="$MB_END" python3 - "$_mb_file" "$_mb_payload" <<'PY'
import os, sys
target, payload = sys.argv[1], sys.argv[2]
begin, end = os.environ["AIRULES_B"], os.environ["AIRULES_E"]
try:
    text = open(target, encoding="utf-8").read()
except FileNotFoundError:
    text = ""
lines, out, skipping = text.splitlines(True), [], False
for line in lines:
    if line.strip() == begin:
        skipping = True
        continue
    if line.strip() == end:
        skipping = False
        continue
    if not skipping:
        out.append(line)
rest = "".join(out).lstrip("\n")
block = begin + "\n" + open(payload, encoding="utf-8").read().rstrip() + "\n" + end + "\n"
tmp = target + ".tmp"
with open(tmp, "w", encoding="utf-8") as fh:
    fh.write(block + ("\n" + rest if rest.strip() else ""))
os.replace(tmp, target)
PY
}

managed_block_remove() {
  _mb_file=$1
  [ -f "$_mb_file" ] || return 0
  AIRULES_B="$MB_BEGIN" AIRULES_E="$MB_END" python3 - "$_mb_file" <<'PY'
import os, sys
target = sys.argv[1]
begin, end = os.environ["AIRULES_B"], os.environ["AIRULES_E"]
text = open(target, encoding="utf-8").read()
out, skipping = [], False
for line in text.splitlines(True):
    if line.strip() == begin:
        skipping = True
        continue
    if line.strip() == end:
        skipping = False
        continue
    if not skipping:
        out.append(line)
rest = "".join(out).strip()
if not rest:
    os.path.exists(target) and os.unlink(target)
else:
    tmp = target + ".tmp"
    open(tmp, "w", encoding="utf-8").write(rest + "\n")
    os.replace(tmp, target)
PY
}
