---
name: codebase-design
description: Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find deepening opportunities, decide where a seam goes, make code more testable or AI-navigable, or when another skill needs the deep-module vocabulary.
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/codebase-design/SKILL.md)
>
> **description 中譯：** 設計 deep module（深模組）的共同詞彙。當使用者想設計或改善某個 module（模組）的 interface（介面）、找出 deepening opportunities（深化機會）、決定 seam（接縫）要放在哪裡、讓程式碼更容易測試或更容易讓 AI 導覽，或其他 skill（技能）需要 deep-module 詞彙時使用。

# Codebase Design

設計 **deep modules**：在小小的 interface 後面放大量的行為，放在乾淨的 seam 上，並且能透過那個 interface 來測試。凡是在設計或重新組織程式碼的地方，都使用這套語言和這些原則。目標是：給呼叫端 leverage（槓桿），給維護者 locality（局部性），給所有人可測試性。

## Glossary

精確使用這些術語：不要用 "component"、"service"、"API" 或 "boundary" 來替代。一致的語言就是全部的重點。

**Module**：任何有 interface 和 implementation（實作）的東西。刻意不分規模：一個函式、class、package，或跨越多層的切片。_Avoid_（避免使用）：unit、component、service。

**Interface**：呼叫端要正確使用這個 module 所必須知道的一切：型別簽章，但也包括不變條件、順序限制、錯誤模式、必要的設定，以及效能特性。_Avoid_：API、signature（太窄了，它們只指型別層級的表面）。

**Implementation**：module 裡面的東西，也就是它的程式碼本體。和 **Adapter**（轉接器）不同：一個東西可以是帶著大 implementation 的小 adapter（一個 Postgres repo），也可以是帶著小 implementation 的大 adapter（一個記憶體內的 fake）。當主題是 seam 時就用 "adapter"；其他情況用 "implementation"。

**Depth**（深度）：interface 上的 leverage。呼叫端（或測試）每學一單位的 interface，能動用的行為量。當大量行為位於小 interface 後面時，module 就是 **deep**（深）的；當 interface 幾乎和 implementation 一樣複雜時，就是 **shallow**（淺）的。

**Seam** _(Michael Feathers)_：一個你不用在那個地方編輯、就能改變行為的地方；也就是 module 的 interface 所在的*位置*。seam 要放在哪裡，本身就是一個設計決定，和 seam 後面放什麼是兩回事。_Avoid_：boundary（已經被 DDD 的 bounded context 佔用，意思過載）。

**Adapter**：在某個 seam 上滿足 interface 的具體東西。描述的是*角色*（它填哪個位置），不是本質（裡面有什麼）。

**Leverage**：呼叫端從 depth 得到的好處。每學一單位 interface，就得到更多能力。一個 implementation 在 N 個呼叫點和 M 個測試上都能回本。

**Locality**：維護者從 depth 得到的好處。改動、bug、知識和驗證都集中在一個地方，而不是散落在各個呼叫端。修一次，處處都修好。

## 深 vs 淺 (Deep vs shallow)

**Deep module** = 小 interface + 大量 implementation：

```
┌─────────────────────┐
│   Small Interface   │  ← 方法少、參數簡單
├─────────────────────┤
│                     │
│  Deep Implementation│  ← 藏起複雜的邏輯
│                     │
└─────────────────────┘
```

**Shallow module** = 大 interface + 很少 implementation（避免）：

```
┌─────────────────────────────────┐
│       Large Interface           │  ← 方法多、參數複雜
├─────────────────────────────────┤
│  Thin Implementation            │  ← 只是直接轉傳
└─────────────────────────────────┘
```

設計 interface 時，問自己：

- 我能減少 method 的數量嗎？
- 我能簡化參數嗎？
- 我能把更多複雜度藏在裡面嗎？

## 原則 (Principles)

- **Depth 是 interface 的屬性，不是 implementation 的屬性**。一個 deep module 內部可以由小的、可以 mock（模擬）的、可替換的部件組成；只是那些部件不屬於 interface。一個 module 可以有 **internal seams**（內部 seam：只屬於它的 implementation，供它自己的測試使用），也可以有位於 interface 的 **external seam**（外部 seam）。
- **The deletion test**（刪除測試）。想像把這個 module 刪掉。如果複雜度消失了，它就只是個轉手的通道。如果複雜度在 N 個呼叫端重新出現，那它就有存在的價值。
- **Interface 就是測試面**。呼叫端和測試跨過同一個 seam。如果你想要*越過* interface 去測試，這個 module 的形狀可能就錯了。
- **一個 adapter 代表假想的 seam。兩個 adapter 代表真的 seam**。除非真的有東西會在這個 seam 上變化，否則不要引入 seam。

## 為可測試性而設計 (Designing for testability)

好的 interface 讓測試變得自然：

1. **接收依賴，不要自己建立依賴。**

   ```typescript
   // Testable
   function processOrder(order, paymentGateway) {}

   // Hard to test
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **回傳結果，不要產生副作用。**

   ```typescript
   // Testable
   function calculateDiscount(cart): Discount {}

   // Hard to test
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **小的表面積**。method 越少 = 需要的測試越少。參數越少 = 測試準備越簡單。

## 關係 (Relationships)

- 一個 **Module** 恰好有一個 **Interface**（它呈現給呼叫端和測試的表面）。
- **Depth** 是 **Module** 的屬性，以它的 **Interface** 來衡量。
- **Seam** 是 **Module** 的 **Interface** 所在的地方。
- **Adapter** 位於 **Seam** 上，並滿足 **Interface**。
- **Depth** 為呼叫端產生 **Leverage**，為維護者產生 **Locality**。

## 被否決的說法 (Rejected framings)

- **把 depth 當成 implementation 行數與 interface 行數的比例**（Ousterhout）：這會鼓勵把 implementation 灌水。我們改用「depth 即 leverage」的說法。
- **把 "Interface" 當成 TypeScript 的 `interface` 關鍵字或 class 的 public method**：太窄了：這裡的 interface 包括呼叫端必須知道的每一個事實。
- **"Boundary"**：已經被 DDD 的 bounded context 佔用，意思過載。要說 **seam** 或 **interface**。

## 更深入 (Going deeper)

- **在考慮依賴的前提下深化一群 module**，見 [DEEPENING.md](DEEPENING.md)：依賴類別、seam 紀律，以及「取代，不要疊加」的測試方式。
- **探索替代的 interface**，見 [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md)：平行啟動多個 sub-agent（子代理），用好幾種截然不同的方式設計 interface，然後在 depth、locality 和 seam 的位置上比較。
