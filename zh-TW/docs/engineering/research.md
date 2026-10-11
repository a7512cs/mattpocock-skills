> 繁體中文翻譯。原文：[research.md](../../../docs/engineering/research.md)

## 它做什麼 (What it does)

`research` 透過閱讀掌握答案的來源來回答問題，然後在 repo（儲存庫）裡留下一份附有引用的 Markdown 檔案。它只根據 **[primary sources](https://www.aihero.dev/ai-coding-dictionary/primary-source)**（一手來源）工作：官方文件、原始碼、規格書、第一方 API。它會把每個說法追溯到擁有它的來源，所以當 API 自己的文件查得到時，它不會轉述部落格文章對該 API 的說法。

它不會在對話中回答你。產出是一個檔案，寫在 repo 原本就存放這類筆記的地方，每個說法都附上連結。你得到的是一份可以回應、交給另一個 agent（代理）、或丟掉的文件，而不是一個在 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段）結束時就消失的答案。

## 什麼時候用它 (When to reach for it)

輸入 `/research`，或者當任務變成需要跑腿閱讀時，[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 會自動使用它。

當下一步是從工作目錄以外*查出某件事*（第三方 API 怎麼運作、某份規格書怎麼說、某個版本說法是否成立），而你不想讓自己的對話串卡在閱讀上時，就用它。你需要什麼，決定了用哪個 skill（技能）：

| 你需要什麼 | 該用什麼 |
| --- | --- |
| 一個決策正在等待的外部事實 | `research` |
| 一個*與*你一起、透過訪談做出的決策 | [grilling](https://aihero.dev/skills-grilling) |
| 一個長期有效的架構決策，寫進 `GLOSSARY.md` 和 ADR（架構決策紀錄） | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 查出某個做法在你的 codebase（程式碼庫）裡是否可行 | [prototype](https://aihero.dev/skills-prototype) |
| 一個大到無法在一個 session 裡掌握的計畫 | [wayfinder](https://aihero.dev/skills-wayfinder) |

`research` 和 `grill-with-docs` 的分界在於**帶回來的東西能保存多久**。research 產出的是短期有效的事實，例如這個函式庫的驗證機制在這一週是怎麼運作的。ADR 記錄的是你會保留的決策。如果你產出的是決策而不是事實，那你是在 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式追問），不是在做研究。

## 委派出去的跑腿工作 (Delegated legwork)

閱讀工作以 **background agent**（背景代理）的方式執行。它把每個說法追溯到 primary source、寫出一份 Markdown 檔案並回報的同時，你可以繼續工作。research 是你委派出去的跑腿工作，不是外包出去的思考。你得到一份可以拿來 grill、規劃或設計的文件，而決策仍然由你來做。

沒有任何機制阻止 background agent 自己再產生另一個 background agent。這是這個 skill 被記錄得最清楚的問題。

檔案放在哪裡由 repo 決定，不是由 skill 決定。它會遵循 repo 裡既有的筆記慣例。如果沒有慣例，它會挑一個合理的位置並告訴你放在哪裡。每次執行只寫一個檔案。

## 常見問題 (Common questions)

**它產生了第二個 research agent。這是應該發生的嗎？**

不是。這是一個尚未解決的 bug，[issue #530](https://github.com/mattpocock/skills/issues/530)（議題）。這個 skill 叫它的呼叫者啟動一個 background agent，但沒有限制 agent 類型。所以呼叫者產生一個 `general-purpose` agent，它擁有 `Agent` 工具和同樣的指示，於是又照著做一次。一位回報者測量到，單一個 research 任務在三次重疊的執行中花了大約 450k [tokens](https://www.aihero.dev/ai-coding-dictionary/token)（詞元），而重複的那一個在半小時後才完成，而且是在使用者看不到的地方。在 Claude Code 以外也會發生。使用者確認在 Codex 搭配 GPT-5.6-sol 時也有同樣的巢狀問題。目前沒有已發布的修正。使用者自行修補了自己安裝的版本，加上一行指示，告訴已經是 [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent)（子代理）的 agent 自己完成工作。這有幫助，但它只是一條指示，不是結構上的修正。呼叫這個 skill 之後，留意你的背景任務清單，並停掉重複的那一個。

相反的失敗也會發生。如果你自己的全域指示禁止 agent 再次委派工作，background agent 就會拒絕這個任務，而這個 skill 什麼都不做，也不會告訴你。

**檔案應該放在哪裡？我應該 commit（提交）它嗎？**

這個 skill 把檔案放在 repo 原本存放筆記的地方，除此之外沒有其他意見。社群的看法大致已有共識：保留 ADR，不保留 research 檔案。一個討論這個問題的 Discord 討論串說得最清楚：「ADR 要留。其他的東西做完之後就封存或刪除。不然它會變成工作留下的殘渣，如果你已經偏離了 spec（規格）／research，它還可能污染之後對 repo 的讀取。」research 檔案記錄的是撰寫當天為真的事，所以過時的檔案比沒有還糟。整體來說，這些檔案不屬於 git，而且它們沒有標準的存放位置。大家改用 Obsidian、獨立的知識 repo，或 issue tracker（議題追蹤系統）。

**什麼才算「高可信度」的 primary source？由誰決定？**

由 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）決定。這個 skill 列出了符合資格的來源*種類*（官方文件、原始碼、規格書、第一方 API），但沒有允許清單、沒有網域把關，也沒有驗證流程。這是這個 skill 最初被提出時最大聲的反對意見，至今沒有人公開回應過：「五個 research subagent 指向垃圾來源，只會讓你更快得到五個充滿自信的錯誤答案。你要怎麼把關什麼才算高可信度的來源？」你唯一的保護是每個說法上的引用。點開其中兩、三個看看。如果它們連到的是那個東西的摘要，而不是那個東西本身，這次執行就失敗了。

**之後的 session 會重用先前執行找到的東西嗎？**

不會。沒有任何東西會自動載入過去的 research 檔案。檔案會留在 repo 裡，直到有人或某個 skill 指向它。這是早期對這個設計最強烈的質疑：「價值在於 markdown 變成 agent 之後會重讀的 context（上下文），而不是抓取本身。只寫一次就沒人碰的檔案，只是花俏一點的搜尋。」已發布的 skill 沒有解決這個問題。實務上，只有當你自己把檔案餵進下一步時它才有用：把它附到 spec 上、把它引用到 grilling session 裡、讓一張 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket)（工單）指向它。

**為什麼不直接叫 agent 去讀文件就好？**

你可以，而一段正是這麼說的兩行 prompt（提示詞），就是這個 skill 取代的做法。這個 skill 給你兩樣 prompt 給不了的東西。它在背景執行，所以你的 session 的 [context](https://www.aihero.dev/ai-coding-dictionary/context) 保持乾淨。而且 primary source 的限制和附引用檔案的產出每次都一樣，而不是取決於你怎麼寫 prompt。和 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)（執行框架）本身的 deep-research 模式相比，差別在於檔案和 primary source 規則，而不是搜尋。如果在小問題上，兩行 prompt 就能給你需要的東西，那就用兩行 prompt。

**它什麼時候停止閱讀？**

這個 skill 沒有停止條件。這表現為兩種看似相反、但原因相同的抱怨：agent 挖得太深，以及 agent 廣泛涵蓋一個主題卻漏掉了真正重要的那個細節。一位實務工作者這樣說：「deep-research skill 有時候有點太深了。而叫 agent 去研究，通常會漏掉關鍵細節。」你必須自己設定範圍。一個範圍窄、可以回答的問題（一個 API、一個行為、一個版本說法），結果會比「研究 X」好得多。

**`/wayfinder` 建立了 research ticket。我要自己處理它們嗎？**

不用，它現在會幫你觸發它們。在 v1.1 之後尚未發布的變更中，一個繪製地圖的 session 會為每張 research ticket 產生一個 `/research` subagent，並平行執行它們。每一個都把發現記錄在一個用完即丟的 `research/<name>` branch（分支）上，並從 ticket 留一個 [context pointer](https://www.aihero.dev/ai-coding-dictionary/context-pointer)（脈絡指標）指向它。research ticket 是 wayfinder「一個 session 一張 ticket」規則的唯一例外，因為它們是 [AFK](https://www.aihero.dev/ai-coding-dictionary/afk)（不需要人在場）的：沒有任何東西在等你。一個已知問題：之後刪除 branch 會讓 ticket 裡的 context pointer 失效。

## 運作正常的跡象 (It's working if)

- 你自己的 session 持續進行。如果你坐在那裡看它閱讀，代表委派沒有發生。
- 剛好出現一個新的背景任務。若出現第二個名稱幾乎一樣的任務，那就是巢狀 bug。
- 一份新的 Markdown 檔案出現在 repo 原本用來存放筆記的資料夾裡，而且 agent 會告訴你路徑。
- 裡面每個說法都附有連結，隨機點兩個，會連到官方文件、規格書或原始碼檔案本身，而不是某人對它的整理文章。
- 你光靠這份檔案就能做出原本卡住的決策，不必自己回頭去查來源。

## 它在流程中的位置 (Where it fits)

`research` 是一個隨時可用的獨立 skill。它為思考類的 skill 提供材料，不是建置鏈中的一個步驟。你要自己把它的檔案*帶進*流程裡。[grilling](https://aihero.dev/skills-grilling) 和 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 在已經掌握事實時會問出更犀利的問題，而 [to-spec](https://aihero.dev/skills-to-spec) 可以根據它來綜合整理。[wayfinder](https://aihero.dev/skills-wayfinder) 是唯一會直接呼叫它的 skill。它用一個 `/research` subagent 處理自己 map（地圖）上的每張 research ticket。完整的 skill 地圖請看 [ask-matt](https://aihero.dev/skills-ask-matt)。
