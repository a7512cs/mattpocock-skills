> 繁體中文翻譯。原文：[setup-matt-pocock-skills.md](../../../docs/engineering/setup-matt-pocock-skills.md)

## 它做什麼 (What it does)

`setup-matt-pocock-skills` 針對一個 repo（儲存庫）回答三個問題：issue（議題）放在哪裡、triage（分類處理）的 label（標籤）叫什麼名字，以及領域文件放在哪裡。它把答案記錄成 `docs/agents/` 底下的 markdown 檔案。

這些檔案是不同 repo 之間唯一不同的東西。skill（技能）本身在任何地方都一模一樣。它們在執行時讀取 `docs/agents/issue-tracker.md`，並照它說的去做。這就是為什麼這套 skill 不綁定 GitHub，也是為什麼你永遠不需要為了指向另一個 tracker（追蹤系統）而去編輯 skill 檔案。用 "link the skills to a custom issue tracker"（把 skill 連到自訂的 issue tracker）呼叫它，就能接上任何你可以用程式連接的東西，完全不需要修改 skill。

它是一個由 prompt（提示詞）驅動的 skill，不是確定性的腳本。它會讀取你的 `git remote`、`CLAUDE.md` 和 `GLOSSARY.md`，提出它找到的東西，並在寫入任何東西之前等你確認。

## 什麼時候用它 (When to reach for it)

