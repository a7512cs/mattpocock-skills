> 繁體中文翻譯。原文：[CLAUDE.md](../CLAUDE.md)

skill（技能包）依 bucket（分類資料夾）放在 `skills/` 底下的各個資料夾：

- `engineering/`：每天的程式碼工作
- `productivity/`：每天用的非程式碼工作流程工具
- `misc/`：留著但很少用，沒有 promoted（推廣）
- `in-progress/`：beta：刻意公開，想要回饋，不隨 plugin（外掛）發布
- `deprecated/`：不再使用

`engineering/` 或 `productivity/`（也就是 **promoted** bucket）裡的每個 skill，都必須在最上層的 `README.md` 裡被提到，並且在 `.claude-plugin/plugin.json` 的 `skills` 陣列裡有一筆項目（Claude Code plugin 發布的剛好就是 promoted 這一組）。`misc/`、`in-progress/` 和 `deprecated/` 裡的 skill 不可以出現在這兩個地方的任何一處。

安裝指令一律從 [.agents/install-block.md](./.agents/install-block.md) 逐字複製。`.claude-plugin/marketplace.json` 是這個 repo（程式碼儲存庫）自己的 marketplace（外掛市集）。除了 Claude Code 以外，每個 agent（AI 代理）都從它安裝，以取得自動更新；Claude Code 則使用 `claude-plugins-official`。動過其中任何一個 manifest 之後，都要執行 `claude plugin validate . --strict`。[ADR 0002](./.agents/adr/0002-ship-as-a-claude-code-plugin.md)（ADR：架構決策紀錄）記錄了原因。

最上層 `README.md` 裡的每個 skill 項目，都必須把 skill 名稱連結到它的 `SKILL.md`。

每個 bucket 資料夾都有一份 `README.md`，列出該 bucket 裡的每個 skill，各附一行說明，並把 skill 名稱連結到它的 `SKILL.md`。promoted bucket 的 `README.md` 和最上層的 `README.md` 會把項目分成 **User-invoked**（使用者呼叫）和 **Model-invoked**（模型呼叫）兩組；非 promoted bucket 的 `README.md`（`misc/`、`in-progress/`）則用不分組的平鋪清單。

`engineering/` 和 `productivity/` 裡的 skill 還有一個給人看的 docs 頁面，位置在 `docs/<bucket>/<skill-name>.md`（docs 目錄樹與 `skills/` 底下那兩個 bucket 資料夾一一對應）。不管在哪個 bucket，發布的網址都是 `https://aihero.dev/skills-<skill-name>`：docs 路徑只是 repo 內部的組織方式。當你新增、重新命名，或改變 `engineering/` 或 `productivity/` 裡某個 skill 的行為時，要依照 [.agents/writing-docs.md](./.agents/writing-docs.md) 建立或重新同步它的 docs 頁面。完成的頁面有四個區段：**What it does**（它做什麼）、**When to reach for it**（什麼時候用它）、**Common questions**（常見問題）和 **It's working if**（運作正常的跡象）。`writing-docs.md` 裡有範本、區段順序，以及去哪裡找問題。非 promoted bucket（`misc/`、`in-progress/`、`deprecated/`）裡的 skill **沒有** docs 頁面。唯一的例外是被整個移除的 promoted skill：它的頁面會保留，並標記為已封存（見 `writing-docs.md`）。

每個 `SKILL.md` 不是 user-invoked（`disable-model-invocation: true`，再加上 `agents/openai.yaml` 裡的 `policy.allow_implicit_invocation: false`，只有人能觸發），就是 model-invoked（model 或使用者都能觸發）。見 [.agents/invocation.md](./.agents/invocation.md)。

[`ask-matt`](./skills/engineering/ask-matt/SKILL.md) 是一個 router（路由器），它對應出每一個使用者能觸發的 skill，以及它們之間的關係。會觸發重新同步 docs 頁面的同一個 trigger（觸發條件），也同樣適用於它：每當你新增、重新命名、移除，或改變某個使用者能觸發的 skill 在流程中的位置時，都要重新讀一遍 `ask-matt` 的 `SKILL.md` 並更新它，讓這張 map（地圖）保持正確：一個它從沒提過的新 skill，或一個它仍然導向的過時 skill，都代表這個 router 在說謊。

要把 `deprecated/` 和 `misc/` 以外的每個 skill（重新）連結到本機的 harness（執行環境）skill 目錄（`~/.claude/skills`、`~/.agents/skills`），請執行 `scripts/link-skills.sh`。每個項目都是指向這個 repo 的 symlink，所以 `git pull` 就能讓已安裝的 skill 保持最新；新增、移除或重新命名 skill 之後，要重新執行這個 script。

這個 repo 的文字敘述裡，任何地方都不能用 em-dash（長破折號），包括 `SKILL.md` 檔案、docs、`README.md`、`CHANGELOG.md`、ADR、changeset（變更集）和程式碼註解。當某個句子想用它時，改為重寫這個句子，用逗號、冒號、句號、括號或連接詞，看句子真正需要哪一個；絕對不要盲目地替換字元。

## Agent skills

### Triage（分類處理）標籤 (Triage labels)

使用標準名稱，沒有更改。見 `docs/agents/triage-labels.md`。Issue（議題）會依照 [`SCOPE.md`](./SCOPE.md) 來評斷。
