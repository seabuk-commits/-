---
name: reference-free-ai-models
description: "External free LLM APIs the user has connected (Gemini, Groq) and where their keys live locally"
metadata: 
  node_type: memory
  type: reference
  originSessionId: dc3c0993-80f6-4e83-8691-c91895880793
---

User wanted to be able to say "제미나이한테 시켜" / "Groq한테 시켜" etc. and have Claude call another free model, refine the output, and present it.

**Gemini**
- API key stored locally at `C:\Users\박성용\.gemini\api_key`
- Endpoint: `https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key=<key>`
- `gemini-2.0-flash` had free-tier quota stuck at 0 (RESOURCE_EXHAUSTED) even after reissuing the key — likely a project/region-level restriction, not a key problem.
- `gemini-2.5-flash` worked fine on the same key/project. Prefer this model for Gemini calls.

**Groq**
- API key stored locally at `C:\Users\박성용\.groq\api_key`
- OpenAI-compatible endpoint: `https://api.groq.com/openai/v1/chat/completions`, `Authorization: Bearer <key>`
- Verified working model: `llama-3.3-70b-versatile`

**OpenRouter**
- API key stored locally at `C:\Users\박성용\.openrouter\api_key`
- OpenAI-compatible endpoint: `https://openrouter.ai/api/v1/chat/completions`, `Authorization: Bearer <key>`
- Free models need the `:free` suffix (e.g. `openai/gpt-oss-20b:free`, `meta-llama/llama-3.3-70b-instruct:free`). Individual `:free` providers can be transiently rate-limited (429) upstream — retry or switch to another `:free` model rather than assuming the key is broken.

**Ollama (local, fully offline)**
- Installed via `winget install --id Ollama.Ollama`, binary at `C:\Users\박성용\AppData\Local\Programs\Ollama\ollama.exe`
- Pulled model: `llama3.1:8b` (chosen for ~16GB RAM machine)
- Prefer the local REST API over the CLI for programmatic calls — `ollama run` renders an interactive spinner (ANSI codes) that pollutes captured output. Use `POST http://localhost:11434/api/chat` (no key needed) instead.

**Explicitly skipped:** Hugging Face — user asked to not connect it (2026-07-05).

**Trigger word "다른놈"**: user said (2026-07-05) that from now on, saying "다른놈" (as opposed to naming a specific service) means: pick whichever of the 4 connected models best fits the task myself, call it, and don't ask which one to use. Only name a specific service ("제미나이", "Groq", "OpenRouter", "Ollama") when they want to force one in particular.

Selection heuristic when picking for "다른놈" (judgment call, refine as real usage reveals better fits):
- Long input / large document / needs big context window → Gemini 2.5 Flash (1M token context)
- Coding / fast turnaround / general chat → Groq llama-3.3-70b-versatile (fastest inference)
- Groq rate-limited or want a different open model's perspective → OpenRouter (`:free` models, e.g. `openai/gpt-oss-20b:free`)
- Privacy-sensitive content, or no internet / want zero external calls → Ollama llama3.1:8b (fully local)

**Canonical spec supersedes this memory's own text:** `G:\내 드라이브\claude-settings\ai-bridge\다른놈.md` (Google Drive, syncs across the user's work/home computers). An older, narrower version of this same concept already existed there as `antigravity_prompt.md` (written 2026-07-04, for a different tool called Antigravity) — that file's original intent was pure delegation for **token/cost savings**: don't do the work myself, hand it to Gemini/Groq whole, and relay the raw output unchanged, with keys never stored in files (typed fresh each time since the folder syncs to multiple machines). When updating behavior or endpoints going forward, edit `다른놈.md` on Drive, not just this memory file, since that's the file other tools/machines actually read.

**How to apply (reconciled 2026-07-05):** When the user asks to delegate a task to "제미나이", "Groq"/"라마", "OpenRouter", "Ollama"/local model, or "다른놈" (auto-pick), read the relevant key file (Ollama needs no key), call the API via curl/WebFetch. Default to relaying the raw response **unchanged** (the original purpose was saving tokens by not redoing the work) — only lightly touch it up if the raw output is malformed, cut off, or doesn't match what was asked; don't do a full rewrite. Never print key values back into chat. Key files under `C:\Users\박성용\` (`.gemini`, `.groq`, `.openrouter`) are local-only, not synced to Drive — on any other computer (e.g. work PC) those files won't exist, so keys must be requested fresh or read from a permanent env var on that machine, per the original design.

**Mobile access (2026-07-05):** the Claude mobile/web app can't read local files or run shell commands, so a Cloudflare Worker MCP server was built and deployed to expose `call_gemini`/`call_groq`/`call_openrouter` as tools, registered as a Custom Connector on the user's Claude account (works on phone too). Ollama is excluded from this bridge (local-only, not worth tunneling). Full details — deployment URL, token file location, redeploy commands — are in [[다른놈.md]] on Drive under its "폰(Claude 앱)에서 쓰기" section; don't duplicate the token here.
