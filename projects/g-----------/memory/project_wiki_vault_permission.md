---
name: project-wiki-vault-permission
description: 소방 wiki-vault(raw→wiki 정리) 작업의 권한 레벨과 현재 진행 상황
metadata: 
  node_type: memory
  type: project
  originSessionId: 0c9f5cac-6db4-4500-9885-4126159d47ba
---

`g:\내 드라이브\소방\wiki-vault\` 정리(/정리, raw→wiki 반영) 작업은 **권한 레벨 3(자동 실행 —
가역적 행동만)** 로 진행하기로 사용자가 확정함 (2026-07-05).

**Why:** 이 작업은 로컬 md 노트 생성/수정, log.md·index.md 갱신뿐인 가역적 작업이라 매 파일마다
승인받을 필요가 없다고 사용자가 판단함. 삭제·외부발송 등 공통 안전장치 대상 행동은 이 레벨에서도
항상 별도 확인 필요(전역 CLAUDE.md 0단계 규칙).

**How to apply:** 이후 세션에서 wiki-vault 정리 작업을 이어서 할 때는 이 레벨 질문을 다시 묻지
않고 바로 착수한다. 단, raw-wiki-규칙.md §D의 "모호" 판정 사례(영역 분류 애매)는 이 레벨과
무관하게 항상 사용자에게 후보를 제시하고 선택받아야 한다.

**진행 상황 스냅샷** (자세한 최신 상태는 항상 `wiki-vault/wiki/log.md`와 `index.md`를 직접 읽어
확인할 것 — 이 메모는 참고용 스냅샷이며 시간이 지나면 낡는다):
- 완료: 기사-전기 17개년, 기사-기계 17개년+HWP 12건, 시설관리사 서브노트 4종(점검표편/화재안전기준편/
  점검실무계산편 65%/법령편 전체)
- 남은 작업(2026-07-05 세션 종료 시점 기준): 시설관리사 1차 16개년(교사용 MCQ), 시설관리사 2차 9개년,
  기술사 23개회차, 음성강의 8건(STT 필요 — `.claude/scripts/transcribe.py` 사용, 새 컴퓨터면
  `setup_machine.ps1` 먼저 실행 필요할 수 있음)
- 관련: [[raw-wiki-규칙]] (vault 헌법), 상위 프로젝트 CLAUDE.md의 소방기술사 PDF 파이프라인과는
  완전히 별개 시스템
