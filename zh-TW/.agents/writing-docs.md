> 繁體中文翻譯。原文：[writing-docs.md](../../.agents/writing-docs.md)

# 撰寫 docs 頁面 (Writing docs pages)

`engineering/` 和 `productivity/` 裡的每個 skill（技能包）都有一個給人看的 **docs page**（說明頁面），位置在 `docs/<bucket>/<skill-name>.md`。docs 目錄樹與 `skills/` 底下那兩個 bucket（分類資料夾）一一對應。它發布在 `https://aihero.dev/skills-<skill-name>`；不管在哪個 bucket，網址永遠是 `skills-<skill-name>`，所以 docs 路徑只是 repo（程式碼儲存庫）內部的組織方式。這個頁面不是 skill 本身，也不是 `SKILL.md` 的副本。只有這兩個 bucket 是 promoted（推廣）的；其餘的（`misc/`、`in-progress/`、`deprecated/`）不提供 docs 頁面。

這些 skill 大多是 **user-invoked**（使用者呼叫：只有人能觸發）：agent（AI 代理）永遠不會替你觸發它們，所以*你*就是那份索引，必須記得它們存在，以及什麼時候該用它們。這份記憶就是 **cognitive load**（認知負荷）。docs 頁面的工作就是減輕它：圍繞一個 skill 替一位讀者定位，讓他能把它記在腦中、知道什麼時候該用它，並看出它在整個系統中的位置。這些頁面合起來是一個分散式的 router（路由器）；每個頁面是一個節點。

每當有 promoted skill 被新增、重新命名，或行為被改變時，就要行動：建立或重新同步它的 docs 頁面。重新命名時檔案也要跟著搬（`docs/<bucket>/<old>.md` → `docs/<bucket>/<new>.md`），因為發布的網址跟著名稱走；在 `engineering/` 和 `productivity/` 之間移動的 skill，要把它的 docs 檔案搬到對應的資料夾。`misc/`、`in-progress/` 和 `deprecated/` 裡的 skill 沒有頁面，因為這些 bucket 都不是 promoted。一個 skill 從它們其中之一*移出*、進到 `engineering/` 或 `productivity/` 時，就會得到頁面；反方向移動的則會失去頁面。被整個移除的 promoted skill 會把它的頁面保留為 **archived**（已封存）頁面：內文保持原樣，並在開頭加上一段引言區塊通知（`> **Archived.** ...`），寫出它在哪個版本被移除，以及取代它的東西（如果有的話），讓發布的網址能繼續解析。

因為這些頁面發布在 `aihero.dev` 上，**每個連結都是絕對路徑**：絕不使用相對於 repo 的路徑。連到另一個 skill 的連結指向 `https://aihero.dev/skills-<name>`；連進 repo 的連結指向完整的 `https://github.com/mattpocock/skills/...` 網址。在 repo 裡能用的相對連結，一發布就會壞掉。

沒有 H1。發布的頁面會從 slug 取得標題。

## 頁面結構 (Page structure)

填寫下面的範本，並保持它的順序。**fixed frame**（固定框架：`## What it does`、`## When to reach for it`、`## Where it fits`）會出現在每個頁面上。`## Prerequisites` 和自由格式的內容區段，只放這個 skill 需要的東西；其餘的刪掉。

有四個區段讓一個頁面值得一讀：`What it does`、`When to reach for it`、`Common questions`、`It's working if`。前兩個幫讀者定位；後兩個則是頁面不再摘要 skill、開始回答讀者自身情況的地方。後兩個各有一個要通過的門檻（見下方），但一個兩者都沒通過的頁面，要當成還沒完成，而不是已經完成只是比較短。

**頁面不放安裝指令。** ai-hero 的頁面範本會自己在內文上方顯示安裝小工具（一個複製按鈕、單一 skill 的指令、整組的指令，以及更新那一行）。如果頁面也把它們寫出來，讀者就會看到同一個指令兩次，而且兩份副本會漸漸不一致：每個頁面上手寫的那一對指令，都已經和旁邊的小工具對不上了。安裝的措辭是網站的屬性，不是頁面的屬性。如果需要修改，就在 ai-hero 裡改；標準措辭放在[安裝區塊](./install-block.md)裡。

<page-template>

## 它做什麼 (What it does)

一到兩段淺白的文字。先用一句話說出這個 skill 的工作，接著說出 **defining constraint**（決定性限制）：讓這個 skill 的行為和顯而易見的預設做法不同的那一個事實（以 `to-spec` 為例：它不會再訪談使用者一次，而是整合已經知道的內容）。把它寫成平鋪直敘的句子，絕不要寫成帶標籤的旁白，像是 "The defining constraint:" 或 "The key thing:"；這種公式讀起來像填充文字。這一句是整個頁面最有價值的；絕對不要省略。

## 什麼時候用它 (When to reach for it)

你如何以及何時使用這個 skill，分成兩個重點，兩者實際上都一定會出現：

