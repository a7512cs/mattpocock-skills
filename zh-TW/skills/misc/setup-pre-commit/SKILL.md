---
name: setup-pre-commit
description: Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, and tests in the current repo. Use when user wants to add pre-commit hooks, set up Husky, configure lint-staged, or add commit-time formatting/typechecking/testing.
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/misc/setup-pre-commit/SKILL.md)
>
> **description 中譯：** 在目前的 repo（程式碼儲存庫）中設定 Husky pre-commit hook（提交前掛鉤），搭配 lint-staged（Prettier）、型別檢查和測試。當使用者想加入 pre-commit hook、設定 Husky、設定 lint-staged，或加入在 commit（提交）時執行的格式化／typecheck（型別檢查）／測試時使用。

# 設定 Pre-Commit Hooks (Setup Pre-Commit Hooks)

## 這會設定什麼 (What This Sets Up)

- **Husky** pre-commit hook
- **lint-staged**，對所有已暫存（staged）的檔案執行 Prettier
- **Prettier** 設定（如果還沒有的話）
- pre-commit hook 中的 **typecheck** 和 **test** script

## 步驟 (Steps)

### 1. 偵測套件管理器 (Detect package manager)

檢查是否有 `package-lock.json`（npm）、`pnpm-lock.yaml`（pnpm）、`yarn.lock`（yarn）、`bun.lockb`（bun）。用存在的那一個。不確定時預設用 npm。

### 2. 安裝相依套件 (Install dependencies)

安裝成 devDependencies：

```
husky lint-staged prettier
```

### 3. 初始化 Husky (Initialize Husky)

```bash
npx husky init
```

這會建立 `.husky/` 目錄，並在 package.json 中加入 `prepare: "husky"`。

### 4. 建立 `.husky/pre-commit` (Create `.husky/pre-commit`)

寫入這個檔案（Husky v9 以上不需要 shebang）：

```
npx lint-staged
npm run typecheck
npm run test
```

**調整**：把 `npm` 換成偵測到的套件管理器。如果 repo 的 package.json 中沒有 `typecheck` 或 `test` script，就省略那幾行，並告訴使用者。

### 5. 建立 `.lintstagedrc` (Create `.lintstagedrc`)

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

### 6. 建立 `.prettierrc`（如果還沒有） (Create `.prettierrc` (if missing))

只有在沒有任何 Prettier 設定時才建立。使用這些預設值：

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

### 7. 驗證 (Verify)

- [ ] `.husky/pre-commit` 存在且可執行
- [ ] `.lintstagedrc` 存在
- [ ] package.json 中的 `prepare` script 是 `"husky"`
- [ ] `prettier` 設定存在
- [ ] 執行 `npx lint-staged` 驗證它能運作

### 8. Commit

把所有修改過／新建立的檔案加入暫存區（stage），並用這個訊息 commit：`Add pre-commit hooks (husky + lint-staged + prettier)`

這會跑過新的 pre-commit hook：是一個確認一切都正常運作的好 smoke test（冒煙測試）。

## 備註 (Notes)

- Husky v9 以上的 hook 檔案不需要 shebang
- `prettier --ignore-unknown` 會跳過 Prettier 無法解析的檔案（圖片等）
- pre-commit 會先執行 lint-staged（快速，只處理已暫存的檔案），然後才執行完整的 typecheck 和測試
