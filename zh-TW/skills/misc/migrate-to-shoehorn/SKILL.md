---
name: migrate-to-shoehorn
description: Migrate test files from `as` type assertions to @total-typescript/shoehorn. Use when user mentions shoehorn, wants to replace `as` in tests, or needs partial test data.
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/misc/migrate-to-shoehorn/SKILL.md)
>
> **description 中譯：** 把測試檔案從 `as` 型別斷言遷移到 @total-typescript/shoehorn。當使用者提到 shoehorn、想取代測試中的 `as`，或需要部分的測試資料時使用。

# 遷移到 Shoehorn (Migrate to Shoehorn)

## 為什麼用 shoehorn？ (Why shoehorn?)

`shoehorn` 讓你在測試中傳入部分資料，同時讓 TypeScript 滿意。它用型別安全的替代方案取代 `as` 斷言。

**只用於測試程式碼。** 絕不要在正式環境的程式碼中使用 shoehorn。

在測試中使用 `as` 的問題：

- 大家被訓練成不要用它
- 必須手動指定目標型別
- 刻意傳入錯誤資料時要用雙重 as（`as unknown as Type`）

## 安裝 (Install)

```bash
npm i @total-typescript/shoehorn
```

## 遷移模式 (Migration patterns)

### 大型物件但只需要少數屬性 (Large objects with few needed properties)

之前：

```ts
type Request = {
  body: { id: string };
  headers: Record<string, string>;
  cookies: Record<string, string>;
  // ...20 more properties
};

it("gets user by id", () => {
  // Only care about body.id but must fake entire Request
  getUser({
    body: { id: "123" },
    headers: {},
    cookies: {},
    // ...fake all 20 properties
  });
});
```

之後：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

it("gets user by id", () => {
  getUser(
    fromPartial({
      body: { id: "123" },
    }),
  );
});
```

### `as Type` → `fromPartial()`

之前：

```ts
getUser({ body: { id: "123" } } as Request);
```

之後：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

getUser(fromPartial({ body: { id: "123" } }));
```

### `as unknown as Type` → `fromAny()`

之前：

```ts
getUser({ body: { id: 123 } } as unknown as Request); // wrong type on purpose
```

之後：

```ts
import { fromAny } from "@total-typescript/shoehorn";

getUser(fromAny({ body: { id: 123 } }));
```

## 各自的使用時機 (When to use each)

| 函式 | 使用情境 |
| --- | --- |
| `fromPartial()` | 傳入仍能通過型別檢查的部分資料 |
| `fromAny()` | 傳入刻意錯誤的資料（保留自動完成） |
| `fromExact()` | 強制完整物件（之後再換成 fromPartial） |

## 工作流程 (Workflow)

1. **蒐集需求**，問使用者：
   - 哪些測試檔案中有造成問題的 `as` 斷言？
   - 他們是否在處理只有部分屬性重要的大型物件？
   - 他們是否需要為了錯誤測試而傳入刻意錯誤的資料？

2. **安裝並遷移**：
   - [ ] 安裝：`npm i @total-typescript/shoehorn`
   - [ ] 找出有 `as` 斷言的測試檔案：`grep -r " as [A-Z]" --include="*.test.ts" --include="*.spec.ts"`
   - [ ] 把 `as Type` 換成 `fromPartial()`
   - [ ] 把 `as unknown as Type` 換成 `fromAny()`
   - [ ] 加入從 `@total-typescript/shoehorn` 的 import
   - [ ] 執行型別檢查來驗證
