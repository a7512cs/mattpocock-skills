> 繁體中文翻譯。原文：[tests.md](../../../../skills/engineering/tdd/tests.md)

# 好的測試和壞的測試 (Good and Bad Tests)

## 好的測試 (Good Tests)

**整合風格 (Integration-style)**：透過真實的 interface（介面）測試，而不是內部零件的 mock（模擬物件）。

```typescript
// GOOD: Tests observable behavior
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

特徵：

- 測試使用者/呼叫者在乎的行為
- 只使用公開 API
- 能撐過內部的 refactor（重構）
- 描述 WHAT（做什麼），不是 HOW（怎麼做）
- 每個測試一個邏輯上的斷言

## 壞的測試 (Bad Tests)

**implementation（實作）細節測試 (Implementation-detail tests)**：和內部結構耦合。

```typescript
// BAD: Tests implementation details
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

警訊：

- mock 內部的協作者
- 測試 private 方法
- 對呼叫次數/順序做斷言
- refactor 時測試壞了，但行為沒有改變
- 測試名稱描述 HOW（怎麼做）而不是 WHAT（做什麼）
- 透過外部手段驗證，而不是透過 interface

```typescript
// BAD: Bypasses interface to verify
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GOOD: Verifies through interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**套套邏輯測試 (Tautological tests)**：預期值只是把 implementation 重新說一遍，所以測試在結構上必然通過。

```typescript
// BAD: Expected value is recomputed the way the code computes it
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// GOOD: Expected value is an independent, known literal
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
