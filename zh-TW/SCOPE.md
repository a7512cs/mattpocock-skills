> 繁體中文翻譯。原文：[SCOPE.md](../SCOPE.md)

# 範圍 (Scope)

這個 repo（程式碼儲存庫）是我每天在用的那一組 skill（技能包）。它是經過挑選的：歡迎提出想法，而每個想法都會用下面的門檻來評斷。Issue（議題）是用來追蹤 skill 的變更。問題和討論請到 [GitHub Discussions](https://github.com/mattpocock/skills/discussions)。

## 門檻 (The bar)

一個想法或回饋的 issue，只有在**兩個**部分都通過時才會保持開啟：

1. **實際觀察到的失敗。** 它描述了在真實 session（工作階段）中出錯的事：你執行了什麼、skill 做了什麼、你原本預期什麼。假設性的改進（「如果……會更好」）過不了這一關。
2. **符合理念。** 它不符合 [`.out-of-scope/`](./.out-of-scope/) 裡的任何項目或過去被拒絕的提案，而且它不是一個設定選項、不是針對某個 harness（執行環境：例如 Claude Code、Codex 這類跑 agent 的工具）的分支，也不是為了配合某一個人的工作流程而做的微調。這些東西應該放在你自己的 `CLAUDE.md` / `AGENTS.md`，或放在 fork 裡（skills.sh 會給你一份可編輯的副本）。

大小無關緊要：改一個字和整個重寫，面對的是同一個門檻。表情回應和 +1 留言不算數。

## 依 bucket（分類資料夾）區分 (By bucket)

- **`engineering/`、`productivity/`、`in-progress/`**：適用上面的門檻。
- **`misc/`**：已凍結，不再維護。所有 issue 都會被關閉。見 [`frozen-misc-skills.md`](./.out-of-scope/frozen-misc-skills.md)。
- **新的 skill**：提案和貢獻都會被關閉。如果這個行為可以用現有的 skill 組合出來，就不會為它做新的 skill。見 [`new-skills.md`](./.out-of-scope/new-skills.md)。

## 已經決定的事 (Already decided)

[`.out-of-scope/`](./.out-of-scope/) 裡的每個檔案記錄一個被拒絕的概念，以及拒絕的原因。提出 issue 之前請先讀過：

- [`frozen-misc-skills.md`](./.out-of-scope/frozen-misc-skills.md)
- [`harness-name-collisions.md`](./.out-of-scope/harness-name-collisions.md)
- [`mainstream-issue-trackers-only.md`](./.out-of-scope/mainstream-issue-trackers-only.md)
- [`native-question-tool.md`](./.out-of-scope/native-question-tool.md)
- [`new-skills.md`](./.out-of-scope/new-skills.md)
- [`question-limits.md`](./.out-of-scope/question-limits.md)
- [`setup-skill-verify-mode.md`](./.out-of-scope/setup-skill-verify-mode.md)
- [`subagent-recursion.md`](./.out-of-scope/subagent-recursion.md)

## 不清楚的 issue (Unclear issues)

無法用門檻評斷的 issue，會得到一輪提問和 `needs-info` 標籤。如果回報者 14 天內沒有回覆，就會被關閉。被拒絕的 issue 會以「not planned」關閉。
