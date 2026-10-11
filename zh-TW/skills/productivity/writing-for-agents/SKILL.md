---
name: writing-for-agents
description: Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md.
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/productivity/writing-for-agents/SKILL.md)
>
> **description 中譯：** 為 agent（AI 代理）撰寫文件。在建立或編輯 skill（技能包），或修改 AGENTS.md 或 CLAUDE.md 時使用。

撰寫任何給 agent 讀取的文件時的參考：skill、`AGENTS.md` / `CLAUDE.md`、透過 pointer（指標）到達的文件。包裝方式不同；寫法沒有不同：同樣的槓桿讓每一種都變得可預測，因為 agent 每次執行走的是同樣的*流程*，而不是產出同樣的輸出。

當你要寫的文件是 skill 時，閱讀 [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md)，了解 frontmatter（檔頭中繼資料）、invocation（呼叫方式）的選擇，以及 router skill（路由型 skill）。

## Context pointers

**context pointer**（脈絡指標）是存在 agent 的 context（脈絡）裡的一個參照，它點名某份不在 context 裡的材料，並編碼了取用它的條件。skill 的 description（描述）就是一種；`AGENTS.md` 裡點名某份文件的一行，也是同一種東西。決定 agent 何時取用那份材料、以及有多可靠的，是 pointer 的*措辭*，而不是它指向的目標。一個必要的目標藏在措辭薄弱的 pointer 後面，就是一個變異性（variance）bug：先把措辭磨利，只有在磨利失敗時，才把材料內嵌進來。

pointer 做兩件事：說明這份材料是什麼，並列出應該觸發取用它的 **branches**（分支情況：文件處理的一種獨立情況，所以不同的執行會走不同的路徑穿過文件）。一個永遠載入的 pointer，每個字在每一輪都要付出成本，所以它比內文更值得嚴格修剪：

- **把 leading word（引導詞）放在最前面**：pointer 正是它發揮觸發作用的地方。
- **每個 branch 一個 trigger**（觸發詞）。只是替同一個 branch 換名字的同義詞，等於把一個 branch 寫了兩次；把它們合併，只保留真正不同的 branch。
- **刪掉內文已經交代的身分說明**。

## 兩種負擔 (The two loads)

你加入的每份文件和 pointer，都會花掉兩種預算之一：

- **Context load**（context 負擔）是永遠載入的材料加在 agent 視窗上的成本：`AGENTS.md` 的一行、skill 的 description，任何每一輪都待在 context 裡的東西，不論它有沒有觸發，都在花費 token（詞元）和注意力。
- **Cognitive load**（認知負擔）是加在人類身上的成本：有哪些文件存在，以及何時該去找哪一份。人類就是那份索引。它不是要最小化的成本：它是人類主導權的代價；在人類判斷重要的地方花它，在不重要的地方移除它。

只透過 pointer 取用的材料，以 pointer 自己那一行為代價，避開了 context load；完全沒有 pointer 的材料，則完全落在 cognitive load 上。

## Information hierarchy

文件由兩種內容類型組成：**steps**（步驟：agent 依序執行的動作）和 **reference**（參考：需要時才查閱的定義、規則、事實）。兩者可以自由混合：全是 steps（一份食譜）、全是 reference（一份審查的規則、這個 skill），或兩者都有。核心決定是每一塊內容落在 **information hierarchy**（資訊層級）的哪個位置，這是一道依 agent 需要該材料的急迫程度排列的階梯：

1. **In-file step**（檔內步驟）是首要層級：agent 依序要做的事。
2. **In-file reference**（檔內參考）是在需要時查閱的。它常常是一組合理地平鋪的同級項目（一份審查的每條規則都在同一階），這是很好的安排，不是壞味道（smell）。
3. **Disclosed reference**（揭露式參考）被推到另一個檔案，透過 context pointer 取用，只在 pointer 觸發時才載入。範圍從同一資料夾裡的兄弟檔案，一直到完全外部的參考：可以放在任何地方、任何文件都能指向它。

往下推得太少，頂層就會膨脹；推得太多，你就會藏起 agent 真正需要的材料。這個拉扯就是整個決定的全部。

