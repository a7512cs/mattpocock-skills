> 繁體中文翻譯。原文：[wayfinder.md](../../../docs/engineering/wayfinder.md)

## 它做什麼 (What it does)

`wayfinder` 處理的是一個大到一個 agent（AI 代理）[session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段：一次對話）裝不下的工作。這是一個你說得出 **destination**（目的地），卻還看不清路線的想法。wayfinder 會把它畫成你 issue tracker（議題追蹤系統）上一張共享的 **map**（地圖），由 **decision tickets**（決策工單）組成，然後一次解決一個 ticket，直到路線變清楚。

它只規劃，不建造。每個 ticket 都在問一個問題，而答案是一個決定，不是建造工作的一個切片。當有人開始建造之前已經沒有任何東西需要決定時，map 就完成了。這條規則把 wayfinder ticket 和一般的實作 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) 區分開來，而它也是 agent 最常違反的規則。當 map 完成時，wayfinder 會做 handoff（交接），不會繼續寫程式碼。

## 什麼時候用它 (When to reach for it)

你要輸入 `/wayfinder` 來呼叫它；[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不會自己去用它。

它是這整套裡最重的流程，所以 trigger（觸發條件）很窄。工作必須大於一個 agent session 能容納的量，而且通往 destination 的路線必須是不清楚的。分界線在於 session 數量：單一 session 的規劃用 `/grill-with-docs`，多個 session 的規劃用 `/wayfinder`。

| 你眼前有什麼 | 要執行什麼 |
| --- | --- |
| 一個範圍明確、一次就能定案的功能 | [grill-me](https://aihero.dev/skills-grill-me)，或在有 codebase（程式碼庫）時用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 一個全新專案，或一個跨越很多 session 的建造工作，而且路線還不清楚 | `/wayfinder` |
| 一段決定已經做完的對話 | [to-spec](https://aihero.dev/skills-to-spec)：直接跳過 map |
| 一張已完成的 wayfinder map | [to-spec](https://aihero.dev/skills-to-spec)，然後 [to-tickets](https://aihero.dev/skills-to-tickets) 和 [implement](https://aihero.dev/skills-implement) |
| 一個已經長得太大的現有 session | 說「hand off to `/wayfinder`」（[handoff](https://aihero.dev/skills-handoff) 既能把工作接進 map，也能把工作從 map 接出去） |

全新專案不是必要條件。大家經常在舊有和蓋到一半的 codebase 上使用 wayfinder，而且它在那裡可能更有用，因為很多迷霧（fog）是「這裡已經是什麼狀況」，而不是「我們應該做什麼」。

## 前置條件 (Prerequisites)

map 和它的 ticket 都放在 repo（儲存庫）的 issue tracker 上，所以 wayfinder 需要用 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 完成 tracker 設定。那一步會寫出一個「Wayfinding operations」章節。這個章節描述如何在 GitHub、GitLab 或本機 markdown 上表達 map、它的 child ticket（子工單）、blocking edges（阻擋關係）和 frontier query（前沿查詢）。wayfinder 是透過你 `CLAUDE.md` / `AGENTS.md` 裡的指標找到那份文件，而不是在固定的路徑。如果沒有設定 tracker，它會退回使用本機 markdown 檔案。

tracker 做的是實際的工作。它原生的阻擋連結會在 tracker 自己的 UI 裡顯示 frontier（前沿）。在沒有原生相依連結的 tracker 上（例如自架的 Gitea），wayfinder 會從 map 的文字推斷阻擋者。這行得通，但你必須更密切地監督它。

## Map、迷霧與 frontier (The map, the fog, and the frontier)

**map** 是一個貼了 `wayfinder:map` 標籤的單一 issue，它的 ticket 就是它的子 issue。它是**索引（index），不是倉庫（store）**。一個決定只存在一個地方，也就是它的 ticket，map 只提供一行摘要和一個連結。session 會以低解析度載入 map，需要時才打開個別的 ticket。這讓 map 可以一直成長，而不需要每個 session 都載入它的完整歷史。

map 有四個章節：

- **Destination**（目的地）。這張 map 的終點長什麼樣子。你要最先為它命名，在任何 ticket 存在之前，因為 destination 決定了你用來衡量每個 ticket 的範圍。
- **Decisions so far**（目前為止的決定）。每個已關閉的 ticket 一行，每行都附上連結，指向細節所在的地方。
- **Not yet specified**（尚未定義）。這就是 **fog of war**（戰爭迷霧）：你看得出即將到來、但還無法清楚表述的決定。判斷是 fog 還是 ticket 的標準，是你*現在*能否精確地說出這個問題，而不是你能否回答它。當你解決一個 ticket，它前方的 fog 就會散開，任何你現在能定義的東西都會升級成一個新的 ticket。
- **Out of scope**（範圍外）。超出 destination 的工作。fog 只會*朝著* destination 聚集，所以範圍外的工作會保持關閉，永遠不會升級。

**frontier** 是一組開啟中、沒被阻擋、沒被認領的 ticket（已知範圍的邊緣）。session 在做任何工作之前，會先把 ticket 指派給自己來認領它。被指派人*就是*認領的依據，所以同時進行的其他 session 會跳過那個 ticket。session 用名稱來稱呼 ticket，絕不只用光禿禿的 `#42`，因為一整片 issue 編號在敘述中很難閱讀。

## 四種 decision ticket 類型 (The four decision-ticket types)

每個 ticket 都帶有一個 `wayfinder:<type>` 標籤。每個 ticket 不是 **[HITL](https://www.aihero.dev/ai-coding-dictionary/human-in-the-loop)**（和一位能為自己發言的人一起處理），就是 **[AFK](https://www.aihero.dev/ai-coding-dictionary/afk)**（由 agent 單獨推動）。HITL ticket 只能透過即時的交流來解決。一個自己回答自己 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式提問）問題的 agent，就是破壞了它。

| 類型 | 模式 | 什麼時候用 | 由什麼解決 |
| --- | --- | --- | --- |
| `grilling` | HITL | 預設類型。這個問題可以透過討論來定案。 | [grilling](https://aihero.dev/skills-grilling) 加上 [domain-modeling](https://aihero.dev/skills-domain-modeling)，在一個全新的 session 裡 |
| `prototype` | HITL | 「這應該長什麼樣子」或「這應該怎麼運作」：討論無法定案的問題。 | [prototype](https://aihero.dev/skills-prototype)，並從 ticket 連結到建好的產出物 |
| `research` | AFK | 工作目錄以外的某個事實阻擋了一個決定。 | 一個 [research](https://aihero.dev/skills-research) [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent)（子 agent），在你畫 map 時啟動，並在 `research/<name>` branch（分支）上平行執行 |
| `task` | 兩者皆可 | 沒有東西要決定，但有手動工作阻擋了一個決定，例如開通存取權限、註冊一個服務，或搬移資料好讓你看清它的樣子。 | 能做的地方由 agent 單獨完成，否則提供一份給人用的精確檢查清單 |

`task` 是唯一一個*動手做*而不是做決定的類型。它之所以屬於 map，只因為它能解除一個決定的阻擋，絕不是因為它交付了 destination 的一部分。這個類型在實務上最常出錯。agent 會把它當成實作步驟，開始在 map 裡寫產品程式碼。

research 是*每個 session 一個 ticket* 這條規則唯一的例外。

## 常見問題 (Common questions)

**這和 `/grill-with-docs` 有什麼不同？我應該從哪一個開始？**
看 session 數量，不是看專案大小。`/grill-with-docs` 是單一 session 的規劃；wayfinder 是多個 session 的規劃。如果你能在一段對話裡掌握整件事，grilling 更便宜也更好，而在那種情況下 wayfinder 更慢、更繁重。社群的簡單說法是：只有當工作放不進單一 session 時，wayfinder 才有意義。這是到目前為止 wayfinder 被問最多的問題。大家一直問，是因為 skill（技能）的 description（描述）沒有告訴你，你自己的任務落在那條線的哪一邊。你必須自己判斷 session 數量。

**當它問「destination」時，指的是這個 session 的終點，還是一切的終點？**
是整張 map 的終點，不只是第一個 session。這個問題讀起來有歧義，但 wayfinder 依定義就是跨多個 session 的工具，所以以單一 session 為範圍的答案永遠不合理。典型的 destination 有：一份要交接出去的 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格書）、一個在規劃開始前要鎖定的決定、一個概念驗證，或一個就地進行的改動，例如資料遷移。

**map 已經完成了。wayfinder 不是已經寫好 spec、建好 ticket 了嗎？為什麼我還需要 `/to-spec` 和 `/to-tickets`？**
不是。wayfinder 的 ticket 是 decision ticket，等到 map 關閉時，它們也全都關閉了。剩下的是一張充滿互相連結的決定的 map，那不是建造計畫。[to-spec](https://aihero.dev/skills-to-spec) 會把那些連結起來的決定收斂成一份 spec（`/to-spec #<map_issue>`），而 [to-tickets](https://aihero.dev/skills-to-tickets) 會把那份 spec 切成 tracer bullet（曳光彈：貫穿所有層的一條窄路徑）式的實作 ticket。如果你把 map 直接接到 [implement](https://aihero.dev/skills-implement)，你就跳過了收斂這一步，也會失去連結在一起的細節。只有當工作最後發現很小時，才直接進入實作。有些人跑比較短的流程，並回報說行得通。多出來的兩個步驟會給你一份明確的 spec，讓審查者或同事可以閱讀，這在你不是獨自工作時更重要。

**我的 agent 在 wayfinder session 進行到一半時開始寫正式環境的程式碼。**
這是這個 skill 被回報最多的失敗，而原因是 skill 本身確實有個缺口。你可以在 map 的 **Notes**（備註）裡覆寫 wayfinder「只規劃，不動手」的預設。但 Notes 是 agent 寫的，所以限制和它的豁免都放在一個由受限 agent 自己掌控的檔案裡。有一位使用者看到 agent 在它自己的 Notes 裡寫下「這個 map 包含執行工作」。在之後的 session 裡，agent 把那一行讀回來當作許可，就在正式運作的伺服器上動手建造。這個 skill 沒有針對「我指的是預設行為」的硬性停止機制。在它有之前，請讀過任何不是你自己畫的 map 的 Notes，把實作放在不同的 session 裡，並把任何看起來像建造工作切片的 `wayfinder:task` 當成類型標錯了。

**我畫了 27 個 ticket，等我做到第十三個時，剩下的已經都不合理了。**
這個問題是從一份使用者回報逐字摘錄的，其他人也回報了同樣的結果。預設上，wayfinder 會做全面的規劃。當後面的 ticket 建立在前面的 ticket 推翻掉的假設上時，map 就會掉進批評者指控這個 skill 的瀑布式陷阱。有兩件事有幫助。第一，把 map 的範圍限定在一個有邊界的 destination，而不是整個產品。使用者回報，範圍限定在一個明確 epic 的 map，表現比一個無限蔓延的「實作 V1」好。目標是交付小幅度的增量，而不是規劃一個非常大的東西。第二，積極地做 [prototype](https://www.aihero.dev/ai-coding-dictionary/prototyping)（原型）。路線之所以能保持在最新狀態，是因為便宜又具體的產出物會在實作依賴不確定性之前就把它暴露出來。wayfinder 是「prototypemaxxing」（把原型做到極致），不是「planmaxxing」（把規劃做到極致）。

**我可以平行處理好幾個 ticket 嗎？**
frontier 會告訴你可以拿哪些 ticket，而 blocking edges 讓平行工作在紙面上是安全的。實務上，一次一個 ticket 是比較安全的預設。如果你同時處理兩個 grilling ticket，一個 session 可能會問你一個你剛在另一個 session 回答過的問題，因為 session 之間不共享任何 [context](https://www.aihero.dev/ai-coding-dictionary/context)（上下文）。prototype ticket 也有已知的缺口。有一位使用者回報，一個 agent 做了三種 UI 變化，自己挑了一個，就把 ticket 關掉了。那個選擇應該是你的，而這個 skill 目前還沒有說得夠清楚。如果你真的要平行執行 ticket，請先自己檢查相依關係圖。

**我一定要用 GitHub Issues 嗎？**
不用。任何 issue tracker 都可以。GitHub 的支援最好，因為它原生的 sub-issue 和阻擋關係，讓你不用打開 map 就看得到 frontier。大家也會用 GitLab、Linear、Jira 和本機 markdown。有兩個注意事項。在沒有原生阻擋功能的 tracker 上，wayfinder 會從文字推斷相依關係圖，你必須手動修正。本機 markdown 會把產出物放在你的 repo 裡，這是不建議的，因為存在 repo 裡的東西往往會意外地一直留著。開源專案的維護者遇到的是相反的問題（公開的 tracker 被 agent 產生的規劃 ticket 塞滿），所以常常還是選擇本機 markdown。

**grilling 讓人筋疲力盡。每個問題都長達三段。**
這是對 wayfinder 最尖銳、尚未解決的抱怨，目前還沒有人修好它。有一位使用者是這樣拆解的：冗長本身就會造成決策疲勞，而且長度掩蓋了 agent *為什麼*問這個問題，所以隨著 map 成長，你會失去決定與決定之間的脈絡。這種冗長看起來是目前這批 [models](https://www.aihero.dev/ai-coding-dictionary/model)（模型）的特性，而不是 skill 的特性。使用者會嘗試兩種緩解方式：較低的 [reasoning effort](https://www.aihero.dev/ai-coding-dictionary/effort)（推理強度），以及在你全域的 `CLAUDE.md` 裡加一條要求用白話表達的指示。不過在這裡還是要有心理準備得用力思考。wayfinder 要求你大量思考，那正是它大部分的目的，不是缺陷。

**一個我已經關閉的決定後來發現是錯的。我要修改舊的 ticket，還是建一個新的？**
沒有官方的指引，而 agent 的預設做法沒什麼幫助。它傾向於繞著那個錯誤的決定做設計，而不是挑戰它，所以你必須自己引導它。有效的做法是直接告訴 wayfinder 什麼改變了。接著它會更新 map、修改受影響的 ticket，並在已關閉的 ticket 上留言。你可以在 map 進行中從範圍變更裡恢復過來。但如果你一開始就把 map *設計*成會改變，那就表示範圍是錯的。

**`decision-mapping` 跑去哪了？**
就是這個 skill。v1.1 把它改名為 `wayfinder`，你用 `/wayfinder` 來呼叫它。「Decision map」是行話，而且也不準確，因為四種 ticket 類型中只有一種本身就是決定。新名字給了這個 skill 一套一致的詞彙（destination、fog of war、frontier、map），而不是在上面再疊一個自創的術語。單位保留了「decision」這個詞：wayfinder ticket 是一個 **decision ticket**（決策工單），這樣大家就不會把它讀成實作 ticket。

## 運作正常的跡象 (It's working if)

- 在任何一個 ticket 存在之前，destination 就已經寫下來並取得共識。
- 每個開啟中的 ticket 讀起來都是一個問題。任何讀起來像「建出 X」的 ticket，不是類型標錯了，就是屬於 map 下游的工作。
- 你看你的 tracker 就能知道哪些 ticket 可以拿，不用打開 map，因為原生的阻擋關係會顯示出 frontier。
- 一個 session 解決一個 ticket，把答案貼成一則解決留言，關閉它，並在 map 的 *Decisions so far* 加上一行。然後它就停下來。
- **Not yet specified** 會隨時間縮小。當 fog 升級成 ticket 時，它就離開那個章節，不會同時出現在兩個地方。
- 當一開始的廣度優先 grill 完全找不到 fog 時，skill 會停下來，告訴你這個工作夠小，可以跳過 map。
- 完成 map 的那個 session 會把你引導到 spec，而不是 pull request。

## 它在流程中的位置 (Where it fits)

`wayfinder` 是一個 **situational on-ramp**（視情況使用的入口匝道），不是預設的起點。大部分工作仍然從以 grill 帶頭的「想法 → 上線」鏈開始。當想法大到一個 session 裝不下時，你才用 wayfinder。它會在 [to-spec](https://aihero.dev/skills-to-spec) 重新接回那條鏈，因為完成的 map 會交接出去，不會自己建造。

大部分的工作發生在 wayfinder 安排的其他 skill 裡。[grilling](https://aihero.dev/skills-grilling) 和 [domain-modeling](https://aihero.dev/skills-domain-modeling) 解決預設的 ticket 類型，[prototype](https://aihero.dev/skills-prototype) 解決討論無法定案的 ticket，而 [research](https://aihero.dev/skills-research) 以 subagent 的形式執行，讓它的閱讀工作不會進到你的 session 裡。[handoff](https://aihero.dev/skills-handoff) 負責把工作移進移出：從一段長得太大的對話移進 map，以及在 session 中途出現支線任務時從 map 移出。其他任何情況，[ask-matt](https://aihero.dev/skills-ask-matt) 會在整套 skill 中幫你指路。
