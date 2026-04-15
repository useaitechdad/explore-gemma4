---
title: Data Model
updated: 2026-04-15
sources:
  - index.html
confidence: high
---

# Data Model

The primary data structures are shaped by the Google Generative Language REST API (`/v1beta/models/...:streamGenerateContent`).

## API Request Body

```javascript
{
  contents: [
    {
      role: 'user',
      parts: [
        // Optional image part
        { inlineData: { mimeType: '...', data: '...' } },
        // Text prompt
        { text: "user prompt string" }
      ]
    }
  ],
  // Optional configuration for Thinking Mode
  generationConfig: {
    thinkingConfig: {
      thinkingLevel: 'HIGH'
    }
  }
}
```

## API Response (Streaming SSE)

The application parses an SSE stream of JSON chunks matching this structure:

```javascript
{
  candidates: [
    {
      content: {
        parts: [
          { text: "chunk of response text" }
        ]
      }
    }
  ]
}
```
