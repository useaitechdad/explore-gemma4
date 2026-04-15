# Gemma 4 Demo App — Test Artefacts

Source code, prompts, and outputs accompanying two YouTube videos.

## Videos

| Video | Link |
|-------|------|
| **Gemma 4: 8 Real-World Tests** — the demo app, prompts, and model outputs | https://youtu.be/WcdFG1Onj5U |
| **LLM Wiki** — a living, agent-maintained wiki for any codebase (uses this repo as the demo) | https://youtu.be/J3szwLZ6YfI |

The `.agents/` directory contains the portable **LLM Wiki** package (skills, workflows, rules) that any Antigravity user can drop into their own repo. The `wiki/` directory is the generated output. See [`.agents/README.md`](.agents/README.md) for details.

---

## What's in this folder

```
demo-app/
├── index.html          # The demo app (single HTML file, no build step)
├── start.command       # macOS double-click launcher
├── README.md           # This file
├── PROMPTS.md          # All 8 test prompts, copy-paste ready
└── outputs/            # Model responses for each test
    ├── response_test6_multifile.txt
    ├── response_test7_reasoning.txt          # Gemma 31B, thinking OFF
    ├── response_test7_reasoning_gemmathinking.txt  # Gemma 31B, thinking ON
    ├── response_test7_reasoning_gemini.txt   # Gemini 3.1 Pro
    ├── response_test8_json_26b.txt
    └── response_test8_json_31b.txt
```

> Tests 1–5 outputs are shown as screenshots/images in the video. Tests 6–8 full responses are in `outputs/`.

---

## Running the Demo App

**Requirements:** A Google AI Studio API key (free at [aistudio.google.com](https://aistudio.google.com))

**API Key setup:**
```bash
cp env.txt.example env.txt
# Edit env.txt and replace "your_api_key_here" with your actual key
```
The app reads `env.txt` at startup and pre-fills the API key field. Alternatively, paste your key directly into the key field in the UI. `env.txt` is gitignored so your key is never committed.

**macOS:**
```bash
# Option 1: Double-click start.command
# Option 2: Terminal
cd demo-app
npx serve . -p 4000
# Open http://localhost:4000
```

**Windows / Linux:**
```bash
cd demo-app
npx serve . -p 4000
# Open http://localhost:4000
```

Enter your API key in the top-right field. Select a model, mode (Text or Image), and optionally enable Thinking Mode.

---

## Models Tested

| Model ID | Type | Notes |
|---|---|---|
| `gemma-4-31b-it` | Dense | All params active per token |
| `gemma-4-26b-a4b-it` | MoE | Only 3.8B active per token |
| `gemini-3.1-pro-preview` | Proprietary | Used for Test 7 comparison |
| `gemini-3-flash-preview` | Proprietary | Used for hook comparison |

---

## Test Results Summary

| Test | Description | Result |
|---|---|---|
| 1 | JSON Extraction | ✅ Both models — clean, correct |
| 2 | Single Function Coding | ✅ Both models — working code first try |
| 3 | Simple Reasoning | ✅ Correct step-by-step |
| 4 | OCR & Chart Reading | ✅ Surprise pass — all 72 data points correct |
| 5 | Image Q&A (Architecture) | ✅ Surprise pass — identified SPOF unprompted |
| 6 | Multi-File Code Generation | ⚠️ Passed with caveats — see notes below |
| 7 | Deep Reasoning (Logic Puzzle) | ✅ Surprise pass — found both valid solutions |
| 8 | Complex Nested JSON | ✅ 100% correct, both models |

### Tests we expected to fail — but didn't

Tests 4, 5, 7, and 8 were designed expecting Gemma to struggle. It didn't. The video tells the honest story — results updated in real time as we ran each test.

**Test 6 caveats** (passed, but with code quality issues):
- Pydantic V1/V2 mixed syntax (`class Config` vs `ConfigDict`)
- Deprecated FastAPI `@app.on_event("startup")` handler
- Simplified auth — username used directly as Bearer token
- These are real-world issues but not correctness failures

---

## Prompts

See [PROMPTS.md](PROMPTS.md) for all 8 prompts, copy-paste ready.
