> 繁體中文翻譯。原文：[to-spec.md](../../../docs/engineering/to-spec.md)

## 它做什麼 (What it does)

`to-spec` 把你剛剛進行的對話變成一份 **[spec](https://www.aihero.dev/ai-coding-dictionary/spec)**（規格書），並以單一個 issue（議題）發布到你的 issue tracker（議題追蹤系統）。

它不會訪談你。當你用到它的時候，決定都已經做完了。所以它會綜合已知的內容（來自對話串、codebase（程式碼庫）、你的 `GLOSSARY.md` 和 ADR（架構決策紀錄）），不會開始新一輪的提問。spec 記錄的是你已經做出的決定。它不是做新決定的地方。

## 什麼時候用它 (When to reach for it)

你要輸入 `/to-spec` 來呼叫它；[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（AI 代理）不會自己去用它。

當要建造的東西太大，一個 agent [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段：一次對話）裝不下、必須拆到好幾個 session 時，就用它。這就是全部的 trigger（觸發條件）：

| 你現在的處境 | 要執行什麼 |
| --- | --- |
| 你還什麼都沒決定 | 先用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 已經決定，而且工作放得進一個 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window)（上下文視窗） | [implement](https://aihero.dev/skills-implement)：跳過 spec |
| 已經決定，而且工作跨越好幾個 session | `/to-spec`，然後 [to-tickets](https://aihero.dev/skills-to-tickets) |
| 一張 [wayfinder](https://aihero.dev/skills-wayfinder) map（地圖）已經完成 | `/to-spec #<map_issue>` |

## 前置條件 (Prerequisites)

`to-spec` 會把 spec 發布成一個 issue，所以必須先用 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 為這個 repo（儲存庫）設定好 tracker 和 triage（分流）標籤的詞彙。兩種 tracker 都可以：像 GitHub 這樣真正的 tracker，或是 `.scratch/` 底下的本機 markdown 檔案，後者不需要額外設定就能用。

## Spec 是決策紀錄 (The spec is a decision record)

spec 之所以存在，是因為 context window 會用完。你在 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式提問）時定下了很多事：解法的形狀、你反覆討論過的選擇，以及你刻意拒絕的東西。這些全都在一段你即將清除的對話裡。spec 把它們保存下來。

所以 spec 不驗證也不決定任何事。它用你專案自己的詞彙記錄你決定了什麼，讓一個全新的 session 可以接手工作，不需要你再解釋一次。如果 spec 寫了你從沒說過的東西，那就是缺陷。

## 先 seam，後文字 (Seams before prose)

在寫任何東西之前，`to-spec` 會先勾勒出這個功能要在哪些 **seam**（接縫：可以觀察行為的公開邊界）上測試，並跟你確認。它偏好既有的 seam 勝過新的，而且會挑它能挑的最高層 seam。一次改動最理想的 seam 數量是一個。

其他 skill（技能）之後會用到這些已經同意的 seam。[tdd](https://aihero.dev/skills-tdd) 只在你事先同意的 seam 上工作。[code-review](https://aihero.dev/skills-code-review) 會拿 diff（差異）對照 spec 來審查，所以一個沒人同意過的 seam 會變成一條審查發現。這兩條連結都要經過這份文件。這就是為什麼你應該在這裡認真看待 seam 的討論，而不是留到實作階段。

## 常見問題 (Common questions)

**`/to-prd` 跑去哪了？**
就是這個 skill，在 v1.1 改了名。現在全文統一只用「spec」這個詞，舊的 `to-prd` slug 已經不能用了，所以請用新名字重新安裝。舊的詞彙被 *spec* 和 *tickets* 這一組取代。spec 是目的地，以及確定這個目的地的那些決定。[tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（工單）是抵達那裡的步驟。如果你改變方向，就刪掉還沒完成的 ticket，保留 spec。

**為什麼 spec 會被貼上 `ready-for-agent` 標籤？我不想讓 agent 直接照它實作。**
這個標籤的意思是「不需要再 triage」：這份文件已經完整到足以讓 agent 依據它工作。它標記的是一份輸入，不是一張工作指令。但是會輪詢 `ready-for-agent` 的 [AFK](https://www.aihero.dev/ai-coding-dictionary/afk)（離開鍵盤：agent 自己跑，不需要人在場）agent 看不出這個差別。它們會試圖一次跑完整份 spec，而不是去拿切好的 ticket。這是這個 skill 被回報最多的問題。在它改變之前，請在你的 AFK agent 的 prompt（提示詞）裡明確排除上層 spec，或在 `/to-tickets` 跑完之後移除這個標籤。

**為什麼不從 grilling 直接跳到 `/to-tickets`，跳過 spec？**
很多時候你確實應該這樣做。只有在跨多個 session 的工作上，spec 這一步才值得。它的價值在於 ticket 是用完即丟的，而 spec 不是。每個 ticket 的大小都是為一個全新的 context window 設計，之後就被刪除或關閉，而 spec 會留下來，是唯一記錄這些 ticket 背後理由的地方。在單一 session 的改動上，這對你毫無幫助，你還要多付出一個綜合步驟的成本，而 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）可能在這一步偏離。直接從 grilling 走到 `/implement`。

**我剛完成一張 wayfinder map。要餵它什麼？**
給它主要的 map issue，也就是 `/to-spec #<map_issue>`，不是個別的 decision ticket（決策工單）。[wayfinder](https://aihero.dev/skills-wayfinder) 產出的是分散在 map 上的決定，不是交付物。`to-spec` 會把它們收斂成一份你可以拿來建造的文件。如果你把 map 直接接到 `/implement`，就會失去這一步。

**spec 是給我審閱的，還是只給 agent 看？**
主要給 agent，讀起來也是這樣：完整、密集、充滿引用。請讀 seam 和 out-of-scope（範圍外）那一節。在這兩個地方，錯誤的決定現在抓最便宜，之後才發現最昂貴。確實有人抱怨要讀完整份，而且沒有摘要模式。但如果 spec 讓你感到意外，那是 grilling 太淺了；不是 spec 太長。

**ticket 開始之後，我要把 spec 凍結，還是讓 agent 改寫它？**
沒有任何東西會讓它保持同步。實務上它是你在那個時間點所知道的事的快照，實作第一次讓你學到新東西時，它就過時了。工作上線之後，把它當成可以丟棄的東西。你的 `GLOSSARY.md` 和 ADR 才是要長期保存的檔案。如果你在實作過程中學到應該長期保存的東西，就放到那裡，不要放進修改過的 spec。

**我的工作是 refactor（重構）或 module（模組）邊界，不是功能。範本適用嗎？**
比較不適用，這是已知的限制。範本大量依賴使用者故事，而使用者故事不適合架構性的工作。你最後會圍繞著其實是關於 interface（介面）和不變條件的決定，寫出沒人要的故事。改用 implementation-decisions（實作決策）和 testing-decisions（測試決策）這兩節。把要長期保存的架構決策透過 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 記錄成 ADR，而不是寫在 spec 裡。

**它會去 tracker 找相關的工作，或引用它遵守的 ADR 嗎？**
兩者都不會。它會讀並遵守它涉及區域的 ADR，但不會連結它們。它在寫之前也不會到 tracker 搜尋重疊的 issue，所以 spec 可能重複別人已經提出的工作，而且沒有任何東西會警告你。如果這個區域很熱鬧，請先自己搜尋 tracker。

**`/to-tickets` 讀不了我的 spec：它一直被截斷。**
tracker 的 issue 可能無法完整回傳一份非常大的 spec，而且也沒有本機副本可以替代。要解決這個問題，不要在 `/to-spec` 和 `/to-tickets` 之間 [clear](https://www.aihero.dev/ai-coding-dictionary/clearing)（清除 context）或 [compact](https://www.aihero.dev/ai-coding-dictionary/compaction)（壓縮 context）。在同一個視窗裡執行它們，`/to-tickets` 就永遠不需要再抓一次 spec。

## 運作正常的跡象 (It's working if)

- 它直接開始寫，而不是問你新一輪的問題。
- 它在寫之前先給你看 seam，而且提出的數量盡可能少。
- 它用的是你專案的名詞，不是通用的產品管理樣板文字。
- 裡面每一個決定你都記得是自己做的。它沒有為了填滿某一節而捏造任何東西。
- out-of-scope 那一節列出的是真實的東西。你拒絕的東西通常是這一頁上最有用的幾行。

## 它在流程中的位置 (Where it fits)

`to-spec` 是主要建造鏈中的一步，但只在其中跨多個 session 的那條分支上：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

在上游，[grill-with-docs](https://aihero.dev/skills-grill-with-docs) 做出決定，這個 skill 只負責記錄；完成的 [wayfinder](https://aihero.dev/skills-wayfinder) map 也在這裡接上這條鏈。在下游，[to-tickets](https://aihero.dev/skills-to-tickets) 把 spec 切成 tracer bullet（曳光彈：貫穿所有層的一條窄路徑）式的 ticket，交給 [implement](https://aihero.dev/skills-implement) 建造。當你不確定哪個 skill 或流程適合時，[ask-matt](https://aihero.dev/skills-ask-matt) 會幫你指路。
