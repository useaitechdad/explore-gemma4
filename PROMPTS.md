# Test Prompts — Gemma 4 Demo

All 8 prompts used in the video, copy-paste ready. Run them in the demo app or directly in [Google AI Studio](https://aistudio.google.com).

---

## Test 1 — JSON Extraction
**Model:** Gemma 4 31B & 26B A4B | **Mode:** Text | **Thinking:** Off

```
Extract the following product information into a clean JSON object with these exact fields: name, price, currency, sku, in_stock, category, rating, review_count.

Product listing:
"The AeroGrip Pro X — $149.99. SKU: AGP-2024-BLK. Currently in stock. Category: Sports Equipment. Rated 4.7 out of 5 based on 1,284 customer reviews."
```

**Result:** Both models — clean, correct output, no hallucinations.

---

## Test 2 — Single Function Coding
**Model:** Gemma 4 31B & 26B A4B | **Mode:** Text | **Thinking:** Off

```
Write a Python function called validate_email that takes a single string argument and returns True if it is a valid email address, False otherwise. Use regex. Include a docstring and 3 example assertions at the bottom.
```

**Result:** Both models produced working code on the first try. Identical timing (~23s), MoE generated 30% more tokens.

---

## Test 3 — Simple Reasoning
**Model:** Gemma 4 31B | **Mode:** Text | **Thinking:** Off

```
Here are 3 facts:
1. Alice is taller than Bob.
2. Bob is taller than Carol.
3. Carol is taller than David.

Answer these questions step by step:
- Who is the tallest?
- Who is the shortest?
- Is Alice taller than David?
- How many people is Bob taller than?
```

**Result:** Correct step-by-step in 13.3s, 398 tokens.

---

## Test 4 — OCR & Chart Reading
**Model:** Gemma 4 31B | **Mode:** Image | **Thinking:** Off

Upload a screenshot of the benchmark comparison table, then send:

```
This is a benchmark comparison table. Please:
1. Identify what is being measured
2. List every model and their scores
3. Which model ranks highest overall?
4. What is the exact score for Gemma 4 31B on GPQA Diamond?
```

**Result:** Surprise pass — all 72 data points extracted correctly, zero mistakes.

---

## Test 5 — Image Q&A / Architecture Review
**Model:** Gemma 4 31B | **Mode:** Image | **Thinking:** Off

Upload `cloudflare-ai-composable.png` (Cloudflare's Composable AI Architecture diagram), then send:

```
Analyze this system architecture diagram:
1. Describe what each numbered component does
2. Explain why each layer has multiple provider options
3. What is the benefit of this "composable" approach?
4. What is the main risk or dependency in this architecture?
```

**Result:** Surprise pass — identified all 4 layers correctly, flagged Compute Provider as SPOF unprompted, noted multi-hop latency as secondary risk.

---

## Test 6 — Multi-File Architecture
**Model:** Gemma 4 31B | **Mode:** Text | **Thinking:** Off

```
Build a full-stack to-do application. Generate all files:

Backend (FastAPI, Python):
- main.py: POST /auth/login, POST /tasks, GET /tasks, PUT /tasks/{id}, DELETE /tasks/{id}
- models.py: SQLAlchemy models for User and Task
- schemas.py: Pydantic schemas matching the API shapes

Frontend (React, TypeScript):
- api.ts: typed API client matching the above endpoints exactly
- TaskList.tsx: fetches and displays tasks
- LoginForm.tsx: calls /auth/login

All TypeScript types in api.ts must exactly match the Pydantic schemas in schemas.py.
```

**Result:** Passed with caveats. All 6 files generated, TypeScript types matched Pydantic schemas exactly. Issues: Pydantic V1/V2 mixed syntax, deprecated FastAPI startup handler, simplified auth. Full response in `outputs/response_test6_multifile.txt`.

---

## Test 7 — Deep Reasoning (10-Step Logic Puzzle)
**Model:** Gemma 4 31B (thinking OFF), Gemma 4 31B (thinking ON), Gemini 3.1 Pro | **Mode:** Text

```
There are 5 people: Amir, Beatrix, Carlos, Diana, and Ethan.
Each person has a unique job: Doctor, Engineer, Lawyer, Teacher, Chef.
Each person owns a unique pet: Cat, Dog, Fish, Bird, Rabbit.
Each person lives on a different floor: 1, 2, 3, 4, 5.

Constraints:
1. Amir lives on floor 1.
2. The Doctor lives on floor 5.
3. Beatrix is not the Doctor.
4. Carlos owned the Dog.
5. The person on floor 3 owned the Fish.
6. The Lawyer lives directly above the Teacher.
7. Diana lives on floor 4.
8. The Engineer owned the Cat.
9. Ethan is the Chef.
10. The person who owned the Bird lives on floor 2.

Determine the floor, job, and pet for each person. Show your full reasoning step by step.
```

**Note:** This puzzle has two valid solutions — the constraints don't fully determine a unique answer. All three models found this and presented both.

**Results:**
| Model | Time | Tokens | Result |
|---|---|---|---|
| Gemma 4 31B (no thinking) | 203.8s | 5,901 | Pass — found both valid solutions |
| Gemma 4 31B (thinking) | 234.1s | 6,313 | Pass — found both valid solutions |
| Gemini 3.1 Pro | 96.5s | 1,002 | Pass — found both valid solutions |

Full responses in `outputs/`:
- `response_test7_reasoning.txt` — Gemma 31B, thinking OFF
- `response_test7_reasoning_gemmathinking.txt` — Gemma 31B, thinking ON
- `response_test7_reasoning_gemini.txt` — Gemini 3.1 Pro

---

## Test 8 — Complex Nested JSON
**Model:** Gemma 4 26B A4B & 31B | **Mode:** Text | **Thinking:** Off

```
Extract all information from the following patient record into a strictly valid JSON object matching this schema exactly. Do not add or remove any fields.

Schema:
{
  "patient": {
    "id": "string",
    "personal": {
      "first_name": "string",
      "last_name": "string",
      "dob": "YYYY-MM-DD",
      "gender": "string"
    },
    "contact": {
      "email": "string",
      "phone": "string",
      "address": {
        "street": "string",
        "city": "string",
        "state": "string",
        "zip": "string"
      }
    },
    "insurance": {
      "provider": "string",
      "policy_number": "string",
      "group_number": "string",
      "copay_usd": "number"
    },
    "visits": [
      {
        "visit_id": "string",
        "date": "YYYY-MM-DD",
        "physician": "string",
        "diagnosis": "string",
        "icd10_code": "string",
        "prescriptions": [
          {
            "drug": "string",
            "dosage": "string",
            "frequency": "string",
            "refills": "number"
          }
        ]
      }
    ]
  }
}

Patient record:
"Patient James R. Calloway, DOB 14 March 1978, male. ID: PAT-00291. Email: j.calloway@email.com, phone 555-0182. Address: 44 Birchwood Drive, Austin, TX 78701. Insured under BlueCross BlueShield, policy BXL-992-44A, group GRP-0044, $30 copay. Visit on 2026-01-15 with Dr. Sarah Nguyen. Diagnosed with Type 2 Diabetes Mellitus (ICD-10: E11.9). Prescribed Metformin 500mg twice daily, 3 refills. Second visit 2026-03-02 with Dr. James Park. Diagnosed with Hypertension (ICD-10: I10). Prescribed Lisinopril 10mg once daily, 2 refills. Visit ID for first visit: VIS-001, second: VIS-002."
```

**Result:** Both models 100% correct — valid JSON, correct types, correct nesting. Only difference: 31B kept middle initial in `first_name`, 26B dropped it (a judgment call, not an error). Full responses in `outputs/response_test8_json_26b.txt` and `outputs/response_test8_json_31b.txt`.