你要輸入 `/setup-matt-pocock-skills` 來呼叫它；[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（代理）不會自行使用它。它的 metadata 刻意把它標記為不可被呼叫，所以沒有其他 skill 能替你觸發它。

每個 repo 用一次，在第一次使用任何其他 engineering（工程類）skill 之前。如果 [triage](https://aihero.dev/skills-triage)、[to-spec](https://aihero.dev/skills-to-spec)、[to-tickets](https://aihero.dev/skills-to-tickets) 或 [wayfinder](https://aihero.dev/skills-wayfinder) 開始猜你的 issue 該放哪裡，或套用你的 tracker 沒有的 label，就代表這個 repo 還沒設定好。你可以在專案進行到一半時，在 repo 裡執行它。這個 skill 會讀取已經存在的東西，所以先前的工作都不會遺失。

## 前置條件 (Prerequisites)

它會寫入你執行它的那個 repo：

| 它寫入 | 位置 |
| --- | --- |
| `issue-tracker.md` | `docs/agents/` |
| `domain.md` | `docs/agents/` |
| `triage-labels.md` | `docs/agents/`，只在安裝了 `triage` skill 時 |
| 一個 `## Agent skills` 區塊 | `CLAUDE.md` 或 `AGENTS.md` 之中已經存在的那一個 |

你把這些全部以 markdown 形式 commit（提交）。沒有使用者層級或全域模式。設定存放在 repo 裡，所以每個 repo 都有自己的一份。

## 三個決定 (The three decisions)

它在每個部分都先給出建議的答案，並跳過探索時已經回答過的問題。大多數執行只需要確認兩次。

| 決定 | 它提出什麼 | 什麼時候問 |
| --- | --- | --- |
| **Issue tracker** | 符合你 `git remote` 的那一個 | 一定會問，因為這是唯一真正的選擇 |
| **Triage labels**（分類 label） | 保留五個標準名稱（`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`） | 只在安裝了 `triage` skill 時 |
| **Domain docs**（領域文件） | 單一 context（脈絡）：根目錄下一個 `GLOSSARY.md` 加上 `docs/adr/` | 只在它發現 monorepo 的跡象時，而且這時它會提供多 context 的 `GLOSSARY-MAP.md` |

tracker 的選項：

| 選項 | issue 放在哪裡 | 需要 |
| --- | --- | --- |
| **GitHub** | repo 的 GitHub Issues | `gh` CLI |
| **GitLab** | repo 的 GitLab Issues | `glab` CLI |
| **Local markdown**（本地 markdown） | 這個 repo 裡 `.scratch/<feature>/` 底下的檔案 | 什麼都不需要，連 remote 都不用 |
| **Other**（其他） | 你指定的任何地方 | 你寫一段話描述工作流程 |

前三個以範本形式隨 skill 提供，開箱即用。Local markdown 是一個完整的選項，不是退而求其次的備案。這個 skill 支援沒有 remote 的個人專案。一個注意事項：如果你使用 GitHub，就不要用 local markdown。它們是二選一的，所以挑一個。

「Other」也是一個完整的選項。Jira、Linear、Azure DevOps 和 Beads 都是透過它運作的。你描述工作流程，skill 把你的文字記錄在 `docs/agents/issue-tracker.md`，下游的 skill 就照著這段文字做。使用者已經做出這樣的東西：一個透過 [MCP](https://www.aihero.dev/ai-coding-dictionary/mcp) 使用 Jira 的版本、一個長得像 `gh` 的 Gitea CLI、一個手工打造的本地儀表板。

## 常見問題 (Common questions)

**我一定要用 GitHub 嗎？**

不用。GitHub、GitLab 和 `.scratch/` 底下的 local markdown 都以現成範本提供，其他任何東西都可以透過「other」路徑運作。這是被問最多次的問題，大致是這樣問的：*「被硬綁在 github 上」*、*「我可以用 GitLab／Jira 嗎」*、*「那 Azure DevOps 呢」*。答案永遠一樣：由設定步驟選擇 tracker，不是由 skill 選擇。

**更新 skill 之後，我需要重新執行它嗎？**

v1.1 之後的直接答案是：需要。skill 自己的結尾訊息說得比較委婉。它告訴你只有在要切換 tracker 或重新開始時才需要重新執行。兩種說法都說得通。初始範本會隨版本改變，所以舊版本產生的 `docs/agents/issue-tracker.md`，可能會跟現在讀取它的 skill 脫節。如果某個下游 skill 的行為和文件描述的不同，就重新執行設定。成本很低。

**它寫進了 `CLAUDE.md`，但我用的是 Codex。**

這是一個已知的缺口，而且還沒解決。檔案選擇的規則是「如果 `CLAUDE.md` 存在就編輯它，否則編輯 `AGENTS.md`」。它檢查的是哪個檔案存在，而不是正在執行的是哪個 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)（執行框架）。在一個留有 Claude Code 時期 `CLAUDE.md` 的 repo 裡，skill 會把它的 `## Agent skills` 區塊寫進 Codex 從來不讀的檔案。使用者有兩個變通方法：手動把區塊搬到 `AGENTS.md`，或以 `AGENTS.md` 為準，讓 `CLAUDE.md` 只有一行指向它。如果兩個檔案都不存在，skill 會問你要建立哪一個，而不是自己挑一個。這讓期待它自己決定的人感到困惑。

**它沒有建立我的 triage label。**

它本來就不會。`docs/agents/triage-labels.md` 是一份*對應表*：它告訴 `/triage` 你的 tracker 中哪些字串對應到五個標準角色。它不會執行 `gh label create`。在全新的 GitHub repo 上，這些 label 還不存在，而使用者已經不只一次把這件事當成 bug 回報。兩個後果：

- 如果你的 tracker 已經使用標準名稱，這份對應表就是一張恆等表，沒有任何東西需要設定。這是預期中的常見情況，不是漏掉的步驟。
- 這個 skill 也不會建立 [wayfinder](https://aihero.dev/skills-wayfinder) 的 `wayfinder:map` 和 `wayfinder:<type>` label，而 `gh issue create --label <missing>` 會直接失敗，而不是建立那個 label。在 GitHub repo 上第一次執行 wayfinder 之前，請手動建立它們。

**我可以在這裡設定其他 skill 的行為嗎（[grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式追問）的節奏、提問格式、語氣）？**

不行。它只設定三件事：tracker、label、文件結構。使用者曾要求讓它成為存放個人偏好的地方。答案是：skill 保持自己的主張，不接受個人化設定。偏好應該以一般指示的形式寫在你的 `CLAUDE.md` 裡，每個 skill 本來就會讀它。

**我可以把設定放在 `~/.claude`，而不是 commit 到每個 repo 嗎？**

目前不行。有一位在許多 repo 中使用這些 skill 的使用者為此提出了一個尚未關閉的需求，但目前並沒有使用者層級的模式。每個 repo 都帶著自己的 `docs/agents/`。

**用一個 skill 來設定其他 skill，不是很奇怪嗎？**

有一則長期存在的抱怨認為是的，原話是：「*用一個 skill 去設定其他 skill，我覺得不太對：這代表 LLM 在設定它自己的 skill。*」這個取捨是真實存在的。如果沒有設定步驟，每個碰到 issue 的 skill 都需要自己的一份 tracker 指示。產出是你可以閱讀和編輯的 markdown，這限制了風險。你可以讀它寫的每個檔案，並手動修改。日常的修改就用這種方式，而不是再執行一次。

## 運作正常的跡象 (It's working if)

- `docs/agents/issue-tracker.md` 和 `docs/agents/domain.md` 存在；如果安裝了 `triage`，還有 `triage-labels.md`。
- 你的 harness 會讀的指示檔案裡出現一個 `## Agent skills` 段落，其中對每個檔案都有一行摘要指向它。
- 它提出的 tracker 符合你使用的 remote，而且 label 字串符合你 tracker 中實際存在的 label。
- 之後，`/to-tickets` 發布時不會問你 issue 放在哪裡，而 `/triage` 會套用 label，而不是自己編造。
- skill 檔案本身沒有任何改變。如果設定步驟編輯了某個 `SKILL.md`，就是出問題了。

## 它在流程中的位置 (Where it fits)

`setup-matt-pocock-skills` 是 engineering 流程的**只需執行一次的設定**，它是其他一切都預設已經完成的前提，而不是鏈中的一個步驟。它的鄰居就是它的讀者：[triage](https://aihero.dev/skills-triage)，套用這裡寫下的 label 詞彙；[to-spec](https://aihero.dev/skills-to-spec) 和 [to-tickets](https://aihero.dev/skills-to-tickets)，發布到這裡指定的 tracker；還有 [wayfinder](https://aihero.dev/skills-wayfinder)，它讀取同一個 tracker 檔案中的「Wayfinding operations」段落，學習如何儲存 map（地圖）和 child [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（子工單）。[domain-modeling](https://aihero.dev/skills-domain-modeling) 之後會填入設定步驟所記錄的領域文件結構。它只在你確定某個術語或決策時才建立 `GLOSSARY.md` 和 ADR（架構決策紀錄），所以設定完之後 repo 裡沒有領域文件是正常的。至於下一步該用哪個 skill，[ask-matt](https://aihero.dev/skills-ask-matt) 會為整套 skill 指路。
