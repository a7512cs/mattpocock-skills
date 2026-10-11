> 繁體中文翻譯。原文：[to-questionnaire.md](../../../docs/productivity/to-questionnaire.md)

## 它做什麼 (What it does)

`to-questionnaire` 把一個你自己無法拍板的決定，變成一份 **questionnaire**（問卷）：一份 Markdown 文件，交給那位掌握你所缺資訊的人，讓對方非同步填寫，或讓你們兩個在會議中一起過一遍。

它會 grill（拷問式追問）你關於 **send**（發送這件事）的部分，從來不碰主題本身。針對主題的訪談毫無意義，因為不懂這個主題，正是你要寫給別人的原因。所以它只問兩件你一定答得出來的事（這份要給誰，以及你需要對方回覆什麼），並讓文件裡的每一個問題都瞄準兩者之間的 **gap**（落差）。

## 什麼時候用它 (When to reach for it)

你要輸入 `/to-questionnaire` 來呼叫它；[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（代理）不會自己使用它。

當一個決定卡在只存在於另一個人腦中的知識時，就用它：客戶、領域專家、掌握商業規則的主管、一位不和你同團隊的同事。要用哪個 skill（技能），取決於答案在哪裡：

| 答案在…… | 要用 |
| --- | --- |
| 你自己的腦中，還沒想清楚 | [grill-me](https://aihero.dev/skills-grill-me) |
| codebase（程式碼庫） | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 別人的腦中 | `to-questionnaire` |
| 還沒有人知道，這個問題需要一個能讓人回應的東西 | [prototype](https://aihero.dev/skills-prototype) |

常見的情況是一個 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式提問）的 session（對話階段）卡住了，因為它提出的某些問題不是你能回答的。在同一段對話中執行 `/to-questionnaire`，把那些問題拿到線下處理，然後把答案帶回來，繼續進行。

## 問的是發送，不是主題 (The send, not the subject)

訪談只有兩輪來回，然後就停止。

- **要給誰？** 對方的角色、專業，以及和你的關係。這決定了語氣，以及文件需要帶多少 context（上下文）。外部客戶需要先了解背景；隊友則不需要。
- **你需要對方回覆什麼？** 你自己無法解決的具體決定或事實。這會成為完成後文件的檢查清單。你說出的每一項，都會有一個問題瞄準它。

之後的一切都是起草。這個 skill 會把檔案寫到目前目錄下的 `to-questionnaire-<slug>.md`。沒有初始設定，沒有工作區，也沒有任何需要設定的東西。

## 文件 (The document)

這份文件是一份 **discovery questionnaire**（探索式問卷），因為缺 context 的是你，而有 context 的是收件人。這決定了它的形式：

- 一行目的說明，指出依賴它的那個決定，還有一段簡短的背景說明，給完全不知道你背景的收件人。
- 問題依照**最重要的放最前面**排序，並分組放在主題標題底下，因為非同步代表你可能只有一次機會。
- 每個問題只有一個概念，絕不複合，下面有一個作答欄位，只有在問題可能被誤讀時，才加一行*為什麼這很重要*。
- 明確允許回答「我不知道」，因為標出來的不確定是有用的，而一個讀起來像事實的自信猜測則不是。
- 結尾的總括問題：有沒有我們沒問、但應該知道的事？

這份文件刻意不是兩種東西。它不是 **branching**（分支式）的。問題是一份扁平、分組的清單，而不是一棵「如果你回答了 A 就跳過 D 段」的樹。它也不是 **multi-recipient**（多收件人）的。一次執行只為一個人產生一份文件。

## 常見問題 (Common questions)

**它會讀我的 grilling session，並從中擷取問題嗎？**
不是作為一個獨立的步驟。這個 skill 沒有讀取階段。它問關於發送的事，然後起草。讓它在 grilling session 之後能派上用場的，是你在**同一段對話**裡執行它，所以 [session](https://www.aihero.dev/ai-coding-dictionary/session) 已經在 [context](https://www.aihero.dev/ai-coding-dictionary/context) 裡，起草時可以利用它。如果你在新的 session 裡開始，它對那次 grilling 一無所知，你在回答「你需要對方回覆什麼？」時，就得自己再提供一次主題。

**缺的答案不全在同一個人身上。它可以按收件人拆開嗎？**
不行。第一步問的是*那一位*收件人，單數，而這個 skill 會把整份文件的語氣和背景都針對那個人來調整。如果三個人各自掌握答案的三個部分，就執行三次，每人一次。有人要求過一份能依照專業或角色分派問題的文件，但那個功能沒有推出。

**問題之間有依賴關係嗎：它會根據前面的答案跳過某些段落嗎？**
不會。依賴式問題的設計曾經被探索過，但沒有推出。輸出是一份靜態文件：主題分組、最重要的放最前面、每個問題都有效。對這個設計的反對意見是合理的。一個在拿到真正答案之前就規劃超過兩三個問題的 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型），會規劃得很差，而一份分支式文件必須在每個答案出現之前，就把所有問題規劃好。

**如果收件人也不知道呢？**
文件會叫他們直接說。它明確要求「我不知道」和部分答案。標出來的不確定比猜測更有價值，因為一個模糊的答案和一個自信但錯誤的答案，一旦回到你的 context 裡，看起來是一模一樣的。

**它會把問卷寄到任何地方嗎（Slack、issue tracker（議題追蹤系統）、email）？**
不會。它在目前目錄寫一個 Markdown 檔，並告訴你路徑。發送由你負責：貼到一張 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket)（工作單）裡、丟到 Slack 討論串、附在 email 裡，或在共用螢幕上打開它，現場一起過一遍。這四種做法大家都手動做過。

**這不就是批次模式的 `/grill-me` 嗎？**
不是。`grill-me` 本來就是以 **rounds**（輪次）來問的。它會一次問出整個 frontier（前沿）上的未決問題，然後根據你的答案重新計算，所以它已經滿足了「一次把所有問題都給我」的需求。`to-questionnaire` 是在另一個面向上不同。它關心的是答案在誰的腦中，而不是問題怎麼送出。想自己更快回答，就用 `grill-me`。想從別人那裡取得答案，就用這個。

**我不能不用 skill，直接請 agent 做這件事嗎？**
可以，而且在它出現之前就有很多人這樣做：`OPEN_QUESTIONS.md` 檔案、寄給客戶的試算表、每個未回答的問題各開一張 "needs more info"（需要更多資訊）ticket。這個 skill 給你兩樣東西：訪談絕不會偏到主題上，而且產出的文件形式，是非技術背景的收件人也填得了的。如果你已經有一套好用的內部格式，你就不需要這個。

## 運作正常的跡象 (It's working if)

- 它問收件人是誰、你需要對方回覆什麼，然後就不再問。如果它問到主題本身，代表這個 skill 出錯了。
- 你列為「我需要對方回覆的東西」的每一項，都可以對應到檔案中的某個問題。
- 問題讀起來是針對*收件人*所知道的東西，而不是把你自己的未決問題原封不動抄下來。
- 你可以把檔案交給一個不在這段對話裡的人，而對方會知道為什麼收到它，以及要在什麼時候之前回覆。
- 回來的答案是新一輪 grilling 可以用的輸入，而不是又一組新的問題。

## 它在流程中的位置 (Where it fits)

`to-questionnaire` 是一個隨時可用的獨立 skill。當你自己的知識用到盡頭，而下一步是去問另一個人、而不是再執行另一個 skill 時，你就用它。最常見的是在流程進行到一半、規劃卡在一件不歸你決定的事情上時。

它的鄰居是 [grill-me](https://aihero.dev/skills-grill-me)，兩者的差別在於答案在哪裡。grilling 從你身上取得答案；問卷從別人身上取得答案。把回來的內容餵進另一輪 grilling，或者如果工作正要進入建構，就餵進 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 或 [to-spec](https://aihero.dev/skills-to-spec)。當你不確定哪個 skill 適合當下時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你指路。
