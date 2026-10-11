> 繁體中文翻譯。原文：[issue-tracker-github.md](../../../../skills/engineering/setup-matt-pocock-skills/issue-tracker-github.md)

# Issue tracker: GitHub

這個 repo（程式碼倉庫）的 Issue（議題）和 spec（規格）以 GitHub issue 的形式存在。所有操作都使用 `gh` CLI。

## 慣例 (Conventions)

- **建立 Issue**：`gh issue create --title "..." --body "..."`。多行內容用 heredoc。
- **讀取 Issue**：`gh issue view <number> --json number,title,body,labels,comments`。
- **列出 Issue**：`gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`，加上適當的 `--label` 和 `--state` 篩選條件。
- **把 Issue 設為某個 parent 的 sub-issue**：`gh issue create --parent <parent> ...`，或之後用 `gh issue edit <parent> --add-sub-issue <child>`（`gh` 2.94+）。較舊的 `gh`：`gh api --method POST repos/<owner>/<repo>/issues/<parent>/sub_issues -F sub_issue_id=<child-db-id>`（database id，跟下面 **Blocking** 中的一樣）。沒有 sub-issue 時，在 child 內容的最上方放 `Part of #<parent>`。
- **在 Issue 上留言**：`gh issue comment <number> --body "..."`
- **套用 / 移除 label**：`gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **關閉**：`gh issue close <number> --comment "..."`

從 `git remote -v` 推斷 repo；在 clone 下來的目錄內執行時，`gh` 會自動這樣做。

## Pull request 作為 triage 入口 (Pull requests as a triage surface)

**PRs as a request surface: no.** *（如果這個 repo 把外部 PR 當作功能請求，就設為 `yes`；`/triage` 會讀取這個旗標。）*

設為 `yes` 時，PR 會經過跟 Issue 一樣的 label 和狀態，使用對應的 `gh pr` 指令：

- **讀取 PR**：`gh pr view <number> --comments`，以及用 `gh pr diff <number>` 看 diff（差異內容）。
- **列出要 triage（分類處理）的外部 PR**：`gh api --paginate 'repos/{owner}/{repo}/pulls?state=open' --jq '.[] | select(.author_association | IN("OWNER","MEMBER","COLLABORATOR") | not) | {number, title, author: .user.login, author_association, labels: [.labels[].name]}'`。
- **留言 / label / 關閉**：`gh pr comment`、`gh pr edit --add-label`/`--remove-label`、`gh pr close`。

GitHub 的 Issue 和 PR 共用同一個編號空間，所以單獨一個 `#42` 可能是其中任何一種：用 `gh pr view 42` 解析，失敗時退回 `gh issue view 42`。

## 當 skill 說 "publish to the issue tracker" 時 (When a skill says "publish to the issue tracker")

建立一個 GitHub Issue。

## 當 skill 說 "fetch the relevant ticket" 時 (When a skill says "fetch the relevant ticket")

照上面 **讀取 Issue** 的方式讀取它。

## Wayfinding 操作 (Wayfinding operations)

由 `/wayfinder` 使用。**map**（地圖）是單一個 Issue，以 **child**（子項）Issue 作為 ticket（工作單）。

- **Map**：單一個標了 `wayfinder:map` label 的 Issue，內容包含 Notes / Decisions-so-far / Fog（筆記 / 目前為止的決定 / 未知區域）。`gh issue create --label wayfinder:map`。
- **Child ticket**：一個以 GitHub sub-issue 形式連結到 map 的 Issue（見 **把 Issue 設為某個 parent 的 sub-issue**）。沒有啟用 sub-issue 的地方，就把 child 加到 map 內容裡的 task list，並在 child 內容的最上方放 `Part of #<map>`。Label：`wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）。一旦被認領，ticket 就指派給負責推進的開發者。
- **Blocking**（阻擋關係）：GitHub 的**原生 Issue 相依關係**，這是標準的、在 UI 上看得到的表示方式。用 `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>` 加上一條 edge（阻擋邊），其中 `<blocker-db-id>` 是 blocker 的數字 **database id**（`gh api repos/<owner>/<repo>/issues/<n> --jq .id`，*不是* `#number` 或 `node_id`）。GitHub 會回報 `issue_dependencies_summary.blocked_by`（只算尚未關閉的 blocker，也就是即時的閘門）。沒有相依關係功能的地方，就退回在 child 內容的最上方放一行 `Blocked by: #<n>, #<n>`。當每個 blocker 都關閉時，ticket 就不再被阻擋。
- **Frontier query**（frontier（前沿）查詢：找出目前可以開始做的 ticket）：列出 map 中尚未關閉的 child（`gh issue list --state open`，範圍限定在 map 的 sub-issue / task list），去掉任何有未關閉 blocker 的（`issue_dependencies_summary.blocked_by > 0`，或 `Blocked by` 那一行中有未關閉的 Issue）或已有指派者的；依 map 中的順序，排第一個的勝出。
- **Claim**（認領）：`gh issue edit <n> --add-assignee @me`，這是 session（工作階段）的第一個寫入動作。
- **Resolve**（解決）：`gh issue comment <n> --body "<answer>"`，然後 `gh issue close <n>`，然後把一個 context pointer（脈絡指標）（要點 + 連結）附加到 map 的 Decisions-so-far。
