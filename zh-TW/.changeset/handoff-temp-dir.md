---
"mattpocock-skills": patch
---

> 繁體中文翻譯。原文：[handoff-temp-dir.md](../../.changeset/handoff-temp-dir.md)

`handoff` 現在會寫明作業系統暫存目錄的位置（`$TMPDIR`，沒有的話用 `/tmp`；Windows 上用 `%TEMP%`），讓 agent（代理）不用再猜（#272）。
