> 繁體中文翻譯。原文：[implement-spec.md](../../../docs/engineering/implement-spec.md)

## 它做什麼 (What it does)

`implement-spec` 拿一份 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格）和它的 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（工作單），在一次執行中把全部內容落地。負責編排的 [agent](https://www.aihero.dev/ai-coding-dictionary/agent)（代理）把每張 ticket 交給一個在自己的 git worktree 中工作的 implementer [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent)（負責實作的子代理），把每個完成的 branch（分支）merge（合併）進單一的 **integration branch**（整合分支），對結果執行 [code-review](https://aihero.dev/skills-code-review)，然後把 tickets 結案。

它把 tickets 讀成一張 **task graph**（任務圖），而不是一份清單。Blocking edges（阻擋關係：哪張 ticket 要等哪張完成）決定什麼可以開始，所以在任何時刻都有一個由「阻擋者都已落地的 tickets」組成的 **frontier**（前沿），而 frontier 上的每張 ticket 會同時執行。這就是它和一張一張處理 tickets 的差別。決定速度的是這張圖的形狀，而不是 tickets 在 tracker（追蹤系統）上的順序。

## 什麼時候用它 (When to reach for it)

你要輸入 `/implement-spec` 來呼叫它，agent 不會自己去用它。

| 你的情況 | 該用什麼 |
| --- | --- |
| 一份已拆成帶有 blocking edges 的 tickets 的 spec，你想在一次執行中全部落地 | `/implement-spec` |
| 一次一張 ticket，在你自己的 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window)（上下文視窗）中進行，每張 ticket 之間做 [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing)（清除） | [implement](https://aihero.dev/skills-implement) |
| 一份還沒拆成 tickets 的 spec | 先用 [to-tickets](https://aihero.dev/skills-to-tickets) |
| 一小塊工作，沒有真正的圖結構 | 直接用 [implement](https://aihero.dev/skills-implement) |

## 前置條件 (Prerequisites)

- **一個 issue tracker（議題追蹤系統）。** 這個 skill（技能）從 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 設定好的 tracker 讀取 tickets，也在那裡把它們結案。如果還沒設定任何 tracker，它會停下來，告訴你先去執行那個 skill，而不是自己猜。
- **帶有 blocking edges 的 tickets**，就像 [to-tickets](https://aihero.dev/skills-to-tickets) 寫出來的那樣。沒有這些關係，圖就是平的，每張 ticket 都會同時開始。
- **一個能在背景執行 subagents、並給每個 subagent 一個 git worktree 的 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)（執行 agent 的外殼程式，例如 Claude Code）。** 這個 skill 存在的目的就是同時執行多張 tickets，所以在一次只能跑一個 subagent 的 harness 上，它只是一個比較慢的 `implement`。

## The integration branch

所有東西都落在同一個 branch 上。每個 implementer（實作者）：

1. 開始之前，先確認它的 worktree 是以 integration branch 為基礎，
2. 用 [tdd](https://aihero.dev/skills-tdd) 實作它的 ticket，一次一個切片做 red-green（紅燈到綠燈：先寫會失敗的測試，再讓它通過），
3. 回報完成之前，先把 integration branch 的最新 commit（提交）merge 進自己的 branch，讓落地變成 fast-forward（快轉合併）。

由 tracker 決定到底要不要有 pull request。如果你的 tracker 是透過 PR 結束工作，或者你要求開一個，skill 會在第一次 merge 之後開一個 draft PR，並在最後把它標為 ready。否則，這次執行會停在 integration branch 上，每張 ticket 都依你的 tracker 結束工作的方式結案，搭配本地 markdown tracker 時可以完全離線運作。

Implementer 透過 [context pointers](https://www.aihero.dev/ai-coding-dictionary/context-pointer)（指向資料來源的指標）和編排者溝通（spec、ticket、共享的探索筆記、較早的 commits），而不是透過貼上的摘要。這讓每個 subagent 的 prompt（提示詞）保持精簡，並在編排者的視窗裡留出空間給這張圖。

## 常見問題 (Common questions)

**這和我自己對每張 ticket 執行 `/implement` 有什麼不同？**

這正是這個 skill 存在要回答的問題。在它發布之前，大家一直在自己做各自的版本，有一位使用者這樣描述需求：他們想要「讓 subagents 去實作 tickets」，而不是「當一份 spec 可能包含超過 5 張 tickets 時，還得一個一個建立新的 session，再叫它們一張一張實作 ticket」。用 `implement` 時，你就是調度者：每張 ticket 一個 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段），中間做 clearing，並且自己追蹤哪些 tickets 已經不再被阻擋。`implement-spec` 把這份工作交給一個負責編排的 session。代價是你不再於每張 ticket 落地時閱讀它的成果；你是在最後審查 integration branch。要開始一次執行，先清除 context（上下文），然後輸入 `/implement-spec` 並附上指向 spec 的指標（一個 issue 編號或檔案路徑）。對於沒有真正圖結構的小型變更，就跳過它，直接用 `implement`。

**它需要 GitHub 嗎？我希望它停在 branch 上就好。**

不需要了。有一位喜歡 in-progress（測試中）版本的使用者正好有這個抱怨：「它在最後會建立一個 PR，這需要像 GitHub 這樣的線上儲存庫。我希望它能離線做同樣的工作，然後停在所有工作都已 merge 的那個 branch 上。」現在這次執行會結束在 integration branch 上。只有在設定的 tracker 透過 PR 結束工作，或你要求開 PR 時，才會開 PR，所以在本地 markdown tracker 上，執行結束時每張 ticket 都已結案，工作也已 merge 在 branch 上。

**它的審查與修正迴圈跑了好幾個小時，或是一直在「修正」還沒做出來的 tickets。**

這兩種情況都發生在 `code-review` 於 skill 指定的那個時間點以外執行時。它拿程式碼和整份 spec 比較，所以只有在每張 ticket 都落地之後才有意義。如果在執行途中跑它，每張還沒做的 ticket 都會被當成失敗。agent 接著就去做那張 ticket，這又觸發另一次審查。在最後，skill 會執行一次 `code-review`，並把每個發現都交給一個負責修正的 subagent，但它還沒說明那次修正之後何時該停。有一位使用者回報，一個五張 ticket 的功能，「審查與修正迴圈花了大約四個小時」。如果你看到第二次大範圍審查開始，叫它只針對已修正的發現做聚焦檢查，然後停下來。要預期第一次審查會找到真正的問題。這次執行的產出是一份由審查來補完的草稿，不是可以單獨出貨的東西。

**它會像 implement 一樣驅動 tdd 嗎？**

現在會，雖然一開始不會。執行 in-progress 版本的使用者注意到「implementer subagents 不會繼承 /tdd 指令」，所以一從單張 ticket 擴大到整份 spec，red-green 就停了。現在每個 implementer 都用 `tdd` 實作它的 ticket。不過仍然沒有一個讓你互動式確認 seams（接縫：可以觀察行為的公開邊界）的步驟，不像在 `implement` session 中那樣，所以如果你想把 seams 固定下來，就在 spec 或 tickets 裡寫出它們。

**兩個平行執行的 implementer 在同一個檔案上衝突，或是對同一個東西取了不同的名字。**

Worktree 不會消除衝突；它們只是把衝突延後到 merge 的時候。從 ticket 文字寫出來的 blocking edge，只是對每張 ticket 會動到哪些檔案的猜測，而兩張位在「codebase（程式碼庫）不同部分」的 tickets，仍然會共用一份訊息目錄、一個設定登錄表，或一個型別。每個 implementer 只看得到自己的 ticket 和共享筆記，永遠看不到另一個正在進行的工作，所以有一位使用者的 web 和 mobile tickets，把同一個字串分別加成了 `blockedSince` 和 `blockedOn`。當兩張 frontier tickets 會動到同一個共享檔案時，要嘛在它們之間加一條 blocking edge，讓它們依序執行，要嘛讓探索筆記把每張 ticket 要加的確切名稱固定下來。

**被阻擋的 tickets 永遠不會開始，即使它們的阻擋者已經 merge 了。**

這是 GitHub 上的已知問題。tracker 的 blocked-by 計數只有在阻擋者*關閉*時才會下降，而 tickets 通常在 PR merge 時才關閉，那已經是執行的尾聲了。tracker 是起始圖的正確來源，但在執行途中它是過時的。叫編排者自己追蹤哪些 tickets 已經 merge 進 integration branch，並從這個資訊計算 frontier。

**這會取代 Sandcastle 或 AFK（離開鍵盤：無人看管下執行）腳本嗎？**

不會。大家會這樣問，是因為這些 skill 現在已經延伸到實作了：「Sandcastle 還有用嗎？你的 skills 現在似乎也能處理實作了。」`implement-spec` 是在一個 harness session 裡讓一個 agent 負責編排，這不需要任何基礎設施，而且讓你可以觀看和引導。對於真正 [AFK](https://www.aihero.dev/ai-coding-dictionary/afk) 的工作，一個確定性的迴圈（[Sandcastle](https://github.com/mattpocock/sandcastle)、shell 腳本、CI（持續整合）job）更快、更便宜，也更可靠，因為沒有 agent 在做編排的決策。

**某張 ticket 的關鍵測試在它的 worktree 裡被跳過了，而它卻回報 green（通過）。**

worktree 只包含 git 有追蹤的東西。讀取被 gitignore 的 fixtures（測試用的固定資料）、本地資料庫或憑證的測試，在那裡可能會無聲無息地被跳過。對於驗證依賴未追蹤資料的 ticket，叫編排者改在主要的 checkout 中執行它。

## 運作正常的跡象 (It's working if)

- 只要圖允許，就會有好幾個 implementer 同時執行，而不是一個接一個。
- 一張 ticket 在它最後一個阻擋者落地到 integration branch 時就開始，而不是等整個執行結束。
- 每張 ticket 的執行軌跡都顯示 `tdd` 有在跑，而且在寫程式碼之前先有一個會失敗的測試。
- merge 進 integration branch 的都是 fast-forward，而不是解衝突。
- 執行結束在單一 branch 上，每張 ticket 都已結案，而且只有在你的 tracker 需要時才有 PR。

## 它在流程中的位置 (Where it fits)

`implement-spec` 是主要流程鏈中的建構步驟，是每張 ticket 各跑一次 [implement](https://aihero.dev/skills-implement) 的平行替代方案：

```txt
grill-with-docs → to-spec → to-tickets → implement-spec → retro
```

和它相鄰的是 [to-tickets](https://aihero.dev/skills-to-tickets)，它宣告的 blocking edges 會被這個 skill 讀成 task graph；以及 [code-review](https://aihero.dev/skills-code-review)，這個 skill 在收尾前會對 integration branch 執行它。當你不確定自己在哪個流程時，[ask-matt](https://aihero.dev/skills-ask-matt) 是涵蓋整套 skill 的路由器。
