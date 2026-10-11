---
name: claude-handoff
description: Hand the current conversation off to a fresh background agent that picks up the work immediately.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/in-progress/claude-handoff/SKILL.md)
>
> **description 中譯：** 把目前的對話交接給一個全新的 background agent（背景代理），讓它立刻接手工作。
>
> **argument-hint 中譯：** 下一個 session（工作階段）要用來做什麼？

為目前的對話寫一份 handoff（交接）摘要，讓一個全新的 agent 可以接續工作。把它存到使用者作業系統的暫存目錄，然後啟動一個以它作為 prompt（提示詞）的 background agent：`claude --bg --name "<descriptive name>" -- "$(cat <summary file>)"`。傳入檔案可以避免 shell 執行摘要裡的反引號，或展開其中的 `$`。它會在目前的工作目錄中啟動並立即返回；使用者用 `claude agents` 管理它。

一律傳入 `-n`/`--name` 並附上描述性的名稱（例如 `--name "Fix login bug"`）；它會設定顯示名稱，這個名稱會出現在工作清單、session 選擇器和終端機標題中。

在摘要中加入一個 "suggested skills"（建議使用的 skill）段落，列出下一個 agent 應該用 Skill tool 呼叫哪些 skill（技能）。

不要重複已經記錄在其他產出物中的內容（spec（規格）、計畫、ADR（架構決策紀錄）、issue（議題）、commit（提交）、diff（差異））。改用路徑或 URL 引用它們。

遮蔽任何敏感資訊，例如 API key、密碼或個人可識別資訊，因為這份摘要會成為 agent 的 prompt。

如果使用者有傳入參數，就把它們當作下一個 session 要專注於什麼的描述，並據此調整摘要。
