> 繁體中文翻譯。原文：[grilling.md](../../../docs/productivity/grilling.md)

## 它做什麼 (What it does)

`grilling` 是一個訪談循環，在任何人採取行動之前，對一份計畫、一個決定或一個想法進行壓力測試。它把主題描繪成一棵 **design tree**（設計樹）：每個決定都會分支出掛在它下面的決定，然後一個分支接一個分支地訪談你，直到沒有任何假設還沒說出口。

它不會一次只問一個問題，也不會一次問完所有問題。每一個 **round**（輪次）都會問整個 **frontier**（前沿）：所有前提都已經確定的決定，除此之外什麼都不問。如果兩個問題其中一個依賴另一個，它們絕不會出現在同一輪；一個取決於仍未確定之答案的問題，屬於之後的輪次。你的答案確定了決定，frontier 往外推進，下一輪就問那些因此解鎖的問題。十三個問題通常會落在大約三輪內，而不是十三輪。

## 什麼時候用它 (When to reach for it)

輸入 `/grilling`，或者當任務適合時，[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（AI 代理）會自己主動使用它。它是 grilling（拷問式提問）家族中唯一一個 model-invoked（由 model 自動呼叫）的 [skill](https://www.aihero.dev/ai-coding-dictionary/skill)（技能），所以你很少需要自己輸入它。通常是某個你*確實*有輸入的 skill 幫你執行它。

直接輸入 `/grilling`，你只會得到單純的訪談，其他什麼都沒有。當你想要的不只這些時：

| 你手上有的 | 該用的 |
| --- | --- |
| 你不是在某個工作目錄中工作 | [grill-me](https://aihero.dev/skills-grill-me)：同樣的 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段），但換了一個 agent 永遠不會自己觸發的名字 |
| 你在某個工作目錄中 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)：同樣的 session，而且它會邊進行邊寫 `GLOSSARY.md` 和 ADR（架構決策紀錄） |
| 一個大到一個 session 裝不下的工作 | [wayfinder](https://aihero.dev/skills-wayfinder)：它畫出一張 map（地圖），並在 decision ticket（決策工單）裡執行 grilling |
| 一個無法靠談話解決的問題：某個東西應該長什麼樣子或給人什麼感覺 | [prototype](https://aihero.dev/skills-prototype)：做一個用完即丟的版本，然後再回來 |
| 一個你自己寫的、需要訪談的 skill | 從它裡面呼叫 `/grilling`，而不是再寫一套訪談 |

## round、frontier，以及誰來決定 (The round, the frontier, and who decides)

這個 skill 建立在三個概念上。

**design tree** 是主題的模型：一個個決定，下面再掛著其他決定。**frontier** 是所有前提都已確定的決定所構成的集合：也就是 agent 目前唯一能問的問題。一個 **round** 就是一個 frontier，完整地問、完整地答。

在一輪之中，每個問題都有固定格式：在 `❓` 後面加上編號和標題，接著是內文，然後是 agent 的建議答案，單獨放在一行 `➡️` 上。這個格式讓你可以用編號回答整輪（"1 yes, 2 the second option, 3 no, here's why"，即「1 是，2 選第二個選項，3 否，原因如下」），而不必把問題引用回去。這個格式有一個已知的問題。建議答案有時會*反對*問題原本的措辭，所以同意建議就等於對問題回答 "no"（否）。發生這種情況時，針對建議答案回答，並且說明這一點。

設計的另一半是事實與決定的區分。事實是這個 skill 自己的工作。當一個 frontier 上的問題需要某個 [environment](https://www.aihero.dev/ai-coding-dictionary/environment)（環境）能確定的資訊時，agent 會派出一個 [sub-agent](https://www.aihero.dev/ai-coding-dictionary/subagent)（子代理）去查，而不是問你。這一輪不會等那個研究；只有依賴它的問題會等。決定是你的，agent 必須等你決定。一個執行 `grilling` 卻自己回答決定的 agent，就是破壞了這個 skill。當 frontier 清空時，session 就結束。接著 agent 會等你確認雙方已有共識，才根據你們談定的內容行動。

frontier 有一個限制。agent 是憑判斷選出它的；不是從一張圖計算出來的。所以它可能把兩個問題放在同一輪，之後才發現其中一個答案應該要改變另一個。唯一的防護就是告訴它。這會在下一輪重新打開受影響的分支。

## 哪些內容在這裡、哪些在包裝 skill 裡 (What lives here and what lives in the wrappers)

這一頁說明運作機制。包裝 skill 的頁面則回答大家最常問的問題。

| 問題 | 在哪裡回答 |
| --- | --- |
| 樹、frontier、round、問題格式、事實 vs 決定 | 這裡 |
| 一個 session 應該跑多久、無法靠談話回答的問題該怎麼辦、如何避免一路點頭附和 | [grill-me](https://aihero.dev/skills-grill-me) |
| 什麼會寫進 `GLOSSARY.md`、什麼會變成 ADR | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |

## 常見問題 (Common questions)

**我可以改回一次一個問題嗎？**
可以，而且有很大一部分的使用者都這麼做。把這段加進你的全域 `CLAUDE.md`：

```
When grilling, ask one question at a time.
```

不是每個人都喜歡以輪次為基礎的預設方式。閱讀速度較慢、用第二語言工作，或靠循序格式幫助自己專注的使用者回報說，一次一個問題對他們比較有效。這個退出選項是一個受支援的設定，不是權宜之計。

**`/batch-grill-me` 跑去哪了？**
併進這個 skill 了。以輪次為基礎的提問曾經短暫地以獨立 skill 的形式發布，之後移進 `grilling` 本身，所以所有建立在這個 primitive（基礎元件）上的東西（`grill-me`、`grill-with-docs`、`triage`、`wayfinder`）都一次獲得了它。沒有 `batch-grill-me` 可以安裝，也沒有另外的循序版 skill；上面那行 `CLAUDE.md` 設定就是回到一次一題的方法。

**一次問完整輪，一定會漏掉我先前的答案本來會引出的問題。不是嗎？**
這是對 round 最常見的反對意見，而 frontier 回答了它。一輪只包含彼此不互相依賴的問題，所以同一輪中沒有任何答案能讓同一輪的另一個問題失效。你的答案仍然會改變之後的內容，因為 agent 會從頭推算每一個下一輪。你確實會失去一些東西，但比「一次問完所有問題」所暗示的要少。參見上面提到的 frontier 的限制。

**它問完問題就開始動手做了。**
確認關卡就是為了這個而存在的。當你說雙方已有共識時，這個 skill 才算完成，而不是 frontier 清空時。較弱、較快的 [models](https://www.aihero.dev/ai-coding-dictionary/model)（模型）仍然會跳過這個關卡。使用者最常在低 effort 或非頂尖（non-frontier）的 model 上回報這個問題，這些 model 會把「訪談到雙方有共識為止」壓縮成幾個問題加一份大綱。如果你的 model 也這樣，可靠的解法是在你自己的 `AGENTS.md` 或 `CLAUDE.md` 中加一行，告訴 agent 未經許可不要實作。

**它自己回答了自己的問題，而不是問我。**
那是這次執行的 bug，也正是這個 skill 的內文要把事實和決定分開的原因。最常發生在另一個 skill 執行 `grilling` 來解決某個 ticket（工單）時，agent 把那個任務當成可以繼續往下做的許可。同樣的限制也是沒有非同步模式的原因。有人要求一個會讀取 GitHub issue（議題）並貼出一份彙整決策備忘錄的變體，那是另一個 skill，因為一場沒有人回答的 grilling session，產出的是 agent 的意見，而不是你的。

**我可以限制問題的數量嗎？**
不行，而且上限是刻意列為 out of scope（不在範圍內）的。有些計畫需要三個問題，有些需要五十個；固定的上限不是截斷困難的情況，就是在簡單的情況下顯得很武斷。預期的控制方式是直接用白話說。叫它收尾，或者停下來，接受計畫目前的樣子。如果一個 session 跑得非常久，原因通常是範圍太大；把工作拆開，再分別拷問各個部分。

**我只單獨安裝了 `grill-me`，結果什麼都沒發生。**
`grill-me` 是一個只有一行的 skill，它的整個內文就是 "run a `/grilling` session"（執行一個 `/grilling` session），所以這個 skill 也必須安裝。`grill-with-docs` 也一樣，而且它還額外需要 [domain-modeling](https://aihero.dev/skills-domain-modeling)。安裝整套就能避免這個問題；選擇性安裝的話，就代表也要安裝那些 primitive。

**`grill-with-docs` 有執行，但它從來沒有載入 `grilling`。**
這是一個真實存在、至今仍未修復的 bug，使用者在各種 [harnesses](https://www.aihero.dev/ai-coding-dictionary/harness)（執行環境）和 model 上都回報過。一個 skill 提到另一個 skill，並不能可靠地讓那個 skill 被載入，而 `grill-with-docs` 提到了兩個。徵兆是 session 一次問完所有問題，而且沒有建議答案。這代表 model 是在即興發揮一場訪談，而不是執行這一個。直接問 agent 有沒有載入 `grilling` 和 `domain-modeling`，通常就能讓它恢復。

## 運作正常的跡象 (It's working if)

- 一輪以編號清單的形式出現，每個問題的建議答案都在獨立的 `➡️` 行上，而且你可以用編號回答整輪。
- 一輪之中，沒有任何問題需要先回答同一輪的另一個問題。
- 後面的輪次會問第一輪不可能問的東西。
- 它會自己去查事實（讀檔案、派出 sub-agent），而不是問你一些它自己就查得到的事。
- 在背景執行的研究不會拖住這一輪；只有依賴它的問題會等。
- 它在最後停下來，請你確認雙方已有共識，而不是直接開始做事。
- 問題數量維持在高，而輪數維持在低。

## 它在流程中的位置 (Where it fits)

`grilling` 是一個 **primitive**，不是一個你要排進流程的步驟：它是訪談技巧唯一可信的來源，集中放在一個地方，讓每個需要訪談的 skill 都去用它，而不是自己發明一套。[grill-me](https://aihero.dev/skills-grill-me) 和 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 是它的兩個 user-invoked（由使用者手動呼叫）入口，而 `grill-with-docs` 是主要建置鏈的起點，位在 [to-spec](https://aihero.dev/skills-to-spec) 之前。[wayfinder](https://aihero.dev/skills-wayfinder) 執行它來解決 decision ticket，[triage](https://aihero.dev/skills-triage) 用它把一份模糊的回報拷問成可以處理的回報，[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 則在你選好要深化的候選項目後，用它走過整棵樹。當你不確定哪個入口適合時，[ask-matt](https://aihero.dev/skills-ask-matt) 會幫你導向。
