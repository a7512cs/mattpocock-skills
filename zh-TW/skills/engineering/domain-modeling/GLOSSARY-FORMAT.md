> 繁體中文翻譯。原文：[GLOSSARY-FORMAT.md](../../../../skills/engineering/domain-modeling/GLOSSARY-FORMAT.md)

# GLOSSARY.md 格式 (GLOSSARY.md Format)

## 結構 (Structure)

```md
# {Context 名稱}

{用一到兩句話描述這個 context 是什麼，以及它為什麼存在。}

## Language

**Order**:
{用一到兩句話描述這個用語}
_Avoid_: Purchase, transaction

**Invoice**:
送貨後寄給客戶的付款請求。
_Avoid_: Bill, payment request

**Customer**:
下訂單的個人或組織。
_Avoid_: Client, buyer, account
```

## 規則 (Rules)

- **要有主見**。當同一個概念有多個詞時，挑最好的那個，把其他的列在 `_Avoid_`（避免使用）底下。
- **定義要精簡**。最多一到兩句。定義它**是**什麼，而不是它做什麼。
- **只收錄這個專案 context（領域上下文）特有的用語**。一般的程式設計概念（timeout、錯誤類型、工具模式）即使專案大量使用，也不屬於這裡。加入一個用語之前，先問：這是這個 context 獨有的概念，還是一般的程式設計概念？只有前者才屬於這裡。
- 當自然的群組浮現時，**把用語分組放在子標題底下**。如果所有用語都屬於同一個緊密的領域，平鋪的清單也可以。

## 單一 vs 多 context 的 repo (Single vs multi-context repos)

**單一 context（大部分 repo）：** 在 repo（儲存庫）根目錄放一個 `GLOSSARY.md`。

**多個 context：** 在 repo 根目錄放一個 `GLOSSARY-MAP.md`，列出各個 context、它們在哪裡，以及它們彼此之間的關係：

```md
# Glossary Map

## Contexts

- [Ordering](./src/ordering/GLOSSARY.md): 接收並追蹤客戶訂單
- [Billing](./src/billing/GLOSSARY.md): 開立發票並處理付款
- [Fulfillment](./src/fulfillment/GLOSSARY.md): 管理倉庫揀貨與出貨

## Relationships

- **Ordering → Fulfillment**: Ordering 發出 `OrderPlaced` event；Fulfillment 消費這些 event 來開始揀貨
- **Fulfillment → Billing**: Fulfillment 發出 `ShipmentDispatched` event；Billing 消費這些 event 來開立發票
- **Ordering ↔ Billing**: 共用 `CustomerId` 和 `Money` 的型別
```

這個 skill（技能）會推斷適用哪一種結構：

- 如果 `GLOSSARY-MAP.md` 存在，就讀它來找出各個 context
- 如果只有根目錄的 `GLOSSARY.md`，就是單一 context
- 如果兩者都不存在，就在第一個用語確定時，延遲建立一個根目錄的 `GLOSSARY.md`

當有多個 context 時，推斷目前的主題跟哪一個有關。如果不清楚，就問。
