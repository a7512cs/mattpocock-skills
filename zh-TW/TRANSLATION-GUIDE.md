# 翻譯規則（zh-TW 鏡像）

這個資料夾是 repo 的繁體中文**學習用鏡像**。原文完全不動，skill 實際載入的永遠是 repo 根目錄下的英文原檔（`skills/`、`.claude-plugin/plugin.json`、`scripts/link-skills.sh` 都只看原檔）。所以翻譯只影響閱讀，不影響 skill 行為。

- 授權：原文為 MIT License，版權屬 Matt Pocock，見根目錄 [LICENSE](../LICENSE)。

## 0. 同步上游（每次上游發 release 時做）

分支安排：`main` = 上游的 `main` 加上 `zh-TW/` 資料夾，是預設 branch，別人 clone 下來就有中文。上游從不碰 `zh-TW/`，所以合併永遠不會 conflict。每次同步開一條暫時的 `sync/<日期>` branch，合併回 `main` 後刪掉。

不用手動記翻譯基準 commit：`main...upstream/main`（三個點）會自動從上次同步的位置開始比，只列出上游的改動，不含翻譯。

通知：在 GitHub 的 `mattpocock/skills` 頁面按 Watch → Custom → Releases。

1. 抓上游最新狀態，列出新的 commit 和改動的檔案（第一次要先 `git remote add upstream https://github.com/mattpocock/skills.git`）：

   ```bash
   git fetch upstream
   ```

   ```bash
   git log --oneline main..upstream/main
   ```

   ```bash
   git diff --stat main...upstream/main -- '*.md'
   ```

   先讀新增的 `.changeset/*.md` 或 `CHANGELOG.md` 新段落，它們是每個改動的一兩句摘要。

2. 開同步 branch，合併上游：

   ```bash
   git switch -c sync/<日期> main
   ```

   ```bash
   git merge upstream/main
   ```

3. 重翻。**只改英文有變動的段落，其他譯文保持不動**，這樣中文 diff 才看得出改了什麼。用 `git diff main...upstream/main -- <檔案>` 看單一檔案的英文改動（在第 2 步合併之前看，或改用 `git diff main -- <檔案>`）。新增的檔案整份翻，刪除的檔案連譯檔一起刪。
4. 驗證，必須全部通過：

   ```bash
   bash zh-TW/tools/verify.sh
   ```

5. commit 並 push，在**自己的 repo** 開 PR 到 `main`。base repository 要選 `a7512cs/mattpocock-skills`，GitHub 預設會選上游 `mattpocock/skills`，選錯就變成發 PR 給 Matt。不想開 PR 也可以直接合併：`git switch main && git merge --ff-only sync/<日期> && git push`。
6. 刪掉同步 branch（本機和 GitHub），再更新 plugin：

   ```bash
   claude plugin marketplace update mattpocock
   ```

   ```bash
   claude plugin update mattpocock-skills@mattpocock
   ```

`verify.sh` 檢查結構（缺檔、frontmatter、code fence、破折號、連結、粗體渲染、特殊檔名），**不會檢查譯文是否過時**。過時與否只能靠第 1 步的 diff。

## 1. 檔案位置

- 原檔 `<path>` 的翻譯放在 `zh-TW/<path>`，檔名完全相同（例如 `SKILL.md` 還是 `SKILL.md`）。
- **例外：harness 會自動載入的檔名不可沿用。** Claude Code 讀到子資料夾裡的檔案時，會自動載入該資料夾的 `CLAUDE.md`，Codex 對 `AGENTS.md` 也一樣，翻譯版會變成額外的 agent 指令。所以 `CLAUDE.md` 譯成 `CLAUDE.zh-TW.md`。`AGENTS.md` 在原 repo 只是指向 `CLAUDE.md` 的 symlink，不另外翻譯。鏡像裡也不可建立 `.claude/` 或 `.agents/skills/` 資料夾。
- 只翻 `.md` 檔。`.sh`、`.yaml`、`.json`、`.cjs` 不翻，不複製。
- **絕對不可修改任何原檔。**

## 2. 檔頭

### 有 frontmatter 的檔案（主要是 `SKILL.md`）

frontmatter（兩個 `---` 之間）**逐字保留英文原文，一個字都不改**。這樣才能對照原本的 trigger 寫法。

frontmatter 後面空一行，加上：

```md
> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/tdd/SKILL.md)
>
> **description 中譯：** <description 的中文翻譯>
```

如果 frontmatter 還有 `argument-hint`，再加一行 `> **argument-hint 中譯：** ...`。其他 key（`disable-model-invocation`、`metadata` 等）不用譯。

### 沒有 frontmatter 的檔案

第一行加 `> 繁體中文翻譯。原文：[<檔名>](<相對路徑>)`，空一行後接正文。

### 原文連結的相對路徑

從 `zh-TW/<path>` 指回原檔，`../` 的數量 = `<path>` 的目錄層數 + 1。例如：

| 翻譯檔 | 原文連結 |
| --- | --- |
| `zh-TW/README.md` | `../README.md` |
| `zh-TW/docs/engineering/tdd.md` | `../../../docs/engineering/tdd.md` |
| `zh-TW/skills/engineering/tdd/SKILL.md` | `../../../../skills/engineering/tdd/SKILL.md` |

## 3. 保持英文的內容

以下一律保留英文原文：

