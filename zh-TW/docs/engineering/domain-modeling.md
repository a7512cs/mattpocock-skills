> 繁體中文翻譯。原文：[domain-modeling.md](../../../docs/engineering/domain-modeling.md)

## 它做什麼 (What it does)

`domain-modeling` 在你做設計的同時，建立並磨利一個專案的 **ubiquitous language**（通用語言：團隊和程式碼共用的一套領域用詞）。它會質疑和 glossary（詞彙表）衝突的用詞，在你用了模糊字眼的地方要求一個精確的詞，並用具體情境去檢驗一個關係，直到邊界完全明確。

它是**主動的**紀律，不是被動的。任何 skill（技能）都可以讀 `GLOSSARY.md` 來借用裡面的詞彙。這個 skill 是在你*修改*模型的時候用的，所以它會打斷你。它在你確定一個用詞的當下，就在對話途中把它寫進 `GLOSSARY.md`，而不是在最後產出一份整齊的 glossary。在最後才寫的 glossary 是一個 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段）的摘要；即時寫入的版本才是這個 session 的產出。

## 什麼時候用它 (When to reach for it)

輸入 `/domain-modeling`，或是當任務合適時，agent（代理）會自動使用它。實際上，自動呼叫是這個 skill 最弱的一環。當 `grill-with-docs` 或 `wayfinder` 說要載入它時，[models](https://www.aihero.dev/ai-coding-dictionary/model)（模型）常常只載入 `grilling`，而跳過這一個。如果一個 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式提問）session 跑完了，`GLOSSARY.md` 卻沒有改變，就是發生了這種事。請在用另一個 skill 的同時，直接點名呼叫它。

當問題出在*用詞*上時，就用它：

| 情況 | 做法 |
| --- | --- |
| 兩個人說 "cancellation"（取消）時，指的是不同的東西 | `domain-modeling`：選定標準用詞，把另一個列在 `_Avoid_` 底下 |
| "Account" 在三個檔案裡做三種不同的事 | `domain-modeling`：把它拆成 Customer 和 User |
| 你剛做了一個難以反悔的架構選擇 | `domain-modeling`：如果這個選擇達到門檻，它會提議寫一份 ADR（架構決策紀錄） |
| 問題出在 module（模組）的*形狀*：seam（接縫：可以觀察行為的公開邊界）放哪裡、interface（介面）有多深 | [codebase-design](https://aihero.dev/skills-codebase-design) |
| 你想在動手建構之前，把整個計畫徹底拷問一遍 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，它在底層驅動這個 skill |
| 你只想查一個用詞，不想改它 | 什麼都不用。讀 `GLOSSARY.md` 就好。它就是一個檔案。 |

## 前置條件 (Prerequisites)

不需要事先準備。這個 skill 會寫入兩個地方，而且兩者都是等到需要時才建立：

- repo（儲存庫）根目錄的 **`GLOSSARY.md`**。你確定第一個用詞時，skill 才建立它。如果 repo 根目錄有 `GLOSSARY-MAP.md`，用詞則會改寫進這份 map（地圖）所指向的、各個 context（領域中劃分出的範圍）各自的 `GLOSSARY.md`。
- **`docs/adr/`**。skill 會在第一份達到門檻的 ADR 出現時建立它。

開始之前什麼都不需要存在，skill 也不會事先建立任何東西。

## 兩種產物，兩種門檻 (Two artifacts, two bars)

glossary 和 ADR 的門檻不同。這個 skill 的大部分麻煩，都來自把兩者搞混。

| | `GLOSSARY.md` | `docs/adr/NNNN-slug.md` |
| --- | --- | --- |
| 內容 | 用詞。一個東西**是**什麼，用一兩句話說明，被捨棄的同義詞列在 `_Avoid_` 底下 | 一個決策，用一到三句話：背景、選擇、理由 |
| 寫入門檻 | 一個模糊的用詞成為標準用詞 | **三項全部成立**：難以反悔、沒有背景就會讓人意外、是真正取捨後的結果 |
| 寫入方式 | 即時寫入，在用詞確定的當下 | 會先提議，不會擅自認定要寫 |
| 絕不包含 | implementation（實作）細節、[spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格）、草稿筆記、一般程式設計概念 | 這個 session 中做過的每個選擇的流水帳 |

ADR 的三項檢驗只要有一項不過，就沒有 ADR。容易反悔的決策只會直接被改回來；不令人意外的決策不會有人問；沒有真正替代方案的決策，記錄下來的只是你做了顯而易見的事。

`GLOSSARY.md` 的規則最重要，因為實際上最常被打破的就是它。**它是 glossary，除此之外什麼都不是**。如果不加約束，model 會把「寫進 `GLOSSARY.md`」當成可以把你給的每個答案都存下來的許可，這個檔案就會變成一份不斷增長的 spec。這是這個 skill 被回報最多的問題，而且跨好幾個 model 都有。

## 交叉比對，以及它的界線 (Cross-referencing, and where it stops)

當你陳述某件事怎麼運作時，skill 會去檢查程式碼並指出任何矛盾。*「你的程式碼會取消整筆 Order，但你剛才說可以部分取消，哪個才對？」*這個 skill 會在修改任何一方之前，公開地讓用語和程式碼取得一致。

它交叉比對的是**程式碼**，以及已 commit（提交）的 `GLOSSARY.md` 和 ADR，除此之外沒有別的。它不會搜尋你的 issue tracker（議題追蹤系統）。如果你的團隊幾個月前在一個已關閉的 issue 裡爭論完並解決了一個命名衝突，skill 還是會把它當成新問題再提一次。目前有[一個尚未關閉的請求](https://github.com/mattpocock/skills/issues/717)要修正這一點。在那之前，變通方法是把指示寫在你自己的 `docs/agents/domain.md` 裡，這些 skill 本來就會讀這個檔案。

## 常見問題 (Common questions)

**我的 `GLOSSARY.md` 有 500 行。1,000 行。3,000 行。我該怎麼辦？**
大小只是症狀。原因是這個檔案收進了 implementation 細節和決策，而這些本來就不屬於 glossary。修正方法是一個直接的指令：`/grill-with-docs make my GLOSSARY.md more concise and remove any implementation details from it`。對一個膨脹的檔案執行它，大部分內容都會被刪掉。只有在檔案已經精簡、卻仍涵蓋兩個讀者不想同時記在腦中的領域時，才用 `GLOSSARY-MAP.md` 拆分它。拆分一個膨脹的檔案，只會得到好幾個膨脹的檔案。這個 skill 在這方面的指引還不夠強，無法從一開始就防止檔案膨脹，追蹤這件事的 issue 也仍未關閉。

**為什麼是 `GLOSSARY.md` 而不是 `GLOSSARY.md`？**
這是整套 skill 中爭論最多的命名問題，而且沒有定論。反對目前名稱的理由很充分：如果它是「glossary，除此之外什麼都不是」，`GLOSSARY.md` 就直接說明了這一點，而且如同一位讀者說的，「對 AI agent 來說，一切都是 [context](https://www.aihero.dev/ai-coding-dictionary/context)（上下文）」。支持目前名稱的理由是 map：`GLOSSARY-MAP.md` 指向好幾個 `GLOSSARY.md` 檔案，讀起來很自然，這種自然感是 `GLOSSARY-MAP.md` 所沒有的；而且 `context` 是 DDD 中指稱模型裡一塊有邊界區域的固定用語。至少有一個人維護了一個本地 fork，純粹只為了改這個檔名。你也可以這樣做，但這套 skill 中的其他每個 skill 都會找 `GLOSSARY.md`，所以改名就代表要修改所有 skill。

**`/ubiquitous-language` 到哪去了？**
它被移除了，而不是被標為 deprecated（已棄用）。它的工作移到了 `domain-modeling`，後者會持續維護整個模型，而不是從一次對話裡倒出一份 glossary。詞彙的一致性要求現在變得更重要，而不是更不重要。它在 grilling、triage（分流）和繪製 map 的底層運作，而不是一個你必須記得去執行的獨立步驟。

**一個完全沒有 glossary 的 codebase（程式碼庫），要怎麼得到一份？**
明確地要求它，而不是等它慢慢累積。`/grill-with-docs help me scaffold my existing repo with a GLOSSARY.md` 是文件記載的做法。要預期一段很長的盤問。有一位使用者回報，在檔案成形之前被問了超過 50 個問題。在既有（brownfield）repo 上，靠順帶使用來累積 glossary 實在太慢了。

**我可以保留 domain model（領域模型），但使用我自己的 ADR 格式嗎？**
目前沒辦法乾淨地做到。glossary 這一半和 ADR 這一半包在同一個 skill 裡，所以已有既定 ADR 慣例（不同範本、不同位置、不同命名）的團隊，會拿到和自家風格衝突的指示。目前的選擇是把 skill 複製到本地再修改，或是在你 repo 自己的 agent 說明文件中覆寫 ADR 慣例。把兩者拆開是[一個尚未關閉的請求](https://github.com/mattpocock/skills/issues/557)。

**glossary 真的值得維護嗎？它是又一份要審查的產物，而且可能會過時。**
有時候並不值得。DDD 越接近 implementation 就越沒用。它的回報在上游，在命名和概念對齊上，而不是在 aggregate 和分層的形式儀式上。同義詞控管在命名邊界上很重要：module 名稱、資料表名稱、狀態 enum、issue 標題、CLI 指令。在一般敘述文字中就沒那麼重要。另外也有一種反對意見：領域用詞壓縮的是已經共享這些用詞的*人與人之間*的溝通，而 agent 對白話英文描述的反應是一樣的。照這個解讀，glossary 的價值在於讓你和你的審查者跟上 agent 正在做的事，而不是讓 agent 變得更好。如果是一天就能做完的東西，就跳過它。而且一份沒人審查、由 agent 寫的 glossary 比沒有還糟：它會塞滿充滿自信的主張，之後的 session 都會把這些當真。

**它能幫我把模糊的 prompt（提示詞）轉成領域語言嗎？**
不能，而且也沒有計畫做一個能這樣做的 skill。你自己都不理解的領域語言，寫下來也沒有意義。這個 skill 是在你已經理解之後，強制要求精確；它不會發明你沒有的詞彙。相關的陷阱是只使用領域用詞，卻沒有真正做建模。在錯誤的概念上套上正確的名詞，產出的東西讀起來是對的，實際上卻不是。

## 運作正常的跡象 (It's working if)

- 它會在你話說到一半時打斷你，問你指的是兩件事中的哪一件，而不是自己挑一個就繼續。
- `GLOSSARY.md` 在對話**進行中**就會改變，而不是在最後一口氣出現。
- 對於你明天就能撤銷的事，它會拒絕寫 ADR，並說出三項檢驗中哪一項沒過。
- 新條目用一兩句話定義一個東西*是*什麼，並在 `_Avoid_` 底下列出你要放棄的用詞。
- 當你的程式碼和你說的話不一致時，它會引用你的程式碼回給你看。
- `GLOSSARY.md` 變短的次數和變長的次數一樣多。

## 它在流程中的位置 (Where it fits)

`domain-modeling` 是一個 **model-invoked（可由 model 自動呼叫）的參考型 skill**，它在其他 skill *底下*運作的時候，比自己單獨運作的時候還多。[grill-with-docs](https://aihero.dev/skills-grill-with-docs) 透過 grilling session 驅動它，[wayfinder](https://aihero.dev/skills-wayfinder) 在繪製 map 時載入它，[triage](https://aihero.dev/skills-triage) 用它讓 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（工作單）維持使用專案自己的用詞，[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 則在決策確定時呼叫它。和它最接近的是 [codebase-design](https://aihero.dev/skills-codebase-design)。它們合起來是其他一切底下的詞彙層，這一個負責*領域*，那一個負責 module 的*形狀*。當你想要這套紀律，又不想照著平常會載入它的那個 skill 的步驟走時，也可以直接呼叫它。當你不確定哪個 skill 適合時，[ask-matt](https://aihero.dev/skills-ask-matt) 會幫你導向。
