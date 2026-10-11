---
name: setup-ts-deep-modules
description: Wire dependency-cruiser into a TypeScript repo so each package is a deep module, with implementation hidden in subfolders and reachable only through its entry-point files. User-invoked.
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/in-progress/setup-ts-deep-modules/SKILL.md)
>
> **description 中譯：** 把 dependency-cruiser 接進 TypeScript repo（程式碼儲存庫），讓每個 package（套件）都是一個 deep module（深模組：小介面背後藏著大量行為），implementation（實作）藏在子資料夾裡，只能透過它的 entry-point（進入點）檔案存取。User-invoked（由使用者手動呼叫）。

# 設定 TS Deep Modules (Setup TS Deep Modules)

讓這個 repo 裡的每個 package 都成為 **deep module**：小 interface（介面）背後有大量行為。一個 package 的公開表面是它的 **entry points**（進入點，也就是 package 根目錄下的檔案），子資料夾裡的所有東西都是隱藏的。這個 skill（技能）會安裝 [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) 以及讓 entry point 成為唯一入口的規則，然後證明這些規則真的有作用。

關於詞彙（deep module、interface、seam（接縫）、depth（深度）），用 "codebase-design" 呼叫 Skill tool，並在整個過程中使用它的用語。

## 這套規則強制的結構 (The shape this enforces)

```
src/packages/
  <name>/
    index.ts        ← 一個 entry point（公開）。從外部 import 這個。
    client.ts       ← 另一個 entry point。package 可以公開「好幾個」。
    lib/            ← implementation：對外隱藏，彼此之間可以自由 import。
    tests/          ← 放在一起的 test 與 fixture（是子資料夾，所以是私有的）。
```

公開表面是 package 的**根目錄檔案**，而不是某一個指定的 `index.ts`。依照慣例，implementation 放在 `lib/`，test 放在 `tests/`，讓每個 package 都有相同的雙資料夾結構。不過規則本身是通用的：*任何*子資料夾裡的*任何東西*都是私有的，所以你永遠不需要為了新增資料夾而擴充設定。

四條規則，全部都是 `error`：

1. **Entry-point boundary**（entry point 邊界）：package 外部的程式碼（應用程式的程式碼或另一個 package）只能 import 該 package 的 entry point（它的根目錄檔案），絕不能 import 它子資料夾裡的任何東西。
2. **Intra-package freedom**（package 內部自由）：package 自己的檔案之間可以自由互相 import。
3. **Tests through the entry points**（test 只透過 entry point）：`<pkg>/tests/` 底下的檔案可以 import 任何 package 的 entry point 以及自己 `tests/` 裡的 fixture（測試固定資料），但絕不能 import 任何 package 子資料夾裡的內部檔案（連自己的也不行）。跨 package 的整合測試沒問題；深層 import 則不行。
4. **No cycles**（不可循環）：不能有依賴循環。

**用 entry point，不用 barrel（集中 re-export 的索引檔）。** 因為公開表面是*每一個*根目錄檔案，package 可以公開好幾個小的 entry point（`index.ts`、`client.ts`、`server.ts`），而不是把所有東西都塞進一個巨大的 `index.ts`。不鼓勵使用重新 export 整個子樹的 barrel 檔案；讓 entry point 保持小巧，並把 implementation 藏在子資料夾裡。

分層（哪些 package 可以依賴哪些）是一個*不同*的議題，在設定檔中只留了一段註解掉的骨架，讓這個 repo 自己填寫。

## 步驟 (Steps)

### 1. 偵測環境 (Detect the environment)

- **套件管理器**：`pnpm-lock.yaml` → pnpm，`yarn.lock` → yarn，`bun.lockb` → bun，否則用 npm。下面每個指令都用它來執行（`pnpm`/`yarn`/`npm run`/`bunx`）。
- **Packages 根目錄**：如果 `src/` 存在就用 `src/packages`，否則用 `packages`。如果 repo 已經有另一個明顯的慣例，先和使用者確認這個選擇。
- **既有設定**：檢查是否有 `.dependency-cruiser.*` 檔案。如果有，**不要**覆寫它：把四條規則和選項合併進去，並告訴使用者你加了什麼。

**完成條件：** 套件管理器、packages 根目錄和既有設定的狀態都已確認。

### 2. 安裝 dependency-cruiser (Install dependency-cruiser)

用偵測到的套件管理器，把 `dependency-cruiser` 安裝成 devDependency。

**完成條件：** `dependency-cruiser` 出現在 `devDependencies` 中。

### 3. 撰寫設定檔 (Write the config)

