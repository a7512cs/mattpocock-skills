---
name: domain-modeling
description: Build and sharpen a project's domain model. Use when discussing codebase terminology, writing or editing a GLOSSARY.md, or recording or editing an ADR.
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/domain-modeling/SKILL.md)
>
> **description 中譯：** 建立並磨利專案的 domain model（領域模型）。在討論 codebase（程式碼庫）用語、撰寫或編輯 GLOSSARY.md，或記錄或編輯 ADR（架構決策紀錄）時使用。

# Domain Modeling

在你設計的同時，主動建立並磨利專案的 domain model。這是*主動*的紀律：挑戰用語、發明極端情況的情境，並在 glossary（詞彙表）和決策一成形的當下就把它們寫下來。（只是*讀* `GLOSSARY.md` 來取得詞彙，不算這個 skill（技能）：那是任何 skill 都能做的一行習慣。這個 skill 是用在你要改變這個模型時，而不只是使用它。）

## 檔案結構 (File structure)

大部分 repo（儲存庫）只有單一個 context（領域上下文）：

```
/
├── GLOSSARY.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

如果根目錄有 `GLOSSARY-MAP.md`，代表這個 repo 有多個 context。這份地圖指出每個 context 位於哪裡：

```
/
├── GLOSSARY-MAP.md
├── docs/
│   └── adr/                          ← 全系統層級的決策
├── src/
│   ├── ordering/
│   │   ├── GLOSSARY.md
│   │   └── docs/adr/                 ← 特定 context 的決策
│   └── billing/
│       ├── GLOSSARY.md
│       └── docs/adr/
```

延遲建立檔案：只在你有東西要寫時才建立。如果沒有 `GLOSSARY.md`，就在第一個用語確定時建立一個。如果沒有 `docs/adr/`，就在需要第一份 ADR 時建立它。

## 在 session 進行中 (During the session)

### 拿 glossary 來挑戰 (Challenge against the glossary)

當使用者用了一個跟 `GLOSSARY.md` 既有語言衝突的用語時，立刻指出來。「你的 glossary 把『cancellation』定義成 X，但你似乎是指 Y。到底是哪一個？」

### 磨利模糊的語言 (Sharpen fuzzy language)

當使用者用了含糊或一詞多義的用語時，提出一個精確的標準用語。「你說的是『account』：你是指 Customer 還是 User？那是兩個不同的東西。」

### 討論具體情境 (Discuss concrete scenarios)

當在討論領域中的關係時，用具體的情境對它們做壓力測試。發明能探測極端情況的情境，逼使用者把概念之間的界線講精確。

### 和程式碼交叉比對 (Cross-reference with code)

當使用者說明某件事是怎麼運作的時候，檢查程式碼是否同意。如果你發現矛盾，就把它提出來：「你的程式碼會取消整筆 Order，但你剛才說可以部分取消。哪個才對？」

### 即時更新 GLOSSARY.md (Update GLOSSARY.md inline)

當一個用語確定下來時，就在當下更新 `GLOSSARY.md`。不要把它們累積起來批次處理：它們一發生就記下來。使用 [GLOSSARY-FORMAT.md](./GLOSSARY-FORMAT.md) 裡的格式。

`GLOSSARY.md` 應該完全不含 implementation（實作）細節。不要把 `GLOSSARY.md` 當成 spec（規格）、草稿本，或存放 implementation 決策的地方。它是一份 glossary，除此之外什麼都不是。

### 謹慎地提議 ADR (Offer ADRs sparingly)

只有在以下三點全部成立時，才提議建立 ADR：

1. **難以反悔**：之後改變心意的成本是有意義的
2. **沒有背景就會讓人意外**：未來的讀者會想知道「他們為什麼要這樣做？」
3. **真實取捨的結果**：確實存在其他選項，而你基於特定理由挑了其中一個

只要三者中缺了任何一個，就跳過 ADR。使用 [ADR-FORMAT.md](./ADR-FORMAT.md) 裡的格式。
