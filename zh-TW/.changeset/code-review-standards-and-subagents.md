---
"mattpocock-skills": patch
---

> 繁體中文翻譯。原文：[code-review-standards-and-subagents.md](../../.changeset/code-review-standards-and-subagents.md)

`code-review` 現在會在 repo（程式庫）中搜尋規範檔案，並且一定會把 `CODING_STANDARDS.md` / `CONTRIBUTING.md` 交給負責 Standards 的 sub-agent（子 agent）處理（#1065）；它會在前景執行兩個 sub-agent，並使用它們回傳的報告（#1073）；它也會透過提供的 tracker 說明檔找到 issue tracker（議題追蹤系統），而不是使用寫死的路徑（#937）。