- **Skill 名稱與 slash command**：`tdd`、`grilling`、`grill-me`、`wayfinder`、`to-spec`、`to-tickets`、`triage`、`ask-matt`、`/setup-matt-pocock-skills` 等全部 skill 名。
- **檔名、路徑、程式碼、指令、設定 key、label 名稱**：`SKILL.md`、`CONTEXT.md`、`needs-triage`、`ready-for-afk`、`wayfinder:map` 等。
- **inline code**（反引號包住的內容）：一律逐字保留。
- **產品與工具名**：Claude Code、Codex、GitHub Copilot、Gemini CLI、GitHub Issues、Linear、GitLab 等。
- **本 repo 的專有術語**（見下表）。

### 術語表：保持英文

這些詞在 skill 裡有特定意思，翻成中文容易走味，所以保留英文：

| 類別 | 術語 |
| --- | --- |
| Agent 相關 | skill, agent, sub-agent / subagent, background agent, implementer subagent, model, harness, plugin, marketplace, frontmatter, description, trigger, prompt, context, context window, session, token, slash command, user-invoked, model-invoked, Claude Code plugin |
| Issue 流程 | Issue tracker, Issue, ticket, Decision ticket, child ticket, Triage role, triage, spec, PR, map, shared map, frontier, frontier query, blocking edges, task graph, out of scope, changeset, CHANGELOG |
| 設計 | seam, module, deep module, shallow module, interface, implementation, adapter, depth, leverage, locality, deepening opportunities, design tree, ADR, glossary, domain model, ubiquitous language, refactor, prototype |
| 測試 | TDD, red-green, red-green-refactor, tracer bullet, vertical slice, horizontal slicing, mock, fixture, test seam |
| 工作模式 | HITL, AFK, handoff, grilling, primary source, context pointer, navigation pointer |
| Git / 工程 | repo, codebase, commit, branch, integration branch, merge, rebase, diff, CI, lint, typecheck |
| Repo 結構 | bucket, promoted, engineering, productivity, misc, in-progress, deprecated |

規則：

- 表中術語在**每個檔案第一次出現**時，後面加中文括號說明，例如「**seam**（接縫：可以觀察行為的公開邊界）」或「**frontier**（前沿）」。之後直接用英文。
- 原文用**粗體**定義的術語（例如 `**design tree**`、`**rounds**`），即使不在表中也保留英文，第一次出現加中文括號。
- 一般英文單字（不是術語的）照常翻譯。拿不準時，保留英文並加中文括號。

## 4. 引號內的文字

- **字面字串保留英文**：trigger 用語（例如 "grill me"、"zoom out"、"red-green-refactor"）、agent 要輸出或比對的固定字串、label、commit message、回答範例中的 "yes"。需要時在後面加（中文）。
- **一般引述照常翻譯**：使用者的話、文章引述、說明性的引號內容。中文引號用「」。

## 5. 標題

標題格式：`中文 (English original)`，例如：

```md
## 它做什麼 (What it does)
## 前置條件 (Prerequisites)
```

標題本身就是術語或 skill 名時，只保留英文。

如果同一檔案內有 anchor 連結指向某個標題（例如 `](#ticket-types)`），在翻譯後的標題**上一行**加 `<a id="ticket-types"></a>`，讓原本的 anchor 繼續有效。連結本身不改。

## 6. 連結

- URL 不改。
- 指向 `.md` 檔的相對連結：**不改**（鏡像裡有同名翻譯檔）。
- 指向資料夾的相對連結：不改。
- 指向非 `.md` 檔的相對連結（`.sh`、`.yaml`、`.json`、`.cjs`、`LICENSE` 等）：改成指回原檔，多加的 `../` 數量同第 2 節。
- 連結文字：一般敘述就翻譯；是 skill 名、檔名、術語就保留。

## 7. 程式碼區塊

- 程式語言、shell、JSON、YAML、設定檔：**逐字保留**，連註解都不改。
- 用來示範文字內容的範本（```` ```md ````、```` ```text ````、或沒標語言的區塊，例如 issue 範本、ADR 範本、提問格式）：翻譯其中的敘述文字；保留結構性內容的英文（key、label、emoji、檔名、指令、`Status:` 這類欄位名）。`<placeholder>` 裡的文字可以翻譯，例如 `<question title>` 改成 `<問題標題>`。

## 8. 忠實度

- 逐句翻譯。**不摘要、不省略、不加內容、不加自己的解釋。**
- 保留原本的結構：段落數、清單項目數、表格欄列、粗體、斜體、引言區塊。
- 粗體與斜體要落在對應的中文詞上。
- 祈使語氣（skill 對 agent 下的指令，例如 "Do not..."、"Always..."）要譯得同樣明確，強度不可變弱或變強。
- 不加譯註。真的無法翻譯的雙關或語感，保留英文並加中文括號就好。

## 9. 用字與標點

- 台灣繁體用語：程式碼、檔案、資料、介面、預設、專案、函式、物件、設定、使用者、回饋、執行、品質、支援。不用簡體或中國用語（代碼、數據、默認、函數、對象、配置、用戶、反饋、運行、質量、支持）。
- file 譯「檔案」，不要譯「文件」。document 譯「文件」可以。project 譯「專案」，item 譯「項目」可以。
- 中文與英文、數字之間加一個半形空格，例如「用 `tdd` 寫 3 個 test」。
- 中文標點用全形：，。：；？！（）「」。
- **不可使用破折號**（`—`、`——`、`–`）。原文用破折號的地方，改成逗號、冒號、句號或括號，看句子需要哪個。
