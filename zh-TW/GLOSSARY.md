> 繁體中文翻譯。原文：[GLOSSARY.md](../GLOSSARY.md)

# Matt Pocock Skills

一組由 Claude Code 載入的 agent（AI 代理）skill（技能包），包含 slash command（斜線指令）和行為。skill 依 bucket（分類資料夾）組織，並透過 `/setup-matt-pocock-skills` 產生的各 repo（程式碼儲存庫）專屬設定來使用。

## 用語 (Language)

**Issue tracker**（議題追蹤工具）：
存放一個 repo 的 issue 的工具：GitHub Issues、Linear、本機的 `.scratch/` markdown 慣例，或類似的東西。`to-tickets`、`to-spec` 和 `triage` 這類 skill 會讀取和寫入它。
_避免使用_：backlog manager、backlog backend、issue host

**Issue**（議題）：
**Issue tracker** 裡一個被追蹤的工作單位：一個 bug、任務、spec（規格），或由 `to-tickets` 產出的切片。
_避免使用_：ticket（只有在引用把它們叫做 ticket 的外部系統時，或用於 **Decision ticket** 時才用，見下方）

**Decision ticket**（決策 ticket）：
一個 `wayfinder` 單位：`wayfinder:map` 底下的一個子 **Issue**，裡面裝的是一個*問題*，它的結論是一個決策，而不是一塊要去執行的建置切片。**decision**（決策）這個修飾詞，就是讓它和 implementation ticket（實作 ticket）區分開來的關鍵；`wayfinder` 先介紹這個詞，之後就只用「ticket」。

**Triage role**（分類角色）：
在 triage（分類處理）期間貼在 **Issue** 上的標準狀態機標籤（例如 `needs-triage`、`ready-for-afk`）。每個 role 都透過 `docs/agents/triage-labels.md` 對應到 **Issue tracker** 裡真正的標籤字串。

## 關係 (Relationships)

- 一個 **Issue tracker** 存放多個 **Issue**
- 一個 **Issue** 同一時間只帶一個 **Triage role**
- 一個 **Decision ticket** 是一個 **Issue**（`wayfinder:map` 的子項目）

## 已標記的歧義 (Flagged ambiguities)

- 「backlog」以前同時用來指存放 issue 的*工具*，以及工具裡的*工作內容*。已解決：工具叫 **Issue tracker**；「backlog」不再當作領域術語使用。
- 「backlog backend」／「backlog manager」。已解決：合併成 **Issue tracker**。
