---
title: API Client Module
updated: 2026-04-15
sources:
  - index.html
confidence: high
---

# API Client Module

The API client logic handles communication with the Google Generative Language REST API (`https://generativelanguage.googleapis.com/v1beta/models`).

## Flow
1. **Validation**: Ensures an API key is provided (either from `env.txt`, `localStorage`, or manual entry). If missing, blocks the request immediately and triggers inline UI error feedback before hitting the network.
2. **Payload Construction**: Builds the `contents` structured array and optionally appends a `generationConfig` block for thinking mode.
3. **Execution**: Performs a `POST` request to `{model}:streamGenerateContent?alt=sse&key={apiKey}`.
4. **Streaming**: Reads the response body via a `TextDecoder` and a `ReadableStreamDefaultReader`.
5. **Parsing**: Splits the response buffer over `\n` characters, parses valid JSON `data: ` blocks iteratively, accumulates the text, and writes directly to the DOM for immediate feedback.

## Key Functions

| Function | Role |
|----------|------|
| `init()` | IIFE that checks for `env.txt` or `localStorage` to pre-fill the API key. |
| `handleSend()` | The main async function that constructs the request, manages the UI busy state, handles stream parsing, measures metrics (Time / estimated Tokens based on char length), and renders the response. |
