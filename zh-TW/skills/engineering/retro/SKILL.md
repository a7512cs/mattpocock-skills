---
name: retro
description: "Conduct a retrospective on a coding session."
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/retro/SKILL.md)
>
> **description 中譯：** 對一次 coding session（工作階段）進行回顧。

使用者要求做一次 **retrospective**（回顧）。你要針對 coding agent（代理程式）的 **environment**（環境）提出改進建議，讓之後的執行更好。

## 步驟 (Steps)

1. 用 `writing-for-agents` 呼叫 Skill 工具，取得寫作風格指南。

2. 讀取使用者指定的那個 session 的 primary source（第一手資料）。這可能表示要搜尋這台機器上的 session 紀錄。如果使用者沒有指定 session，預設用目前這一個。

3. 在以下類別中尋找可以改進的候選項目。

- **導覽 (Navigation)**：agent 找到正確的檔案有多容易？檔案之間有沒有隱藏的相依關係？一個 **navigation pointer**（導覽指標：指向其他檔案的提示）會不會讓它更容易？*使用時機：* session 花了很長時間才找到某項資訊。
- **自動化檢查 (Automated checks)**：有沒有自動化檢查能抓到 agent 犯的錯？lint（靜態程式碼檢查）、型別、測試、檔案系統 linter？先讀 repo（程式碼倉庫）自己的檢查指令（它的 `package.json`/建置工具的 `lint`/`check` script、它的 CI（持續整合）workflow），這樣「某個檢查已經存在，但沒接上或默默壞掉」才會是發現，而不是重新發明一次。一個沒有 **guardrail**（護欄）的 repo（沒有 pre-commit hook，也沒有執行它 lint/typecheck（型別檢查）/test 指令的 CI job），本身就是一個發現：沒有 lint 的 repo 是一個一直存在的錯失機會，不是一個中性的預設狀態。*使用時機：* agent 犯了一個自動化檢查本來可以抓到的錯，或 repo 完全沒有 guardrail。
- **程式碼規範 (Coding standards)**：是否應該給 **reviewer agent**（審查 agent）一條新規則去執行？是否應該移除或釐清某條現有規則？先把違規分類：**mechanical**（機械式）的違規（固定的語法模式、被禁止的 API、import 的形狀、檔案位置規則）就做成一個確定性的檢查，沒有例外：在 repo 自己的 linter 裡加一條自訂規則、一個新的 pre-commit hook，或一個新的 CI job，看 repo 的語言和現有的 guardrail 哪一個最便宜。預設是建立檢查，而不是寫規則。`CODING_STANDARDS.md` 只留給真正的 **judgement calls**（判斷題）（跨檔案的一致性、「符合周圍的風格」、任何 guardrail 永遠無法取代的東西）。*使用時機：* reviewer agent 沒抓到某個錯誤。
- **全域 AGENTS.md (Global AGENTS.md)**：有沒有任何引導指示應該改放到程式碼規範（或自動化檢查）裡？*使用時機：* AGENTS.md 檔案特別大的時候：不論是 repo 裡的，還是使用者全域範圍的，都算。
- **工具經濟 (Tool economy)**：agent 有沒有做出可以精簡的昂貴工具呼叫？有沒有哪個自訂工具（CLI、MCP）特別浪費 token（模型計算用量的單位）？*使用時機：* agent 做了一次昂貴的工具呼叫。
- **無作用指令 (No-ops)**：找出引導檔案中那些不會改變 agent 行為的指示。*使用時機：* 引導檔案又大又難以管理的時候。
- **資訊取得 (Information access)**：找出能增加 agent 取得資訊的機會。用 tee 把 dev server 的 log 另外輸出一份、對第三方服務的唯讀存取。*使用時機：* agent 拿不到某項關鍵資訊的時候。

4. 把這些候選項目依嚴重程度排序，呈現給使用者。

## 參考 (Reference)

### 實作 vs 審查 (Implementation vs Review)

記住，所有工作都會經過兩個階段：實作和審查。實作 agent 承受最大的 **context pressure**（context 壓力：context window 被塞滿的壓力）。它們負責探索、寫程式碼，以及為失敗除錯。

審查 agent 承受的 context pressure 最小：它收到的是一份 diff（差異內容），所以不需要探索。它通常不需要寫程式碼或除錯。

這表示應該由審查 agent 負責強制執行程式碼規範，而不是實作 agent。

### 檔案 (Files)

你可以存取 repo 裡的幾個檔案：

- `CLAUDE.md`/`AGENTS.md`：這些檔案會被推進任何在這個 repo 工作的 agent 的 context window（上下文視窗）。使用時應該極度節制，通常只用來放指向其他檔案的 **navigation pointer**。
- `CODING_STANDARDS.md`：這個檔案在審查時讀取，不在實作時讀取。如果規範檔超過 1,000 行，就加上指向 docs 資料夾的 **navigation pointer**。
- 文件 (Docs)：把文件當作參考檔案使用，由其他檔案指向它們。寫新的之前，先找找有沒有現有的文件。
- Skill：用 skill（技能）來放文件（因為它們的 description（描述）會進入 agent 的 context window），或用於 user-invoked（由使用者呼叫的）指令。遵循 `writing-for-agents` skill 裡的建議。
