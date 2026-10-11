---
name: wayfinder
description: Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear.
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/wayfinder/SKILL.md)
>
> **description 中譯：** 把一大塊工作（超過一個 agent session 能容納的量）規劃成你 issue tracker（議題追蹤系統）上一張由 decision ticket（決策單）組成的 shared map（共享地圖），然後一次解決一張，直到通往 destination（終點）的路變清楚。

一個鬆散的想法來了，它大到一個 agent（AI 代理）的 session（工作階段）裝不下，而且籠罩在 fog（迷霧）裡：從這裡到 **destination** 的路還看不見。Wayfinding（找路）是要找出那條路，而不是直衝 destination。這個 skill（技能包）把路線畫成 repo（程式碼儲存庫）的 issue tracker 上的一張 **shared map**，然後一次處理一張它的 **decision ticket**（這類問題的答案是一個決定，而不是一段要執行的建置工作），直到路線變清楚。

每項工作的 destination 都不同，而說出它是繪製的第一個動作：它會影響每一張 ticket（工作單）。它可能是一份要交出去再反覆修改的 spec（規格），一個在規劃開始前就要定下來的決定，或是一個就地完成的變更，例如資料結構遷移。map 不限領域：工程工作、課程內容，任何符合這種形態的東西都可以。

## 規劃，不要動手做 (Plan, don't do)

Wayfinder 預設是在做**規劃**：每張 ticket 解決一個決定，當路變清楚、在有人動手去做之前已沒有任何待決事項時，map 就完成了。想直接動手做的衝動，通常是一個訊號：你已經走到 map 的邊緣，是時候 handoff（交接）了。某項工作可以在它的 **Notes** 裡覆寫這條規則，把執行也帶進 map 本身；但如果沒有這樣寫，就產出決定，而不是交付物。

## 用名稱指稱 (Refer by name)

每張 map 和 ticket 都是一個 issue（議題），所以它有一個 **name**（名稱）：它的標題。在人類會讀到的所有內容裡（敘述文字、map 的 Decisions-so-far），都用那個 name 指稱它，絕不用單獨的 id、編號或 slug。一整片 `#42, #43, #44` 難以辨讀；name 一眼就能讀懂。id 和 URL 不會消失；name 會包住它的連結，但它們是藏在 name *裡面*，絕不取代 name。

## The Map

map 是這個 repo 的 issue tracker 上的單一 issue，標有 `wayfinder:map` 標籤，是唯一權威的產出物。它的 ticket 都是 map 的 child issue（子 issue）。

map 是一份 **index**（索引），不是存放處。它列出已做的決定，並指向保存其細節的 ticket；一個決定只存在於一個地方，也就是它的 ticket，所以 map 絕不重述它，只寫重點並附上連結。

**map、它的 child ticket（子工作單）、blocking（阻擋關係）和 frontier query（前沿查詢）實際存放在哪裡，取決於使用哪種 tracker**。應該已經有人把 issue tracker 提供給你。如果沒有，請使用者執行 `/setup-matt-pocock-skills`。查閱 tracker 文件的 "Wayfinding operations" 一節，了解*這個* repo 如何表達它們。如果沒有提供任何 tracker，預設使用 local-markdown tracker。

### Map 內文 (The map body)

整張 map 的低解析度樣貌，每個 session 載入一次。開著的 ticket **不會**列在這裡：它們是開著的 child issue，靠查詢找到。

```markdown
## Destination

<抵達這張 map 盡頭時是什麼樣子：這項工作正在找路前往的 spec、決定或變更。一兩行；每個 session 在選 ticket 之前都先以它定向。>

## Notes

<領域；每個 session 都該參考的 skill；這項工作的長期偏好>

## Decisions so far

<!-- index：每張已關閉的 ticket 一行，足以判斷相關性，再點進連結看 ticket 保存的細節 -->

- [<已關閉 ticket 的標題>](link): <答案的一行重點>

## Not yet specified

<!-- 見 "Fog of war"：還無法開成 ticket 的範圍內 fog；隨著 frontier 推進而升級 -->

## Out of scope

<!-- 見 "Out of scope"：判定在 destination 之外的工作；已關閉，永遠不會升級 -->
```

### Tickets

每張 ticket 都是 map 的一個 **child issue**；tracker 的 issue id 就是它的身分。它的內文是那個問題，大小以一個 100K token（詞元）的 agent session 為準：

```markdown
## Question

<這張 ticket 要解決的決定或調查>
```

