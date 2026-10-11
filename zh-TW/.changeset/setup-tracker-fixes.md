---
"mattpocock-skills": patch
---

> 繁體中文翻譯。原文：[setup-tracker-fixes.md](../../.changeset/setup-tracker-fixes.md)

`setup-matt-pocock-skills` 現在會在 GitHub/GitLab 上建立缺少的 triage（分流）label（#616）、修正 GitLab 範本中的 `glab` 指令（#635）、用 `--json` 讀取 GitHub issue（議題），讓 label 和內文都能正確取得（#733），並在 `triage-labels.md` 中把該欄位命名為 "Label in our tracker"（我們 tracker 中的 label）（#801）。請重新執行 `/setup-matt-pocock-skills` 來更新 `docs/agents/`。
