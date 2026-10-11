---
name: code-review
description: "Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes: Standards (does the code follow this repo's documented coding standards?) and Spec (does the code match what the originating issue/spec asked for?). Runs both reviews in parallel sub-agents and reports them side by side. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to \"review since X\"."
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/code-review/SKILL.md)
>
> **description 中譯：** 沿著兩個軸審查從某個固定點（commit（提交）、branch（分支）、tag 或 merge-base）以來的改動：Standards（程式碼是否遵守這個 repo（儲存庫）文件化的程式規範？）與 Spec（程式碼是否符合原始 issue（議題）/ spec（規格）的要求？）。用平行的 sub-agent（子代理）執行兩個審查，並把結果並排回報。當使用者想審查一個 branch、一個 PR（pull request）、進行中的改動，或要求 "review since X"（審查 X 之後的改動）時使用。

對 `HEAD` 和使用者提供的固定點之間的 diff（差異）做雙軸審查：

- **Standards**（標準）：程式碼是否符合這個 repo 文件化的程式規範？
- **Spec**（規格）：程式碼是否忠實實作了原始的 issue / spec？

兩個軸都以**平行的 sub-agent** 執行，讓它們不會污染彼此的 context（上下文），然後由這個 skill（技能）彙整它們的發現。

Issue tracker（議題追蹤系統）應該已經提供給你了。如果沒有，告訴使用者執行 `/setup-matt-pocock-skills`。

## 流程 (Process)

### 1. 釘住固定點 (Pin the fixed point)

使用者說的任何東西就是固定點（一個 commit SHA、branch 名稱、tag、`main`、`HEAD~5` 等等）。如果他們沒有指定，就問他們。

把 diff 指令記下來，只做一次：`git diff <fixed-point>...HEAD`（三個點，所以比較的基準是 merge-base）。也用 `git log <fixed-point>..HEAD --oneline` 記下 commit 清單。

在繼續之前，確認固定點可以被解析（`git rev-parse <fixed-point>`），而且 diff 不是空的。錯誤的 ref 或空的 diff 應該在這裡就失敗，而不是在兩個平行的 sub-agent 裡面才失敗。

### 2. 找出 spec 來源 (Identify the spec source)

依照這個順序尋找原始的 spec：

1. commit message 裡的 issue 參照（`#123`、`Closes #45`、GitLab `!67` 等等），依照 tracker 文件裡的流程抓取。
2. 使用者當作參數傳入的路徑。
3. `docs/`、`specs/` 或 `.scratch/` 底下，跟 branch 名稱或功能相符的 spec 檔。
4. 如果什麼都找不到，問使用者 spec 在哪裡。如果他們說沒有，**Spec** sub-agent 會跳過，並回報 "no spec available"（沒有可用的 spec）。

### 3. 找出 standards 來源 (Identify the standards sources)

在 repo 裡搜尋每一個記錄程式碼該怎麼寫的檔案。當 `CODING_STANDARDS.md` 或 `CONTRIBUTING.md` 存在時，它一定要在清單上。

除了 repo 自己記錄的東西之外，Standards 軸永遠都會帶著下面這份 **smell baseline**（壞味道基準清單）：一組固定的 Fowler 程式碼壞味道（_Refactoring_，第 3 章），即使 repo 什麼都沒記錄也適用。有兩條規則約束它：

- **Repo 優先**。文件化的 repo 標準永遠勝出；當它認可某個 baseline 會標記的東西時，就壓下那個 smell。
- **永遠是判斷題**。每個 smell 都是一個有標籤的經驗法則（"possible Feature Envy"，可能有 Feature Envy），絕不是硬性違規。和這裡的任何標準一樣，跳過任何工具已經強制執行的東西。

每個 smell 的讀法是*它是什麼* → *怎麼修*；拿它來比對 diff：

