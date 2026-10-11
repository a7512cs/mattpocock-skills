> 繁體中文翻譯。原文：[grill-me.md](../../../docs/productivity/grill-me.md)

## 它做什麼 (What it does)

`grill-me` 接手一個**鬆散的想法**，然後訪談你，直到你能下定決心去做它。你不需要先有一份想清楚的計畫才能開始，因為這個 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段）存在的目的就是產出計畫。它以 **rounds**（輪次）提問。每一輪就是整個 **frontier**（前沿），也就是所有前提你都已經確定的問題。所以它永遠不會問你一個依賴於它還沒聽到之答案的問題。

它是 **[stateless](https://www.aihero.dev/ai-coding-dictionary/stateless)**（無狀態）的。它不寫任何檔案，也不留下任何工作區。唯一的結果是一個更清晰的想法版本，存在你自己的腦中。

## 什麼時候用它 (When to reach for it)

你要輸入 `/grill-me` 來呼叫它；[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（AI 代理）不會自己主動使用它。在一個**全新的對話**中啟動它，而不是接在你已經讓 agent 寫好的計畫後面。

一旦你有一個值得認真看待的想法（一個功能、一個產品方向、一個商業決策、一篇文章），就馬上用它，遠在你想清楚它牽涉到什麼之前。模糊不是等待的理由，因為 session 存在的目的就是消除模糊。如果你已經能精確地描述這件事，就不需要拷問它了。

你需要三個 grilling（拷問式提問）skill（技能）中的哪一個，取決於你眼前有什麼：

- **任何事、任何地方。** 用 `grill-me`。它不需要 repo（程式碼儲存庫），也不寫任何檔案，主題也不一定要是程式碼。
- **有一個要對齊的 codebase（程式碼庫）。** 用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)。它是同樣的訪談，但是 [stateful](https://www.aihero.dev/ai-coding-dictionary/stateful)（有狀態）：它會讀你的程式碼，並把學到的東西記在 `GLOSSARY.md` 和 ADR（架構決策紀錄）裡。
- **大到一個 session 裝不下。** 用 [wayfinder](https://aihero.dev/skills-wayfinder)。它把整個工作畫成一張 map（地圖），並在裡面執行 grilling session。

把 [plan mode](https://www.aihero.dev/ai-coding-dictionary/agent-mode)（計畫模式）關掉。Plan mode 會讓 agent 急著產出計畫，但你要的是它繼續提問。

## 這是對話，不是單向訪談 (It's a conversation, not an interview)

這個 skill 負責提問，但範圍由**你**掌控。大家常常忽略這一點。這就是一個把想法變成決策的 session，和一個產出充滿自信的胡說八道的 session 之間的差別。

失敗模式是**被動**：連續四十個問題都回答「同意、同意、同意」，最後得到一份 agent 寫的、你只是點頭附和的計畫。因為過程很長，所以感覺很有生產力。但你什麼都沒有決定，而結果看起來比實際上更確定。

主動代表要掌舵。對不夠細、不符合你需要的問題提出反駁。範圍開始偏移時要說出來。回答「我不知道」，而且是真心的。這個 skill 是幫助工程師，而不是取代工程師。結果的品質取決於你答案的品質，而不是問題的數量。

相反的錯誤確實存在，但比較少見：在訪談中待太久，久到一直沒開始寫程式碼。

## 可以拷問與無法拷問的問題 (Grillable and ungrillable)

有些問題可以靠談話回答。有些不行，再怎麼 grilling 都沒辦法讓你得到答案。

「一個長表單還是三個頁面？」和「這個互動應該給人什麼感覺？」都是 **ungrillable**（無法靠拷問解決）的問題。你需要先有東西可以反應，才能回答它們。碰到這種問題時，停止 grilling。用 [prototype](https://aihero.dev/skills-prototype) 做一個用完即丟的版本，看一看，然後回來用一句話回答。

當你試圖用談話解決一個 ungrillable 的問題時，session 就會變得太長。agent 不斷換句話說，你不斷猜，範圍也隨著不確定性一起擴大。

## 運作正常的跡象 (It's working if)

- 你對某些事情表示不同意。一個你完全沒有反駁的 session，就是一個你根本不需要的 session。
- 問題分成幾輪出現，而不是長時間一次一題，而且後面的輪次明顯建立在你先前說的話之上。
- 你最後走到一個意料之外的地方，因為某個問題讓你看見一個你一直在做、卻沒有察覺的決定。
- 到最後，你能向一個不在場的人為每個選擇辯護。

## 常見問題 (Common questions)

**我應該預期會有多少問題？我怎麼知道它什麼時候結束？**
計算輪數，不要計算問題數。四輪共四十六個問題是很普通的 session。當 frontier 清空時它就結束：它已經走過每一個分支，沒有任何東西還停留在未說出口的假設。

**它問了我兩百個問題。哪裡出錯了？**
通常是範圍太大。先請 agent 把工作拆成較小的部分，再逐一拷問。很長的 session 也會漂進 **[dumb zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)**（變笨區），在那裡 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window)（上下文視窗）已經滿到讓問題品質變差。

**我可以改回一次一個問題嗎？**
可以。把這段加進你的全域 `CLAUDE.md`：

```
When grilling, ask one question at a time.
```

**如果我真的不知道答案怎麼辦？**
直接說。「我不知道」是一個真正的答案，而一個你答不出來的問題，通常是該做 prototype（原型）而不是去猜的訊號。

**寫 spec（規格）之前要開一個新的 session 嗎？**
不用。這個 session 的價值就在你剛建立的 [context](https://www.aihero.dev/ai-coding-dictionary/context)（上下文）。把同一段對話直接交給 [to-spec](https://aihero.dev/skills-to-spec)。

**model（模型）重要嗎？**
比大多數 skill 都重要。Grilling 依賴 [model](https://www.aihero.dev/ai-coding-dictionary/model) 自身對系統如何出錯的知識，所以要用你最好的那一個。implementation（實作）大多是跟著 context 走，所以那個階段用便宜一點的 model 就可以。

## 它在流程中的位置 (Where it fits)

`grill-me` 是一個**可以在任何地方、針對任何事情執行的獨立工具**。因為它是 stateless 的，所以可以帶著走。它不需要 repo、工作區或任何設定，也不假設這個想法跟軟體有關。大家用它來做商業決策、寫作，以及決定接下來要做什麼：任何他們自己沒辦法想清楚的事。

可攜性是它和 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 唯一的差別。那個 skill 執行同樣的訪談，但會讀取一個要對齊的 codebase，並把學到的東西記錄成 `GLOSSARY.md` 和 ADR。兩者底層都使用 [grilling](https://aihero.dev/skills-grilling) skill。`grill-me` 是不保存狀態的 user-invoked（由使用者手動呼叫）入口。

如果你拷問的東西最後真的是軟體，你可以把同一段對話交給 [to-spec](https://aihero.dev/skills-to-spec)，繼續進入建置流程（這是一個選項，不是這個 skill 的重點）。當你不確定哪個流程適合時，[ask-matt](https://aihero.dev/skills-ask-matt) 會幫你導向。
