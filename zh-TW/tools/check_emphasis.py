"""Find bold/italic markers that fail to render in the zh-TW mirror.

CommonMark will not close `**x。**` when a CJK character follows it, so the
asterisks show up as literal text. Render each file with pandoc (gfm), drop
code, and count leftover `**` / `__`. Flag a file only when it has more
leftovers than its English original, so intentional literals are ignored.
"""
import pathlib
import re
import subprocess
import sys

REPO = pathlib.Path(sys.argv[1])
MIRROR = REPO / "zh-TW"
CODE = re.compile(r"<(pre|code)\b.*?</\1>", re.S)
LEFTOVER = re.compile(r"\*\*|__|(?<![\w*])\*(?=\S)[^*\n]+?(?<=\S)\*(?![\w*])")


def leftovers(path: pathlib.Path) -> list[str]:
    html = subprocess.run(
        ["pandoc", "-f", "gfm", "-t", "html", str(path)],
        capture_output=True, text=True, check=True,
    ).stdout
    return LEFTOVER.findall(CODE.sub("", html))


bad = 0
for t in sorted(MIRROR.rglob("*.md")):
    rel = t.relative_to(MIRROR)
    src = REPO / rel
    if not src.exists():
        continue
    a, b = leftovers(src), leftovers(t)
    if len(b) > len(a):
        bad += 1
        print(f"EMPHASIS {t.relative_to(REPO)}: {len(a)} -> {len(b)} unrendered markers")
sys.exit(1 if bad else 0)
