> 繁體中文翻譯。原文：[issue-tracker-gitlab.md](../../../../skills/engineering/setup-matt-pocock-skills/issue-tracker-gitlab.md)

# Issue tracker: GitLab

這個 repo（程式碼倉庫）的 Issue（議題）和 spec（規格）以 GitLab issue 的形式存在。所有操作都使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI。

## 慣例 (Conventions)

- **建立 Issue**：`glab issue create --title "..." --description "..."`。多行描述用 heredoc。傳入 `--description -` 會開啟編輯器。
- **讀取 Issue**：`glab issue view <number> --comments`。用 `-F json` 取得機器可讀的輸出。
- **列出 Issue**：`glab issue list -O json`，加上適當的 `--label` 篩選條件。
- **在 Issue 上留言**：`glab issue note <number> --message "..."`。GitLab 把留言稱為 "notes"。
- **套用 / 移除 label**：`glab issue update <number> --label "..."` / `--unlabel "..."`。多個 label 可以用逗號分隔，或重複使用這個旗標。
- **關閉**：`glab issue close <number>`。`glab issue close` 不接受關閉時的留言，所以先用 `glab issue note <number> --message "..."` 貼出說明，再關閉。
- **Merge request**：GitLab 把 PR 稱為 "merge requests"。使用 `glab mr create`、`glab mr view`、`glab mr note` 等等，形狀跟 `gh pr ...` 一樣，只是用 `mr` 取代 `pr`，用 `note`/`--message` 取代 `comment`/`--body`。

從 `git remote -v` 推斷 repo；在 clone 下來的目錄內執行時，`glab` 會自動這樣做。

## Merge request 作為 triage 入口 (Merge requests as a triage surface)

**MRs as a request surface: no.** *（如果這個 repo 把外部 merge request 當作功能請求，就設為 `yes`；`/triage` 會讀取這個旗標。）*

設為 `yes` 時，MR 會經過跟 Issue 一樣的 label 和狀態，使用對應的 `glab mr` 指令：

- **讀取 MR**：`glab mr view <number> --comments`，以及用 `glab mr diff <number>` 看 diff（差異內容）。
- **列出要 triage（分類處理）的外部 MR**：`glab mr list -F json`，然後只保留作者不是專案成員/擁有者的 MR（貢獻者的 MR，而不是維護者正在進行中的工作）。
- **留言 / label / 關閉**：`glab mr note`、`glab mr update --label`/`--unlabel`、`glab mr close`。

跟 GitHub 不同，GitLab 對 Issue 和 MR 分別編號，所以一旦你知道維護者指的是哪個入口，`#42` 就沒有歧義。

## 當 skill 說 "publish to the issue tracker" 時 (When a skill says "publish to the issue tracker")

建立一個 GitLab Issue。

## 當 skill 說 "fetch the relevant ticket" 時 (When a skill says "fetch the relevant ticket")

執行 `glab issue view <number> --comments`。

## Wayfinding 操作 (Wayfinding operations)

由 `/wayfinder` 使用。**map**（地圖）是單一個 Issue，以 **child**（子項）Issue 作為 ticket（工作單）。

- **Map**：單一個標了 `wayfinder:map` label 的 Issue，內容包含 Notes / Decisions-so-far / Fog（筆記 / 目前為止的決定 / 未知區域）。`glab issue create --label wayfinder:map`。（在有原生 epic 的 GitLab 方案中，可以改用一個 epic 來承載 map；標了 label 的 Issue 則在任何地方都行得通。）
- **Child ticket**：一個在描述最上方帶有 `Part of #<map>`，並帶有 label `wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）的 Issue。一旦被認領，ticket 就指派給負責推進的開發者。
- **Blocking**（阻擋關係）：GitLab 的**原生阻擋連結**，這是標準的、在 UI 上看得到的表示方式。用 `/blocked_by #<n>` quick action 加上它，以 note 的形式貼出（`glab issue note <child> --message "/blocked_by #<blocker>"`）。原生阻擋連結是 Premium/Ultimate 方案的功能；在免費方案上（或無法使用的地方），退回在描述的最上方放一行 `Blocked by: #<n>, #<n>`。當每個 blocker 都關閉時，ticket 就不再被阻擋。
- **Frontier query**（frontier（前沿）查詢：找出目前可以開始做的 ticket）：`glab issue list -O json`，範圍限定在 map 的 child，去掉任何有未關閉 blocker 的：指向未關閉 Issue 的原生 `blocked_by` 連結（`glab api projects/:id/issues/<child-iid>/links`），或 `Blocked by` 那一行中有未關閉的 Issue，或已有指派者的；依 map 中的順序，排第一個的勝出。
- **Claim**（認領）：`glab issue update <n> --assignee @me`，這是 session（工作階段）的第一個寫入動作。
- **Resolve**（解決）：`glab issue note <n> --message "<answer>"`，然後 `glab issue close <n>`，然後把一個 context pointer（脈絡指標）（要點 + 連結）附加到 map 的 Decisions-so-far。
