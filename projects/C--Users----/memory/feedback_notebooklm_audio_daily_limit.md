---
name: feedback_notebooklm_audio_daily_limit
description: NotebookLM 오디오(팟캐스트) 아티팩트는 하루 3개까지만 생성 가능
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 73bfa1c6-6203-4131-844c-30dfdde2485c
---

NotebookLM(노엘) `studio_create(artifact_type="audio")`는 하루에 최대 3개까지만 생성된다
(2026-07-16 기술사님 확인).

**Why**: 계정/서비스 단의 실제 생성 한도로 보임(에러 없이 그냥 막히거나 실패할 수 있음). 리포트·퀴즈·
플래시카드·마인드맵·슬라이드덱 등 다른 아티팩트 타입에는 이 제한이 적용되지 않는 것으로 보임(사용자가
오디오만 특정해서 언급).

**How to apply**: 여러 노트북에 걸쳐 오디오를 생성해야 할 때는 하루 3개 한도를 넘지 않도록 순서를
계획한다. [[노엘]] 서브에이전트(`wiki-vault/.claude/agents/노엘.md`) 원칙에도 반영해둠. 급하지 않은
오디오 생성은 여러 날에 나눠 진행하고, 리포트/퀴즈 등 비-오디오 아티팩트부터 우선 처리하는 것이 효율적.
