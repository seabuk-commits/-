---
name: ""
metadata: 
  node_type: memory
  originSessionId: b34846af-e807-4d57-ba51-b68a4fdf8713
---

사용자가 "똑똑이"라고 부르면 Gemini 3.5 Flash를 직접 호출한다. Claude.ai 내장 `call_gemini` MCP 도구([[reference_other-model-router]] 참고)는 2.5 Flash로 고정되어 있어 3.5가 필요할 때만 아래 경로를 쓴다.

**방법 0 (폰/PC 무관, MCP 커넥터 — 2026-07-07 추가, 가장 간단)**:
- `other-model-mcp` Cloudflare Workers 커넥터(`https://other-model-mcp.seabuk.workers.dev`)에 `call_gemini35` 툴이 추가됨.
- 이 커넥터가 등록된 기기(폰 포함)라면 MCP 툴 `call_gemini35`를 그냥 호출하면 됨 — 로컬 스크립트/터미널 불필요.
- 소스: `C:\Users\박성용\ai-bridge-mcp\src\index.js` (`callGemini35` 함수, `v1beta/interactions` 엔드포인트 사용). 키는 기존 `GEMINI_API_KEY` Workers Secret 재사용.
- 이 컴퓨터(집컴)에서만 소스 수정/재배포 가능 — 다른 컴퓨터에는 이 레포가 없음.

**방법 1 (터미널 실행 권한이 있을 때)**:
```
python "g:\내 드라이브\소방\.claude\scripts\call_gemini35.py" "질문"
```
- API 키는 환경변수 `GEMINI_API_KEY`에서 읽음 (setx로 등록되어 있음).
- "환경변수 없음" 에러가 나도 **사용자에게 키를 물어보지 말 것** — setx 반영이 늦어서 이미 열려 있던 세션엔 안 보일 수 있음. 새 터미널/새 세션에서 재시도하라고 안내.
- 2026-07-07 기준: 이 세션(Bash/PowerShell 모두)에서 GEMINI_API_KEY가 보이지 않음 확인됨 — 새 세션에서 재시도 필요.

**방법 2 (터미널/스크립트 접근 불가할 때)**: HTTP 직접 호출
- `POST https://generativelanguage.googleapis.com/v1beta/interactions`
- 헤더: `x-goog-api-key: <GEMINI_API_KEY>`, `Content-Type: application/json`
- 바디: `{"model": "gemini-3.5-flash", "input": "<질문>"}`
- 응답: `steps` 배열 중 `type: "model_output"` → `content[0].text`

**둘 다 안 될 때**: "이 세션에서는 똑똑이를 직접 호출할 수 없다"고 솔직히 말할 것. 다른 모델(예: 2.5 Flash)을 대신 "똑똑이"라고 부르며 답하지 않는다 — 원래 세션(소방 프로젝트, VSCode Claude Code)에서 물어보라고 안내.

Why: 3.5 Flash가 2.5보다 최신이라 정확도가 필요할 때 사용자가 명시적으로 이 경로를 원함. 임의 대체 응답은 신뢰를 깨므로 금지됨.
