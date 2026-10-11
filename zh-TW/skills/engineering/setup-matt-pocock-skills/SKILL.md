---
name: setup-matt-pocock-skills
description: "Configure this repo for the engineering skills: set up its issue tracker, triage label vocabulary, and domain doc layout. Run once before first use of the other engineering skills."
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/setup-matt-pocock-skills/SKILL.md)
>
> **description 中譯：** 為 engineering（工程類 bucket）的 skill（技能）設定這個 repo（程式碼倉庫）：設定它的 Issue tracker（議題追蹤系統）、triage（分類處理）label 詞彙，以及領域文件的版面配置。在第一次使用其他 engineering skill 之前執行一次。

# 設定 Matt Pocock 的 Skills (Setup Matt Pocock's Skills)

為每個 repo 建立 engineering skill 預設會存在的設定骨架：

- **Issue tracker**：Issue（議題）放在哪裡（預設是 GitHub；本機 markdown 也有內建支援）
- **Triage labels**（triage 標籤）：五個標準 Triage role（分類角色）所使用的字串
- **Domain docs**（領域文件）：`GLOSSARY.md` 和 ADR（架構決策紀錄）放在哪裡，以及讀取它們時要遵守的規則

這是一個由 prompt（提示）驅動的 skill，不是確定性的 script。先探索，呈現你找到的東西，跟使用者確認，然後才寫入。

## 流程 (Process)

### 1. 探索 (Explore)

查看目前的 repo，了解它的起始狀態。讀取所有存在的東西；不要假設：

- `git remote -v` 和 `.git/config`：這是 GitHub repo 嗎？是哪一個？
- repo 根目錄的 `AGENTS.md` 和 `CLAUDE.md`：有沒有其中一個存在？其中任何一個裡面是不是已經有 `## Agent skills` 區段？
- repo 根目錄的 `GLOSSARY.md` 和 `GLOSSARY-MAP.md`
- `docs/adr/` 以及任何 `src/*/docs/adr/` 目錄
- `docs/agents/`：這個 skill 之前的輸出是不是已經存在？
- `.scratch/`：表示已經在使用本機 markdown Issue tracker 慣例的跡象
- `triage` skill 有沒有安裝？（跟這個 skill 並列的 `triage` skill 資料夾，或你可用的 skill 中有 `triage`。）這決定區段 B 到底要不要執行。
- Monorepo 訊號：`pnpm-workspace.yaml`、`package.json` 中的 `workspaces` 欄位，或一個有內容、各自帶有 `src/` 的 `packages/*`。這些只會出現在真正大型的多套件 repo 中；沒有它們就表示是單一 context（脈絡），而幾乎所有 repo 都是這樣。

### 2. 呈現發現並詢問 (Present findings and ask)

總結哪些已經存在、哪些缺少。然後依序處理各個區段。一個區段，一個答案，然後下一個。

每個區段都先給出建議的答案，讓使用者用一個字就能接受。只有在選擇真的有分歧時，才給一行說明；當探索已經確定了某個區段時，就整個跳過那個區段（`triage` 沒有安裝時跳過區段 B，沒有 monorepo 時跳過區段 C）。

**區段 A：Issue tracker。**

> 說明：「Issue tracker」是這個 repo 的 Issue 存放的地方。像 `to-tickets`、`triage`、`to-spec` 這樣的 skill 會從它讀取，也會寫入它。它們需要知道該呼叫 `gh issue create`、在 `.scratch/` 底下寫一個 markdown 檔，還是遵循你描述的其他 workflow。選你實際追蹤這個 repo 工作的地方。

預設立場：這些 skill 是為 GitHub 設計的。如果 `git remote` 指向 GitHub，就提議 GitHub。如果 `git remote` 指向 GitLab（`gitlab.com` 或自架的主機），就提議 GitLab。否則（或如果使用者有其他偏好），提供以下選項：

- **GitHub**：Issue 放在 repo 的 GitHub Issues（使用 `gh` CLI）
- **GitLab**：Issue 放在 repo 的 GitLab Issues（使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI）
- **本機 markdown (Local markdown)**：Issue 以檔案形式放在這個 repo 的 `.scratch/<feature>/` 底下（適合個人專案或沒有 remote 的 repo）
- **其他 (Other)**（Jira、Linear 等）：請使用者用一段文字描述 workflow；skill 會把它記錄為自由格式的文字

