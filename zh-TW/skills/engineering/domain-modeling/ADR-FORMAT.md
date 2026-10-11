> 繁體中文翻譯。原文：[ADR-FORMAT.md](../../../../skills/engineering/domain-modeling/ADR-FORMAT.md)

# ADR 格式 (ADR Format)

ADR（架構決策紀錄）放在 `docs/adr/`，使用連續編號：`0001-slug.md`、`0002-slug.md` 等等。

延遲建立 `docs/adr/` 目錄：只在需要第一份 ADR 時才建立。

## 範本 (Template)

```md
# {決策的簡短標題}

{1 到 3 句：背景是什麼、我們決定了什麼，以及為什麼。}
```

就這樣。一份 ADR 可以只有一段。價值在於記錄*有*做了一個決定，以及*為什麼*，而不是在於填滿各個段落。

## 選用段落 (Optional sections)

只有在它們真的有價值時才加入。大部分 ADR 不需要它們。

- **Status**（狀態）frontmatter（檔頭中繼資料，值為 `proposed | accepted | deprecated | superseded by ADR-NNNN`）：當決策會被重新檢視時很有用
- **Considered Options**（考慮過的選項）：只在被否決的替代方案值得記住時
- **Consequences**（後果）：只在需要指出不明顯的下游影響時

## 編號 (Numbering)

掃描 `docs/adr/`，找出目前最大的編號，然後加一。

## 何時提議 ADR (When to offer an ADR)

以下三點都必須成立：

1. **難以反悔**：之後改變心意的成本是有意義的
2. **沒有背景就會讓人意外**：未來的讀者看到程式碼時會想「他們到底為什麼要這樣做？」
3. **真實取捨的結果**：確實存在其他選項，而你基於特定理由挑了其中一個

如果一個決定很容易反悔，就跳過：你直接反悔就好。如果它不令人意外，就沒有人會想知道為什麼。如果當時沒有真正的替代方案，除了「我們做了顯而易見的事」之外，就沒有什麼好記錄的。

### 什麼算數 (What qualifies)

- **架構的形狀**。「我們使用 monorepo。」「write model 是 event-sourced，read model 會投影到 Postgres。」
- **context（領域上下文）之間的整合模式**。「Ordering 和 Billing 透過 domain event 溝通，不用同步的 HTTP。」
- **會帶來鎖定的技術選擇**。資料庫、message bus、auth provider、部署目標。不是每個函式庫都算：只有那些要花一季才能換掉的。
- **邊界與範圍的決定**。「Customer 資料由 Customer context 擁有；其他 context 只能用 ID 引用它。」明確的「不」和「是」一樣有價值。
- **刻意偏離顯而易見的路**。「我們用手寫 SQL 而不用 ORM，因為 X。」任何一個合理的讀者會以為是相反做法的事。這些能防止下一個工程師去「修正」某個刻意的設計。
- **程式碼裡看不到的限制**。「因為合規要求，我們不能用 AWS。」「因為合作夥伴 API 的合約，回應時間必須低於 200ms。」
- **否決理由不明顯時，被否決的替代方案**。如果你考慮過 GraphQL，卻因為一些微妙的理由選了 REST，就記下來；否則六個月後又會有人提議用 GraphQL。
