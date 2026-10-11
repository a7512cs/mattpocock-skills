> 繁體中文翻譯。原文：[ask-matt.md](../../../docs/engineering/ask-matt.md)

## 它做什麼 (What it does)

`ask-matt` 是這個 repo（儲存庫）中所有 skill（技能）的路由器。你描述你所處的情況（一個不知道怎麼開始的點子、一堆湧進來的 bug 回報、一個拖得太長的 [session](https://www.aihero.dev/ai-coding-dictionary/session)（對話階段）），它就會說出適合的 skill 或 skill 序列，以及在那個序列中，人類要做決定的地方在哪裡。

它推薦完就停下來。它不會 grill（拷問式追問）你、不會寫 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格文件）、不會開檔案，也不會觸發它剛剛點名的 skill；你拿到的是下一個要輸入的東西，然後由你來輸入。它也是一張手寫的、這個 repo 的 skill 地圖，而不是掃描你已安裝的東西，所以它不會在你自己的 skill 或其他作者的 skill 之間幫你指路。

## 什麼時候用它 (When to reach for it)

你要輸入 `/ask-matt` 來呼叫它；agent（代理）不會自己使用它。

| 你的情況 | 路由器給你的回覆 |
| --- | --- |
| 有一個點子，卻不知道從哪裡開始 | 主流程的起點，以及這次建構是否小到可以跳過 spec |
| 別人送來的 bug 和需求 | [triage](https://aihero.dev/skills-triage)（分類處理）這個 on-ramp（入口匝道），以及為什麼你自己產生的 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（工作單）不屬於那裡 |
| 兩個看起來可以互換的 skill | 兩者之間的分界線，而且通常是一個具體的判斷標準，而不是個人喜好。[grill-me](https://aihero.dev/skills-grill-me) 還是 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，取決於你是否在一個工作目錄裡；[grill-with-docs](https://aihero.dev/skills-grill-with-docs) 還是 [wayfinder](https://aihero.dev/skills-wayfinder)，取決於這項工作能否在一個 session 內完成 |
| 一個很長的 session，以及一個關於 [context](https://www.aihero.dev/ai-coding-dictionary/context)（上下文）的決定 | 階段邊界上五個選項的有序決策樹 |
| 一個你已經選好的 skill | 沒什麼用處。直接呼叫那個 skill。 |

## 前置條件 (Prerequisites)

路由器只說出 skill 的名字；它不會安裝它們。它指向的所有 skill 都必須已經安裝，推薦才能真的執行，而且它只知道這個 repo 中 promoted（正式推廣、收進 plugin 的）skill。

依賴 tracker 的路線（triage、`to-spec`、`to-tickets`、`implement`）假設 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 已經在 repo 中設定好 issue tracker（議題追蹤系統）。即使還沒設定，路由器也會推薦它們。

## 是流程，不是 skill (Flows, not skills)

這個 skill 的 leading word（引導詞）是 **flow**（流程），一條*穿過*多個 skill 的路徑，而不是單一一個 skill。當你說出你的情況，路由器會把你放在某個 flow 上的某一步。這和「這是符合你關鍵字的 skill」是不同的答案。路線有五種，skill 本身會完整描述它們：

- **The main flow**（主流程），從點子到上線。grill、spec、ticket、implement（一次一張 ticket，或用 [implement-spec](https://aihero.dev/skills-implement-spec) 平行處理整個 task graph（任務圖）），review（審查），然後是 [retro](https://aihero.dev/skills-retro)，它會把這次建構學到的東西回饋到 agent 的環境中。它有兩條分支。一條是 prototype（原型）繞道，用在需要可執行的程式碼才能解決某個問題時。另一條是 spec 與 ticket 的拆分，只有在建構跨越不只一個 session 時，才值得付出它的成本。
- **On-ramps**（入口匝道），適用於會產生工作、然後併入主流程的情況：湧入的 bug 回報、某個東西壞掉了，或一項太模糊、太大、無法在一個 session 中掌握的工作。
- **Codebase health**（codebase 健康度），是維護而不是功能開發。[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 會檢視程式碼，找出 deepening opportunities（深化機會：可以把 module 變深的地方），它找到的每一個都會以點子的身分重新進入主流程。
- **Standalones**（獨立 skill），位在所有 flow 之外，你會單獨使用它們：prototype、問卷、research 調查。
- **A vocabulary layer underneath**（底層的詞彙層），也就是當問題出在用字、而不是流程時，其他 skill 會引用的那兩份參考資料。

## 階段邊界 (The phase boundary)

這個 skill 的另一個關鍵概念是 **phase boundary**（階段邊界）。phase（階段）是 session 內的一段工作（[grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式提問）、實作、QA），兩個階段之間的邊界，是唯一該問「我要怎麼處理這些 context？」的地方。在階段中途沒有什麼要決定的：繼續，或把剩下的工作拆給 [subagents](https://www.aihero.dev/ai-coding-dictionary/subagent)（子代理）。

| 選項 | 什麼時候選它 |
| --- | --- |
| **Continue**（繼續） | 下一個階段需要原封不動的這個階段，或你還剩下 [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)（聰明區：context 還沒塞太滿、model 表現最好的範圍）。這是唯一能讓 session 保持為 [primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source)（第一手資料）的做法，所以要最先把它排除 |
| **`/clear`** | 你身後的一切都可以丟掉。這是最便宜的選項，但如果你判斷錯了，就無法復原 |
| **[handoff](https://aihero.dev/skills-handoff)**（交接） | 有東西必須移動：新的 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)（執行 agent 的外殼程式）、新的目錄、一位同事、一個在階段中途分叉出去的支線任務 |
| **Subagent** | 任務範圍夠明確，可以在你[離開鍵盤](https://www.aihero.dev/ai-coding-dictionary/afk)時執行 |
| **`/compact`** | 以上皆非。它是預設選項，決策樹常常停在這裡 |

有兩個選項大家常常搞錯，這就是為什麼路由器給的是順序，而不只是清單。`/handoff` 看起來像是在 context 視窗之間移動的通用方法，但它不是。它給你的只有可攜性。`/compact` 是決策樹中的最後一個選項，而不是第一個，因為它上面的四個選項，每一個都更便宜或更精確。

## 常見問題 (Common questions)

**難道沒有一份照正確順序排好的 skill 清單嗎？**

大家一直要求在 README 裡放一份這樣的清單。這個 skill 就是那份清單。一張靜態表格會寫 `wayfinder → to-spec → to-tickets → implement → code-review → retro`，而且對大多數情況都是錯的。重要的部分是分支：有沒有 codebase（程式碼庫）、建構會不會跨越多個 session、這個問題能不能靠討論解決。代價是路由器是手動維護的，所以它會落後於 repo。`/grilling` 推出了很久之後，路由器才提到它。

**它說我有一半的 skill 沒安裝。**

這是一個已知的 bug，而且還沒修好。路由器帶你走過的大多數 skill 都設定了 `disable-model-invocation: true`，這代表 harness 會把它們排除在它注入 agent context 的 skill 清單之外。agent 把那份清單當成完整的清單，於是回報它們不存在。在一個被回報的 session 中，它宣稱整個 spec 與 ticket 流程都不存在，並改走單純的 `/grilling` 和 `/tdd`。這個 plugin（外掛）的二十七個 skill 中，有十六個帶有這個旗標，所以這是常態，而不是特例。它們其實已經安裝了。還是照樣輸入 slash command（斜線指令），或檢查 `.claude-plugin/plugin.json`，它才是判斷有哪些 skill 存在的權威來源。

**它描述了某個 skill 的行為，但那個 skill 根本不是這樣。**

這也是一個真實的 bug，也還沒修好。路由器是根據它自己對每個 skill 的一行摘要來回答，而不是根據 skill 本身。一份詳細的回報在單一 session 中追蹤到三個案例，其中包括只根據 "turn the thread into a spec"（把對話串變成 spec）這個摘要，就建議跳過 [to-spec](https://aihero.dev/skills-to-spec)。路由器從來沒有打開 `to-spec/SKILL.md`。每一次都是在使用者反駁之後，它才去驗證，從來不是主動的。在那個案例中跳過 `to-spec`，讓他們少做了一次真正的 seam（接縫：可以觀察或替換行為的邊界）檢查，結果產出的 ticket 低估了工作量。當路由器對另一個 skill 做出你會據以行動的陳述時，請它先打開那個 `SKILL.md`。地圖完全沒涵蓋的問題也一樣，例如要不要用 [plan mode](https://www.aihero.dev/ai-coding-dictionary/agent-mode)（規劃模式）：那個答案是 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）的推論，不是這裡寫下來的東西。

**為什麼它是散文，而不是編號的檢查清單？**

這個抱怨很合理。有一個還沒關閉的 issue（議題）主張大部分的路由都是確定性的，而敘述形式讓人很難快速瀏覽。沒有什麼能阻止你要求精簡版：說 "just give me the sequence"（直接給我順序就好）就能拿到序列。散文承載的是條件性的部分：分支、預期由人類做決定的地方，以及在步驟之間要在哪裡 clear 或 compact。一份扁平的檢查清單剛好會丟掉這些。

**它能在我自己的 skill，或其他作者的 skill 之間幫我指路嗎？**

不能。有三個不同的提案，要求一個會讀取你本地 `skills/` 目錄、並根據已安裝的東西來推薦的路由器。`ask-matt` 不是那種東西。它是一張手動維護的、單一 skill 集合的地圖，對你自己寫的或從別處安裝的 skill 一無所知。

**它叫我去編輯一個 SKILL.md。**

這個建議常常是對的，但改動很少能持久。有人問它要怎麼讓 [implement](https://aihero.dev/skills-implement) 關閉 ticket，被告知在 skill 裡加一行，然後馬上看出問題。`npx skills update` 會覆寫那個檔案，而 plugin 安裝是唯讀的。把常駐的行為放在你自己的 `CLAUDE.md` 或 `AGENTS.md`，或在呼叫時直接說。你在 prompt（提示詞）裡做的改變，在更新後仍然有效。大家就是用這種方式讓流程改用 Linear 而不是 GitHub，或問它哪些未完成的 ticket 可以平行執行。

**它提到一個我沒有的 skill，或漏掉一個我有的。**

在假設它已經消失之前，先查 CHANGELOG（變更紀錄），看看是不是改名了。`writing-great-skills` 變成了 [writing-for-agents](https://aihero.dev/skills-writing-for-agents)，沒有別名；`to-prd` 變成了 [to-spec](https://aihero.dev/skills-to-spec)；`pathfinder` 變成了 [wayfinder](https://aihero.dev/skills-wayfinder)。有四個 skill 被直接退役，併入吸收它們的 skill：`ubiquitous-language`、`design-an-interface`、`qa` 和 `request-refactor-plan`。如果它漏掉了一個你有的 skill，那是路由器本身的落後，上面已經說明過。

## 運作正常的跡象 (It's working if)

- 它最後會說出要輸入什麼，然後就停在那裡，而不是自己開始做事。
- 它給的路線會提到要在哪裡 clear 或 compact context，以及哪裡需要你審查，而不只是一串 skill 名稱。
- 當兩個 skill 很接近時，它會說要用哪一個，以及為什麼另一個不適合你。
- 它對另一個 skill 行為的任何陳述，都會在執行紀錄中顯示它讀過那個 skill 的 `SKILL.md`。
- 你在它給的回覆中看到的是你自己的情況，而不是最接近的通用情境。

## 它在流程中的位置 (Where it fits)

`ask-matt` 是一個位於整個集合之上的 **standalone router**（獨立路由器）。它從來不是鏈中的一個步驟。它指向每一條鏈，而其他文件頁面都會連回它，所以沒有任何一頁需要重畫整張圖。從這裡出發，你最常落腳在 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，也就是主流程的起點，或 [triage](https://aihero.dev/skills-triage)，也就是給「別人送來的工作」、而不是「你自己開始的工作」的入口。

對於它所描述的那些 skill 來說，它是一份 [secondary source](https://www.aihero.dev/ai-coding-dictionary/secondary-source)（第二手資料）。當路由器和某個 `SKILL.md` 說法不一致時，以 `SKILL.md` 為準。