- **Invocation mode**（呼叫方式）。說明是你輸入它，還是 agent 觸發它。user-invoked skill："You invoke this by typing `/<name>`, and the agent won't reach for it on its own."（「你要輸入 `/<name>` 來呼叫它，agent 不會自己去用它。」）model-invoked（模型呼叫）skill："Type `/<name>`, or the agent reaches for it automatically when a task fits."（「輸入 `/<name>`，或在任務合適時由 agent 自動使用它。」）
- **Trigger boundary**（觸發邊界）。也就是索引項目："reach for this when …"（「在……的時候用這個」）。如果這個 skill 容易和某個相近的 skill 搞混，就加上另一半："for <X> instead, use [<sibling>](https://aihero.dev/skills-<sibling>)."（「如果是 <X>，請改用 <sibling>。」）

## 前置條件 (Prerequisites)

選用：只有在 skill 需要某些東西先就位才能運作時才放；否則整個標題都省略。涵蓋：**它會寫入的工作區**（像 `grill-with-docs` 這種有狀態的 skill 會寫 `GLOSSARY.md` 和 ADR（架構決策紀錄）；`teach` 會建立一整個目錄，所以要說明它寫什麼、寫在哪裡）、**事先的設定**（`triage`/`to-spec`/`to-tickets` 需要 `setup-matt-pocock-skills` 已經設定好一個 issue tracker（議題追蹤工具）），或 **repo 專屬的工具**。一個在哪裡都能跑的無狀態 skill 沒有前置條件，所以把這個區段拿掉。

## <自由格式的中段> (<free-form middle>)

一到三個短區段，用 skill *自己的詞彙*寫，讓讀者一看就懂。選任何適合這個 skill 的標題：它跑的迴圈、它產出的成品、它做出的分岔、它消滅的那一個反模式。沒有規定的標題；這些 skill 彼此差異太大，沒辦法用同一個。

唯一不能妥協的一點：**把 skill 的 leading word（主導詞）／核心概念凸顯出來**（`tight` feedback loop、`deep module`、throwaway-code-answers-a-question、red-green（紅燈、綠燈））。這會帶來兩次回報：讀者學到這個 skill *是*什麼，也學到之後會用來想到並*使用*它的那個詞。

## 常見問題 (Common questions)

讀者真正會問的、關於這個 skill 的問題，每個問題用粗體，答案寫在下面幾行。不要用子標題。

實際觀察到的問題永遠勝過編出來的問題，所以在寫任何問題之前，先去找出它們：

- **wiki。** 如果這台機器上有 `~/repos/matt/personal-wiki`，它就是最豐富的來源。它的 `wiki/audience/` 區域是圍繞著受眾想要什麼、討論什麼，以及**對什麼感到困惑**來組織的：先讀 `wiki/index.md` 看頁面清單，再讀和這個 skill 有關的頁面。每個頁面都帶有 `sources:` 回連到原始的 X、Discord、GitHub 和 email 討論串；wiki 是二手來源，所以要引用提問者自己的問題，而不是 wiki 對它的摘要。如果這個目錄不存在，就跳過這一項。
- **這個 repo 的 issue（議題）。** `gh issue list --repo mattpocock/skills --search "<skill-name>" --state all`。被提出兩次的問題，就是頁面欠讀者一個答案的問題。
- **`CHANGELOG.md`。** 任何被重新命名、搬移，或行為改變的東西，都會引發一個「它跑去哪了？」的問題，頁面必須回答。

如果找到的不多，這個區段也可以放一個讀者顯然會問的問題，但**數量要誠實反映證據**。一個被大量討論的 skill 可以有六個；一個冷門的只值得一兩個，或一個都沒有。把資料少的 skill 硬塞到和資料多的一樣多，就是這個區段被沒人會問的問題塞滿的原因，而一個編出來的問題教不了讀者任何東西。

依每個問題出現的頻率排序，最尖銳的放最前面，而且在屬實的地方，要說出不討喜的事實：很長的 grilling session（拷問式對談）通常代表範圍太大；叫 model（模型）自己寫 skill，產出的東西會很冗長。如果沒有值得回答的問題，就省略這個標題。

## 運作正常的跡象 (It's working if)

幾個項目，說出 skill 正常運作時讀者會看到什麼。每一項的門檻是：讀者不用打開 `SKILL.md` 就能檢查，也就是他們自己工作中的一個訊號，或眼前執行紀錄裡的一個訊號。「文件越寫越好時，也會越來越短」合格；「library 區段和 `template.sh` 逐位元組相同」則是披著這個區段名稱、對 skill 內部做的合規檢查。只要跡象清楚，就放這個區段；如果跡象一直很模糊，就省略這個標題。

## 它在流程中的位置 (Where it fits)

一定要有。用一兩句話把 skill 放進整個系統中：

