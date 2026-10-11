> 繁體中文翻譯。原文：[writing-for-agents.md](../../../docs/productivity/writing-for-agents.md)

## 它做什麼 (What it does)

`writing-for-agents` 是撰寫給 agent（代理）看的文件的參考資料：一個 skill（技能）、一份 `AGENTS.md` 或 `CLAUDE.md`、一份 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格文件）、一個執行時的 prompt（提示詞）、一份 README，任何 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 會讀的文件。格式不同，但寫法不變。同樣的槓桿讓每一種都變得可預測，所以 agent 每次執行都會遵循同樣的*流程*（不一定得到同樣的輸出）。

它預設的修正方式是刪除，而不是解釋。請一個 agent 為另一個 agent 寫指示，它會把大部分字數花在解釋 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）早就知道的事。每一行這樣的內容都是一個 **no-op**（無作用的內容）：它花掉 [context](https://www.aihero.dev/ai-coding-dictionary/context)（上下文），卻不改變任何行為。這份參考資料幫你找出它們，所以它用在你已經有的文件上，和用在空白檔案上一樣有用。

它在 v1.1 之前叫做 `writing-great-skills`。新名字符合它一直以來的本質。它幾乎沒有任何內容是 skill 專用的。只屬於 skill 的機制（frontmatter（檔頭設定區塊）、要 model-invoked（由模型呼叫）還是 user-invoked（由使用者呼叫）的選擇、router skill（路由用的 skill））放在一份連結的 `SKILL-MECHANICS.md`，只有當你眼前的文件是 skill 時才需要讀。

## 什麼時候用它 (When to reach for it)

輸入 `/writing-for-agents`，或者當你在建立或編輯 skill，或修改 `AGENTS.md` 或 `CLAUDE.md` 時，agent 會自己使用它。

其他任何 agent 會讀的東西，就手動使用它：你的文件、spec 和 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（工作單），system prompt 和 [AFK](https://www.aihero.dev/ai-coding-dictionary/afk)（Away From Keyboard：你離開鍵盤時讓 agent 自己跑）prompt。判斷只需要一個問題：agent 會讀這個嗎？agent 怎麼拿到這份文件並不重要：可能是一個 pointer（指標）指名它、一個人把它貼上，或它就在 repo（儲存庫）裡。想知道一個 codebase（程式碼庫）裡有什麼，就用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)。這份參考資料控制的是一份文件讀起來如何，而不是它知道什麼。

## 兩種負擔 (The two loads)

核心概念是每一份文件和 pointer 都會花費的兩種預算：

- **Context load**（context 負擔）：常駐內容對 agent 視窗造成的成本：一行 `AGENTS.md`、一段 skill description（描述）、任何不管有沒有觸發，每個 [turn](https://www.aihero.dev/ai-coding-dictionary/turn)（回合）都待在 context 裡的東西。
- **Cognitive load**（認知負擔）：你要記得有哪些文件存在、各自何時使用，所付出的成本。你就是索引。不要試圖把這個成本降到最低，因為它是人類保有主導權的代價。

一旦你用這兩種負擔來思考，大多數撰寫上的決定（拆不拆分、直接寫進來還是延後揭露、用 pointer 指過去還是直接推給 agent）都會變成在不同地方做的同一種取捨。

## 槓桿 (The levers)

- **[Context pointers](https://www.aihero.dev/ai-coding-dictionary/context-pointer)**（context 指標）：存在 context 裡的參照，它指名 context 之外的內容，並寫明何時該去取用。一段 skill description 和一行指名某份文件的 `AGENTS.md`，是同一種東西。決定 agent 多可靠地遵循它的，是 pointer 的*措辭*，而不是它指向的目標。
- **Information hierarchy**（資訊階層）：一道階梯，從檔案內的步驟，到檔案內的參考資料，再到藏在 pointer 後面、需要時才揭露的參考資料。**[Progressive disclosure](https://www.aihero.dev/ai-coding-dictionary/progressive-disclosure)**（漸進式揭露）就是把內容往這道階梯下方移，讓最上層保持容易閱讀。
- **Completion criteria**（完成條件）：每個步驟的完成條件有多清楚、多嚴格，以及這種要求帶來的 **legwork**（跑腿工作）。它們是對抗 **premature completion**（過早完成）的防線。
- **Leading words**（引導詞）：一個已經存在於 model 預訓練中的精簡概念（*tight*（緊湊）、*red*（紅燈：測試失敗）、*tracer bullet*（曳光彈：先打通一條端到端的細路徑）），agent 在執行文件時會用它來思考。它在兩個地方起作用。在內文中它引導執行，在 pointer 中它觸發呼叫。
- **Pruning**（修剪）：單一事實來源、相關性，以及逐句套用的 no-op 測試，用來對抗 **duplication**（重複）、**sediment**（沉積：過時殘留的內容）和 **sprawl**（蔓延）。

## 常見問題 (Common questions)

**`/writing-great-skills` 跑到哪去了？**
它就是這個 skill，在 v1.1 改名了。早在改名之前，使用者就把它用在 `AGENTS.md`、文件、spec、ticket 和執行時的 prompt 上。結構、leading word 和 pruning，適用於任何 agent 會讀的文字。沒有別名。請用新名字重新安裝。

**"Writing for agents"：所以是 agent 負責寫作？**
反過來。你是作者；agent 是讀者。這正是困難的地方。你是寫給一個已經讀過所有東西的讀者，所以解釋是浪費，精確才是全部的工作。

**我不能直接請 agent 幫我寫嗎？**
可以，但它會寫出冗長的東西。放著不管的話，model 會解釋它已經知道的事，而且它不會自己套用 no-op 測試，也不會自己去找 leading word。用這份參考資料來審查草稿。它大部分的價值來自那一次審查。

**我請 agent 精簡一份文件，結果它把功能砍掉了。**
被要求 "streamline"（精簡）的 agent 會針對長度做最佳化，因為長度是它們看得到的東西。no-op 測試檢查的是行為，不是風格：刪掉那一行，然後問 agent 的行為有沒有改變。當一個句子沒通過測試時，刪掉整個句子，而不是刪減其中的字詞；如果對某句有不同意見，就實際執行文件來解決，而不是靠爭論。

**我怎麼知道已經完成了？**
當它能正常運作，而你再也找不到 duplication、sediment 或 no-op 的時候。沒有自動化評估。你要手動執行文件，並用失敗模式的詞彙來診斷問題。當一份文件行為不正常時，同一套詞彙也能幫你修正它：先說出失敗模式的名字，再修正它。

**這應該放在 `CLAUDE.md` 還是其他地方？**
問問自己你想付哪一種負擔。`CLAUDE.md` 會無條件載入到每個 [session](https://www.aihero.dev/ai-coding-dictionary/session)（對話階段）。藏在 pointer 後面的內容，在被觸發之前只花掉 pointer 自己那一行。任何十個 session 中只有一個用得到的東西，在另外九個 session 裡都會花掉 context load。

**每出一個新的 model，我都需要重寫文件嗎？**
大多不需要，而且過度針對某一個 model 調整，本身就會造成問題。為新 model 更新，通常只是再做一次 no-op 檢查，而不是重寫。

**我的 skill 只在我建立它時用的那個任務上有效。**
常見的做法（先把工作做一次，再請 agent 把它寫成 skill）會過度貼合那一次執行，範例也會寫得太具體。把那次執行留作證據，然後刻意去一般化：拿掉屬於那個 repo 和那些檔案的部分，為這一類任務來寫。

**英文不是我的母語。我會失去 leading word 的優勢嗎？**
不會。找出用最少 [tokens](https://www.aihero.dev/ai-coding-dictionary/token)（token：模型處理文字的計量單位）裝下最多行為的那個詞，是這份參考資料幫你做的工作。

## 運作正常的跡象 (It's working if)

- 文件越改越好，也越來越短，而你會驚訝剩下的東西這麼少。
- 你可以指著一個 leading word，看到它在不只一個地方改變了 agent 的行為。
- 沒有任何東西被說了兩次，不論以什麼形式。duplication 是一份文件從未被測試過的最可靠跡象。
- 只有某一個分支需要的參考資料，放在 pointer 後面，而不是放在主檔案裡。

## 它在流程中的位置 (Where it fits)

這是一份隨時可用的獨立參考資料。它適用於整個 skill 集合，而不是某一個 skill。這裡的每一個 skill 都是用它寫的，而且一旦 agent 必須讀其他 skill 產出的文件（一份 `GLOSSARY.md` 和它的 ADR（架構決策紀錄）、一份 spec、一張 ticket），它也涵蓋這些文件。它唯一的直接呼叫者是 [retro](https://aihero.dev/skills-retro)，retro 在提議任何 steering file（引導 agent 行為的檔案）或 skill 之前，會先載入它。當你不確定哪個 skill 或流程適合一個任務時，[ask-matt](https://aihero.dev/skills-ask-matt) 會在整個集合中為你指路。
