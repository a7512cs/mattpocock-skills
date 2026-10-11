> 繁體中文翻譯。原文：[native-question-tool.md](../../.out-of-scope/native-question-tool.md)

# 透過 harness 原生的提問工具進行 grilling (Grilling through the harness's native question tool)

grilling session（拷問式對談），包括 `/grilling`、`/grill-me`、`/grill-with-docs`，以及其他 skill（技能包）裡的 grilling，都是用純聊天文字提出問題。要求改用 harness（執行環境）內建提問介面的請求（Claude Code 的 `AskUserQuestion`、宿主的「提問工具」、結構化或批次的問卷模式），都是 out of scope（不在範圍內）。

## 為什麼這不在範圍內 (Why this is out of scope)

skill 是不綁定 harness 的文字。它們可以在 Claude Code、Codex、Copilot、Cursor 以及任何 skills.sh 能安裝進去的環境裡執行，而每個 harness 的提問工具都不一樣，或者根本沒有。在 skill 裡指名某個 harness 的工具，意味著要嘛每個 grilling skill 都要有一個 harness 專屬的分支，要嘛 skill 只在一個地方能正常運作。

提問介面也會改變 grilling 本身。結構化的選擇器會把 model（模型）推向附帶預先準備好答案的選擇題，這和 grilling 的目的正好相反：grilling 要的是你用自己的話回答的開放式問題，一次處理決策樹的一個分支。我試過 `AskUserQuestion` 介面，不想把它放進這些 skill 裡。

如果你偏好你的 harness 的提問工具，就在你自己的 `CLAUDE.md` / `AGENTS.md` 裡寫明，例如 "when grilling, ask via AskUserQuestion"（grilling 時，透過 AskUserQuestion 提問）。這是一行、個人的偏好設定，不需要讓共用的 skill 知道。

## 過去的請求 (Prior requests)

- #19: "grill-me: not always using the question tool"（grill-me：沒有每次都使用提問工具）
- #643: "Proposal: Use AskQuestion for structured input during grilling sessions"（提案：在 grilling session 中使用 AskQuestion 取得結構化輸入）
- #840: "Use host's question tool for grilling sessions"（grilling session 改用宿主的提問工具）
- #1107: "Grilling doesn't use Agent's native QA tool OOTB"（grilling 預設不會使用 Agent 原生的問答工具）
- #1152: "Proposal: experimental HTML questionnaire mode for batch grilling"（提案：用於批次 grilling 的實驗性 HTML 問卷模式）
