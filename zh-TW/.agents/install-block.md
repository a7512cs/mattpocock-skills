> 繁體中文翻譯。原文：[install-block.md](../../.agents/install-block.md)

# 標準安裝區塊 (The canonical install block)

一套安裝說法，一種措辭。`README.md`、`.changeset/*`，以及 `docs/` 底下的每個頁面，都必須說**這個**，不能說別的。要改就先改這裡，再同步到其他地方。

## 受管理的安裝方式優先 (Managed installs first)

先介紹會自己更新的安裝方式。只有對沒有這種安裝方式的 agent（AI 代理），才退而使用 skills.sh，並標示為 "manual updates"（手動更新）。只有在使用者不用執行任何指令就會更新時，才能把一條路線稱為受管理的（managed）。任何一次性的選擇加入步驟，都要放在它的安裝指令旁邊。絕對不要承諾 "instant"（即時）。

Claude Code 從它的官方 marketplace（外掛市集）`claude-plugins-official` 安裝。其他每一條受管理的路線，都從這個 repo（程式碼儲存庫）自己的 marketplace 安裝，也就是 `.claude-plugin/marketplace.json` 和 `plugin.json`。這些路線只有在 `plugin.json` 裡的 `version` 改變時才會重新安裝。Release workflow 會執行 `npm run version`，它會從 `package.json` 複製那個欄位，所以當 "chore: version skills" 這個 PR（合併請求）merge（合併）時，使用者就會拿到新版本。

| Agent | 路線 | 會自己更新嗎？ |
| --- | --- | --- |
| Claude Code | `@claude-plugins-official` | 會，預設就會 |
| Codex | `@mattpocock` marketplace | 會，預設在啟動時更新 |
| Copilot CLI | `@mattpocock` marketplace | 會，但要先做一次性的 `autoUpdate: true` |
| VS Code | Chat: Install Plugin From Source | 會，預設每天更新 |
| Gemini CLI | `gemini skills install`（複製） | 不會。Gemini extension 需要平面的 `skills/<name>/` 版面配置 |
| 其他所有人 | skills.sh | 不會。執行 `npx skills update`，並重新執行 `add` 來取得新的 skill |

來源（2026-10-08）：Codex `core-plugins/src/manager.rs`；Copilot [cli-config-dir-reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference)；VS Code `pluginAutoUpdate.ts`；Gemini `skillLoader.ts`。

還沒有人用 Auggie、Droid、Qwen 或 Goose 跑過這個 repo，所以在有人跑過之前，它們都維持用 skills.sh。

## Claude Code

<canonical-block name="claude-code">

```bash
claude plugin install mattpocock-skills@claude-plugins-official
```

預設會自己更新。

</canonical-block>

## Codex

<canonical-block name="codex">

```bash
codex plugin marketplace add mattpocock/skills
codex plugin add mattpocock-skills@mattpocock
```

啟動時會自己更新。

</canonical-block>

## GitHub Copilot（CLI 和 VS Code） (GitHub Copilot (CLI and VS Code))

請用 marketplace，不要用 `copilot plugin install mattpocock/skills`。Copilot 已經棄用直接從 repo 安裝的方式，而且那種安裝無法自動更新。`extraKnownMarketplaces` 這個項目遵循文件上的 schema，但還沒有人實際跑過。

<canonical-block name="copilot">

```bash
copilot plugin marketplace add mattpocock/skills
copilot plugin install mattpocock-skills@mattpocock
```

接著，只需要做一次，把下面這段加到 `~/.copilot/settings.json`：

```json
{
  "extraKnownMarketplaces": {
    "mattpocock": { "source": { "source": "github", "repo": "mattpocock/skills" }, "autoUpdate": true }
  }
}
```

在 VS Code 裡，執行 **Chat: Install Plugin From Source**，然後輸入 `https://github.com/mattpocock/skills`。它每天會更新。

</canonical-block>

## Gemini CLI

Gemini 不會讀取 `.claude-plugin`，而且 `--path` 只能接受一個 bucket（分類資料夾）。每個 promoted（推廣）bucket 各安裝一次，剛好就是 promoted 那一組（27 個 skill（技能包），2026-10-07 驗證過）。

<canonical-block name="gemini">

```bash
gemini skills install https://github.com/mattpocock/skills.git --path skills/engineering
gemini skills install https://github.com/mattpocock/skills.git --path skills/productivity
```

要更新時，重新執行這兩個指令。

</canonical-block>

## 其他每個 agent，或可編輯的檔案（skills.sh） (Every other agent, or editable files (skills.sh))

`-a` 會預先選好 agent。註解裡列出的每個 agent 都在 2026-10-07 跑過。比起 agent 自己的 repo 安裝工具，例如 `amp skill add` 或 `pi install git:…`，請優先使用 skills.sh，因為那些工具也會把 `misc/` 和 `in-progress/` 一起拉進來。`npx skills update` 會略過在 `add` 之後才在 upstream 新增的 skill，所以這個區塊會告訴使用者重新執行 `add`。

<canonical-block name="other-agents">

```bash
npx skills@latest add mattpocock/skills -a <agent>  # cursor, opencode, devin, windsurf, amp, pi; omit -a to choose
```

安裝程式問你要裝哪些 skill 時，記得包含 `setup-matt-pocock-skills`。要更新時，執行 `npx skills@latest update`；要取得新的 skill，就重新執行 `add`。

</canonical-block>

只要是單獨提到一個 skill 的地方，就用單一 skill 的寫法。`docs/` 頁面不使用這個區塊，因為 ai-hero 會在頁面內文上方顯示安裝小工具。見 [writing-docs.md](./writing-docs.md)。

<canonical-block name="skills-sh-one-skill">

```bash
npx skills@latest add mattpocock/skills --skill=<name>
```

```bash
npx skills@latest update <name>
```

</canonical-block>

`skills@latest` 是所有地方都固定使用的寫法。

## 兩條路線互斥 (The two routes are exclusive)

plugin（外掛）是一個受管理、唯讀、讓你訂閱的套件。skills.sh 則會寫出你擁有、可以編輯的檔案。兩個都裝的話，使用者的每個 skill 都會出現兩次：一定要說 "pick one"（選一個）。
