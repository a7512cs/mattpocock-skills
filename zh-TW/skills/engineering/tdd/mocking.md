> 繁體中文翻譯。原文：[mocking.md](../../../../skills/engineering/tdd/mocking.md)

# 什麼時候該 Mock (When to Mock)

只在**系統邊界**上 mock（模擬物件）：

- 外部 API（付款、email 等）
- 資料庫（有時候：優先用測試 DB）
- 時間/隨機性
- 檔案系統（有時候）

不要 mock：

- 你自己的 class/module（模組）
- 內部的協作者
- 任何你能控制的東西

## 為可 mock 性而設計 (Designing for Mockability)

在系統邊界上，設計容易 mock 的 interface（介面）：

**1. 使用依賴注入 (dependency injection)**

把外部依賴從外面傳進來，而不是在內部建立它們：

```typescript
// Easy to mock
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Hard to mock
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. 偏好 SDK 風格的 interface，而不是通用的 fetcher**

為每個外部操作建立專屬的函式，而不是一個帶有條件邏輯的通用函式：

```typescript
// GOOD: Each function is independently mockable
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// BAD: Mocking requires conditional logic inside the mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

SDK 做法的意思是：
- 每個 mock 只回傳一種特定形狀
- 測試設定中沒有條件邏輯
- 比較容易看出一個測試會用到哪些 endpoint
- 每個 endpoint 都有型別安全
