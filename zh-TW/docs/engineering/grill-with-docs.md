> 繁體中文翻譯。原文：[grill-with-docs.md](../../../docs/engineering/grill-with-docs.md)

## 它做什麼 (What it does)

`grill-with-docs` 針對一個計畫或設計對你進行訪談，直到你和 [agent](https://www.aihero.dev/ai-coding-dictionary/agent)（代理）對它有一致的理解，並在過程中把詞彙和困難的決策寫進你的 repo（儲存庫）。它和 [grill-me](https://aihero.dev/skills-grill-me) 進行的是同一種訪談（一輪問題，然後等待，再下一輪），只是對象換成一個 codebase（程式碼庫）。

它是 **[stateful](https://www.aihero.dev/ai-coding-dictionary/stateful)**（有狀態的）。其他所有 grilling（拷問式提問）skill（技能）都把 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段）的內容留在你腦中；這一個則會在磁碟上留下檔案。一個用詞確定時，skill 會立刻把它寫進 `GLOSSARY.md`，而不是在最後批次寫入。一個決策通過三道關卡時，skill 會把它寫成一份 ADR（架構決策紀錄）。差別就只有這樣，而這也造成了大家使用這個 skill 時遇到的大部分麻煩。這些產物是真實 repo 裡的真實檔案，所以在你預期它們存在時可能會缺少，而且當不只一個人在寫它們時，內容可能會漸漸走樣。

## 什麼時候用它 (When to reach for it)

你要輸入 `/grill-with-docs` 來呼叫它，agent 不會自己去用它。

在一個 repo 裡，一項變更剛開始、計畫還很模糊、描述它的用詞也還沒確定時，就用它。它是單一 session 的工具。你要用哪個 grilling skill，取決於你眼前有什麼：

| 你手上有什麼 | 該用什麼 |
| --- | --- |
| 你根本不是在某個工作目錄裡工作 | [grill-me](https://aihero.dev/skills-grill-me) |
| 一個 repo，以及一項一個 session 內就能確定的變更 | `grill-with-docs` |
| 一項大到一個 session 裝不下的工作（全新的 greenfield 專案、大型功能） | [wayfinder](https://aihero.dev/skills-wayfinder) |
| 一個完全沒有領域文件的 repo，而且心裡也沒有特定的功能 | `grill-with-docs`，對準整個 repo，而不是某項變更 |
| 一個卡在別人腦中知識上的決策 | [to-questionnaire](https://aihero.dev/skills-to-questionnaire) |

和 wayfinder 的分界取決於 session 數量：單一 session 的規劃用 `/grill-with-docs`，多個 session 的規劃用 `/wayfinder`。

## 前置條件 (Prerequisites)

這個 skill 會寫入你的 repo，所以你需要待在一個可以安全寫入的地方。確定的用詞會寫進根目錄的 `GLOSSARY.md` glossary（詞彙表），或者，如果根目錄有 `GLOSSARY-MAP.md` 把這個 repo 標示為多 context（領域中劃分出的範圍），就寫進相關 context 的 `GLOSSARY.md`。決策會寫進 `docs/adr/`。skill 只在需要時才建立這兩者。在第一個用詞或決策確定之前什麼都不存在，所以你不需要事先設定任何東西。

它還需要另外兩個 skill 存在，因為它自己的 `SKILL.md` 只有一行，把工作委派給它們。[grilling](https://aihero.dev/skills-grilling) 提供訪談，[domain-modeling](https://aihero.dev/skills-domain-modeling) 提供寫入。只安裝 `grill-with-docs`，你得到的會是一個無法運作的 skill。

## 書面紀錄 (The paper trail)

一個 session 會產出三種東西，而它們的分量並不相同。

| 確定了什麼 | 寫到哪裡 |
| --- | --- |
| 一個用詞：專案自己對某個東西的稱呼 | `GLOSSARY.md`，即時寫入，在確定的當下 |
| 一個難以反悔、沒有背景就會讓人意外、而且是真正取捨的決策 | `docs/adr/` 底下的一份 ADR |
| 你決定的其他一切 | 對話裡，別的地方都沒有 |

第三列就是讓大家踩坑的地方。`GLOSSARY.md` 只是 glossary。它不包含 implementation（實作）細節、不包含 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格），也不包含草稿筆記。一份 ADR 需要三個條件同時成立，所以大多數決策都不符合，大多數 session 也一份都不會產出。一個 session 產出更精準的 glossary 而零份 ADR，是照設計在運作，但這代表你們同意的大部分內容，只存在於你們達成同意的那個 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window)（上下文視窗）裡。把同一段對話交給 [to-spec](https://aihero.dev/skills-to-spec)，而不是把它 [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing)（清除）掉。

glossary 是主要產出。這個 skill 建立的是領域語言：專案自己的用詞，一次談定，讓你、agent 和你的同事不必再重新推敲一遍。不是每個人都同意這能提升 agent 的表現。最有力的反對意見是：一個用詞和它的白話英文展開說法，從 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）那裡得到的結果是一樣的，而這套詞彙主要是縮短了共享它的人與人之間的溝通。照這個看法，glossary 仍然有價值，但價值是給人的。

## 常見問題 (Common questions)

**我該用這個還是 `/wayfinder`？**
範圍決定一切。一個 session 內能確定的事都用這個；工作大到一個 session 裝不下時用 [wayfinder](https://aihero.dev/skills-wayfinder)，它會先把工作畫成一張由決策 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（工作單）組成的 map（地圖）。Wayfinder 比較慢、比較密集，在範圍明確的功能上用它是常見的錯誤。它不會取代這個 skill，而且它可以針對 map 中適合的部分啟動一個 grilling session。

**它跑完了，但沒有出現 `GLOSSARY.md`，也沒有任何 ADR。**
已知有兩個原因。第一個是沒有任何東西符合條件。ADR 需要通過全部三道關卡，而一個關於某項變更、卻沒有新詞彙的 session，沒有東西可寫。第二個是真正的 bug。當 skill 在另一層編排機制裡執行時（spec 驅動開發的包裝層、多 agent 框架、在別人的 pipeline 中把它當成一個步驟來呼叫的規則），使用者回報寫檔案的那一半會無聲無息地沒有發生，而訪談仍照常進行。這個 bug 已經回報，但還沒修。如果你是這種設定，在相信 session 的產出之前，先檢查工作目錄。

**它一次問了所有問題，沒有任何建議，也從沒提到 `GLOSSARY.md`。**
這是 skill 沒有成功載入它的兩個相依 skill。因為 `SKILL.md` 只是一行委派，沒有載入 [grilling](https://aihero.dev/skills-grilling) 和 [domain-modeling](https://aihero.dev/skills-domain-modeling) 的 agent 會自己猜 grilling 是什麼意思，於是你一次拿到所有問題，毫無結構。只載入一部分更令人困惑。`grilling` 載入了，`domain-modeling` 沒有，你就會得到一場好的訪談，卻沒有書面紀錄。這種情況發生的頻率取決於 model 和 [effort](https://www.aihero.dev/ai-coding-dictionary/effort)（推理力度）等級，而這是這個 skill 被回報最多的問題。如果你懷疑發生了這種事，直接問 agent 它載入了哪些 skill。

**我其他的決策都跑到哪去了？**
只存在對話裡。這是對這個 skill 最嚴重、仍未解決的抱怨。glossary 不是 spec，大多數答案也夠不上一份 ADR，而且沒有任何紀錄把每個已確定的答案連到一份 spec、一張 ticket 和一個測試。後續步驟會把精確的答案（順序保證、否定性需求、數值預設值）軟化成較弱的敘述，結果看起來可能很完整，卻漏掉了你決定的事。目前的做法是保留這個 session，直接把它餵給 [to-spec](https://aihero.dev/skills-to-spec)。然後拿你自己的答案重讀一遍 spec，而不是假設它都收進去了。

**我可以把它用在一個完全沒有文件的既有 repo 上嗎？**
可以。對於一個沒有 ADR、沒有領域語言、也沒有設計原則的 codebase，這就是正確的 skill：呼叫它，然後說「幫我把我的 repo 寫成文件」。使用者常把它和 [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 搭配，用來建立或修補 `GLOSSARY.md`。要有心理準備得引導它。它會讀程式碼，並就它發現的東西問你，由你決定 codebase 裡已經存在的哪些用詞才是正確的。

**session 結束後我該做什麼？**
這個 skill 的結尾訊息常常沒有明確的下一步，這是已知問題。在主要流程中，答案是在同一段對話裡接著用 [to-spec](https://aihero.dev/skills-to-spec)。如果變更小到可以馬上動手做，就改成直接用 [implement](https://aihero.dev/skills-implement)。

**為什麼叫這個名字？**
沒有人滿意這個名字。有一個尚未關閉的建議，要把它改名為 `grill-domain-model`，這更準確地描述了它的行為。這個建議一直沒有進展。如果哪天真的改名了，文件頁面會跟著搬，URL 也會改變。

## 運作正常的跡象 (It's working if)

- `GLOSSARY.md` 在 session *進行中*就一個用詞一個用詞地改變，而不是在最後一整塊出現。
- glossary 讀起來是純粹的詞彙（你專案的用詞，加上精簡的定義），不包含 implementation 細節，也沒有像 spec 的敘述。
- codebase 能回答的問題，是透過讀 codebase 來回答，而不是拿來問你。
- 你得到的 ADR 很少或沒有，而得到的那幾份，都是你如果得再爭論一次會很煩的決策。
- 它會質疑你用的某個詞，因為你現有的 glossary 對它的定義不同。

## 它在流程中的位置 (Where it fits)

`grill-with-docs` 是主要建構鏈的起點：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

它發生在任何東西被寫成 spec 之前。它產出共同的理解和已確定的詞彙，接著由 [to-spec](https://aihero.dev/skills-to-spec) 加以整合，不必再訪談你一次。和它最接近的是 [grill-me](https://aihero.dev/skills-grill-me)，同樣的訪談，但沒有 repo 也沒有檔案；以及 [domain-modeling](https://aihero.dev/skills-domain-modeling)，也就是它所驅動的 glossary 與 ADR 紀律；兩者都使用 [grilling](https://aihero.dev/skills-grilling) 這個基本元件來進行訪談。在它的上游，[wayfinder](https://aihero.dev/skills-wayfinder) 負責規劃一個 session 裝不下的大型工作，並且可以把 map 的部分內容交回給它。當你不確定哪個 skill 或流程適合時，[ask-matt](https://aihero.dev/skills-ask-matt) 會幫你導向。
