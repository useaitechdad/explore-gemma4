---
title: UI Module
updated: 2026-04-15
sources:
  - index.html
confidence: high
---

# UI Module

The UI component handles the visual presentation and user interaction for the Gemma 4 demo. It is fully contained within `index.html`.

## Responsibilities
- Layout styling using a dark theme with CSS variables (e.g., `--bg: #0d0d0f`, `--accent: #4f8ef7`).
- Capturing user input: API keys, prompts, image uploads, model selection, and configuration toggles.
- Formatting and displaying streaming responses, including code blocks.

## State elements
- `currentModel`: The selected model string (e.g., `'gemma-4-31b-it'`).
- `currentMode`: The interaction mode, either `'text'` or `'image'`.
- `fileBase64`, `fileMimeType`: Stored state for user-uploaded images in image mode.

## Key Interactions

| Action | Logic Triggered |
|--------|-----------------|
| Enter key / 'Send' button | Triggers `handleSend()` for the API request. If API key is blank, displays inline error and returns focus to the input field. |
| API Key Input change | Hides validation errors and saves the key to `localStorage`. |
| Model change | Updates `currentModel` state and UI metrics label. |
| Image upload | Reads file via `FileReader` and updates thumbnail and `fileBase64`. |
| Copy button | Copies the innerText of the response panel to clipboard using `navigator.clipboard`. |
