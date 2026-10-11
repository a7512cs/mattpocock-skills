> 繁體中文翻譯。原文：[resolving-merge-conflicts.md](../../../docs/engineering/resolving-merge-conflicts.md)

> **已封存。** 這個 skill（技能）在 v1.3.0 從 plugin（外掛）中移除，不再維護。沒有任何東西取代它：agent（代理）會在沒有專用 skill 的情況下處理 merge（合併）或 rebase（重新定基）衝突。這個頁面保留下來供參考。

## 它做什麼 (What it does)

`resolving-merge-conflicts` 會逐個 hunk（差異區塊）處理進行中的 git merge 或 rebase，然後執行專案自己的檢查，並以一個 commit（提交）完成這次操作。

它拒絕把衝突當成文字問題。在動任何一個 hunk 之前，它會把兩邊各自追溯回 **[primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source)**（一手來源），也就是 commit message、PR（合併請求）、原始的 issue（議題），所以它是在兩個意圖之間做選擇，而不是在兩塊文字之間，而且只要兩者相容，它就兩者都保留。兩者不相容時，它會選擇符合這次 merge 所述目標的那一邊，並說明取捨。它不會發明新的行為來掩蓋衝突，也從不使用 `--abort`。它一定會把 merge 推進到一個完成的 commit。

## 什麼時候用它 (When to reach for it)

輸入 `/resolving-merge-conflicts`，或者在任務適合時，[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 會自動使用它。

當 git 已經因為無法自行解決的衝突而停下來時，就用它。它的範圍限定在你眼前的衝突，不包含衝突前後的任何事情：

| 你的情況 | Skill |
| --- | --- |
| merge 或 rebase 進行到一半，工作樹裡有衝突標記 | 就是這個 |
| merge 已完成，但現在有東西因為你看不出來的原因而行為異常 | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |
| 正在規劃如何切分工作，讓 branch（分支）少一點衝突 | 都不是：見下方關於平行工作的問題 |

## 優先看 primary source，而不是 `ours` 和 `theirs` (Primary sources over `ours` and `theirs`)

這個 skill 存在的目的是防止靠旗標解決衝突：`--ours`、`--theirs`，或手動刪掉看起來比較不重要的那一塊，讓標記消失、build 能編譯過。這樣的解法在語法上可以完美無缺，卻仍然悄悄丟掉某人刻意做的變更。

你無法保留一個你沒讀過的意圖。所以工作從歷史紀錄開始，也就是 commit、PR 和 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（工單），然後才移到 diff（差異）。檢查步驟也是基於同樣的理由而存在。這個 skill 會找出 repo（儲存庫）自己的 [automated checks](https://www.aihero.dev/ai-coding-dictionary/automated-check)（自動化檢查），並在 commit 之前執行它們，因為在 git 裡，merge 是最容易產生「同時滿足兩個 branch、卻兩邊的 test 都過不了」的程式碼的地方。

## 常見問題 (Common questions)

**Claude Code 自己就已經很會解決衝突了。為什麼還需要一個 skill？**

額外的價值在於「找出 primary source」和「執行回饋迴圈」這兩個步驟，否則你每次都得手動用 prompt（提示詞）要求。沒有被提示的 agent 通常只會根據 diff 做出一個看似合理的解法，然後就停在那裡。這個 skill 的價值在於它不讓 agent 跳過的兩個步驟：讀懂每一邊為什麼存在，以及事後執行檢查。相對於一個好的 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型），這只是小小的提升，而這是刻意的。至少有一位讀者預測，隨著 model 進步，這整個 skill 會變得毫無作用。

**我應該讓平行的 agent 避開同樣的檔案，從一開始就避免衝突嗎？**

大多數情況下不用。在平行任務之間劃分檔案區域的成本比省下的還多，因為 agent 處理 merge 衝突已經夠好了，這個取捨並沒有看起來那麼嚴苛。唯一值得保留的紀律是先做大型的 refactor（重構）。在十個 branch 已經從它分出去之後才落地的大型重新命名，才是代價始終很高的情況。

有一則關於平行 worktree 的使用者回報提出一個注意事項：當並行的各個 [sessions](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段）各自在自己的工作樹裡實作一張 ticket 時，合併回去的工作最好由寫出那個變更的 session 來做，因為它本來就知道意圖。如果最後由一個 agent 解決所有人的衝突，它就失去了 [context](https://www.aihero.dev/ai-coding-dictionary/context)（上下文），而這個 skill 的第 2 步就必須重建那些 context。

**為什麼從不使用 `--abort`？**

中止會丟掉已經做好的解決工作，而下次你再試時，會回到完全相同、毫無改變的衝突。這個 skill 是為了「merge 一定會發生」的情況而寫的。如果你已經決定它不該發生，那是呼叫之前就要做的決定，不是迴圈裡的一個分岔。

## 運作正常的跡象 (It's working if)

- agent 在解決衝突時會引用 commit message、PR 或 issue 給你看，而不只是 diff 的 hunk。
- 每個 hunk 最後都保留了兩邊的行為，或附上明確的說明，指出丟掉了什麼以及原因。
- 結果中沒有出現任何兩個 branch 上都沒有的東西。
- agent 找到了 typecheck（型別檢查）、test 和 format，並在 commit *之前*讓它們全部通過，而不是在你發現東西壞掉之後。
- 你最後得到乾淨的工作樹，操作也已完成，包括多個 commit 的 rebase 中剩下的每個 commit。

## 它在流程中的位置 (Where it fits)

一個隨時可用的獨立 skill，不依賴任何其他 skill：它在 git 卡住時開始，在工作樹乾淨並已 commit 時結束。它唯一真正的鄰居是 [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs)，它在 merge 已經乾淨解決、但合併後的程式碼行為異常時接手：那是診斷問題，不是衝突問題。它不在從想法到出貨的主流程中，所以要知道它之前和之後執行什麼，請看 [ask-matt](https://aihero.dev/skills-ask-matt) 這張地圖。