每張 ticket 帶有一個 `wayfinder:<type>` 標籤，是 `research`、`prototype`、`grilling`、`task` 其中之一（見 [Ticket 類型](#ticket-types)）。`wayfinder:` 標籤是 map 和它的 ticket 唯一會帶的標籤，絕不帶像 `ready-for-agent` 這種 triage（分類）標籤：它們是決定，不是實作工作。

session 透過把 ticket 指派給正在推動這張 map 的開發者來 **claim**（認領）它，而且要**最先**做，在任何工作之前，這樣同時進行的其他 session 就會跳過它。那個被指派者*就是* claim 本身：一張開著、未指派的 ticket 就是未被 claim 的。

Blocking 使用 tracker 的**原生**相依關係：這是必要的，因為它會在 tracker 自己的 UI 上把 frontier *視覺化*呈現，讓人類不用打開 map 就看得到哪些可以接。只有缺少原生 blocking 的 tracker，才退而使用內文慣例。當所有阻擋某張 ticket 的 ticket 都已關閉，它就是 **unblocked**（未被阻擋）；**frontier** 是那些開著、unblocked、未被 claim 的子項，也就是已知範圍的邊緣。

答案不屬於內文；它在解決時才記錄（見 [逐一處理 map](#work-through-the-map)）。解決 ticket 時產生的素材，從 issue 加上連結，而不是貼進來。

<a id="ticket-types"></a>
## Ticket 類型 (Ticket Types)

每張 ticket 不是 **HITL**（human in the loop，人在迴圈中：*和*一位能為自己發言的人類一起處理），就是 **AFK**（away from keyboard，離開鍵盤），完全由 agent 獨自推動。HITL ticket 只能透過那種即時交流來解決；agent 絕不代替人類那一方（一個自問自答的 grilling（連續追問）agent 就違反了這點）。

- **Research**（研究，AFK）：閱讀文件、第三方 API，或知識庫這類本地資源，找出某個決定所等待的事實。由一個用 "research" 呼叫 Skill tool 的 subagent（子代理）解決。當需要目前工作目錄以外的知識時使用。
- **Prototype**（原型，HITL）：用 "prototype" 呼叫 Skill tool，做出一個便宜、粗糙、具體、可以讓人回應的產出物（一份大綱、一個粗略的初版、一個 stub，或 UI／邏輯程式碼），藉此提高討論的精確度。把 prototype 當作素材連結上去。當「它看起來該是什麼樣子」或「它該怎麼運作」是關鍵問題時使用。
- **Grilling**（連續追問，HITL）：對話。這是預設情況。一律呼叫 Skill tool 兩次，分別帶 "grilling" 和 "domain-modeling"。
- **Task**（任務，HITL 或 AFK）：在做出*決定*之前必須完成的手動工作：沒有要決定、要做 prototype 或要研究的東西，但討論會卡住，直到它完成為止。例如註冊某個服務以便評估它的 API、開通存取權限、搬移資料以便看清它的形狀。這是唯一一種是在*做事*而不是做決定的類型，它存在的理由是解除某個決定的阻擋，而不是交付 destination。agent 能做的部分就自己推動（AFK）；否則就交給人類一份精確的檢查清單（HITL）。工作完成時即算解決；答案要記錄做了什麼，以及後續 ticket 依賴的任何結果事實（憑證存放位置、新的 URL、資料列數）。

## Fog of war

map 是*刻意*不完整的：不要畫出你還看不見的東西。在進行中的 ticket 之外，是 **fog of war**（戰爭迷霧）：你看得出即將到來、但還無法確定的決定與調查的模糊樣貌，因為它們取決於仍未解決的問題。解決一張 ticket 會清除它前方的 fog，把現在已經能具體描述的東西升級成新的 ticket，一次一張，直到通往 destination 的路變清楚、不再剩下任何 ticket。

map 的 **Not yet specified**（尚未具體化）區段，就是寫下那份模糊樣貌的地方：猜測中的問題、之後要回頭看的領域。它是*朝向* destination 的未發現 frontier：這裡的一切都在範圍內，只是還不夠明確，無法開成 ticket。看得多清楚，就寫得多鬆散或多完整；它同時也是一個路標，讓協作者看出這項工作往哪裡走。

**Fog 還是 ticket**？判斷標準是你現在能否精確地說出這個問題，*而不是*你現在能否回答它。

- **開成 ticket 的時機**：問題已經很明確，即使它被阻擋、你還無法處理它。
- **放進 Not yet specified 的時機**：你還無法把它講得那麼明確。不要把 fog 預先切成 ticket 大小的小塊：它比 ticket 粗，等 frontier 抵達時，一塊 fog 可能升級成好幾張 ticket，也可能一張都沒有。

**Not yet specified** 不包括已經決定的事（Decisions so far）、已經是進行中 ticket 的事，以及 out of scope（範圍外）的事（下一節）。

## Out of scope

fog 只會*朝著* destination 聚集。destination 決定了範圍，所以超出它的工作就是 **out of scope**：它不是 fog，也不屬於 **Not yet specified**。它在 map 上有自己的 **Out of scope** 區段：你有意識地排除在*這項*工作之外的工作。讓它落在這裡的是範圍，而不是明確程度。

out of scope 的工作永遠不會升級（frontier 止於 destination），所以只有在 destination 重新劃定時它才會回來，而且是作為一項全新的工作，而不是接續原本的工作。

把某件事判定為 out of scope 是一個劃定範圍的動作，不是路線上的一步。當一張已存在的 ticket 結果發現位於 destination 之外（繪製時被誤納入範圍，或被某次解決結果揭露），**關閉它**（已關閉的 ticket 毫無疑問不在 frontier 上），並在 **Out of scope** 區段留一行：重點加上它為什麼 out of scope，並連結那張已關閉的 ticket。它不放進 **Decisions so far**，那裡記錄的是實際走過的路線；範圍邊界不是路線上的一步。

## 呼叫方式 (Invocation)

兩種模式。無論哪一種，**每個 session 絕不解決超過一張 ticket**，research ticket 例外。

### 繪製 map (Chart the map)

使用者帶著一個鬆散的想法呼叫。

1. **指明 destination**。呼叫 Skill tool 兩次，分別帶 "grilling" 和 "domain-modeling"，確定這張 map 要找路前往的是什麼：spec、決定或變更。destination 決定了範圍，所以要最先確定。
2. **畫出 frontier**。再做一次 grilling，這次採**廣度優先**：在整個空間中展開，而不是深入任何單一線索，找出待決的決定和現在就能採取的第一步。**如果這樣找不出任何 fog**（通往 destination 的路已經很清楚，整趟旅程小到一個 session 就能完成），你就不需要 map。停下來，問使用者想怎麼進行。
3. **建立 map**（標籤 `wayfinder:map`）：填好 Destination 和 Notes，Decisions-so-far 留空，把 fog 粗略寫進 **Not yet specified**。
4. **建立你現在就能具體描述的 ticket**，作為 map 的 child issue，然後在**第二輪**才接上 blocking edges（阻擋關係），原因是 issue 需要先有 id 才能互相引用。交叉引用也在那一輪寫，用真實的 id：佔位用的 `#<n>` 會自動連結到一個不相關的 issue。接線會把它們分成 frontier 和被阻擋的兩群；所有還無法具體描述的東西都留在 fog 裡，也就是 **Not yet specified** 區段。
5. **啟動 research subagent**。對你剛建立的每張 `research` ticket，啟動一個用 "research" 呼叫 Skill tool 的 subagent 來平行解決它，把它的發現記錄在一個用完即丟的 `research/<name>` branch（分支）上，並從 ticket 放一個 context pointer（脈絡指標）指向它。推送這個 branch，但不開 PR（合併請求）：它永遠不會被 merge（合併）。
6. 停下來：繪製是一個 session 的工作；它不親手解決任何東西。

<a id="work-through-the-map"></a>
### 逐一處理 map (Work through the map)

使用者帶著一張 map（URL 或編號）呼叫。ticket 是**可選的**：沒有指定時，由你挑下一個決定，而不是使用者。

1. 載入 **map**：低解析度的樣貌，不是每張 ticket 的內文。
2. 選擇 ticket。如果使用者指定了一張，就用它。否則依順序拿第一張 frontier ticket。**Claim 它**：在任何工作之前，把它指派給你自己。
3. 依照它的 `wayfinder:<type>` 標籤所指的類型來解決它（見 [Ticket 類型](#ticket-types)）。要讀標籤，不能只讀內文：內文從不說明類型。**視需要放大細看**：需要時抓取任何相關或已關閉 ticket 的完整內文；為 `## Notes` 區塊列出的任何 skill 呼叫 Skill tool。如果不確定，就呼叫 Skill tool 兩次，分別帶 "grilling" 和 "domain-modeling"。
4. 記錄解決結果：把答案以一則 **resolution comment**（解決結果留言）發布，**關閉** issue，並**在 map 的 Decisions-so-far 附加一個 context pointer**。
5. 加入新浮現的 ticket（先建立再接線）；把答案讓它變得可具體描述的 fog 升級，並把每一塊已升級的 fog 從 **Not yet specified** 清掉，讓它只以新 ticket 的形式存在。如果答案揭露某張 ticket（這張或另一張）位於 destination 之外，就**把它判定為 out of scope**，而不是在路線上解決它。如果這個決定讓 map 的其他部分失效，就更新或刪除那些 ticket。

使用者可能會平行處理多張 unblocked ticket，所以要預期其他 session 同時在編輯 tracker。