- **Mysterious Name**（神秘命名）：一個函式、變數或型別的名稱沒有透露它做什麼或裝了什麼。→ 重新命名；如果想不出誠實的名稱，代表設計本身很模糊。
- **Duplicated Code**（重複的程式碼）：同一種邏輯形狀出現在這次改動的多個 hunk（diff 片段）或檔案裡。→ 把共同的形狀抽出來，兩邊都呼叫它。
- **Feature Envy**（依戀情結）：一個 method 伸手去拿別的物件的資料，比拿自己的還多。→ 把這個 method 搬到它所羨慕的那份資料上。
- **Data Clumps**（資料泥團）：同樣幾個欄位或參數老是一起出現（一個想要誕生的型別）。→ 把它們包成一個型別，傳遞那個型別。
- **Primitive Obsession**（基本型別偏執）：用一個基本型別或字串代替一個值得擁有自己型別的領域概念。→ 給這個概念一個專屬的小型別。
- **Repeated Switches**（重複的 switch）：針對同一個型別的同一個 `switch`/`if` 連鎖，在這次改動中反覆出現。→ 用多型取代，或改用一個兩處共用的 map。
- **Shotgun Surgery**（霰彈式修改）：一個邏輯上的改動，迫使 diff 中許多檔案都要分散地修改。→ 把會一起改變的東西集中到一個 module（模組）裡。
- **Divergent Change**（發散式變化）：一個檔案或 module 因為好幾個不相關的理由被修改。→ 拆開，讓每個 module 只因為一個理由而改變。
- **Speculative Generality**（夸夸其談未來性）：為了 spec 裡沒有的需求而加入的抽象、參數或 hook。→ 刪掉它；把它 inline 回去，直到真正的需求出現。
- **Message Chains**（過長的訊息鏈）：呼叫端不應該依賴的一長串 `a.b().c().d()` 導覽。→ 把這段走訪藏到第一個物件上的一個 method 後面。
- **Middle Man**（中間人）：一個大部分只是把工作往下委派的 class 或函式。→ 砍掉它，直接呼叫真正的目標。
- **Refused Bequest**（被拒絕的遺贈）：一個忽略或覆寫了它所繼承的大部分東西的 subclass 或實作者。→ 拿掉繼承，改用組合。

### 4. 平行啟動兩個 sub-agent (Spawn both sub-agents in parallel)

把兩個 sub-agent 呼叫一起發出，在前景執行，然後彙整它們回傳的報告。

**Standards sub-agent 的 prompt**（提示詞）應該包含：

- 完整的 diff 指令和 commit 清單。
- 你在步驟 3 找到的 standards 來源檔案清單，**加上步驟 3 的 smell baseline**，完整貼上（sub-agent 沒有其他途徑可以取得它）。
- 任務說明："Report, per file/hunk where relevant, (a) every place the diff violates a documented standard: cite the standard (file + the rule); and (b) any baseline smell you spot: name it and quote the hunk. Distinguish hard violations from judgement calls: documented-standard breaches can be hard, but baseline smells are always judgement calls, and a documented repo standard overrides the baseline. Skip anything tooling enforces. Under 400 words."（在相關時依檔案 / hunk 回報：(a) diff 違反文件化標準的每一處：引用該標準（檔案 + 規則）；以及 (b) 你發現的任何 baseline smell：說出它的名稱並引用該 hunk。區分硬性違規與判斷題：違反文件化標準可以是硬性違規，但 baseline smell 永遠是判斷題，而且文件化的 repo 標準優先於 baseline。跳過任何工具已強制執行的東西。少於 400 字。）

**Spec sub-agent 的 prompt** 應該包含：

- diff 指令和 commit 清單。
- spec 的路徑，或抓取到的 spec 內容。
- 任務說明："Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Under 400 words."（回報：(a) spec 要求了、但缺少或只做了一部分的需求；(b) diff 中沒有被要求的行為（範圍蔓延）；(c) 看起來已經實作、但實作看起來是錯的需求。每個發現都要引用 spec 的那一行。少於 400 字。）

如果 spec 不存在，就跳過 Spec sub-agent，並在最終報告中註明這一點。

### 5. 彙整 (Aggregate)

把兩份報告放在 `## Standards` 和 `## Spec` 標題底下呈現，原文照貼或稍微整理。**不要**合併或重新排序這些發現，因為這兩個軸是刻意分開的（見*為什麼要兩個軸*一節）。

最後用一行摘要收尾：每個軸的發現總數，以及*每個軸內*最嚴重的問題（如果有的話）。不要跨軸挑出單一個最嚴重的：那正是這種分離要防止的重新排序。

## 為什麼要兩個軸 (Why two axes)

一個改動可能通過其中一軸，卻沒通過另一軸：

- 遵守每一條標準、但實作了錯誤東西的程式碼 → **Standards 通過，Spec 失敗。**
- 完全照 issue 要求去做、但破壞了專案慣例的程式碼 → **Spec 通過，Standards 失敗。**

分開回報，可以避免一個軸掩蓋另一個軸。
