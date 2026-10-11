> 繁體中文翻譯。原文：[0002-ship-as-a-claude-code-plugin.md](../../../.agents/adr/0002-ship-as-a-claude-code-plugin.md)

# 把 skill 組合以原生 Claude Code plugin 發布；延後原生 Codex plugin (Ship the skill set as a native Claude Code plugin; defer a native Codex plugin)

這些 skill（技能包）一直都可以透過 [skills.sh](https://skills.sh/mattpocock/skills)（`npx skills add mattpocock/skills`）安裝，它會把可編輯的 skill 檔案複製到使用者的專案裡，支援 Claude Code、Codex，以及其他遵循 Agent Skills 標準的 harness（執行環境）。一個反覆出現的需求是 **plug-and-play**（隨插即用）的發布方式：把這組 skill 當成一個唯讀、永遠保持最新、你不會去編輯的套件來訂閱，而不是一個你自己擁有的 fork。這正是原生 plugin（外掛）系統提供的東西。

我們發布一個原生的 **Claude Code plugin**，並且暫時**延後**原生的 **Codex plugin**。這樣的分開是被迫的，原因在於每個生態系的 plugin manifest 選擇 skill 的方式，和這個 repo（程式碼儲存庫）依 bucket 分類的版面配置互相衝突。

## 限制：分 bucket 的 skill 與單一路徑選取 (The constraint: bucketed skills vs. single-path selection)

skill 放在 `skills/` 底下的 bucket（分類資料夾）資料夾裡：`engineering/` 和 `productivity/` 是 **promoted**（推廣：會隨 plugin 發布）；`misc/`、`personal/`、`in-progress/` 和 `deprecated/` **不是**。plugin 只能公開 promoted 這一組，而它橫跨其中兩個 bucket 資料夾。

- **Claude Code**：`.claude-plugin/plugin.json` 接受 `skills` 為一個**明確列出 skill 目錄路徑的陣列**。我們一個一個列出 promoted skill，毫無歧義地排除其他所有東西，並加上 `.claude-plugin/marketplace.json`，讓這個 repo 本身就是只有一個 plugin 的 marketplace（外掛市集）。已經端到端驗證過：`claude plugin validate . --strict` 通過，而且 `marketplace add` → `install` 能解析出所有 promoted skill。

- **Codex**：`.codex-plugin/plugin.json` 只接受 `skills` 為**單一路徑字串**（陣列會被拒絕，錯誤訊息是 `missing or invalid plugin.json`），而且 Codex 會在那個路徑底下遞迴尋找 `SKILL.md` 檔案。用一個路徑，沒辦法指定兩個 bucket 資料夾，也沒辦法挑選出一個子集合。我們測試過兩個替代方案，都否決了：
  - 指向 `./skills/` 的話，也會把 `deprecated/`、`in-progress/`、`personal/` 和 `misc/` 一起發布出去：這些是退役的、草稿中的，以及個人用的 skill，我們刻意不推廣它們。
  - 做一個精選過的平面目錄，裡面放指向各 bucket 的 **symlink**（符號連結），這撐不過安裝：Codex 會把 plugin 目錄樹複製到它的快取裡，並且**丟掉 symlink**，所以 skill 送到時是空的。

要給 Codex 一個只含 promoted skill 的單一路徑，唯一穩健的做法是：(a) **重新組織結構**，讓 `skills/` 只包含 promoted skill（把非 promoted 的 bucket 移出去，影響範圍很大，會波及 `CLAUDE.md`、`scripts/link-skills.sh`、各 bucket 的 README，以及依賴 `in-progress/` 和 `personal/` 的本機開發流程），或 (b) 把 promoted skill 的**重複副本 commit**（提交）到一個平面目錄裡（會帶來同步負擔，並產生第二個真實來源）。兩者都是結構性的決策，不該和發布 Claude plugin 綁在一起做。這很可能就是當初沒有更早發布 plugin 的原始原因，只是大家只記得一半：manifest 格式無法乾淨地表達一個分 bucket 的 repo 裡經過挑選的子集合。

## 決策 (Decision)

- 現在就發布 **Claude Code plugin**（`.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json`），內容挑選為 promoted 那一組，作為 v1.2 的主打交付項目。
- 保留 **skills.sh** 作為通用的安裝工具：它現在就已經支援 Codex 和其他 harness，所以沒有任何 Codex 使用者會沒有安裝管道。
- **延後**原生 Codex plugin，直到我們決定要把 `skills/` 重新組織成只含 promoted，還是 commit 一份產生出來的平面副本。等 Codex 支援 `skills` 陣列／include-list，或在安裝時保留 symlink 時，再重新檢視。

## 由此產生的不變條件 (Invariants this creates)

- 每個 promoted skill 都在 `.claude-plugin/plugin.json` 的 `skills` 陣列裡有一筆項目（這本來就是 `CLAUDE.md` 的一條規則；現在它也決定了 plugin 的內容）。
- `.claude-plugin/plugin.json` 的 `version` 跟著 `package.json` 的版本走：發布時兩個一起升版。Claude 會用 plugin 的 `version` 來決定已安裝的使用者什麼時候會看到更新。

## 更新，2026-08-05 (Update, 2026-08-05)

`mattpocock-skills` 已被收錄進 **Claude Code 的官方 marketplace**（設定名稱 `claude-plugins-official`，來源 repo `anthropics/claude-plugins-official`），每個 Claude Code 安裝預設都有它。`claude plugins install mattpocock-skills` 現在是文件上寫的安裝方式，上面的 `marketplace add` → `install` 路徑已被取代。安裝的文字說明放在 [.agents/install-block.md](../install-block.md)。

官方的上架項目指向這個 repo 的 git URL，並直接讀取 `.claude-plugin/plugin.json`，所以它不依賴 `.claude-plugin/marketplace.json`。那個檔案只保留作為直接安裝這個 repo 時的備案（一個尚未發布的 commit，或一個 fork）。

2026-08-05 在 Claude Code 2.1.222 上，對照線上的上架項目驗證過：

- `claude plugins install mattpocock-skills` 不需要先加入任何 marketplace 就能解析，並回報 `mattpocock-skills@claude-plugins-official`。
- 接著 `claude plugin details mattpocock-skills` 回報版本 1.2.0，並載入 promoted skill。
- 上架項目的 `source` 是 `{"source": "url", "url": "https://github.com/mattpocock/skills.git", "sha": …}`：**sha 是固定的**，所以一個版本要等那個固定點移動時才會送到已安裝的使用者手上，而不是我們打 tag 的那一刻。在撰寫本文時，固定點落後 `main` 兩個 commit，這就是為什麼它列出 22 個 skill，而不是 `plugin.json` 裡的 24 個。
- session（工作階段）內的 `/plugin install mattpocock-skills` **沒有**實際測試：`/plugin` 在 headless（`claude -p`）session 中無法使用。它執行的是和 CLI 相同的解析器，而文件上的範例寫法是 `/plugin install <name>@claude-plugins-official`。

## 更新，2026-10-07 (Update, 2026-10-07)

上面提到的 Codex 限制已經不成立了。Codex 的 `main` 接受 `skills` 字串陣列，而且在沒有 `.codex-plugin/` 時會退回使用 `.claude-plugin/`（[manifest.rs](https://github.com/openai/codex/blob/main/codex-rs/core-plugins/src/manifest.rs)）。Codex 仍然會丟掉 symlink。

在 Codex 0.161.0 上，從 `@mattpocock` marketplace 安裝會載入 promoted 的 model-invoked（模型呼叫）skill，而 `misc/` 或 `in-progress/` 裡的東西一個都不會載入。Copilot CLI 讀取同樣的 manifest，並回報「Installed 27 skills」。

## 更新，2026-10-08：受管理的安裝方式優先 (Update, 2026-10-08: managed installs first)

`@mattpocock` 現在是 Codex、Copilot 和 VS Code 上的主要安裝路線，代價是在 Copilot 上需要一次性的選擇加入。Claude Code 維持使用 `claude-plugins-official`，和 2026-08-05 的更新一樣，因為它預設會自動更新，也不需要 `marketplace add`。

上面的版本不變條件，現在適用於每一條受管理的路線。`npm run version` 已經透過執行 `scripts/sync-plugin-version.mjs` 來維持它。`marketplace.json` 沒有 `version` 欄位，所以它不會漂移。
