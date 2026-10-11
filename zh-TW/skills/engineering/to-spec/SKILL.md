---
name: to-spec
description: "Turn the current conversation into a spec and publish it to the project issue tracker: no interview, just synthesis of what you've already discussed."
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/to-spec/SKILL.md)
>
> **description 中譯：** 把目前的對話變成一份 spec（規格），並發布到專案的 Issue tracker（議題追蹤系統）：不做訪談，只綜合你們已經討論過的內容。

這個 skill（技能）拿目前對話的 context（上下文）和對 codebase（程式碼庫）的理解，產出一份 spec。不要（NOT）訪談使用者；只要綜合你已經知道的東西。

Issue tracker 和 triage（分類處理）label 詞彙應該已經提供給你了。如果沒有，告訴使用者執行 `/setup-matt-pocock-skills`。

## 流程 (Process)

1. 如果你還沒探索過，就探索 repo（程式碼倉庫），了解 codebase 目前的狀態。在整份 spec 中使用專案領域 glossary（詞彙表）的詞彙，並尊重你正在修改的區域中的任何 ADR（架構決策紀錄）。

2. 草擬你要在哪些 seam（接縫：可以觀察行為的公開邊界）上測試這個功能。應該優先使用現有的 seam，而不是新的。使用盡可能高層的 seam。如果需要新的 seam，就在你能做到的最高點提議它們。整個 codebase 中的 seam 越少越好：理想的數量是一個。

跟使用者確認這些 seam 符合他們的預期。

3. 用下面的範本寫 spec，然後發布到專案的 Issue tracker。套用 `ready-for-agent` triage label：不需要額外的 triage。

<spec-template>

## 問題陳述 (Problem Statement)

使用者面臨的問題，從使用者的角度出發。

## 解決方案 (Solution)

問題的解決方案，從使用者的角度出發。

## 使用者故事 (User Stories)

一份很長（LONG）、有編號的使用者故事清單。每個使用者故事都應該採用以下格式：

1. 身為一個 <角色>，我想要 <功能>，以便 <好處>

<user-story-example>
1. 身為行動銀行的客戶，我想要看到我帳戶的餘額，以便對我的花費做出更有根據的決定
</user-story-example>

這份使用者故事清單應該極為詳盡，涵蓋這個功能的所有面向。

## 實作決定 (Implementation Decisions)

已經做出的實作決定清單。可以包括：

- 會建立/修改的 module（模組）
- 這些 module 中會被修改的 interface（介面）
- 開發者提供的技術釐清
- 架構決定
- Schema 變更
- API 合約
- 具體的互動

不要（NOT）包含具體的檔案路徑或程式碼片段。它們可能很快就會過時。

例外：如果某個 prototype（原型）產出了一段比文字更能精確表達某個決定的程式碼片段（狀態機、reducer、schema、型別形狀），就把它內嵌在相關的決定裡，並簡短註明它來自 prototype。修剪到只剩富含決定的部分：不是一個能運作的示範，只留重要的片段。

## 測試決定 (Testing Decisions)

已經做出的測試決定清單。包括：

- 說明什麼是好的測試（只測試外部行為，不測試 implementation（實作）細節）
- 哪些 module 會被測試
- 這些測試的前例（也就是 codebase 中類似類型的測試）

## Out of Scope

說明這份 spec 中屬於 out of scope（範圍之外）的東西。

## 補充說明 (Further Notes)

關於這個功能的任何補充說明。

</spec-template>
