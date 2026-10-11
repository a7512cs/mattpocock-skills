> 繁體中文翻譯。原文：[triage.md](../../../docs/engineering/triage.md)

## 它做什麼 (What it does)

`triage` 會逐一處理你專案 tracker（追蹤系統）上的 issue（議題）。它讓每一個 issue 走過一個由 **triage roles**（分流角色）組成的小型狀態機（一個類別角色和一個狀態角色）。每個 issue 最後會變成一份 agent-ready（agent 可以直接接手）的 brief（工作說明）、一個要問回報者的具體問題，或是一個記錄了原因的已關閉 issue。

它只用於**不是你建立的** issue。也就是原始的 bug 回報、外來的功能需求，或一個沒打招呼就出現的外部 pull request：從外部進到 tracker 的工作，保持著回報者留下的任何樣子。來自 [to-tickets](https://aihero.dev/skills-to-tickets) 的 [Tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（工單）已經是 agent-ready 的，所以如果你對它們跑 `triage`，就是浪費功夫。規則很簡單：`/triage` 只用於外來的 issue，不用於你自己建立的 issue。

它和手動貼標籤的不同之處還在於：它先提出建議，然後等待。它會給你它判斷的類別和狀態以及理由，加上它在 codebase（程式碼庫）裡找到的東西，而且在你告訴它之前，什麼都不會套用。

## 什麼時候用它 (When to reach for it)

你要輸入 `/triage`，然後用白話描述你想要什麼來呼叫它。[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（AI 代理）不會自己去用它。例如：「給我看任何需要我注意的東西」、「我們來看 #42」、「把 #42 移到 ready-for-agent」。

| 你手上有什麼 | 該去哪裡 |
| --- | --- |
| 一個塞滿別人原始回報的 tracker | `/triage` |
| 你自己的一個粗略想法，什麼都還沒寫下 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 一段已經定案、要轉成 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格書）的對話 | [to-spec](https://aihero.dev/skills-to-spec) |
| 一份要拆成 agent-ready ticket 的 spec | [to-tickets](https://aihero.dev/skills-to-tickets) |
| 一個已確認、需要找出根本原因而不是貼標籤的 bug | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |

## 前置條件 (Prerequisites)

`triage` 會讀寫你的 issue tracker（議題追蹤系統），所以必須先用 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 設定好這個 tracker 和它的標籤詞彙。下面的角色名稱是 **canonical**（標準名稱）。你 tracker 裡的標籤字串可能不同，setup 會提供對應關係。如果你的 tracker 已經完全使用標準名稱，你就沒有東西要對應，也沒有東西要設定。

tracker 設定也決定了外部 pull request 是否算作一種請求入口，以及誰算是外部的人。這個旗標預設是關閉的，而且 setup 已經不再詢問它。要把 PR（pull request）納入範圍，請在 `docs/agents/issue-tracker.md` 裡開啟它。

## 狀態機 (The state machine)

每個經過 triage 的項目最後都恰好有一個類別角色和一個狀態角色。類別有兩種：`bug`（有東西壞了）和 `enhancement`（新功能或改進）。狀態有五種：

| 狀態 | 意思 |
| --- | --- |
| `needs-triage` | 你需要評估它。沒有標籤的 issue 通常會先落在這裡。 |
| `needs-info` | 等待回報者。他們回覆後會回到 `needs-triage`。 |
| `ready-for-agent` | 已完整定義，並附上 agent brief。[AFK](https://www.aihero.dev/ai-coding-dictionary/afk)（離開鍵盤：agent 自己跑，不需要人在場）agent 可以接手。 |
| `ready-for-human` | 同樣的 brief，再加上為什麼 agent 做不了：需要判斷、需要外部存取權限、需要手動測試。 |
| `wontfix` | 已關閉，並記錄原因。 |

這就是全部的詞彙。每個項目恰好一個狀態角色的規則，讓查詢保持簡單。狀態也是這個 [skill](https://www.aihero.dev/ai-coding-dictionary/skill)（技能）被要求最多的部分。使用者要求過：給已定義但被另一個 issue 阻擋的工作一個狀態、給等待未來某個觸發條件的工作一個 `deferred` 狀態，以及一個終止的 `implemented` 狀態。這些都還沒推出。見下面的問題。

`wontfix` 有三種情況。差別很重要，因為只有其中一種會寫入知識庫：

| 你為什麼要關閉它 | 會發生什麼 |
| --- | --- |
| 已經實作過了 | 一則留言，指出這個功能已經存在於哪裡。不會寫任何東西到 `.out-of-scope/`，因為它是已經建好的功能，不是被拒絕的功能，而在那裡放一個檔案會破壞去重檢查。 |
| 被拒絕的 bug | 禮貌地說明，然後關閉。 |
| 被拒絕的 enhancement | 在 `.out-of-scope/` 放一個檔案，從關閉留言連結過去，然後關閉。 |

`.out-of-scope/` 為每一個被拒絕的**概念**存一個 markdown 檔，而不是每個 issue 一個。每個檔案都是一份簡短的設計文件，不是資料庫裡的一列。它說明拒絕了什麼、為什麼，並列出每一個提出這個需求的 issue。`triage` 在評估任何東西之前，會先讀完整個目錄。它依概念比對，而不是依關鍵字，所以「夜間主題」會比對到 `dark-mode.md`。找到相符的項目時，它會給你看舊的決定，並問你是否仍然同意，而不是從頭再爭論一次這個需求。

## 先驗證，再寫 brief (Verify before you brief)

在任何 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式提問）之前，`triage` 會先檢查這個說法是否成立。如果是 bug，它會照著回報者的步驟重現它。如果是 PR，它會 check out 那個 branch（分支）並執行相關的測試。然後它會回報三種結果之一：

- 已確認，附上程式碼路徑。
- 無法重現。
- 細節不足，無法嘗試。這是最強烈的 `needs-info` 訊號。

在同一輪裡，它還會對 codebase 執行另外兩項檢查。**redundancy**（重複）檢查會問這個功能是否已經實作，並依領域概念搜尋，而不是依回報者的用字。**prior rejection**（先前已拒絕）檢查會問 `.out-of-scope/` 是否已經拒絕過。兩項檢查都很便宜，任何一項命中都會產生 `wontfix`。

這些工作全都是為了讓一個產出物變好：**agent brief**（給 agent 的工作說明）。這是 issue 移到 `ready-for-agent` 時，`triage` 貼出的結構化留言。`triage` 貼出它之後，brief 就是合約，原本的回報只是 context（上下文）。brief 追求的是 **durable**（經得起時間）而不是精確，因為一個 issue 可能在 `ready-for-agent` 裡放上好幾週，而程式碼在這段期間會改變。所以 brief 會指名型別、函式簽章和行為合約，但絕不寫檔案路徑或行號。一個已確認的重現，會讓 brief 比靠猜測寫的強得多。

## PR 是附帶程式碼的 issue (A PR is an issue with attached code)

如果 tracker 把外部 pull request 當成一種請求入口，它們就會走過同一個狀態機，使用相同的類別、狀態和轉換。狀態套用在 diff（差異）上。`ready-for-agent` 表示附上了 brief，agent 應該在程式碼上進行下一步。`ready-for-human` 表示人可以 merge（合併）它。PR 上的 brief 描述的是現有 diff 還剩下什麼要做，而不是怎麼從零開始建造這個東西。

探索階段只會顯示*外部*的 PR，因為協作者進行中的 branch 不是 triage 的工作。這個過濾只適用於探索階段。如果你明確指名一個 PR，不論是誰寫的，`triage` 都會處理它。

## 常見問題 (Common questions)

**我跑了 `/to-spec` 和 `/to-tickets`，現在那些 ticket 還沒經過 triage 就擺在那裡。我要對它們跑 `/triage` 嗎？**
不用。它們已經是 agent-ready 的了。`to-tickets` 發布它們時就會貼上 `ready-for-agent` 標籤，所以 AFK runner 不需要再多一輪就能接手。遇到這個問題的使用者跑了 spec 流程，在產出上看到的是 `needs-triage`，結果他們的 AFK runner 什麼都忽略了。`triage` 是外部進來的工作的入口匝道（on-ramp）。spec 流程是你自己開始的工作所走的車道。兩者在 `ready-for-agent` 交會，不會更早。

**既然現在有 `to-spec` → `to-tickets` → `implement` 流程，`triage` 還有用嗎？**
只有在你有外來工作時才有用。`triage` 比那個流程更早出現，做的是不同的工作：它處理別人提交的回報。如果你 tracker 裡的一切都來自你自己的規劃，你很少會用到它。如果你維護任何公開的東西，或你的團隊會向你提交 bug，那它就是這類工作的起點。主要的用途是接受外部貢獻者 issue 的開源 repo（儲存庫）。

**agent 試著套用 `ready-for-agent`，結果 `gh` 說這個標籤不存在。**
這是一個已知、尚未解決的 bug（[#616](https://github.com/mattpocock/skills/issues/616)）。`setup-matt-pocock-skills` 會把標籤詞彙寫進 `docs/agents/triage-labels.md`，但不會在你的 tracker 裡建立這些標籤。用 `gh label create` 或 tracker 的 UI，自己建立五個狀態標籤和兩個類別標籤，做一次就好，錯誤就會消失。這個 issue 連到一個社群修正 branch，但它還沒被 merge。

**五個狀態不夠用。那 blocked、deferred 或 implemented 呢？**
這是這個 skill 被提交最多的缺口。它有三種形式：

- 一個已完整定義、但要等另一個 issue 關閉的 issue（[#139](https://github.com/mattpocock/skills/issues/139)）。回報者說 `ready-for-agent` 在那裡「技術上是對的」，但會誤導人，所以 agent 接手後就卡住了。
- 打算要做、但要等某個觸發條件的未來工作，所以現在還不能動手（[#297](https://github.com/mattpocock/skills/issues/297)）。
- 一個表示「已實作，等待驗證」的終止狀態。沒有它，AFK runner 可能會把已完成的 ticket 再次排進佇列。

blocked 這個情況已經被接受是真實的需求，但名稱還沒決定（`blocked` 還是 `paused`）。這些都還沒推出。作為替代做法，大家會在類別旁邊加一個 repo 自己的額外標籤。這樣狀態欄位就能放一個準確的值，但 skill 不知道這個額外標籤的存在。有一個社群 fork 更進一步，加了 `needs-slicing`、`tracking` 和工作量標籤。這行得通，但它屬於那個 fork，不屬於這個 skill。

**這和 `/diagnosing-bugs` 有什麼不同？**
這裡的驗證步驟是刻意做得很淺的。它回答「這是真的嗎，大概在哪裡」，不會去找根本原因。如果照回報者的步驟幾分鐘內重現不了 bug，就用 `needs-info`，或者如果你想現在就調查，就用 [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs)。目前兩個 skill 的內文都還沒有提到對方。有使用者回報了這個缺口，它仍然尚未解決。

**我可以把它指向我整個待辦清單，讓它自己跑嗎？**
你可以這樣要求，但要注意它讀了什麼。「顯示需要注意的東西」這一輪是一份用來*挑選*的便宜清單。你挑一個 issue，然後 `triage` 才會收集那個 issue 的完整 [context](https://www.aihero.dev/ai-coding-dictionary/context)。如果你一次對二十個 issue 跑它，agent 可能會把那份便宜清單當成唯一的證據，而且不告訴你。這份清單會回傳 issue 內文，但不包含留言。有一位使用者就正好遇到這個情況。三個 issue 已經有一則留言寫著「已經修好，建議關閉」，結果三個都反而拿到了新的 agent brief。要做批次處理時，請明確說它必須讀每個 issue 的留言。

**它能搭配 Linear，或 GitHub Issues 以外的東西用嗎？**
可以。tracker 是設定，不是寫死的假設。大家會拿它搭配 Linear（透過 `linear` CLI）、GitLab，以及 `.scratch/` 底下的純 markdown 檔案。一種常見的分工是：Linear 管 issue 和規劃，GitHub 管程式碼和 PR。這樣一來，說「issue tracker」的 skill 就對應到 Linear，說「PR」的 skill 就對應到 GitHub。本機 markdown tracker 有一個尚未解決的範本 bug：產生的檔案可能會包含兩次驗收標準，一次在最上層，一次在 agent brief 裡（[#200](https://github.com/mattpocock/skills/issues/200)）。

## 運作正常的跡象 (It's working if)

- 它處理過的每個項目最後都恰好有一個類別角色和一個狀態角色，絕不會是零個，也絕不會有兩個互相衝突的狀態。
- 它給你附理由的建議，然後停下來。它不會重新貼標籤然後就繼續往下。
- 在任何東西進到 `ready-for-agent` 之前，它已經重現過 bug，或 check out 並執行過 PR。
- 它寫的 brief 指名的是型別和行為，不包含檔案路徑，也不包含行號。
- 當一個你六個月前拒絕過的需求又回來時，它會告訴你並引用當時的理由，而不是再 triage 一次。
- 它貼出的每則留言都以 `> *This was generated by AI during triage.*` 開頭

## 它在流程中的位置 (Where it fits)

`triage` 是一個 **on-ramp**（入口匝道），不是主鏈中的一步。主流程從你自己的一個想法開始（grill、spec、tickets、implement、review）。`triage` 是給別人送來的工作走的平行車道。兩條車道的終點相同：一個貼著 `ready-for-agent` 標籤、附有 brief 的 issue。[implement](https://aihero.dev/skills-implement) 接手它的方式，和接手來自 [to-tickets](https://aihero.dev/skills-to-tickets) 的 ticket 一樣。當一個需求在 `triage` 能寫 brief 之前需要更多細節時，`triage` 會同時執行 [grilling](https://aihero.dev/skills-grilling) 和 [domain-modeling](https://aihero.dev/skills-domain-modeling)，一次一輪問題，所以它會在你做決定的當下，把決定記錄到 `GLOSSARY.md` 和 ADR（架構決策紀錄）裡。當你不確定自己在哪條車道時，[ask-matt](https://aihero.dev/skills-ask-matt) 會幫你指路。