- **角色。** 說出它是什麼：**chain step**（鏈中的一步：`grill-with-docs → to-spec → to-tickets → implement → code-review`）、**run-once setup**（只跑一次的設定：`setup-matt-pocock-skills`）、**periodic maintenance**（定期維護：`improve-codebase-architecture`，「每隔幾天」），或 **reach-for-it-anytime standalone**（隨時可用的獨立 skill：`diagnosing-bugs`、`prototype`、`handoff`）。獨立 skill 的地圖就是一句誠實的話，這遠比省略這個區段好。
- **鄰居。** 一兩個重要的相近 skill，每個都附上一個「因為……」的理由，並用絕對連結。
- **整體地圖。** 指向 [ask-matt](https://aihero.dev/skills-ask-matt)，也就是涵蓋整組 skill 的 router，讓這個頁面保持只是一個節點，永遠不需要重畫整張圖。

</page-template>

## 慣例 (Conventions)

- 解釋**為什麼**，而不是流程。頁面是用來定位 skill、說明它在哪裡；它絕不重現 `SKILL.md` 的步驟或整段範本：一個正在挑工具的人不需要操作手冊。
- **絕不提到作者的名字。** 頁面是一份技術文件，不是誰說了什麼的紀錄。"Matt says"、"Matt's own answer"、"his position is"、一段引用的回覆：全部拿掉。從找問題的過程中得到的發現值得保留；但它的出處不用保留。把實質內容寫成關於 skill 的單純陳述（"the fix is a direct instruction: …"（「解法是一個直接的指令：……」）、"the split comes down to session count"（「分法取決於 session 的數量」）），並拿掉那層框架。讀者正在決定要不要用一個工具；一個意見不管有沒有署名，分量都一樣，而署名的意見只要立場一變就過時了。引用*使用者*的話則沒問題："one user reported …"（「有一位使用者回報……」）是這個 skill 在實際使用中的證據，而且保持匿名。
- 使用 skill 的 **leading words**，例如 _seam_（接縫：可以觀察行為的公開邊界）、_deep module_（深模組）、_tracer bullet_（曳光彈），讓頁面和 skill 說同一種語言。
- **只要 [AI Coding Dictionary](https://www.aihero.dev/ai-coding-dictionary) 裡有對應的術語，就用它的術語，並在頁面上第一次使用時加上連結。** 這本詞典是 AI 寫程式的內部標準詞彙：_context window_（上下文視窗）、_subagent_（子 agent）、_harness_（執行環境）、_primary source_（一手來源）、_agent mode_（agent 模式）。優先用它的詞，而不是你自己發明的同義詞。把每個術語第一次出現的地方連到 `https://www.aihero.dev/ai-coding-dictionary/<slug>`（slug 就是把術語轉成小寫，非英數字元換成連字號：_context window_ → `context-window`），之後再出現都不加連結。只有在這個詞帶有詞典裡的意思時才加連結：domain *model*（領域模型）、background *context*（背景脈絡）或 auth *token*（驗證權杖），是剛好拼法相同的不同詞。絕不在標題、code span 或既有的連結裡加連結，也絕不連結那些指的是這個 repo 裡某個 skill、而不是那個概念的詞。完整的術語清單，如果這台機器上有 `~/repos/ai/ai-coding-dictionary/dictionary/` 就讀它（每個術語一個檔案，檔名*就是*術語），否則就讀 [mattpocock/dictionary-of-ai-coding](https://github.com/mattpocock/dictionary-of-ai-coding)，不管哪種情況，它都是真實來源。
- **分支放在表格或清單裡，絕不放在段落裡。** 當頁面呈現一個選擇時（skill 能產出的兩種成品、觸發它的四種情況、某個邊界上的五個選項），讀者是在掃描找出符合自己情況的那一列。段落會逼他們全部讀完才知道。一個短的 markdown 表格（左欄寫條件，右欄寫該做什麼）或一個項目清單，讓他們一眼就看到。不管分支出現在哪裡都適用，最常見的是在 `## When to reach for it` 和自由格式的中段。
- 讓頁面本身保持低負荷。它是*關於*低認知負荷 skill 的文件；多餘的擺設（多出來的標題、重複的連結）正是它所反對的東西。

## 完成的條件 (Done when)

- 頁面存在於 `docs/<bucket>/<name>.md`，而且重新命名或搬移 bucket 之後，沒有任何過時的頁面殘留。
- 頁面沒有原始檔連結，也沒有自己寫安裝指令。
- `## What it does` 說出了 defining constraint，用平鋪的文字，而不是帶標籤的旁白。
- 頁面沒有提到作者，也沒有引用作者：每個陳述都能獨立成立。
- `## When to reach for it` 說出了 invocation mode 和 trigger boundary。
- `## Where it fits` 說出了角色，並連結到 `ask-matt`。
- 有前置條件（工作區、事先設定、工具）時就寫出來，沒有時這個區段就不存在。
- 中段凸顯了 leading word。
- 頁面用到的每個 AI Coding Dictionary 術語，都照詞典的方式拼寫，而且它第一次使用時（而且只有第一次）連結到詞典條目。
- 每個多路分支都是表格或清單，而不是讀者必須全部讀完的段落。
- 找真實問題的搜尋已經做過（wiki、issue、changelog），而且 `## Common questions` 的大小符合找到的內容，沒有為了比照資料較多的 skill 頁面而灌水。
- 每一個 `## It's working if` 項目，都能在不打開 `SKILL.md` 的情況下檢查。
- 各區段依照範本的順序出現。
- 每個連結都是絕對路徑，而且每一個都能正確連到。
