> 繁體中文翻譯。原文：[lazy-load-writing-for-agents.md](../../.out-of-scope/lazy-load-writing-for-agents.md)

# 在評斷給 agent 看的文字的 skill 裡延遲載入 `writing-for-agents` (Lazy-loading `writing-for-agents` in skills that judge agent-facing writing)

`retro` 每次執行都會載入 `writing-for-agents`，而不是只在它要寫東西之前才載入。要求把這次載入延後到 skill（技能包）要編輯某個 skill、某個 `AGENTS.md`/`CLAUDE.md` 或某份文件時才做的請求，都是 out of scope（不在範圍內）。

## 為什麼這不在範圍內 (Why this is out of scope)

`writing-for-agents` 不只是一份風格指南。它定義了什麼是 no-op instruction（無作用的指令），以及什麼才算好的 skill，而 `retro` 會在寫任何東西之前，用這些定義來評斷它讀到的 steering file（引導檔）。一次只讀取和回報的 retro 仍然需要它。如果延遲載入，No-ops 和 Skills 這兩類候選項目就會在沒有衡量標準的情況下被評斷。

## 過去的請求 (Prior requests)

- #1238: "retro: load writing-for-agents only before writing"（retro：只在寫之前才載入 writing-for-agents）（已關閉）
