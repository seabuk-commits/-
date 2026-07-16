---
name: project_noel_youtube_focus
description: 노엘(NotebookLM)은 유튜브 영상 가공 위주로 쓰기로 한 방침 (2026-07-15)
metadata: 
  node_type: memory
  type: project
  originSessionId: 73bfa1c6-6203-4131-844c-30dfdde2485c
---

기술사님이 노엘(NotebookLM)을 앞으로 유튜브 영상 소스 가공 위주로 사용하겠다고 확정함 (2026-07-15).

**Why**: 노엘이 유튜브 영상을 가공하는 데 특히 강점이 있다고 판단함. PDF 등 문서형 자료는
암기노트 제작처럼 서브에이전트(fire-pe-study-coach 등)로 직접 분석하는 경로가 더 적합하다고
본 것으로 보임 — 실제로 같은 세션에서 소방기사 전기 PDF 자료는 노엘을 거치지 않고
fire-pe-study-coach 서브에이전트가 직접 읽어 암기노트를 제작했고, 결과물로 정리된 원본 PDF
소스는 노엘 노트북에서 삭제함(용량 확보).

**How to apply**: `wiki-vault` 프로젝트의 [[노엘]] 서브에이전트(`wiki-vault/.claude/agents/노엘.md`)에
"우선순위: 유튜브 영상 소스" 항목으로 반영함 — inbox-pipeline에서 넘어온 자료가 유튜브 영상이면
노엘에 URL 소스로 등록, 문서(PDF 등)형 자료는 노엘을 거치지 않고 다른 경로(직접 분석/서브에이전트)로
처리하는 것을 기본으로 판단. 또한 "가공 완료된 원자료는 노엘에서 삭제" 정책과 함께 적용 —
노트북 50개 소스 한도([[project_notebooklm_full_roadmap_state]] 참고, 회전형 워크플로 A안 유지 중)
관리에도 도움이 되는 방향.