把 [`dependency-cruiser.config.cjs`](../../../../skills/in-progress/setup-ts-deep-modules/dependency-cruiser.config.cjs) 複製到 repo 根目錄，命名為 `.dependency-cruiser.cjs`。把 `PACKAGES_ROOT` 設成步驟 1 偵測到的根目錄。這些規則以路徑深度為基礎，而且不在乎副檔名，所以其他東西都不需要調整。

**完成條件：** `.dependency-cruiser.cjs` 存在且 `PACKAGES_ROOT` 正確，四條 forbidden（禁止）規則都在。

### 4. 接進檢查流程 (Wire it into the checks)

- 新增一個 `lint:boundaries` script：`depcruise <packages-root>`（或 `depcruise src`）。
- 把它併入 repo 的總檢查指令，也就是已經會跑 typecheck（型別檢查）的那一個（例如 `check` / `ci` / `validate` script）。**不要**動 `tsconfig`，也不要新增 path alias。
- 如果沒有總檢查 script，就新增 `lint:boundaries`，並告訴使用者把它加進 CI（持續整合）。

**完成條件：** `lint:boundaries` 存在，並且和 typecheck 在同一個指令中執行。

### 5. 建立範例 package 的骨架 (Scaffold the example package)

建立一個會被 commit（提交）的 `<packages-root>/example/`，作為可以直接複製使用的範本：

- `index.ts` 是一個 entry point。export 一個函式，把工作委派給內部檔案（讓這個 package 明顯是*深*的，而不是單純轉手）。
- `lib/impl.ts`：位於**子資料夾**裡的內部檔案，由 `index.ts` import，外部無法存取。
- `tests/example.test.ts` **只** import `../index`（一個 entry point），並針對公開函式做斷言。

告訴使用者這是一個起始範本，可以複製也可以刪除。

**完成條件：** 範例 package 存在，透過根目錄的 entry point 公開它的行為，並把 `impl` 藏在子資料夾中。

### 6. 證明規則真的有作用 (Prove the rules bite)

這是整個 skill 的完成標準：遇到違規卻不會失敗的設定毫無價值。

1. 執行 `lint:boundaries`。在乾淨的範例上，它必須**通過**。
2. 暫時在 `tests/example.test.ts` 加入一個深層 import（例如 `import { thing } from "../lib/impl"`）。再次執行 `lint:boundaries`；它必須以 `tests-through-entrypoints` **失敗**。
3. 還原這個深層 import。再執行一次，它必須**通過**。

**完成條件：** 你已經觀察到一次通過，接著在深層 import 上失敗一次，然後再通過一次。如果步驟 2 沒有失敗，代表規則沒有正確接上，所以要在結束前修好。

### 7. 把慣例寫成文件 (Document the convention)

**在 packages 資料夾裡**寫一份 `README.md`（`<packages-root>/README.md`，放在它所規範的 package 旁邊），內容涵蓋：`src/packages/<name>/` 的結構（entry point 在根目錄，`lib/` 放 implementation，`tests/` 放 test）、「只能透過 package 的 entry point（它的根目錄檔案）import」，以及如何執行 `lint:boundaries`。明確地**不鼓勵 barrel 檔案**：公開好幾個小的 entry point，而不是透過單一個 index 重新 export 整個子樹。內容只放那段可以複製的程式碼片段，加上四條規則，每條一段。

接著從 repo 的 agent（AI 代理）指示檔（有 `CLAUDE.md` 就用它，否則用 `AGENTS.md`；兩者都沒有就建立 `AGENTS.md`）加一個指向它的 **context pointer**（上下文指標：指向既有資料的參照）。一行就夠了，例如 `Packages are deep modules: see [src/packages/README.md](./src/packages/README.md) before adding or importing one.`。這就是讓 agent 能發現邊界規則、而不是被它絆倒的關鍵。

**完成條件：** `<packages-root>/README.md` 存在且不鼓勵 barrel，並且 repo 的 `CLAUDE.md`/`AGENTS.md` 有連結到它。

## 備註 (Notes)

- 設定檔中的 `$1` 反向參照（dependency-cruiser 的群組比對）就是讓 package 能存取自己的內部檔案、而外部不行的關鍵。不要把它們攤平成每個 package 各自獨立的規則。
- 公開或私有是由 **depth**（目錄深度）決定的：package 的根目錄檔案是 entry point；子資料夾裡的任何東西都是私有的。慣例上的子資料夾是 `lib/`（implementation）和 `tests/`，但規則並沒有把它們寫死：任何子資料夾都是私有的，所以新增資料夾永遠不需要修改設定。新增 entry point 只是新增一個根目錄檔案（不需要 barrel）。
- Package 是**扁平**的：根目錄下只有一層直接子項。package 的內部可以巢狀到任意深度；但 package 不能包含另一個 package。
- 使用 `.cjs`（不是 `.js`），這樣即使在 `"type": "module"` 的 repo 中，設定檔的 `module.exports` 也能運作。
