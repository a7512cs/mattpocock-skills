> 繁體中文翻譯。原文：[to-tickets.md](../../../docs/engineering/to-tickets.md)

## 它做什麼 (What it does)

`to-tickets` 拿一份計畫、一份 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格書），或你正在進行的對話，把它拆成你 issue tracker（議題追蹤系統）上的一組 **[tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)**（工單）。每個 ticket 都會宣告它的 **blocking edges**（阻擋關係）：在它能開始之前必須先完成的其他 ticket。

每個 ticket 都是一顆 **tracer bullet**（曳光彈）：一條窄但完整、穿過這次改動每一層（schema、API、UI、測試）的路徑，一完成就能單獨 demo。這就是這個 skill（技能）和直覺拆工作方式的不同之處，直覺的方式是一次切一層，最後再整合。它也會把每個 ticket 的大小控制在一個全新的 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window)（上下文視窗）放得下的範圍，因為接手這個 ticket 的會是一個從沒看過你的 spec 的 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段：一次對話）。

## 什麼時候用它 (When to reach for it)

你要輸入 `/to-tickets` 來呼叫它。[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（AI 代理）不會自己去用它。

| 你現在的處境 | 要執行什麼 |
| --- | --- |
| 你有一個 spec issue（議題），而且建造工作跨越好幾個 session | `/to-tickets`，或 `/to-tickets #<spec_issue>` |
| 計畫只存在於對話中，從沒寫下來 | `/to-tickets` 會直接讀對話串，不需要 spec |
| 整個改動放得進一個 context window | [implement](https://aihero.dev/skills-implement)，跳過 ticket |
| 還什麼都沒決定 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，然後 [to-spec](https://aihero.dev/skills-to-spec) |
| 一張 [wayfinder](https://aihero.dev/skills-wayfinder) map（地圖）已經完成 | 先用 [to-spec](https://aihero.dev/skills-to-spec) 收斂 map，再用 `/to-tickets` |

`to-tickets` 產出的 ticket 天生就是 agent-ready（agent 可以直接接手）的。不要對它們跑 [triage](https://aihero.dev/skills-triage)（分流）。triage 是給別人送進來的工作用的。

## 前置條件 (Prerequisites)

`to-tickets` 會發布到 tracker 裡，所以 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 必須已經為這個 repo（儲存庫）設定好一個 tracker，以及 triage 標籤的詞彙。兩種都可以：像 GitHub 或 Linear 這樣真正的 tracker，或是 `.scratch/` 底下的本機 markdown 檔案，後者不需要額外設定就能用。

## 用 tracer bullet，不用分層 (Tracer bullets, not layers)

**horizontal**（水平）切片一次交付改動的一層。在每一層都完成之前，什麼都不會動，而且每個 ticket 的驗收標準都必須伸手碰到另一個 ticket 負責的工作。**vertical**（垂直）切片（也就是 tracer bullet）一次交付一條貫穿所有層的細路徑，所以它可以單獨驗證，而且它評分的所有東西都歸它自己負責。

這是大家最常違反的規則。有一個團隊跑了一疊按層切分的 26 個 ticket（corpus、producer、aggregator、selector），結果每關閉一個 ticket 大約要跑二十次 agent，其中約四分之三是重做。他們自己的事後檢討把每一類失敗都追溯到水平切分，而不是各個實作本身。

在發布任何東西之前，會先發生兩件事。`to-tickets` 會找出 prefactoring（預先重構，也就是「先讓改動變容易，再做那個容易的改動」這個原則），並把這類工作排在最前面。接著它會把拆解結果以編號清單呈現，並針對它考你：粒度對不對、blocking edges 是不是真的、有沒有東西該合併或拆開。在你核准之前，什麼都不會送到 tracker，而那場考問就是你提出反對的地方。

## Blocking edges

這些 edge（關係）才是這個產出物的重點。依 tracker 不同，它們有兩種運作方式：

| Tracker | edge 存在哪裡 | 你怎麼處理它們 |
| --- | --- | --- |
| 本機 markdown | 文字，每個 ticket 一個檔案，放在 `.scratch/<feature>/issues/<NN>-<slug>.md`，依阻擋者優先的順序編號 | 從上到下，手動處理 |
| 真正的 tracker（GitHub、Linear） | 原生的阻擋連結，或在 tracker 支援時用 sub-issue（子 issue） | 任何阻擋者都已完成的 ticket 就在 **frontier**（前沿）上，可以直接拿去做 |

不論哪種方式，edge 都存在 ticket 裡。tracker 只決定是否有東西能平行地依據它們行動。`to-tickets` 產出這個產出物；執行它（一次一個 session，或一整批）是你的工作，不是 skill 的工作。

## 大範圍重構的例外 (The wide-refactor exception)

有一種形狀會打破 tracer bullet 規則。**wide refactor**（大範圍重構）是一個單一的機械式改動（重新命名一個欄位、改變一個共用符號的型別），它的 **blast radius**（爆炸半徑：受影響的範圍）涵蓋整個 codebase（程式碼庫）。一次修改就會弄壞成千上萬個呼叫點，所以沒有任何 vertical slice（垂直切片）能以綠燈狀態合併進去。

`to-tickets` 會改用 **expand-contract**（先擴張再收縮）的方式來安排順序：

- **Expand**（擴張）：在舊形式旁邊加上新形式，所以什麼都不會壞。
- **Migrate**（遷移）：分批把呼叫點搬過去，每批大小依 blast radius 而定（每個 package、每個目錄），每批一個 ticket，每個都被 expand 阻擋。CI（持續整合）保持綠燈，因為舊形式還在。
- **Contract**（收縮）：當沒有呼叫者剩下時，刪除舊形式，放在一個被每個 migrate 批次阻擋的 ticket 裡。

如果連個別批次都無法單獨保持綠燈，它們就共用一個 integration branch（整合分支），並且全部阻擋最後一個整合並驗證的 ticket。CI 只需要在那個 ticket 上是綠燈。

## 常見問題 (Common questions)

**一個三行的改動，它產出了十二個 ticket。**
過度拆解是這個 skill 被回報最多的問題，很多使用者都遇過。[model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）預設會拆成最小單位，並失去能讓它們有意義的分組。考問那一步就是你修正它的地方。要求它合併 ticket，它就會照做。另外也有下限。如果整個改動放得進一個 context window，你根本不需要這個 skill。直接去用 [implement](https://aihero.dev/skills-implement)。

**產出的 ticket 是一層一個：所有 schema 在一個，所有 API 在另一個。**
vertical slice 規則就是為了防止這種失敗而寫的，但這個 skill 有時還是會產出這種結果。在考問那一步把它抓出來，方法是對每個 ticket 問一個問題：這個做完之後，我可以 demo 什麼？答不出來的 ticket 就是水平切片。有些人因此在每個 ticket 加一行「demo path」（展示路徑），並回報這樣能把 model 推向 vertical slice。

**在 GitHub 上，ticket 沒有被建立成 spec issue 的 sub-issue。**
這在十幾次執行和好幾個 model 上都有人回報，[在 issue #554 裡講得最完整](https://github.com/mattpocock/skills/issues/554)。已修正：`to-tickets` 現在會把每個 ticket 建成其來源 issue 的 sub-issue，而 GitHub tracker 範本也提供了指令（`gh issue create --parent <n>`，`gh` 2.94+）。重新執行 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 來更新舊版的 `docs/agents/issue-tracker.md`。

**「Blocked by」被寫進 issue 內文，而不是真正的阻擋連結。**
這是同一類問題，[在 issue #513 被回報](https://github.com/mattpocock/skills/issues/513)，當時 agent 甚至宣稱 GitHub 完全沒有原生的阻擋關係。其實有：`gh issue create --blocked-by 12,15`。因為這個 skill 會先發布阻擋者，所以建立時一定拿得到它們的編號。內文文字本來是給沒有原生 edge 的 tracker 當備案用的，不是預設做法。現在當 edge 是原生的時候，ticket 範本會省略 `## Blocked by`。

**本機的 ticket 放在哪裡？v1.1 的說明寫的是根目錄的 `tickets.md`。**
確實是這樣寫的，而那是個 bug。單一共用檔案在平行 agent 寫入時也會造成競態條件。本機模式現在會在 `.scratch/<feature-slug>/issues/<NN>-<slug>.md` 底下為每個 ticket 寫一個檔案，依相依順序排列，符合本機 tracker 範本原本就描述的結構。`NN` 前綴是真正的 ticket ID，所以可以用 `/implement 03`，不必重打一長串標題。

**它試著讀我的 spec 時，一直被截斷。**
一份非常大的 spec 可能超出 tracker issue 能乾淨回傳的範圍。沒有本機副本可以退而求其次，所以 agent 會花掉很多 [tool calls](https://www.aihero.dev/ai-coding-dictionary/tool-call)（工具呼叫）反覆抓取片段，卻永遠讀不到結尾。不要在 `/to-spec` 和 `/to-tickets` 之間 [clear](https://www.aihero.dev/ai-coding-dictionary/clearing)（清除 context）或 [compact](https://www.aihero.dev/ai-coding-dictionary/compaction)（壓縮 context）。在同一個 context window 裡執行它們，agent 就永遠不需要再抓一次 spec。

**驗收標準什麼都沒檢驗到：有些在任何工作完成前就已經通過了。**
範本要求寫出標準，卻完全沒提到它們是否可能失敗，所以會發生這種事。有三種形狀反覆出現：在基準 commit（提交）上就已經成立的標準、只有另一個 ticket 的工作才能滿足的標準，以及只是重述需求、而不是從產出物推導出來的標準。vertical slicing 能防止大部分問題，因為一個交付新行為的切片，本質上在基準 commit 就一定會失敗。不過這個檢查還是值得手動做。對每一條標準，說出能證明它不成立的觀察，並確認它在實作者開始時的那個 commit 上確實失敗。

**ticket 已經發布了。我實際上要怎麼執行它們？**
這個 skill 停在產出物這一步，沒有自動派工模式。派工是手動的：看看看板，數一數沒有未完成阻擋者的 ticket 有幾個，就開幾個 agent session。給每個 ticket 一個全新的 context（上下文），並在它們之間清除。[implement](https://aihero.dev/skills-implement) 完成時不一定會關閉或勾選 ticket，不論是在 GitHub 還是本機 markdown，所以你要自己更新 ticket 的狀態。

## 運作正常的跡象 (It's working if)

- 每個 ticket 都答得出「這個做完之後，我可以 demo 什麼？」，而且答案是行為，不是一個層。
- 在發布任何東西之前，清單會帶著編號回到你面前，每一項都有一行「Blocked by」。
- 最上面的 ticket 沒有阻擋者，可以立刻開始。
- ticket 內文裡沒有任何檔案路徑或行號，除了 prototype（原型）產出的程式碼片段。
- 每個 ticket 讀起來都像是一個全新的 session 不需要你在場就能完成的東西。
- 如果有找到 prefactoring，它會排在順序的最前面，而不是混在功能 ticket 裡。

## 它在流程中的位置 (Where it fits)

`to-tickets` 是主要建造鏈中的一步：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

上游是 [to-spec](https://aihero.dev/skills-to-spec)，它交給這個 skill 一份已經定案的 spec 來切分。讓兩者在同一個 context window 裡，中間不要 clear。下游是 [implement](https://aihero.dev/skills-implement)，它每個全新 session 建造一個 ticket，用 [tdd](https://aihero.dev/skills-tdd) 推動測試，最後以 [code-review](https://aihero.dev/skills-code-review) 收尾。[implement-spec](https://aihero.dev/skills-implement-spec) 是另一條往下的路。它把同樣的 blocking edges 當成 task graph（任務圖）來讀，並在一個 integration branch 上平行建造每一個已就緒的 ticket。當你不確定哪個 skill 或流程適合時，[ask-matt](https://aihero.dev/skills-ask-matt) 會幫你指路。
