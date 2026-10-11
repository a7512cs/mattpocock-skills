> 繁體中文翻譯。原文：[wizard.md](../../../docs/engineering/wizard.md)

## 它做什麼 (What it does)

`wizard` 會產生一個互動式的 bash 腳本，一步一步帶著人完成一套手動程序：串接第三方服務、執行一次性的遷移、把專案從狀態 A 移到狀態 B。它會打開每個 URL，告訴你要點什麼、複製什麼，擷取你拿回來的東西，並寫進 `.env` 檔案和 GitHub Actions secrets。

[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（AI 代理）負責寫腳本；它從不執行腳本。執行的是你，在你自己的機器上。wizard 是一個程式，不是一份指示清單。腳本會依序執行每一步，並保存你輸入的值。你的部分就是點擊、貼上、按 Enter。

## 什麼時候用它 (When to reach for it)

你可以輸入 `/wizard`，agent 也可以自己去用它。當它遇到一個必須由你來做的步驟（一個它無法產生的金鑰、一個它無法點擊的控制台），它會幫你建一個 wizard，而不是把指示寫進聊天裡，讓它們被捲走。

當下一個擋住你的事情，是要去控制台走一趟時，就用它：

| 情境 | wizard 會做什麼 |
| --- | --- |
| 新進開發者需要先設定好六個服務，應用程式才能啟動 | 依序打開每個控制台，擷取金鑰，寫進 `.env` 和 CI（持續整合） |
| 一次性的遷移需要依特定順序切換開關 | 把不可逆的步驟排好順序，放在確認關卡後面 |
| 一個專案必須從狀態 A 移到狀態 B，只做一次 | 走完這次轉換，並回報它沒能做到的事 |
| 你正打算把那些步驟寫進 README | 改寫成一個可執行的版本，當某個步驟過時時會明顯地失敗 |

不要用它來*決定*要建造什麼；要做那件事，該用的工具是 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 和 [to-spec](https://aihero.dev/skills-to-spec)。

## 前置條件 (Prerequisites)

產生 wizard 不需要任何前置條件。它寫出的 wizard 在 bash 上執行，當某個 stage（階段）要設定 GitHub secret 或 variable 時會用到 `gh`。如果沒有 `gh` 或沒有完成驗證，執行也不會失敗。那個 stage 會顯示警告，而結尾的摘要會告訴你哪些要手動設定。

## Stages

一個 **stage** 是一個畫面上的一項專注任務。腳本會在 stage 之間清空終端機，所以超出一個畫面的 stage 會失去被捲走的那部分。你依照相依順序撰寫 stage，並設定 `TOTAL_STAGES`，它會驅動進度顯示。

[skill](https://www.aihero.dev/ai-coding-dictionary/skill)（技能）在寫任何腳本之前，會先界定程序的範圍。它會讀 repo（儲存庫），而不是憑空發問：`.env*`、`docker-compose*`、框架設定，以及 `.github/workflows/` 裡每一個 `secrets.*` / `vars.*` 參照。每一個這樣的參照，都是 wizard 必須產出的一個值。接著它會給你看排好順序的 stage 清單，讓你確認。只有在你確認之後，它才會把每個 stage 對應到人要走的確切路徑（「Dashboard → Developers → API keys → Reveal test key → copy」）。在它不知道目前 UI 長什麼樣的地方，它會問你或查文件，而不是捏造點擊步驟。

對每一個擷取到的值，範圍界定會決定它要放到哪裡：

| 目的地 | 什麼時候 |
| --- | --- |
| 只放 `.env` | 本機開發需要它，CI 不需要 |
| GitHub secret | CI 會讀它，而且它是敏感資料 |
| GitHub variable | CI 會讀它，而且它是公開的 |
| `.env` 和 secret 都放 | 本機開發和 CI 都需要它 |
| 哪裡都不放 | 這個 stage 是純粹的動作：切換一個開關、升級一個方案 |

## 範本已經解決了使用體驗 (The template already solves the UX)

[範本](https://github.com/mattpocock/skills/blob/main/skills/engineering/wizard/template.sh)提供了完整的體驗：帶有剩餘時間的進度顯示、確認關卡、跨平台開啟 URL（包含 WSL）、secret 的隱藏輸入、冪等的 `.env` upsert、`gh secret` / `gh variable` 寫入，以及一份列出所有它不得不跳過的項目的結尾摘要。`STAGES` 標記以上的所有內容都是固定的函式庫，每個 wizard 都一模一樣，而且從不手動編輯。因為函式庫從不改變，每個 wizard 的行為都相同。每個 wizard 唯一要做的工作，就是界定程序範圍並撰寫它的 stage。

寫 wizard 的 agent 從不從頭到尾執行它，因為腳本會打開瀏覽器並等待人的輸入。agent 改用靜態方式檢查它：`bash -n`、在可用時跑 `shellcheck`，以及追蹤每一個值都落在範圍界定所說的位置，而且每一個 `set_secret` 名稱都對應到 CI 裡真正存在的 `secrets.*` 參照。所以第一次執行是你的，而那次執行就是測試。

## 預設是用完即丟 (Ephemeral by default)

| 你手上有什麼 | 腳本要怎麼處理 |
| --- | --- |
| 一次性的遷移、個人的設定、一次你永遠不會重複的轉換 | 存到 scratch 或 `scripts/` 路徑，執行它，然後刪掉它 |
| 下一個加入這個 repo 的人也會需要的設定流程 | commit（提交）它，並從 README 連結過去，讓他們執行腳本，而不是再去問 agent 一次 |

## 常見問題 (Common questions)

**我的 API 金鑰最後會進到 model（模型）的 context（上下文）裡嗎？**

不會。agent 寫腳本；它不執行腳本。你自己執行腳本，腳本會用隱藏的終端機輸入擷取金鑰，並直接寫進 `.env` 或 `gh secret`。wizard 是一個 CLI，model 沒有連接到它。這只適用於 wizard 在執行時擷取的值。如果你在界定程序範圍時把金鑰貼進聊天，它就會和任何其他貼上的文字一樣，進到 [context](https://www.aihero.dev/ai-coding-dictionary/context) 裡。

**我可以回頭修正打錯的值嗎？**

執行到一半時不行。沒有返回按鈕。stage 只會往前跑，在 stage 3 答錯就表示要按 Ctrl-C 再重新執行。重新執行的成本很低，因為任何已經寫進 `.env` 的值都會作為預設值再提供給你，所以你在答對的 stage 一路按 Enter，只重打錯的那一個就好。使用者在推出的第一週就提出了這個需求，而它仍然尚未解決：「超喜歡！不過有一件事，有沒有辦法回頭修正你已經輸入的東西？」

**它知道我已經設定好哪些東西嗎？**

部分知道，而且比推出時大家的反應所以為的要少。它在發問之前會先讀 repo（你的 `.env` 檔案、`docker-compose`、框架設定、CI 裡的 `secrets.*` 參照），所以它會把範圍界定在缺少的值上，而不是像 README 那樣從零開始。它不會做的是去檢查第三方服務。如果某個金鑰已經存在你的 `.env` 裡，wizard 會再提供給你，按 Enter 就會保留它；如果你已經建立了 Stripe 帳號卻從沒存下金鑰，wizard 還是會叫你去控制台拿。

**它在工作流程中的位置是在 grilling 和 spec 之後嗎？**

沒有特定的位置。它是獨立使用的，不是鏈中的一步。常見的猜測是 `/grill-with-docs → /to-spec → /wizard`，這個順序沒問題，但 trigger（觸發條件）是出現了一套手動程序，而這可能在任何時間點發生：在你開始之前、建造到一半，或上線很久之後。它也可以當成探索工具。範圍界定會在你投入工作之前，找出一個任務隱藏的前置條件，例如你沒想到的那三個 API 金鑰。

**它在 Claude Code 以外能用嗎？**

腳本可以。它是純 bash，不管是哪個 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)（執行框架）產生的，執行起來都一樣。skill 本身是 model-invoked（model 可以自己呼叫）的，所以它在每個地方都會被列出來：在 Claude Code 輸入 `/wizard`，或在 Codex 輸入 `$wizard`，或直接描述你卡住的設定。作為 model-invoked 也讓它避開了 [#693](https://github.com/mattpocock/skills/issues/693)，在那個問題中，Claude 的桌面版和網頁版 app 會把 *user-invoked*（只能由使用者呼叫）的 skill 從 [model](https://www.aihero.dev/ai-coding-dictionary/model) 的清單中拿掉，並回報它們沒有安裝。

**這個 skill 以前不是 user-invoked 嗎？**

以前是。它現在是 model-invoked，所以當 agent 遇到必須由你來做的步驟時，會在沒有提示的情況下自己去用它。你以前能做的事都沒有失效。model 呼叫讓 agent 和你都能呼叫這個 skill，所以 `/wizard` 的行為和以前一樣。這個改變修正了一種失敗。以前，agent 在建造到一半撞上憑證這道牆時，會把六個編號步驟倒進聊天裡，讓你手動照著做。現在它會寫一個 wizard。

**它以前在 `in-progress/` 裡。現在在哪裡？**

從 v1.2 起在 `engineering/`。它從 beta bucket（分類資料夾）畢業，現在隨 plugin（外掛）一起發布，所以它會和其他 promoted（正式收錄）的 skill 一起安裝，不需要單獨安裝。它畢業時行為沒有改變。

## 運作正常的跡象 (It's working if)

- 在任何腳本存在之前，你會看到一份排好順序的 stage 清單，以及每個 stage 產出的值，並被要求確認。
- 每個 URL 都會在要你提供那一頁的值之前先被打開。你永遠不會被要求貼上一個你沒被帶去拿的東西。
- secret 是盲打輸入的。沒有任何敏感資料會顯示在你的捲動紀錄裡。
- 每個 stage 都放得進一個畫面。沒有任何你還需要的東西被捲走。
- 按 Ctrl-C 再重新執行，會從你離開的地方接續，並把已經存下的值作為預設值提供給你。
- 最後一個畫面會列出它寫了什麼，並另外列出它做不到、需要你手動完成的事。

## 它在流程中的位置 (Where it fits)

`wizard` 是一個隨時都可以用的獨立 skill，位在自動化停止、需要人來點擊的那條界線上。它最近的鄰居是 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills)，因為兩者存在的目的都是讓 repo 進入可運作的狀態。那一個設定這套 skill，而 `wizard` 則為其他一切產生設定流程。它也和 [implement](https://aihero.dev/skills-implement) 搭配：當一次建造做出一個需要憑證或手動切換的功能時，wizard 會處理只有人能做的那些步驟。當你不確定此刻適合哪個 skill 時，[ask-matt](https://aihero.dev/skills-ask-matt) 會幫你指路。
