> 繁體中文翻譯。原文：[domain.md](../../../../skills/engineering/setup-matt-pocock-skills/domain.md)

# 領域文件 (Domain Docs)

engineering（工程類 bucket）的 skill（技能）在探索 codebase（程式碼庫）時，應該如何使用這個 repo（程式碼倉庫）的領域文件。

## 探索之前，先讀這些 (Before exploring, read these)

- repo 根目錄的 **`GLOSSARY.md`**，或
- 如果 repo 根目錄有 **`GLOSSARY-MAP.md`**：它會為每個 context（脈絡）各指向一個 `GLOSSARY.md`。讀每一個跟主題相關的。
- **`docs/adr/`**：讀那些涉及你即將工作的區域的 ADR（架構決策紀錄）。在 multi-context 的 repo 中，也要檢查 `src/<context>/docs/adr/`，看有沒有限定在某個 context 範圍內的決定。

如果這些檔案有任何一個不存在，**就默默繼續**。不要指出它們不存在；不要建議事先建立它們。`/domain-modeling` skill（透過 `/grill-with-docs` 和 `/improve-codebase-architecture` 觸及）會在術語或決定真正被確定時，才延遲建立它們。

## 檔案結構 (File structure)

single-context 的 repo（大多數 repo）：

```
/
├── GLOSSARY.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

multi-context 的 repo（根目錄有 `GLOSSARY-MAP.md`）：

```
/
├── GLOSSARY-MAP.md
├── docs/adr/                          ← 整個系統層級的決定
└── src/
    ├── ordering/
    │   ├── GLOSSARY.md
    │   └── docs/adr/                  ← 特定 context 的決定
    └── billing/
        ├── GLOSSARY.md
        └── docs/adr/
```

## 使用 glossary 的詞彙 (Use the glossary's vocabulary)

當你的輸出要命名一個領域概念時（在 Issue 標題、refactor（重構）提案、假設、測試名稱中），使用 `GLOSSARY.md` 中定義的術語。不要偏離到 glossary（詞彙表）明確避免使用的同義詞。

如果你需要的概念還不在 glossary 裡，那是一個訊號：要嘛你在發明專案沒在用的語言（重新考慮），要嘛真的有缺口（記下來交給 `/domain-modeling`）。

## 標出 ADR 衝突 (Flag ADR conflicts)

如果你的輸出跟某個現有的 ADR 矛盾，就明確提出來，而不是默默覆蓋它：

> *與 ADR-0007（event-sourced orders）矛盾，但值得重新討論，因為……*