**Progressive disclosure**（漸進式揭露）是沿著階梯往下移（移出主檔案、放到 pointer 後面），讓頂層保持易讀。它主要不是為了節省 token：它是保護層級的方法。branching（分支）是最乾淨的揭露測試：每個 branch 都需要的就內嵌，只有部分 branch 會用到的就推到 pointer 後面。當文件有 steps 時，本該被揭露的檔內 reference 會把 steps 埋起來，讓 agent 是否注意到它們變成擲硬幣：這是一個變異性槓桿，而不只是易讀性的槓桿。

**Co-location**（就近放置）是檔案內的搭檔：階梯決定一塊內容落在*多深*的位置，co-location 則決定它到了那裡之後*旁邊放什麼*。把一個概念的定義、規則和注意事項放在同一個標題下，而不是四散各處，這樣讀到其中一部分時，相鄰的內容也會一起被讀到。測試方法：這份文件讀起來應該像是為 agent 寫的說明文件。集中的材料讀起來就是那樣；分散的材料則不是。（這和重複不同：重複是把同一個意思放在兩個地方；分散則是把一個意思拆成碎片，散落在許多地方。）

**Sprawl**（蔓生）是這裡的失敗模式：文件就是太長，即使每一行都仍然有效、而且獨一無二。注意力會被多出來的部分稀釋，而每多一行，就多一行需要保持相關。解法就是階梯：把 reference 揭露到 pointer 後面，並依 branch 或順序拆分，讓每條路徑只帶它需要的東西。

## Steps and completion criteria

每個 step 都以一個 **completion criterion**（完成條件）結尾，也就是告訴 agent 工作已完成的條件。有兩個屬性讓它成為一個槓桿：

- **Clarity**（清晰度）：agent 能分辨完成和未完成嗎？一個模糊的界線（"understanding reached"，達成理解）會招來 **premature completion**（過早完成）：在 step 真正完成之前就結束它，注意力滑向*完成這件事本身*。前方仍看得見的 steps（也就是 **post-completion steps**：完成後的步驟）提供拉力；criterion 的清晰度則是阻力。依序防禦：**先把界線磨利**（局部而且便宜）；只有當它本質上無法變清楚，*而且*你觀察到搶快的情況時，才透過拆分順序把後面的 steps 藏起來。只有跨越真正的 context 邊界時，隱藏才有效（一次 handoff（交接）或一次 subagent（子代理）派遣；inline 呼叫會讓後面的 steps 留在 context 裡，什麼都沒清掉）。
- **Demand**（要求度）：它要求多少。"Every modified model accounted for"（每個被修改的 model 都有交代）會迫使徹底的工作，而 "produce a change list"（產出一份變更清單）不會。Demand 驅動 **legwork**（跑腿功夫：agent 在工作中做的挖掘，潛藏在措辭裡，而不是寫成獨立的 step），而且它不受 step 限制："every rule applied"（每條規則都套用了）約束一整塊平鋪的 reference，就像 "every step done"（每個步驟都完成了）約束一個順序一樣，這就是一份全是 reference 的文件仍然能帶有詳盡標準的方式。

最強的 criteria 既可檢查，又徹底詳盡。

## 何時拆分 (When to split)

把一份文件拆成兩份，會花掉兩種負擔之一，所以只在這一刀值得時才拆：

- **依順序**：當 post-completion steps 誘使 agent 趕著做眼前那一步時，就拆開那一串 steps。讓它們不在視線內，能驅動對目前任務更多的 legwork。小心反過來的情況：合併順序會把每個 step 的後續 steps 暴露給接下來的內容，招來 premature completion。
- **依 invocation**，這是 skill 專屬的：見 [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md)。

## Leading words

**leading word** 是一個精簡的概念，早就存在於 model（模型）的預訓練裡，agent 在執行文件時會用它來思考（*lesson*、*fog of war*、*tracer bullets*）。它以一個 token 的形式重複出現，絕不以一個句子的形式重複，於是累積出一個分散式的定義，並藉由調動 model 已經擁有的先驗知識，用最少的 token 錨定一整個區域的行為。自己造詞也行，只要你把它定義清楚，但一個編造的詞調動不了任何先驗知識：預訓練過的詞免費給你的東西，你要用定義的 token 來付；先去找現成的詞。

