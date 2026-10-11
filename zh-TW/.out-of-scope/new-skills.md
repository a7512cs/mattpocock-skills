> 繁體中文翻譯。原文：[new-skills.md](../../.out-of-scope/new-skills.md)

# 新 skill 的提案與貢獻 (New skill proposals and contributions)

這個 repo（程式碼儲存庫）不接受新 skill（技能包）的提案或貢獻，包括那些已經附上現成 branch（分支）或 fork 的。

## 為什麼這不在範圍內 (Why this is out of scope)

這份目錄就是我自己每天在用的那組 skill，而且刻意保持精簡。每個 skill 都是永久的維護面：它必須和其他 skill、docs 頁面、`ask-matt` 的路由地圖，以及 plugin（外掛）manifest 保持同步。skill 越短、越少，維持正確的成本就越低。

我套用在自己想法上的規則，在這裡也一樣適用：如果你能用現有的 skill 組合出這個行為，它就不會得到一個新的 skill。大多數的提案，都是用 grilling（拷問式提問）、`to-spec`、`to-tickets`、`implement` 等 skill 組出來的特定工作流程，而這種組合應該放在你自己的 prompt（提示詞）或你自己的 skill 裡。

非常歡迎你自己發布 skill。skills.sh 讓這件事很簡單，而這裡的任何東西都不需要知道它的存在。

這裡只涵蓋*新的* skill。現有 skill 中的具體失敗，會和其他任何 issue（議題）一樣，用 [`SCOPE.md`](../SCOPE.md) 裡的門檻來評斷。

## 過去的請求 (Prior requests)

- #101: "Any skill to iteratively build CONTEXT.md (and ADRs) for a brownfield codebase?"（有沒有 skill 可以替既有的 codebase 逐步建立 CONTEXT.md（和 ADR）？）
- #414: "Add a `handoff-to-pro` skill for generating one-shot prompts for external frontier chat models"（新增一個 `handoff-to-pro` skill，用來替外部最前沿的聊天模型產生一次到位的 prompt）
- #727: "new skill - teach pr"（新 skill：teach pr）
- #1051: "Contribution ready: /red-team, the optional pre-implementation spec review from #633"（貢獻已就緒：/red-team，也就是 #633 提到的、實作前選用的 spec 審查）
- #1166: "Skill proposal: agent-chat-ux for productivity (branch ready on fork)"（skill 提案：productivity 用的 agent-chat-ux，branch 已在 fork 上準備好）
