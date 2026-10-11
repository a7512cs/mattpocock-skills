---
name: implement-spec
description: "Implement the result of /to-spec and /to-tickets in code."
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/implement-spec/SKILL.md)
>
> **description 中譯：** 把 /to-spec 和 /to-tickets 的結果實作成程式碼。

你拿到了一份 spec（規格）。這份 spec 應該有相關聯的 ticket（工單），描述如何實作這份 spec。

Issue tracker（議題追蹤系統）應該已經提供給你了。如果沒有，告訴使用者執行 `/setup-matt-pocock-skills`。

目標是把整份 spec 實作在單一一條 **integration branch**（整合分支）上，而且每張 ticket 都依照 issue tracker 結案工作的方式被解決。

這些 ticket 不是一份步驟清單。它們是一張 **task graph**（任務圖），彼此之間有阻擋關係。這代表永遠存在一個由已就緒、可以拿來做的 ticket 組成的 **frontier**（前沿）。

和 subagent（子代理）之間的溝通應該精簡。主要透過 **context pointers**（上下文指標）溝通：指向 spec、ticket、研究筆記和之前的 commit（提交）。不要重複已經能透過指標取得的資訊。

**Implementer subagents**（負責實作的 subagent）應該盡可能在背景執行，以達到最大的並行度。

## 步驟 (Steps)

1. 閱讀 spec 和 ticket，理解 task graph。

2. （選用）用一個 **exploration subagent**（負責探索的 subagent）進行 ticket 所需的任何探索：相關的 codebase（程式碼庫）檔案或外部文件。確保 exploration subagent 能儲存檔案：它應該把它的 markdown 筆記存在 repo（儲存庫）外面的一個目錄，讓之後所有的 subagent 都能取用。這讓 **implementer subagent** 能專注在實作上，而不是探索。

3. 建立 integration branch。如果 issue tracker 是透過 PR（pull request）來結案工作，或使用者要求開一個 PR，就在步驟 5 的第一次 merge（合併）之後開一個 draft PR（一條沒有任何 commit 領先 main 的 branch（分支）無法開 PR），並標記為會關閉這份 spec 和這些 ticket。

4. 用 **implementer subagent** 實作每張 ticket，每個都在自己的 worktree、自己的 branch 上。每個 implementer subagent：
   - 開始之前，確認自己的 worktree 是以 integration branch 為基礎，如果不是，就 reset 到它上面；
   - 用 `tdd` 呼叫 Skill 工具來建置這張 ticket；
   - 在回報完成之前，把 integration branch 的最新端點 merge 進自己的 branch

5. 一旦某個 **implementer subagent** 完成，就用一個 **merger subagent**（負責合併的 subagent）把它的成果 merge 到 integration branch。

6. 如果這改變了可用 ticket 的 **frontier**，就啟動更多 **implementer subagent** 去處理新的 ticket。這能達到最大的並行度。

7. 所有 ticket 都完成後，對 integration branch 用 `code-review` 呼叫 Skill 工具。用單一一個 **implementer subagent** 修正 code review 提出的所有問題。

8. 如果有 draft PR，就把它標記為 ready for review。否則，依照 issue tracker 結案工作的方式解決每張 ticket，並回報 integration branch。

9. 清理所有 **implementer subagent** 的 worktree。
