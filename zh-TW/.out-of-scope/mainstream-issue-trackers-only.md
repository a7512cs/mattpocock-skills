> 繁體中文翻譯。原文：[mainstream-issue-trackers-only.md](../../.out-of-scope/mainstream-issue-trackers-only.md)

# Issue tracker 整合：只支援 GitHub、GitLab 和本機 markdown (Issue tracker integrations: GitHub, GitLab and local markdown only)

`setup-matt-pocock-skills` 只對剛好三種 issue tracker（議題追蹤工具）提供一級支援，每一種對應 `skills/engineering/setup-matt-pocock-skills/` 裡的一個種子範本：

- **GitHub**（`issue-tracker-github.md`，透過 `gh`）
- **GitLab**（`issue-tracker-gitlab.md`，透過 `glab`）
- **本機 markdown**（`issue-tracker-local.md`，放在 `.scratch/` 底下的檔案）

要求為任何其他 tracker 加上一級後端支援的請求，都是 out of scope（不在範圍內）。這包括 Jira、Linear、Azure DevOps、Trello、YouTrack，以及新的、專為 agent（AI 代理）設計的 tracker。

## 為什麼這不在範圍內 (Why this is out of scope)

每一種 issue tracker 後端，都會把某種 CLI 的形狀寫死在 skill（技能包）裡（指令、旗標、輸出解析）。每多一個後端，就多一塊永久的維護面，因為它必須隨著那個工具的 CLI 演進而持續可用，也必須持續拿 `/to-spec`、`/to-tickets`、`/triage` 等 skill 來測試。我用的是 GitHub，所以那是我真正能維持正確的後端。GitLab 的形狀夠接近，可以順便帶上，而本機 markdown 根本不需要 CLI。

受不受歡迎不會改變這一點。Jira 被廣泛使用，也有官方 CLI（`acli`），但它仍然不會有範本：它是一個我不使用的後端，有它自己的連結語意、工作流程狀態和 CLI 怪癖需要持續測試。不管這個工具是不是主流，成本都落在我身上。

其他所有 tracker 都走 `/setup-matt-pocock-skills` 裡的 **Other**（其他）選項：你用一段文字描述你的工作流程，skill 就會把它以文字形式記錄在 `docs/agents/issue-tracker.md`。那個檔案是你的。如果你已經打磨出一套可行的 Jira 或 Linear 工作流程，就把它放在你自己的 repo（程式碼儲存庫）裡或公開發布，然後讓 setup 指向它。

## 過去的請求 (Prior requests)

- #99: "Add dex as an issue tracker backend"（把 dex 加為 issue tracker 後端）（提出請求時，dex 才大約 3 個月大，大約 300 顆星）
- #258: "Add Jira as first-class issue tracker via Rovo MCP"（透過 Rovo MCP 把 Jira 加為一級 issue tracker）
- #1137: "Add Jira as a first-class issue tracker, via Atlassian's official CLI (`acli`)"（透過 Atlassian 的官方 CLI（`acli`）把 Jira 加為一級 issue tracker）
