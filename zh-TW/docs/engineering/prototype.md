> 繁體中文翻譯。原文：[prototype.md](../../../docs/engineering/prototype.md)

## 它做什麼 (What it does)

`prototype` 會寫出**用完即丟、用來回答一個問題的程式碼**：這個狀態模型感覺對不對，或這個畫面應該長什麼樣子。問題先出現，並決定你要做什麼。一個回答錯問題的 prototype（原型）就是白費，不管它看起來多好。

「用完即丟」是對程式碼*寫法*的限制，不是承諾要把它銷毀。不寫 test、除了讓它能跑起來之外不做錯誤處理、不做抽象、不做持久化，因為這些都無法幫你學到你想學的那一件事。有兩樣東西會留下來。答案會進入真正的程式碼，而 prototype 會放到一個從 main 分出來的 branch（分支）上，作為這個答案的證據。

## 什麼時候用它 (When to reach for it)

輸入 `/prototype`，或者在任務適合時，[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（代理）會自動使用它。

一遇到光靠討論無法解決的問題，就用它：一個邊界情況多到你腦袋裝不下的狀態機，或一個你得並排看到三個版本才想像得出來的畫面。在這類問題上，[Grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式追問）的 session（工作階段）會拖得很長。agent 換句話說，你用猜的，範圍越來越大。停止 grilling，做出用完即丟的版本，看一看，然後用一句話回答。如果是已經做好的東西行為不對，而你想知道原因，請改用 [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs)；prototyping 探索的是要做什麼，不是做好的東西為什麼壞掉。

你也可能不是自己選擇而來到這裡。[wayfinder](https://aihero.dev/skills-wayfinder) 會在它的 map（地圖）上開 `prototype` 類型的 decision [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（決策工單），而你會用這個 skill（技能）處理其中一張。

## 兩條路線 (Two branches)

問題決定走哪一條路線，而兩條路線產出不同的成品：

- **「這個邏輯／狀態模型感覺對嗎？」**：一個**可分享的單一 HTML 檔案**。一個自給自足的頁面，不需要 build、不需要伺服器，別人點兩下就能打開。頁面上有一個加了標示的狀態面板，每次點擊後都會重新渲染；有自由操作的按鈕，讓你以任意順序戳戳看這個模型；還有分頁式的 **guided walkthroughs**（引導式演練：每個分頁一個情境，下面附上要依序按下的按鈕）。所有東西都用領域語言標示，所以你可以把它交給設計師、PM 或領域專家，讓他們自己試用這個模型。頁面背後的邏輯是一個小型的純 module（模組：一個 reducer、一個狀態機、一組函式），裡面沒有任何 DOM 程式碼，所以你可以把驗證過的版本直接搬進真正的程式碼。
- **「這應該長什麼樣子？」**：在同一個 route 上做出幾個**截然不同**的 UI 版本，可以從浮動的底部列，或用 `?variant=` URL 參數切換。各版本必須在結構上有分歧，而不是只在顏色上；三個只做了小調整的卡片網格什麼都回答不了。只要可能，它們就在真實頁面裡渲染，搭配真實資料與真實的資訊密度，因為在空白頁面上評判的版本，看起來永遠都沒問題。

兩條路線都把狀態放在記憶體裡、不需要任何設定就能啟動，並在每一步之後顯示完整狀態。一旦你發現自己在強化其中一個（加 test、接上真正的資料庫、為以後可能需要的情況做泛化），你就已經不是在做 prototype 了。

## Prototype 本身就是一手來源 (The prototype is a primary source)

一個完成的 prototype 會留下兩樣東西，而它們會去不同的地方。

你把**答案**（結論，加上它解決的問題）記錄在永久的地方：commit（提交）message、ADR（架構決策紀錄）、實作用的 issue（議題）。main 保存答案，存在真正的程式碼裡。

**prototype** 是答案所根據、可以執行的證據，而你不刪除它。它也不屬於 main，因為沒有人維護它，而且它很快就會過時。所以你把它 commit 到一個從 main 分出來、用完即丟的 `prototype/<name>` branch，永遠不 merge（合併）它，並在實作 issue 上留下一個指向那個 branch 的 [context pointer](https://www.aihero.dev/ai-coding-dictionary/context-pointer)（脈絡指標）。main 保持乾淨，而下一個接手工作的人可以找到並重新執行這個 prototype。

## 常見問題 (Common questions)

**等等，prototype 不是應該刪掉嗎？**
現在不用了。以前是這樣：做出來、留下答案、把程式碼丟掉。對這種做法最強烈的反對意見與速度無關。而是*下一個 [session](https://www.aihero.dev/ai-coding-dictionary/session) 由誰接手工作，他們又有什麼可以依據*？用文字摘要一個 prototype，會失去讓它有說服力的那個東西。所以這個 skill 現在把 prototype 當作 [primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source)（一手來源）。它落在一個從 main 分出來的 `prototype/<name>` branch 上，而實作 issue 指向它。改變的是程式碼放在哪裡，而不是紀律；它仍然永遠不會 merge 進 main。

**它以前會做一個終端機 app。那個去哪了？**
邏輯路線現在改為產出一個可分享的單一 HTML 檔案。終端機 app 只有 clone 了 repo（儲存庫）並安裝了 runtime 的人才能操作，這就把 prototype 最需要聽取意見的人排除在外：設計師、PM，以及知道這個狀態模型應該代表什麼意思的領域專家。一個自給自足、點兩下就能打開、用 email 寄出後仍然能用的檔案，任何人都能操作。底下的純邏輯 module 沒有改變，它仍然是你要搬進真正程式碼的那個部分。

**我明明應該在實作了，agent 卻叫我 `/prototype`。**
這是一個已知的命名問題。不了解流程的 agent，在 ticket 已經存在之後，會把 `prototype` 這個通用又吸引人的字，解讀成「顯而易見的下一步」。所以即使設計已經在對話中定案，agent 還是會點名推薦它。如果你已經知道要做什麼，下一步是 `/implement`，一張 ticket 一次。只有在某個具體的設計問題還沒解決，而且討論也解決不了時，才去做 prototype。

**我應該在做任何正式上線功能之前，先把整個應用程式做成 prototype 嗎（例如為了展示給潛在客戶看）？**
那是另一種成品，只是剛好和這個 skill 同名。這裡的 prototype 範圍限定在一個問題，而「整個 app 是什麼？」不是一個問題。完整 app 的 prototype 沒有自然的停止點，所以它會漸漸變成正式上線的 app：清理那一輪永遠不會發生，而在 prototype 規則下寫出的程式碼（沒有 test、沒有錯誤處理）最後會出現在使用者面前。如果你需要銷售用的 demo，就刻意把它當成 demo 來做，並明確說明其中沒有任何部分是正式上線用的。如果你需要解決一個設計問題，就把範圍縮小到那個問題。

**我要怎麼在獨立的 session 裡執行它？**
prototype 住在自己的資料夾裡，並會產生大量 [context](https://www.aihero.dev/ai-coding-dictionary/context)（上下文），而你不希望這些 context 出現在提出問題的那條對話串裡，所以在別的地方執行它，只把答案帶回來。用 [handoff](https://aihero.dev/skills-handoff)（交接）把工作移到那個 session，再把答案帶回來。

**這不就是燒 token 最快的方法嗎？**
有可能是，如果你拿本來靠討論就能回答的問題去做 prototype，或讓一個 prototype 蔓延到整個功能。重要的比較不是 token 對上零；而是 [tokens](https://www.aihero.dev/ai-coding-dictionary/token)（詞元）對上做錯狀態模型，然後在它已經有正式環境的呼叫端之後才發現。讓問題保持精準、執行保持簡短，花費就會維持在合理比例。

## 運作正常的跡象 (It's working if)

- 你能用一句話說出這個 prototype 是為了回答什麼問題而存在，而且這句話寫在 demo 的最上方，不是只在你腦中。
- 不會看程式碼的人也能操作邏輯 demo。他們打開檔案，按下 walkthrough 分頁裡的按鈕，再用自己的話描述看到了什麼。
- 有人說「等等，這不應該做得到」或「咦，我以為是 X」。那是*想法*裡的 bug，而這正是 prototype 存在的目的。
- 各個 UI 版本在版面配置和資訊層級上有分歧，不只是顏色和文案不同，而你得到的回饋是「用 B 的 header 配上 C 的 sidebar」。
- 問題在一次坐下來的時間內就得到回答。如果一天後你還在做它，代表問題太大了；把它拆開。
- 結束時，main 裡有決策，但完全沒有 prototype，而實作 issue 指向仍保存著它的 branch。

## 它在流程中的位置 (Where it fits)

`prototype` 是一個**隨時可用的獨立 skill**：你用它解決一個設計問題，然後回到你的工作。另一個 skill 也會執行它。

最常執行它的 skill 是 [wayfinder](https://aihero.dev/skills-wayfinder)。wayfinder 的 map 由 **decision tickets** 組成，而 `prototype` 是 ticket 可以屬於的四種類型之一：當卡住進度的問題是「這應該長什麼樣子」或「這應該怎麼運作」，而且再多討論也解決不了時，就用這一種。當討論很模糊時，wayfinder 會做出某個具體的東西讓大家回應，而這個 skill 負責做出那個東西。答案會解決一張 prototype ticket，而 map 會把 prototype 當作一項資產連結過去。

其他相鄰的 skill 位在它的上游和下游。[grill-me](https://aihero.dev/skills-grill-me) 和 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 回答可以靠 grilling 解決的問題；不能靠 grilling 解決的問題則改來這裡，而那一句話的答案會回到訪談中。在下游，驗證過的狀態模型或 UI 方向會成為 [to-spec](https://aihero.dev/skills-to-spec) 已定案的輸入，而 to-spec 可以直接內嵌 prototype 產出的、富含決策的程式碼片段，而不是用文字描述它。其他任何情況，[ask-matt](https://aihero.dev/skills-ask-matt) 會在整套 skill 中為你指路。
