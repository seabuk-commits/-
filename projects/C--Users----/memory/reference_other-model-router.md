---
name: other-model-router
description: "\"다른놈\" 트리거 시 Gemini/Groq/OpenRouter/Ollama 중 상황에 맞게 골라 호출"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 91b7bef1-742e-4da4-84be-fe7f675ed5a2
---

사용자가 "다른놈"이라고 부르면, 되묻지 말고 아래 4개 무료 LLM 중 상황에 맞는 것을 스스로 골라 호출한다.
기본은 원문 그대로 전달(토큰 절약 목적)하고, 형식이 깨졌거나 질문 의도와 안 맞을 때만 최소로 다듬는다.

- **정본 스펙 파일**: `G:\내 드라이브\claude-settings\ai-bridge\다른놈.md` — 규칙이 바뀌면 이 파일이 먼저 갱신되므로, 오래됐다 싶으면 다시 읽을 것.
- **이 컴퓨터(박성용의 PC, 2026-07-05 확인됨)에서 즉시 쓸 수 있는 도구**:
  - Gemini (`gemini-2.5-flash`): MCP 툴 `call_gemini` — 긴 문서/대용량 컨텍스트에 적합. **실시간 웹 검색 기본 켜짐**(google_search 그라운딩, 무료 — 모델이 필요할 때만 알아서 검색)
  - Groq (`compound-beta-mini`, 2026-07-05부터): MCP 툴 `call_groq` — 코딩/빠른 응답에 적합. **실시간 웹 검색 기본 켜짐**(내장 에이전트 툴, 무료). `compound-beta`(mini 아님)는 413/rate-limit 에러 잦아서 쓰지 말 것.
  - OpenRouter (`openai/gpt-oss-20b:free`): MCP 툴 `call_openrouter` — Groq가 막혔거나 다른 오픈소스 모델 관점이 필요할 때. `search: true` 인자로 실시간 검색 가능하지만 **호출당 약 $0.005 과금되는 유료 기능**이라 기본값은 꺼짐 — 검색이 꼭 필요할 때만 명시적으로 켤 것.
  - Ollama (`llama3.1:8b`, 완전 로컬): MCP 툴 없음 — `http://localhost:11434/api/chat`으로 Bash/PowerShell에서 직접 curl 호출. 민감한 내용이거나 오프라인 처리가 필요할 때 사용. 검색 기능 없음(완전 오프라인).
- 사용자가 특정 서비스명(제미나이/Groq/OpenRouter/Ollama)을 콕 집으면 그 모델을 강제로 쓴다.
- 실제 토큰 사용량은 모델 자기보고가 아니라 API 응답의 `usageMetadata`/`usage` 필드 기준으로 확인한다.
- **다른 컴퓨터(회사 PC 등)에서는 위 MCP 툴이 등록 안 되어 있을 수 있다** — 도구 목록에 없으면 로컬 키 파일도 없다는 뜻이므로, 사용자에게 키를 요청하거나 방법을 다시 확인할 것. API 키를 대화창에 노출하지 않는다.

Why: 토큰/비용 절약을 위해 만든 개인용 무료 LLM 라우터. 실제 API 키는 로컬 파일(`~/.gemini`, `~/.groq`, `~/.openrouter`)과 Cloudflare Workers Secrets에 있으며, 이 메모리에는 키 값을 저장하지 않는다.
