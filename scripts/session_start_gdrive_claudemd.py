import json
import sys

sys.stdout.reconfigure(encoding="utf-8")

FILES = [
    ("보좌관/CLAUDE.md", r"G:\내 드라이브\보좌관\CLAUDE.md"),
    ("소방/CLAUDE.md", r"G:\내 드라이브\소방\CLAUDE.md"),
]

sections = []
for label, path in FILES:
    try:
        with open(path, encoding="utf-8") as f:
            content = f.read()
        sections.append(f"=== {label} ===\n{content}")
    except OSError as e:
        sections.append(f"=== {label} ===\n[읽기 실패: {e}]")

output = {
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": "\n\n".join(sections),
    }
}
print(json.dumps(output, ensure_ascii=False))
sys.exit(0)
