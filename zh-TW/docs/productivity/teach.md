> 繁體中文翻譯。原文：[teach.md](../../../docs/productivity/teach.md)

## 它做什麼 (What it does)

`teach` 會把你執行它的目錄變成一個長期使用的教學工作區，並透過許多 [sessions](https://www.aihero.dev/ai-coding-dictionary/session)（對話階段），用簡短、自成一體的 HTML 課程，教你一個主題。

它不從 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）原本就知道的東西來教。它把 [parametric knowledge](https://www.aihero.dev/ai-coding-dictionary/parametric-knowledge)（參數化知識：模型訓練時記在權重裡的知識）視為不可信。教學之前，它會先找到高可信度的資源，把它們記在 `RESOURCES.md`，並在每一堂課裡引用。它也是 [stateful](https://www.aihero.dev/ai-coding-dictionary/stateful)（有狀態的）。mission（學習任務）、資源、課程，以及你學會了什麼的紀錄，全都以檔案形式存在目錄裡，所以下一個 session 是從這些檔案接續，而不是從上一段對話剩下的東西接續。

## 什麼時候用它 (When to reach for it)

你要輸入 `/teach` 來呼叫它；[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（代理）不會自己使用它。

當學習本身就是專案時，就用它：一門語言、一個框架、一個你剛加入的 codebase（程式碼庫）、瑜伽、shader、一張證照。它不是用來順便解釋一件事的工具。

| 你想要的 | 要用什麼 |
| --- | --- |
| 花好幾週學一個主題，而且每個 session 的成果會累積 | `teach` |
| 在你目前所在的 session 裡解釋一個概念 | 直接問，就在那個 session 裡 |
| agent 上一則訊息沒讓你聽懂，想請它換個方式重講 | [wait-what](https://aihero.dev/skills-wait-what) |
| 磨利你已經有的想法，而不是吸收新材料 | [grill-me](https://aihero.dev/skills-grill-me) |
| 讓一個 background agent（背景代理）去讀 [primary sources](https://www.aihero.dev/ai-coding-dictionary/primary-source)（第一手資料），並留給你一份附引用的文件 | [research](https://aihero.dev/skills-research) |
| 學習在 grilling（拷問式提問）途中冒出來的東西，又不讓 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) 偏離軌道 | 先 [handoff](https://aihero.dev/skills-handoff)（交接）到一個教學工作區，再在那裡用 `teach` |

## 前置條件 (Prerequisites)

`teach` 建立的是一個目錄，而不是產出一個檔案，而且這個 skill（技能）假設一個工作區只有一個 mission，所以要在你願意整個交給單一主題的地方執行它。不要放在你正在開發的專案裡。獨立的 repo（儲存庫）是最好的地方，比全域的 `~/.learnings/` 資料夾或正在開發的專案本身都好。專屬的 repo 也讓你可以 commit（提交）這些課程，團隊就是這樣分享它們的。

在那個目錄裡會累積的東西：

| 路徑 | 存放內容 |
| --- | --- |
| `MISSION.md` | 你為什麼要學這個。其他每個檔案都依賴它。如果它不存在，`teach` 做的第一件事就是訪談你，直到它存在為止 |
| `RESOURCES.md` | 它用來教學的、經過審核的來源，分成 Knowledge（知識）和 Wisdom（智慧：社群） |
| `lessons/*.html` | 編號的課程：教學的主要單位 |
| `reference/*.html` | 精簡的速查表、演算法、glossary（詞彙表）：你會一再回來查看的文件 |
| `learning-records/*.md` | ADR（架構決策紀錄）風格的筆記，記錄你已經證明自己學會的東西，用來決定下一步教什麼 |
| `assets/*` | 可重複使用的元件，從一份共用的樣式表開始，讓課程看起來像同一門課 |
| `NOTES.md` | 你表明過的教學偏好 |

關於這份清單有兩點說明。glossary 適用於大多數主題，但這個 skill 附帶的 `GLOSSARY-FORMAT.md`，`SKILL.md` 已經不再連結到它，所以只有你主動要求，才會得到一份 glossary（[issue #559](https://github.com/mattpocock/skills/issues/559)）。這些東西全都放在你執行 `/teach` 的那個目錄裡。

## 儲存強度，而不是流暢度 (Storage strength, not fluency)

思考時要用的詞是 **storage strength**（儲存強度）：長期的記憶保留，相對於 **fluency**（流暢度），也就是閱讀當下感覺像是精通、一週後就消失的即時回想。`teach` 透過 desirable difficulty（有益的困難）來建立前者：提取練習、間隔學習、交錯練習。知識先來。在那個階段，困難對你不利，因為它會耗掉你理解時需要的工作記憶。接著 `teach` 透過一個緊密的回饋迴圈來演練技能，而在那個階段，困難就是工具。

有兩件事決定你會被教什麼。**mission**（你想學這個的具體、真實世界的理由）是每一堂課的基礎。沒有它，課程會變得抽象，也沒有東西能決定下一步。根據 mission 和學習紀錄，`teach` 會在你的 **zone of proximal development**（近側發展區）內挑選下一堂課：難到需要花力氣，但又不會遠到你學不會。

Storage strength 也是這個 skill 會反駁你、而不是附和你的原因。需要 **wisdom**（智慧：真實世界的判斷力）的問題，會先得到一個嘗試性的回答，然後指向一個你可以去驗證它的社群。這個 skill 不會讓你跳過測驗。有一位使用者回報，他說了「非常感謝」，結果被告知演練還沒結束。

## 課程、參考文件與元件 (Lessons, references and components)

一個 **lesson**（課程）是一個自成一體的 HTML 檔，短到一次坐下就能完成，與 mission 連結，帶給你一個具體的收穫。它會引用來源，推薦一個值得你自己去讀的 primary source，並連結到同系列的其他課程和參考文件。

你很少回頭看課程，但你會回頭看參考文件。所以課程的精簡版本（語法表、演算法、姿勢序列、glossary）屬於 `reference/`，而不是埋在介紹它的那堂課裡。

課程是由 `assets/` 裡的 **components**（元件）組成的：樣式表、測驗小工具、模擬器、圖表輔助工具。預設就是重複使用。agent 在撰寫課程之前會先讀 `assets/`，並用現有的東西來建構。任何第二堂課也能用到的新東西，它都會寫成元件，而不是直接寫在課程裡面。共用樣式表是每個工作區的第一個元件，它讓課程看起來像同一門課，而不是許多互不相干的頁面。

## 常見問題 (Common questions)

**它把檔案放在哪裡？我的跑到 `~/.claude/skills` 去了。**
放在你執行 `/teach` 的目錄裡（[#377](https://github.com/mattpocock/skills/issues/377)）。

**我要留在同一個 session，還是每堂課開一個新的？**
三種做法都可以：留在同一個 session、在新的 session 裡重新呼叫 `/teach`，或在同一個資料夾開一個新的 session。每一堂課都是一次獨立的呼叫。課程狀態存在資料夾裡，不在對話裡。常見的做法是在工作區開一個全新的 session，然後說 `/teach next lesson for <topic>`。

**我怎麼知道它教我的不是它編出來的？**
光靠這個 skill 自己的說法，你無法知道。你要去讀 primary source。`teach` 還沒有可靠到能不經檢查就信任，任何建立在 LLM 上的 skill 都一樣。這些根據（`RESOURCES.md`、每堂課裡的引用、每堂課推薦一個 primary source）讓檢查一堂課的成本很低。但它並沒有消除檢查的必要。這種失敗真的發生過：一位學 2x2 魔術方塊的使用者，拿到的是憑空編出來、根本解不開方塊的轉法序列。遇到這種情況，要檢查 model、harness（執行 agent 的外殼程式）、effort（推理強度）設定和來源。風險最高的是有精確記號的程序性領域，最低的是輸出可以立刻驗證的地方，例如你可以執行的程式碼。

**正確的測驗答案永遠是第一個選項。**
好幾個人在 Sonnet、Opus 和 GLM 上都確認過這點，而且到現在還沒修好。`SKILL.md` 現在要求每個答案的字數都一樣。這消除了另一個線索（以前正確答案是唯一一個推理完整的選項），但對位置什麼都沒說。有一位貢獻者測試了在指令層面修正位置的做法，結果在九堂課裡，正確答案仍然 33 次中有 33 次落在 A 選項（[#335](https://github.com/mattpocock/skills/issues/335)）。所以真正的修正是在 `assets/` 裡放一個會打亂答案順序的測驗元件，而不是更好的措辭。在那個元件推出之前，請忽略答案的位置。你的 `assets/` 目錄是你可以自己修改的，所以你可以要求一個在顯示時打亂順序的元件，作為本地的修正。

**它假設我已經懂一些東西，還用了它從沒定義過的術語。**
這是最常見的真實抱怨。它沒有評估步驟。`teach` 從 mission 和學習紀錄推斷你的程度，而在第一個 session 裡還沒有任何學習紀錄。一位在 wayfinder 流程裡執行它的使用者說得很直白：「它從來沒有做 grilling 來確認我的起點，所以對我已經懂什麼做了很多假設。」另一位回報，課程用了沒定義過的行話，還有一堂關於他硬體的課，講了硬體能做什麼，卻從沒說它不能做什麼。有兩件事有幫助：在第一則訊息裡說明你已有的知識和不足之處，並在課程程度不對時明白說出來修正它，因為這個修正會變成一筆學習紀錄，並引導下一堂課。明確的知識評估步驟是一個長期存在的功能請求（[#725](https://github.com/mattpocock/skills/issues/725)），不是已推出的行為。

**它會做間隔重複嗎？它知道什麼時候該停止教學嗎？**
第一個不會，第二個不太可靠。這個 skill 在設計課程時會考慮間隔和交錯，但沒有任何東西會排定複習，也沒有 Anki 或行事曆整合。使用者常常要求這兩樣東西。一個相關的缺口是結束條件。就像一位使用者說的，`teach`「很會做出下一堂課，但不太會判斷什麼時候該停下來，轉成複習或實際練習。」如果你想要複習或演練，而不是新教材，就直接要求；這個 skill 不會自己提議轉換。

**它只對程式碼有用嗎？**
不是。大多數被回報的用途都在寫程式之外：韓文、日文正式敬語、鋼琴、吉他、桌遊設計、OpenSCAD、電影情節、Azure 和 CCNA 證照、大學考試，還有八歲和十歲的孩子拿到關於密室逃脫和火蠑螈的可列印小書。這個 skill 裡沒有任何東西是程式設計專用的。mission、資源、近側發展區和演練，在任何領域都以同樣方式運作。在程式碼方面，使用者回報最有價值的是熟悉一個陌生的 codebase 或新團隊的技術棧，勝過從零開始學一門語言。

**我應該用哪個 model 來執行它？**
沒有標準答案，而且被回報的差異很大。使用者回報，較高的 [reasoning effort](https://www.aihero.dev/ai-coding-dictionary/effort)（推理強度）產生的課程比中等設定好。一位使用者透過 Copilot CLI 搭配 Codex 執行同一個 skill，只得到一張 30 行的 HTML 卡片，而 Claude Code 產出的是一整堂完整的課。如果你的組織允許你在 Claude Cowork 加入 skill，它在那裡不用修改就能執行。如果課程內容很單薄，先換 model、[harness](https://www.aihero.dev/ai-coding-dictionary/harness) 或 effort，再考慮重寫你的 prompt（提示詞）。

## 運作正常的跡象 (It's working if)

- 在空目錄裡，它做的第一件事是訪談你為什麼想學這個，而不是產出一堂課。
- `RESOURCES.md` 比課程更早被填滿，而且每堂課都會指名一個值得你自己去讀的 primary source。
- 課程裡的說法都附有對外連結。沒有引用的課程，代表這個 skill 是在憑記憶教學。
- 一堂課一次坐下就能完成，而且讓你能做到一件以前做不到的事。
- 在資料夾裡開一個新 session 並說 "next lesson"（下一堂課），課程會接續下去，而不是重新開始。
- `learning-records/` 持續增加，而課程不再重教你已經證明會的東西。
- 課程看起來像同一門課：它們連結 `assets/` 裡的樣式表，而不是各自帶著自己的樣式。
- 需要判斷力的問題，會讓你被指向一個論壇、subreddit 或課堂，而不只是給你一個答案。

## 它在流程中的位置 (Where it fits)

`teach` 是一個 **reach-for-it-anytime standalone**（隨時可用的獨立 skill）。它不是建構鏈中的一個步驟，也不和 engineering（工程）流程共用任何產出物；只要你還在研讀這個主題，它就在自己的目錄裡運作。

它唯一真正的鄰居是 [handoff](https://aihero.dev/skills-handoff)。它們一起回答了「如果我正在被 grilling 一件我不懂的事，該怎麼辦？」不要為了學習而停止 grilling。用 `/handoff` 轉到一個教學工作區，在那裡用 `/teach` 學這個主題，然後回去從你離開的地方繼續。附近的另一個選擇是 [research](https://aihero.dev/skills-research)，適用於你想要的是一份附引用的文件，而不是課程和記憶保留的時候。當你不確定哪個 skill 或流程適合時，[ask-matt](https://aihero.dev/skills-ask-matt) 會在整個集合中為你指路。
