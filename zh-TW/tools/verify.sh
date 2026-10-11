#!/usr/bin/env bash
# Verify the zh-TW mirror against the English originals.
# Run from anywhere: bash zh-TW/tools/verify.sh
set -uo pipefail
# The default C locale makes grep '[—–]' match bytes inside CJK characters.
export LC_ALL=en_US.UTF-8
TOOLS="$(cd "$(dirname "$0")" && pwd)"
cd "$TOOLS/../.." || { echo "cannot cd to repo"; exit 1; }

fail=0
note() { echo "$1"; fail=1; }
fm() { awk 'NR==1&&/^---$/{p=1;print;next} p{print; if(/^---$/) exit}' "$1"; }
originals() { git ls-files '*.md' ':!zh-TW'; }

echo "== originals untouched"
changed=$(git status --porcelain | grep -v '^?? zh-TW/$' | grep -v ' zh-TW/')
[ -z "$changed" ] || note "ORIGINALS CHANGED:
$changed"

echo "== per-file checks"
while IFS= read -r f; do
  # Harness-loaded names are renamed or skipped in the mirror (see guide section 1).
  case "$f" in
    AGENTS.md) continue ;;
    CLAUDE.md) t="zh-TW/CLAUDE.zh-TW.md" ;;
    *) t="zh-TW/$f" ;;
  esac
  [ -f "$t" ] || { note "MISSING $t"; continue; }
  grep -q '[—–]' "$t" && note "DASH $t: $(grep -c '[—–]' "$t") lines"
  a=$(grep -c '^\s*```' "$f"); b=$(grep -c '^\s*```' "$t")
  [ "$a" = "$b" ] || note "FENCE $t: $a vs $b"
  [ "$(fm "$f")" = "$(fm "$t")" ] || note "FRONTMATTER $t"
  grep -q '繁體中文翻譯。原文：' "$t" || note "NO HEADER $t"
  ha=$(grep -c '^#\{1,6\} ' "$f"); hb=$(grep -c '^#\{1,6\} ' "$t")
  [ "$ha" = "$hb" ] || echo "  (info) HEADINGS $t: $ha vs $hb"
  la=$(wc -l < "$f"); lb=$(wc -l < "$t")
  # Translation far shorter than the source suggests dropped content.
  [ "$lb" -ge $(( la * 8 / 10 )) ] || note "SHORT $t: $la -> $lb lines"
done < <(originals)

echo "== extra files in mirror"
while IFS= read -r x; do note "EXTRA $x (original removed or renamed?)"; done < <(
  comm -13 <(originals | sed 's|^|zh-TW/|' | sort) \
           <(find zh-TW -name '*.md' | sort) | grep -vE '^zh-TW/(TRANSLATION-GUIDE|CLAUDE\.zh-TW)\.md$'
)

echo "== no harness-loaded names in mirror"
while IFS= read -r x; do note "HARNESS NAME $x"; done < <(
  find zh-TW \( -name CLAUDE.md -o -name AGENTS.md -o -name .claude -o -path '*/.agents/skills' \)
)

echo "== emphasis renders"
python3 -I "$TOOLS/check_emphasis.py" "$PWD" || fail=1

echo "== relative links resolve"
python3 -I - <<'PY'
import re, sys, pathlib
root = pathlib.Path('zh-TW')
bad = 0
link = re.compile(r'\]\(([^)\s]+)\)')
for p in root.rglob('*.md'):
    text = p.read_text(encoding='utf-8')
    # Skip fenced code blocks: links inside templates are not real links.
    text = re.sub(r'^\s*```.*?^\s*```', '', text, flags=re.S | re.M)
    # Links inside inline code are examples, not links.
    text = re.sub(r'`[^`\n]+`', '', text)
    for m in link.finditer(text):
        href = m.group(1)
        if re.match(r'^[a-z]+:', href) or href.startswith('#') or href.startswith('<'):
            continue
        target = href.split('#')[0]
        if target and not (p.parent / target).exists():
            print(f'BROKEN {p}: {href}')
            bad += 1
sys.exit(1 if bad else 0)
PY
[ $? -eq 0 ] || fail=1

echo "== same-file anchors have a target"
for f in $(grep -rlE '\]\(#' zh-TW --include='*.md'); do
  for a in $(grep -oE '\]\(#[^)]+\)' "$f" | sed -E 's/\]\(#(.*)\)/\1/' | sort -u); do
    grep -q "id=\"$a\"" "$f" || note "ANCHOR $f: #$a"
  done
done

if [ $fail -eq 0 ]; then echo "ALL CHECKS PASSED"; else echo "SOME CHECKS FAILED"; exit 1; fi