它會錨定兩次。在內文裡，它錨定*執行*：每次這個詞出現，agent 都會採取同樣的行為；而在平鋪的 reference 裡，它會把注意力集中在某一類要找的東西上。在 pointer 裡，它錨定 *invocation*：當同一個詞存在於你的 prompt（提示詞）、你的文件和你的 codebase（程式碼庫）裡時，agent 會把這套共享語言和那份材料連結起來，更可靠地取用它。

積極尋找可以用 leading word 來 refactor（重構）的機會。在三個地方完整寫出的三連詞、一個花一整句話去暗示一個概念的 pointer。每一個都是迫切需要壓縮成單一 token 的段落：

- "fast, deterministic, low-overhead"（快速、確定性、低開銷）→ *tight*（緊密；a *tight* loop）。
- "a loop you believe in"（一個你信得過的迴圈）→ *red*（紅燈），把一個模糊的關卡變成一個可觀察的二元狀態（迴圈要嘛因為 bug 變 *red*，要嘛沒有）。

你贏兩次：更少的 token，以及一個更鮮明的掛鉤，讓 agent 把思考掛在上面。假設每份文件都帶著一些可以被 leading word 淘汰的重述。去把它們找出來。

**Negation**（否定）是這個槓桿旁邊的失敗模式：用禁止來引導，會把被禁止的行為拖進 context，讓它*更*容易被取用，而不是更不容易。*不要想大象*，結果腦中就只剩下大象；否定是一個微弱的修飾語，會被強烈激發的概念蓋過，所以禁令有一半會被讀成去做那件事的指示。用**正面**的方式下 prompt：說出目標行為（"write one-line comments"，寫一行的註解），讓被禁止的那個行為永遠不被說出口。禁令只有在作為一條你無法用正面方式表達的硬性護欄時，才有存在的價值；即使如此，也要搭配正面的目標，讓注意力落在該做的事上。

## 修剪 (Pruning)

- 讓每個意思只保留一個 **single source of truth**（單一事實來源）：一個權威的地方，這樣改變行為就只需要改一個地方。**Duplication**（重複：同一個意思出現在不只一個地方）會花費維護成本和 token，並讓一個意思在階梯上的顯著程度膨脹到超過它真正的層級。（它是 leading word 的意外反面；leading word 是刻意重複一個 token，絕不重複意思。）
- **environment**（環境）也是一個事實來源（`package.json` scripts、設定檔、目錄結構、`--help` 輸出），重述它的文件就是一個 **cache**（快取）：一份查詢結果的副本，只有在查詢很昂貴時才值得付出它的負擔。要 cache 的是 agent 靠查看找不到的東西：沒寫下來的慣例、某個選擇背後的原因、沒有任何設定檔會透露的陷阱。把只需要看一個檔案、跑一個指令的查詢留給 environment，在那裡它們不會過時。
- 檢查每一行的 **relevance**（相關性）：它是否仍然和文件要做的事有關？一行會失去相關性，要嘛是因為它從來就與任務無關（純粹的說明，或一個應該被揭露的 branch），要嘛是因為它描述的行為或世界改變了，它變得過時。越短的文件越容易保持相關。沒有修剪紀律的話，預設的命運就是 **sediment**（沉積物）：過時的層層堆積，因為增加感覺安全、刪除感覺有風險，直到你必須一路鑽探穿過它們，才能找到仍然有效的東西。
- 逐句搜捕 **no-ops**（無作用指令）：一條 model 預設就會遵守的指令，付出負擔卻什麼都沒說。這個測試（相較於預設，它有沒有改變行為？）是相對於 model，而不是相對於讀者：兩個人對某句是不是 no-op 有分歧，其實是對預設行為有分歧，要靠執行這份文件來解決，而不是靠辯論。當一個句子沒通過時，刪掉整個句子，而不是從裡面刪幾個字。這個測試也能評估 leading word：一個弱到贏不了預設的詞（在 agent 已經算是相當徹底的情況下寫 *be thorough*）就是一個 no-op，解法是換一個更強的詞（*relentless*），而不是換一種技巧。
