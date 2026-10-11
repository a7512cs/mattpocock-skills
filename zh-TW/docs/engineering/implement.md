> 繁體中文翻譯。原文：[implement.md](../../../docs/engineering/implement.md)

## 它做什麼 (What it does)

`implement` 負責建構已經決定好的工作。你把它指向一張 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket)（工作單）、一份 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格），或你剛在對話中同意的計畫，它就會寫程式碼、在 seams（接縫：可以觀察行為的公開邊界）上驅動 [tdd](https://aihero.dev/skills-tdd)、一邊寫一邊做 typecheck（型別檢查）、在最後執行 [code-review](https://aihero.dev/skills-code-review)，然後 commit（提交）到目前的 branch（分支）。

它絕不重新打開計畫。沒有訪談，沒有釐清問題的回合，也不會提議不同的做法。上游已確定的東西就是輸入，而這個 skill（技能）的全部工作就是把它變成一個 commit。這就是它和對一個全新的 [agent](https://www.aihero.dev/ai-coding-dictionary/agent)（代理）輸入「把這個做出來」的差別，後者常常一邊做一邊重新設計這份工作。

## 什麼時候用它 (When to reach for it)

你要自己輸入 `/implement` 來呼叫它，agent 不會自己去用它。它附帶 `disable-model-invocation: true`，所以其他 skill 也無法呼叫它。凡是 [ask-matt](https://aihero.dev/skills-ask-matt) 或 [to-tickets](https://aihero.dev/skills-to-tickets) 說「接著每張 ticket 各執行一次 `/implement`」的地方，那是給你的指示，不是 agent 會在沒被要求時自己做的事。

工作目前存放在哪裡，決定了這是不是正確的 skill：

| 這份工作目前… | 該用什麼 |
| --- | --- |
| 是 tracker（追蹤系統）上的一張 ticket | `/implement #42`，每個 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段）一張 ticket，每張 ticket 之間做 [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing)（清除）context（上下文） |
| 是一份還沒拆分的 spec，而且建構會橫跨多個 session | 先用 [to-tickets](https://aihero.dev/skills-to-tickets)，再每張 ticket 各執行一次 `/implement` |
| 是一份 spec，而且建構規模很小 | 直接對 spec 執行 `/implement` |
| 只存在於你剛才的對話裡，而且還很小 | 就在那裡、同一個視窗中執行 `/implement` |
| 還沒寫在任何地方 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，如果沒有 codebase（程式碼庫）就用 [grill-me](https://aihero.dev/skills-grill-me) |
| 是一個你想以測試先行來做的具體行為，沒有 spec | 直接用 [tdd](https://aihero.dev/skills-tdd) |
| 已經做好了，你想檢查它 | 直接用 [code-review](https://aihero.dev/skills-code-review) |

同一個 session 的情況值得特別點出來，因為這個 skill 自己的第一行沒有涵蓋它。`SKILL.md` 寫的是 "the spec or tickets"（spec 或 tickets），這會促使 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）去找一個不存在的檔案。如果計畫只存在於這段對話串裡，呼叫它時就說清楚。

## 前置條件 (Prerequisites)

`implement` 會 commit 到你目前所在的 branch。它不會建立新的 branch，也不會問你。開始之前，先確認你在你想放這份工作的 branch 上。

如果 tickets 來自 [to-tickets](https://aihero.dev/skills-to-tickets)，那麼它們所在的 tracker 是由 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 設定的。`code-review` 在收尾時會讀同一份設定，以找到最初的 spec。

## 一次執行做了什麼 (What one run does)

一次執行有五個步驟，依序是：

1. 讀 ticket 或 spec，找出 seams。
2. 在事先約定好的 seams 上驅動 [tdd](https://aihero.dev/skills-tdd)，一次一個 red-green（紅燈到綠燈：先寫會失敗的測試，再讓它通過）切片。
3. 經常做 typecheck，一邊做一邊執行單一測試檔。
4. 在最後執行一次完整的測試套件。
5. 執行 [code-review](https://aihero.dev/skills-code-review)，然後 commit 到目前的 branch。

一次執行涵蓋一張 ticket。[to-tickets](https://aihero.dev/skills-to-tickets) 產出的 tickets 是 tracer-bullet（曳光彈：先打通一條端到端的最小路徑）vertical slice（垂直切片：一次貫穿所有層的一小塊功能），大小剛好能放進一個全新的 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window)（上下文視窗），所以預期的節奏是：清除 context、實作一張 ticket、commit、再清除。每張 ticket 都是自足的，所以你可以丟掉前一張 ticket 的 context。

## 事先約定好的 seams (Pre-agreed seams)

這個 skill 的核心概念是 **seam**，也就是你不必伸手到內部、就能觀察行為的公開邊界。測試就放在 seams 上。當 seam 在任何程式碼存在之前就已約定好，測試就能長久存活，而你可以重寫底下的 implementation（實作），不必改動這些測試。

「事先約定」這個部分很重要，而它也是這個 skill 最弱的一環。`implement` 內部沒有任何東西會去約定 seams。會開口問的是 `tdd` 這個 skill，而且它拒絕在未確認的 seam 上寫測試。所以實際上，約定要嘛發生在上游的 spec 裡，要嘛發生在這次執行的第一輪對答中。如果哪裡都沒發生，這次執行就會變成「直接寫程式碼就好」，而且沒有任何東西會警告你。在 spec 裡寫出 seams，就是防止這種情況的方法。

## 常見問題 (Common questions)

**它跑完了，但我的 ticket 還是開著，驗收條件也還沒打勾。**

沒錯，這是預期中的行為。`implement` 沒有完成步驟。它在 commit 時結束，從不碰工作項目。在 GitHub Issues 和本地 markdown tracker 上都一樣，所以這不是 tracker 整合的問題。它也不會處理 `code-review` 產出的發現，也不會勾選原始 issue（議題）上的 `- [ ]` 方框。請自己關閉 ticket 並核對驗收條件。這在相依鏈上最重要，因為 `to-tickets` 把 frontier（前沿）定義為所有阻擋者都已關閉的 tickets。如果什麼都沒被關閉，就永遠不會有任何東西看起來變成不再被阻擋。

**我可以一次把它指向所有 tickets，或是平行執行好幾個嗎？**

用 `/implement` 不行：一次呼叫，一張 ticket。要在一次執行中完成整份 spec，用 [implement-spec](https://aihero.dev/skills-implement-spec)，它會把已就緒 frontier 上的每張 ticket 交給一個在自己 worktree 中的 [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent)（子代理），再把結果 merge（合併）到單一的 integration branch（整合分支）上。在同一個 checkout 裡並排執行好幾個 `/implement` session，比不支援還糟。有一份實際使用回報描述了：一個 session 中的 `git commit --amend` 落在另一個 session 的 commit 上、一個 stash 從 `refs/stash` 消失、還有 commits 落在錯的 branch 上，全都發生在同一個下午、橫跨三個 issues。這些 session 共用同一個工作目錄、同一個 index 和同一個 HEAD。使用者用 git worktrees 來繞過這個問題，但 `refs/stash` 在 worktrees 之間也是共用的，所以光靠 worktrees 解決不了 stash 的情況。

**它可以改成開 pull request，而不是直接 commit 嗎？**

沒有內建。它直接 commit 到目前的 branch。有好幾個人覺得這太急了，因為程式碼在他們能驗證它可以運作之前就落地了。沒有設定旗標，也沒有 PR 模式。大家會在呼叫時覆寫它（「commit 到一個 branch，然後開一個 PR」），或是修改他們本地那份 skill。當 agent 真的要寫 PR 時，由 [pr](https://aihero.dev/skills-pr) 決定 PR 內文的形式。

**`code-review` 說它看不到我的變更。**

`code-review` 審查的是 `git diff <fixed-point>...HEAD`，這不包含 staged 和工作目錄中的變更。`implement` 在 commit 之前執行它，所以除非已經有一個中途的 commit，否則那個 diff（差異）裡沒有東西可審查。已經有好幾個人回報這個問題，兩邊都還沒修。先 commit，再對你分出 branch 的那個點做審查。

另外，有些人根本不希望審查發生在這次執行裡，因為 agent 審查自己剛寫的程式碼，會偏袒自己的解法。在一個全新的 session 中，針對一個固定的點執行 [code-review](https://aihero.dev/skills-code-review)，是一個可行的替代方案。同樣的偏誤，也是那個 skill 把它的兩個審查面向放在不同 sub-agents（子代理）中執行的原因。

**一張 ticket 燒掉了 150k 個 token。是我用錯了嗎？**

大概不是。比較可能是 ticket 太大了。一次執行要做 codebase 探索、每個 seam 一個 red-green 迴圈、一次完整測試套件，加上一次審查，所以一張不簡單的 ticket 超過 100k [tokens](https://www.aihero.dev/ai-coding-dictionary/token)（模型計算文字的單位）是正常的，並不代表哪裡壞了。修正要在上游做。在 [to-tickets](https://aihero.dev/skills-to-tickets) 中把 tickets 切成合適的大小，讓每張都能放進一個全新的視窗。如果某張 ticket 一直超出，就拆分它，而不是提高 [effort](https://www.aihero.dev/ai-coding-dictionary/effort)（推理力度）等級。

**在全新的 session 中執行 `/implement #2`，它卻去做了完全不相關的事。**

agent 把 `#2` 對應到 context 中另一份有編號的清單，例如 todo 檔或檢查清單，而不是設定好的 tracker。現在 `implement` 會從 issue tracker（議題追蹤系統）抓取傳入的參照，並在開始前說出它的標題，參照有歧義時還會詢問。請確認那個標題符合你指的 ticket；傳入 issue 的 URL 或 `owner/repo#2` 就能完全消除歧義。

## 運作正常的跡象 (It's working if)

- session 一開始就讀 ticket 或 spec，並重述它要建構什麼，而不是問你要建構什麼。
- 你可以在執行軌跡中看到一個實際的 `tdd` Skill 工具呼叫，而不只是 diff 中出現了測試。
- 執行過程中會反覆跑 typecheck 和單一測試檔，完整測試套件則在接近結尾時跑一次。
- 這次執行不需要你催它繼續，就會在你目前的 branch 上完成一個 commit。
- diff 是一張 ticket 份量的變更：一個貫穿每一層的 vertical slice，而不是好幾張 tickets 混在一起。

## 它在流程中的位置 (Where it fits)

`implement` 是主要流程鏈中的建構步驟：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

和它相鄰的是 [to-tickets](https://aihero.dev/skills-to-tickets)，它產出這個 skill 所消化的 tickets，並宣告決定它們順序的 blocking edges（阻擋關係）；[tdd](https://aihero.dev/skills-tdd)，這個 skill 在每個 seam 上於內部驅動它；以及 [code-review](https://aihero.dev/skills-code-review)，這個 skill 在 commit 之前執行它。它位在規劃類 skill 的下游，並且信任它們。它不會重新驗證交給它的東西的形狀，所以一張結構很差的 map（地圖），或一張按水平分層切的 ticket，會照寫的樣子被做出來。

正因為這份信任，[wayfinder](https://aihero.dev/skills-wayfinder) 才會在 [to-spec](https://aihero.dev/skills-to-spec) 這一步接上流程鏈，而不是把它的 map 直接接進 `implement`。只有在工作結果發現規模很小時，才從 map 直接跳到 `implement`。

當你不確定自己在哪個流程時，[ask-matt](https://aihero.dev/skills-ask-matt) 是涵蓋整套 skill 的路由器。
