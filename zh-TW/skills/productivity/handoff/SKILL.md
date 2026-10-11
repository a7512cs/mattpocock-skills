---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/productivity/handoff/SKILL.md)
>
> **description 中譯：** 把目前的對話壓縮成一份 handoff（交接）文件，讓另一個 agent（AI 代理）接手。
>
> **argument-hint 中譯：** 下一個 session（工作階段）要用來做什麼？

寫一份總結目前對話的 handoff 文件，讓一個全新的 agent 能繼續這項工作。存到使用者作業系統的暫存目錄（`$TMPDIR`，沒有的話用 `/tmp`；Windows 上用 `%TEMP%`），而不是目前的工作區。

在文件裡加一個 "suggested skills"（建議的 skill）區段，列出下一個 agent 應該用 Skill tool 呼叫哪些 skill（技能包）。

不要重複已經記錄在其他產出物（spec（規格）、計畫、ADR（架構決策紀錄）、issue（議題）、commit（提交）、diff（差異））裡的內容。改用路徑或 URL 引用它們。

遮蔽任何敏感資訊，例如 API key、密碼或個人可識別資訊。

如果使用者傳入了參數，就把它們當成下一個 session 要專注之事的說明，並據此調整文件內容。
