> 繁體中文翻譯。原文：[handoff.md](../../../docs/productivity/handoff.md)

## 它做什麼 (What it does)

`handoff` 把你目前所在的對話壓縮成一份 **handoff document**（交接文件）：一個 markdown 檔，寫到作業系統的暫存目錄，而不是寫進工作區，讓一個全新的 [agent](https://www.aihero.dev/ai-coding-dictionary/agent)（代理：能自己讀檔、執行工具的 AI）可以讀它，接手這份工作。

它給你的是 **portability**（可攜性），而不是壓縮，所以這個 skill（技能）的用途比聽起來窄。只有當工作必須*移動*時，你才需要一個檔案：移到新的 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)（執行 agent 的外殼程式，例如 Claude Code、Codex）、新的目錄、一位同事，或一個你想分叉出去的支線任務。如果沒有東西要移動，你就不需要 handoff。留在原本的 [session](https://www.aihero.dev/ai-coding-dictionary/session)（對話階段）、`/clear`、一個 [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent)（子代理）和 `/compact`，都能處理一般的階段結束情況，而且 `/compact` 派上用場的次數比這個 skill 還多。

## 什麼時候用它 (When to reach for it)

你要輸入 `/handoff` 來呼叫它；agent 不會自己使用它。傳入一段說明，講清楚下一個 session 是要做什麼，skill 就會針對那個目的來寫文件。

觸發情況有四種，而且只有四種：

| 情況 | 為什麼需要檔案 |
| --- | --- |
| 換 harness（Claude → Codex） | 新的 harness 看不到舊的 [context](https://www.aihero.dev/ai-coding-dictionary/context)（上下文：agent 目前看得到的內容） |
| 移到另一個目錄或 repo（儲存庫） | 最常見的情況是 prototype（原型）目錄 |
| 把工作交給同事 | 他們需要一份可以讀的東西 |
| 分叉出階段中途發現的支線任務 | 你繼續工作；第二個 agent 接手分叉出去的部分 |

其他任何情況（同一個 harness、同一個目錄、你已經結束 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式提問：agent 連續追問你，直到想法清楚）並要進入實作），就用 `/compact`。[ask-matt](https://aihero.dev/skills-ask-matt) 有一棵有順序的決策樹，涵蓋階段邊界上全部五個選項。

## 分叉是大家略過的用法 (Branching is the use people skip)

這個 skill 的 description（描述）讀起來像是在講恢復 session：寫一份摘要，在這裡結束，到那裡繼續。照這樣讀，它看起來就像比較差的 `/compact`，所以大家略過它。值得知道的是分叉的情況。你**留在自己的 session 裡**，把累積下來的 context 複製一份，交給第二個平行工作的 agent。

繞道 [prototype](https://aihero.dev/skills-prototype) 的流程用的就是這個。你正深入一段設計對話，遇到一個只有實際執行程式碼才能解決的問題，而你不想把辛苦建立起來的對話脈絡花在找答案上。那就 handoff 到一個 prototype session，拿到答案，把答案交回來，再從原本的對話裡引用它。工作來回跨越兩次，原本的對話一直保持有效，你什麼都不用重新解釋。

階段邊界上的五個選項中，有三個保留的東西各不相同：`/compact` 保留你的意圖，`/clear` 什麼都不保留，`/handoff` 保留工作移動的能力。

## 什麼會跟著走，什麼不會 (What travels, and what doesn't)

這份文件帶著正在進行的脈絡（進行中的事、原因、下一步），再加上一個 **suggested skills**（建議使用的 skill）區塊，列出下一個 agent 應該使用什麼。skill 在寫檔之前會先遮蔽機密資訊。

它刻意不帶任何已經寫下來的東西。文件用路徑或 URL 引用 spec（規格文件）、計畫、ADR（架構決策紀錄）、issue（議題）、commit（提交）和 diff（差異），從不複製它們。這讓檔案保持精簡，也讓已經定案的細節只存在一個地方，而不是變成兩份越來越不一致的副本。

## 常見問題 (Common questions)

**Handoff 還是 compact？**
除非有東西要移動，否則用 `/compact`。留在同一個任務上是 compact，不是 handoff。當 harness 和目錄都不變、而你需要持續參與其中時，階段邊界的決策樹大多數時候會停在 `/compact`。`/handoff` 的摘要並沒有比較好。它的優勢是結果是一個檔案，你可以把它帶到 `/compact` 去不了的地方。

**那 compact、clear 和 handoff 到底差在哪？**
每一個保留的東西都不同。`/compact` 壓縮目前的 context，並在一個新的視窗中繼續，所以你的意圖會保留下來。`/clear` 清空視窗，從零開始。當你身後的一切都可以丟掉時，這是正確的選擇；如果不是，你也無法復原。`/handoff` 寫出一個可攜的檔案，所以工作在搬到別處之後仍然保留。三者都會把一個 **[primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source)**（第一手資料：實際發生過的對話）變成一個 **[secondary source](https://www.aihero.dev/ai-coding-dictionary/secondary-source)**（第二手資料：對話的摘要）。只有「繼續」這個選項不會這樣，這就是為什麼你要最先把它排除。

**我的 handoff 檔案跑到哪去了？**
它會寫到暫存目錄，這也是這個 skill 最常被回報的問題。skill 會把位置解析為 `$TMPDIR`，沒有的話就用 `/tmp`（Windows 上是 `%TEMP%`），但這些路徑都很長。請它把路徑告訴你，並在繼續之前記下來。用暫存目錄是刻意的，因為 handoff 是運送途中的文件，不是你要維護的產出物。暫存目錄也不持久，下一個問題會說明。

**我的 handoff 在兩個 session 之間不見了。**
有些環境會在 session 之間清空暫存目錄（被回報的例子是 Codex），而重新開機會清空 `/private/tmp`。如果下一個 session 不會在一小時內開始，或會在不同的 harness 底下開始，檔案一寫好，就自己把它複製到一個持久的地方。文件*指向*的任何東西也一樣：如果一份交辦文件引用了暫存目錄裡的其他檔案，下一個 agent 就無法追過去。

**我實際上要怎麼把它交給下一個 agent？**
開一個新的 session，把路徑指給它：讀這個檔案，然後繼續。要指向檔案，而不是把摘要貼進 shell 指令裡。當你把含有反引號或 `$(...)` 的摘要內插進 `claude "<summary>"` 時，shell 會把它弄壞。通常的結果是無聲的截斷，而不是錯誤，所以新的 agent 拿到的是不完整的說明，而且沒有任何東西會告訴你。

**這跟 `/branch`、`--fork-session` 或內建的 `/handoff` 一樣嗎？**
相似，但不相同。`/branch` 在這裡不是正式發佈的 skill；`/handoff` 才是正式名稱。分叉會繼承 context 的完整副本；這個 skill 產生的則是針對一個明確的下一個任務、*有目標的*壓縮，並寫成檔案。在分叉就能解決的情況下（同一台機器、同一個 harness、同一個目錄），分叉比較省事。當目的地是分叉到不了的地方時，檔案是比較好的選擇。

**什麼時候某件事應該改放在 `CLAUDE.md`？**
問問自己它下個月是否仍然成立。`CLAUDE.md` 是關於專案的常駐 context，不管相不相關，都會載入到每個 session。handoff 是關於一件正在進行中的工作，那件工作一完成，它就沒用了。如果你一直在重複解釋某個事實，它就屬於 `CLAUDE.md`。做到一半的任務則屬於 handoff。

**它記下了「做什麼」，卻沒記下「為什麼」。**
這是一個合理的批評，而且大家常常提出。有兩件事有幫助。傳入參數（告訴它下一個 session 是要做什麼），這樣 skill 會保留與*那件事*相關的推理，而不是把它壓平。另外，留意那些 session 從未驗證過、卻說得很有把握的說法，例如「X 還沒做」或「Y 已經完成」。下一個 agent 會信任這份文件，不會重新檢查，所以一個被寫成事實的想法，會變成之後所有事情的錯誤前提。交出去之前先讀一遍文件，把你只是假設的東西降級。

**為什麼它是 skill，而不是 slash command（斜線指令）？**
兩者都可以；它們適合不同的情況。作為 skill，它和這裡的其他東西一樣，透過同一條安裝路徑發佈和更新，所以容易分享。阻止 agent 自己觸發它的，是它的 frontmatter（檔頭設定區塊），而不是機制本身。

## 運作正常的跡象 (It's working if)

- 文件只占對話的一小部分，而且 spec、issue 和 diff 在其中是以路徑和 URL 出現，而不是複製過來的文字。
- 你可以在沒開啟原本 session 的情況下直接讀懂它，並知道下一步要做什麼。
- 新的 agent 直接開始工作，而不是要你重新解釋設定。
- 在分叉的情況下，你回到原本的 session 時，它沒有任何改變。
- suggested-skills 區塊列出的 skill，正是你自己會選用的那個。
- 裡面沒有任何金鑰、token（存取憑證）或密碼。

## 它在流程中的位置 (Where it fits)

`handoff` 是一個 **reach-for-it-anytime standalone**（隨時可用的獨立 skill）。它在 session 之間運作，而不是在建構鏈裡面。它的用途很窄，你用它的次數會比階段邊界上的其他四個選項少。它最接近的鄰居是 [prototype](https://aihero.dev/skills-prototype)，因為 prototype 住在自己的目錄裡，而出去再回來的這趟來回，正是這個 skill 要處理的動作。當你在邊界上不確定要繼續、清空、handoff、委派還是 compact 時，[ask-matt](https://aihero.dev/skills-ask-matt) 有排出這五個選項順序的決策樹，也會在整個 skill 集合中為你指路。
