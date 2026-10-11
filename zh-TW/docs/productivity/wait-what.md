> 繁體中文翻譯。原文：[wait-what.md](../../../docs/productivity/wait-what.md)

## 它做什麼 (What it does)

當你看不懂某則訊息時，就輸入 `wait-what`。接著 [agent](https://www.aihero.dev/ai-coding-dictionary/agent)（AI 代理）會把它剛才說的話重新表述（re-pitch）一次。它會補上你缺少的 context（上下文），用淺白的英文寫，並使用你專案 `GLOSSARY.md` 中的詞彙。

這個 skill（技能）只有三行長。這就是設計本身，不是沒寫完的草稿。對抗冗長的 skill 通常會失敗，因為它們自己會越寫越長。一個四百行的「要簡潔」skill 仍然會讓 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）很囉嗦，因為 model 模仿的是 skill 的長度，而不是它的要求。這一個只有一個精確的 leading word（主導詞），其他什麼都沒有。

## 什麼時候用它 (When to reach for it)

你要輸入 `/wait-what` 來呼叫它。agent 不會自己主動使用它，也不應該這樣做。只有你知道自己從哪裡開始跟不上。

一發現自己在略讀，就馬上用它。例如，agent 開始使用它自己發明的術語、在一句話裡塞了五個縮寫，或者解釋了一個你從沒看過其前提的決定。它修正的是你目前所在的這段對話。如果要讓這些術語根本不出現，就用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，它會事先建立共享的語言。

## 名字就是機制 (The name is the mechanism)

leading word 是 **wait**。"Be concise"（要簡潔）是針對 agent 輸出的指令，而 model 遵守它的方式是刪減字詞，結果讓你更跟不上。**Wait** 講的是*你的*狀態。它表示你在這裡停止理解了。聽到 "be brief"（簡短一點）的 agent 會寫出被截短的片段。聽到 "wait, you lost me"（等等，你把我搞糊塗了）的 agent 會退回去解釋。

這個差別就是整個 skill。每個熱門的冗長修正方法都在指名*輸出*：`/tldr`、`/no-fluff`、`/talk-normal`。model 會矯枉過正，寫出更短卻沒有更清楚的截短片段。指名*聽的人*則是同時要求兩半：更少的字，**以及**你缺少的 context。

這個 skill 說的是 re-pitch **that**（重新表述「那個」），而不是 "that last message"（上一則訊息）。讓你迷失的通常不只一個段落，所以由 agent 決定要往回追溯多遠。

## 它接上你已經有的語言 (It plugs into the language you already have)

內文重複使用你全域 `CLAUDE.md` 和專案 `GLOSSARY.md` 中已有的 leading word。ASD-STE100 Simplified Technical English（簡化技術英文）決定語域。ubiquitous language（通用語言：團隊共用的領域用語）提供名詞。這個 skill、`CLAUDE.md` 和 `GLOSSARY.md` 使用相同的 [tokens](https://www.aihero.dev/ai-coding-dictionary/token)（詞元），所以呼叫它並不是一個新的指令。它是在提醒 agent 一個它早就同意過的指令。

如果你沒有 `GLOSSARY.md`（也沒有為目前的 context 指向某個 `GLOSSARY.md` 的 `GLOSSARY-MAP.md`），這個 skill 仍然有效。你只會失去領域詞彙那一半。

## 運作正常的跡象 (It's working if)

- 重新表述的內容**更短也更清楚**，而不是更短也更生硬。
- 它補上你缺少的前提，而不是只刪減字詞。
- 專案的名詞取代了自創的名詞。你 `GLOSSARY.md` 裡的術語回來了。
- 你可以連續用兩次，它也不會退化成過度簡略。

## 它在流程中的位置 (Where it fits)

你可以在任何時候、任何對話中、任何其他 skill 裡面使用 `wait-what`。它是事後修補一則訊息。真正的解法是事先談定一套共享的語言，那就是 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)：一個邊進行邊執行 [domain-modeling](https://aihero.dev/skills-domain-modeling) 的 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式提問）session（工作階段），這樣它就會把你們雙方使用的詞記錄在你的 `GLOSSARY.md` 中。如果你不確定當下適合用哪個 skill，[ask-matt](https://aihero.dev/skills-ask-matt) 會幫你導向。
