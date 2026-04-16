---
title: Overview
updated: 2026-04-15
sources:
  - README.md
  - index.html
confidence: high
---

# Overview

This repo contains a lightweight, single-page web application designed to demonstrate the capabilities of Google's Gemma 4 (31B and 26B) and Gemini models. 

## Structure
The codebase is a flat project with no build steps:
- `index.html`: The core application containing UI layout, styling, and JavaScript logic for the REST API client.
- `README.md`: Setup instructions and a summary of test results.
- `PROMPTS.md`: The copy-pasteable test prompts used in the video demonstration.
- `.agents/`: Portable LLM Wiki package for automated documentation.
- `wiki/`: Generated LLM-maintained living documentation.
- `env.txt.example`: Example for providing the Google AI Studio API key.
- `outputs/`: Pre-captured model test responses used in the demonstrations.

## Technology Stack
- Vanilla HTML/CSS/JavaScript
- `npx serve` for local serving
- Server-Sent Events (SSE) for streaming API responses from Google Generative Language APIs.