把選擇記錄在 `docs/agents/issue-tracker.md`。GitHub 和 GitLab 的範本帶有一個 "PRs as a request surface"（把 PR 當作請求入口）旗標，預設為 **off**（關閉）。保持關閉，也不要提起它：想讓外部 PR 進入 triage 佇列的使用者，之後可以自己在檔案裡切換這個旗標。

**區段 B：Triage label 詞彙。** 如果 `triage` skill 沒有安裝（探索時已經告訴你了），就整個跳過這個區段，因為沒安裝的 skill 不需要任何 label。

如果有安裝，就只問一個問題：

> 你要保留預設的 triage label 嗎？（建議：**yes**）

預設值是五個標準 role，每個 label 字串都等於它的名稱：`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`。回答 **yes** 時，就照原樣寫入。只有在使用者說 no 時（通常是因為他們的 tracker 已經使用其他名稱，例如用 `bug:triage` 代表 `needs-triage`），才收集這些覆寫值，讓 `triage` 套用現有的 label，而不是建立重複的 label。

**區段 C：Domain docs。** 預設為 **single-context**（單一 context）（repo 根目錄一個 `GLOSSARY.md` + `docs/adr/`）。這適合幾乎所有 repo；不用詢問，直接寫。

只有在探索時發現 monorepo 訊號時，才提供 **multi-context**（多個 context）選項（根目錄一個 `GLOSSARY-MAP.md`，指向每個 context 各自的 `GLOSSARY.md` 檔）。然後確認他們要哪一種版面配置。

### 3. 確認並編輯 (Confirm and edit)

給使用者看以下內容的草稿：

- 要加進 `CLAUDE.md` / `AGENTS.md` 中被編輯的那一個的 `## Agent skills` 區塊（選擇規則見第 4 步）
- `docs/agents/issue-tracker.md`、`docs/agents/domain.md` 和 `docs/agents/triage-labels.md` 的內容（最後一個只在 `triage` 有安裝時才需要）

讓他們在寫入之前先編輯。

### 4. 寫入 (Write)

**選擇要編輯的檔案：**

- 如果 `CLAUDE.md` 存在，就編輯它。
- 否則如果 `AGENTS.md` 存在，就編輯它。
- 如果兩個都不存在，就問使用者要建立哪一個；不要替他們選。

當 `CLAUDE.md` 已經存在時，絕對不要建立 `AGENTS.md`（反之亦然）；一律編輯已經存在的那一個。

如果選定的檔案裡已經有 `## Agent skills` 區塊，就在原處更新它的內容，而不是附加一份重複的區塊。不要覆寫使用者對周圍區段所做的編輯。

區塊內容：

```markdown
## Agent skills

### Issue tracker

[一行摘要，說明 Issue 在哪裡追蹤]。見 `docs/agents/issue-tracker.md`。

### Triage labels

[一行摘要，說明 label 詞彙]。見 `docs/agents/triage-labels.md`。

### Domain docs

[一行摘要，說明版面配置："single-context" 或 "multi-context"]。見 `docs/agents/domain.md`。
```

只有在 `triage` 有安裝而且區段 B 有執行時，才加入 `### Triage labels` 子區塊，並寫入 `docs/agents/triage-labels.md`。沒有安裝時，兩者都省略。

當區段 B 在 GitHub 或 GitLab 上執行過時，為 tracker 缺少的每個已設定 label 建立 label（`gh label create` / `glab label create`）。

然後使用這個 skill 資料夾中的種子範本作為起點，寫入 docs 檔案：

- [issue-tracker-github.md](./issue-tracker-github.md)：GitHub Issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md)：GitLab Issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md)：本機 markdown Issue tracker
- [triage-labels.md](./triage-labels.md)：label 對照（只在 `triage` 有安裝時）
- [domain.md](./domain.md)：領域文件的讀取規則 + 版面配置

對於「其他」Issue tracker，根據使用者的描述，從頭寫 `docs/agents/issue-tracker.md`。

### 5. 完成 (Done)

告訴使用者設定已經完成，以及哪些 engineering skill 現在會讀取這些檔案。提一下他們之後可以直接編輯 `docs/agents/*.md`；只有在他們想切換 Issue tracker 或從頭開始時，才需要重新執行這個 skill。
