---
name: scaffold-exercises
description: Create exercise directory structures with sections, problems, solutions, and explainers that pass linting. Use when user wants to scaffold exercises, create exercise stubs, or set up a new course section.
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/misc/scaffold-exercises/SKILL.md)
>
> **description 中譯：** 建立能通過 lint（靜態檢查）的練習題目錄結構，包含章節（section）、題目（problem）、解答（solution）和說明（explainer）。當使用者想建立練習題骨架、建立練習題 stub（空殼），或設定新的課程章節時使用。

# 建立練習題骨架 (Scaffold Exercises)

建立能通過 `pnpm ai-hero-cli internal lint` 的練習題目錄結構，然後用 `git commit` 進行 commit（提交）。

## 目錄命名 (Directory naming)

- **章節**：`exercises/` 裡面的 `XX-section-name/`（例如 `01-retrieval-skill-building`）
- **練習題**：章節裡面的 `XX.YY-exercise-name/`（例如 `01.03-retrieval-with-bm25`）
- 章節編號 = `XX`，練習題編號 = `XX.YY`
- 名稱使用 dash-case（小寫、連字號）

## 練習題變體 (Exercise variants)

每個練習題至少需要下列其中一個子資料夾：

- `problem/`：學生的工作區，含有 TODO
- `solution/`：參考 implementation（實作）
- `explainer/`：概念性的教材，沒有 TODO

建立 stub 時，除非計畫另有指定，否則預設使用 `explainer/`。

## 必要檔案 (Required files)

每個子資料夾（`problem/`、`solution/`、`explainer/`）都需要一個 `readme.md`，而且它：

- **不是空的**（必須有實際內容，即使只有一行標題也可以）
- 沒有失效連結

建立 stub 時，建立一個只有標題和描述的最小 readme：

```md
# 練習題標題

描述寫在這裡
```

如果子資料夾有程式碼，它還需要一個 `main.ts`（超過 1 行）。但如果是 stub，只有 readme 的練習題也可以。

## 工作流程 (Workflow)

1. **解析計畫**：擷取章節名稱、練習題名稱和變體類型
2. **建立目錄**：對每個路徑執行 `mkdir -p`
3. **建立 stub readme**：每個變體資料夾一個附標題的 `readme.md`
4. **執行 lint**：用 `pnpm ai-hero-cli internal lint` 驗證
5. **修正所有錯誤**：反覆修改直到 lint 通過

## Lint 規則摘要 (Lint rules summary)

linter（`pnpm ai-hero-cli internal lint`）會檢查：

- 每個練習題都有子資料夾（`problem/`、`solution/`、`explainer/`）
- `problem/`、`explainer/` 或 `explainer.1/` 至少有一個存在
- 主要子資料夾中的 `readme.md` 存在且不是空的
- 沒有 `.gitkeep` 檔案
- 沒有 `speaker-notes.md` 檔案
- readme 中沒有失效連結
- readme 中沒有 `pnpm run exercise` 指令
- 每個子資料夾都需要 `main.ts`，除非它只有 readme

## 移動／重新命名練習題 (Moving/renaming exercises)

重新編號或移動練習題時：

1. 用 `git mv`（不是 `mv`）重新命名目錄：這樣可以保留 git 歷史
2. 更新數字前綴以維持順序
3. 移動後重新執行 lint

範例：

```bash
git mv exercises/01-retrieval/01.03-embeddings exercises/01-retrieval/01.04-embeddings
```

## 範例：依照計畫建立 stub (Example: stubbing from a plan)

假設有一份像這樣的計畫：

```
Section 05: Memory Skill Building
- 05.01 Introduction to Memory
- 05.02 Short-term Memory (explainer + problem + solution)
- 05.03 Long-term Memory
```

建立：

```bash
mkdir -p exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer
mkdir -p exercises/05-memory-skill-building/05.02-short-term-memory/{explainer,problem,solution}
mkdir -p exercises/05-memory-skill-building/05.03-long-term-memory/explainer
```

然後建立 readme stub：

```
exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer/readme.md -> "# Introduction to Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/explainer/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/problem/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/solution/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.03-long-term-memory/explainer/readme.md -> "# Long-term Memory"
```
