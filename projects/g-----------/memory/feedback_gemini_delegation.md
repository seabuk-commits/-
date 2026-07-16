---
name: feedback-gemini-delegation
description: Delegate delegable subtasks to the local Gemini CLI first to conserve Claude token usage; keep Gemini usage under ~90% of its quota
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6b88d89f-7d2a-4800-afe6-4764abcb0f08
---

사용자는 특정 작업 하나가 아니라 **전반적인 운영 방침**으로, 제미나이(Gemini CLI, `gemini`
명령)가 대신할 수 있는 일은 먼저 제미나이에게 시켜서 클로드(나)의 토큰 사용을 아끼라고 지시함
(2026-07-06). 단, 제미나이 사용량은 각 모델 티어별로 90% 한도까지만 쓰고 그 이상 밀어붙이지
말 것.

**Why:** 사용자는 VS Code의 "mana.bar" 확장으로 Claude Code와 여러 Gemini CLI 모델 티어(2.5
Flash, 2.5 Flash Lite, 3 Flash Preview, 3.1 Flash Lite, 3.1 Flash Lite Preview)의 사용량을
동시에 모니터링하고 있음. Claude 토큰은 상대적으로 귀하고(5시간/1주 한도 둘 다 존재), Gemini
CLI 쪽은 여러 티어로 나뉘어 있어 여유가 많으므로, 순수 텍스트 생성/조사/요약처럼 굳이 클로드가
직접 안 해도 되는 작업은 제미나이로 돌려서 클로드 쪽 소모를 줄이려는 목적.

**How to apply:**
- 새 하위작업을 맡기 전에 "이게 파일 편집·도구 조작·판단 없이 순수 텍스트 생성/조사/요약/초안
  작성만으로 처리 가능한가"를 먼저 판단. 그렇다면 직접 답하지 말고 Bash로 Gemini CLI에 위임:
  `GEMINI_API_KEY=$(cat ~/.gemini/api_key | tr -d '\n\r') gemini -p "<프롬프트>" -m <model> --skip-trust`
  (모델 예: gemini-2.5-flash, gemini-2.5-flash-lite, gemini-3-flash-preview,
  gemini-3.1-flash-lite, gemini-3.1-flash-lite-preview — 여러 티어에 분산해서 쓰면 좋음)
- 코드/파일 편집, 여러 도구를 오케스트레이션해야 하는 작업, 최종 판단·검증이 필요한 부분은
  계속 클로드(나)가 직접 수행. Gemini 결과는 그대로 신뢰하지 말고 필요하면 검토 후 반영.
- **90% 한도는 내가 실시간으로 조회할 방법이 없음** (mana.bar는 VS Code 확장 UI라 내가 값을
  못 읽음, `gemini` CLI/설정파일에도 사용량 수치가 없음 — 2026-07-06 확인함). 그래서 정확히
  지키기 어렵고, 사용자가 화면에서 특정 티어가 90% 넘게 소진된 걸 보고 알려주면 그 티어 위임을
  멈추는 방식으로만 근사적으로 지킬 수 있음. 이 한계를 사용자에게 이미 고지함.
- Gemini CLI 인증은 원래 `oauth-personal`이었는데 무료 티어 지원 종료로 막혀 있었음. 이 컴퓨터
  (박성용 계정)에서 `~/.gemini/settings.json`의 `selectedType`을 `gemini-api-key`로 바꿔서
  (기존 `~/.gemini/api_key` 파일의 키 사용) 동작하게 만들어둠. 원본은
  `~/.gemini/settings.json.bak`에 백업되어 있음. 다른 컴퓨터에서는 이 설정이 안 되어 있을 수
  있으니 같은 조치가 필요할 수 있음.
