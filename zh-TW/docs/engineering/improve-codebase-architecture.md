> 繁體中文翻譯。原文：[improve-codebase-architecture.md](../../../docs/engineering/improve-codebase-architecture.md)

## 它做什麼 (What it does)

`improve-codebase-architecture` 會勘查一個 codebase（程式碼庫），尋找 **deepening opportunities**（加深機會）。在這些地方，一個 shallow module（淺模組：它的 interface 介面幾乎和它所隱藏的東西一樣複雜）可以變成 deep module（深模組）。它把這些寫成一份自足的 HTML 報告，然後針對你挑的那一個，對你進行 [grills](https://www.aihero.dev/ai-coding-dictionary/grilling)（拷問式提問）。

它從不修改程式碼。整次執行只產出一段對話，以及你作業系統暫存目錄中的一個 HTML 檔。refactor（重構）是你之後在另一個 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段）中，透過一般的建構流程去做的。這讓它成為一個勘查工具，而不是 refactor 工具，所以你可以在一個還沒準備好要動的 codebase 上執行它。

有兩道過濾，讓報告不會變成泛泛的清理建議。第一，每個候選都必須通過 **deletion test**（刪除測試）：如果你移除這個 module，它的複雜度會移到一個更小的 interface 後面，還是會散布到各個呼叫端？只有第一種情況會得到一張卡片。第二，除非你把它指向特定區域，否則它會先讀最近的 commit（提交）歷史，並把掃描集中在經常變動的路徑上。在沒有人會碰的程式碼上做加深，是一個永遠回不了本的 refactor。

## 什麼時候用它 (When to reach for it)

你要輸入 `/improve-codebase-architecture` 來呼叫它；[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（代理）不會自己去用它。

它不是主要建構迴圈中的一個步驟。你定期執行它，把更多改善 codebase 的工作排進佇列。大家會在四種情況下使用它：

| 情況 | 怎麼使用 |
| --- | --- |
| 例行維護 | 每隔幾天，或有空檔時執行它，讓結構不會在一個個功能之間逐漸腐化。 |
| 大型建構之前 | 把它指向 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格），然後問「我們要怎麼讓這個變更變容易？」這是對它最有效的 prompt（提示詞）。 |
| 既有專案（brownfield）稽核 | 在一個大型、沒有結構，或是 [vibe-coded](https://www.aihero.dev/ai-coding-dictionary/vibe-coding)（憑感覺讓 AI 寫出來的）repo（儲存庫）上執行它，看看它是什麼狀態。 |
| 舊程式碼的測試工作 | 在你對無法測試的程式碼寫測試之前，用它找出缺少的 seams（接縫：可以觀察行為的公開邊界）。 |

它容易和相似 skill（技能）搞混的地方：

- 要設計一個你已經選定的 module，用 [codebase-design](https://aihero.dev/skills-codebase-design)。這個 skill 負責找出要處理的 module，而 `codebase-design` 才是你設計它的地方。
- 對於一個大到一個 session 裝不下的整體工作，用 [wayfinder](https://aihero.dev/skills-wayfinder)。
- 對於「這個特定的東西壞了」，用 [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs)。當真正的發現是沒有好的 seam 能把 bug 鎖住時，它會把你送回這裡。

## 前置條件 (Prerequisites)

執行它不需要任何前置條件。如果 `GLOSSARY.md` 或 `docs/adr/` 中的 ADR（架構決策紀錄）存在，它會讀取它們，並使用你領域自己的名詞。這樣一來，候選讀起來就會是「加深 Order intake module」，而不是「refactor FooBarHandler」。

它會寫入兩個地方。報告寫到 repo 外面的 `<tmpdir>/architecture-review-<timestamp>.html`。在 grilling 迴圈中，它會在 `GLOSSARY.md` 新增或磨利用詞，如果那個檔案不存在就建立它。它也會提議把被否決的候選記錄成一份 ADR，讓之後的執行不會再建議它。

## Depth，以及搜尋它的報告 (Depth, and the report that hunts for it)

這個 skill 建立在一個概念上：**depth**（深度）。deep module 把大量行為放在一個小而穩定的 interface 後面。shallow module 則透過一個幾乎和底下程式碼一樣寬的 interface，暴露它的 implementation（實作）。報告會尋找三種形式的淺：

- 只為了可測試性而抽出來的純函式，而真正的 bug 出在呼叫端怎麼使用它們（沒有 **locality**（局部性：相關的東西集中在一處））。
- 跨越自己的 **seams** 而洩漏出去的 modules。
- 一個不打開五個檔案就無法理解的概念。

針對每一種，它會提出能修正它的加深做法。

每個候選都是一張卡片，包含相關的檔案、摩擦點、一個用白話英文寫的解法、以 **locality** 和 **leverage**（槓桿：用小 interface 換到大量行為）來說明的好處、一張 before/after 圖，以及一個強度標章。

| 標章 | 對你的意義 |
| --- | --- |
| `Strong` | 明確通過 deletion test，而且摩擦是真實的。要認真看待這些。 |
| `Worth exploring` | 合理的加深，但回報取決於程式碼接下來往哪裡發展。 |
| `Speculative` | 為了完整性而列入。這些大多可以忽略。 |

報告最後是一個 **Top recommendation**（首要建議），也就是它會最先做的那個候選。然後 skill 會停下來，問你想探索哪個候選。在那個時間點，你什麼都還沒決定，也沒有任何程式碼被改動。

## 你挑了一個之後會發生什麼 (What happens after you pick one)

當你挑了一個候選，就會針對它開始一個 [grilling](https://aihero.dev/skills-grilling) session。內容涵蓋限制條件、什麼東西要放到 seam 後面、哪些測試會留下來，以及加深後的 interface 應該長什麼樣子。那個 session 的產出是一個決策，而不是一份 diff（差異）。從那之後就套用一般流程：把決策帶進 [to-spec](https://aihero.dev/skills-to-spec)，然後 [to-tickets](https://aihero.dev/skills-to-tickets)，然後 [implement](https://aihero.dev/skills-implement)。

## 常見問題 (Common questions)

**它針對一個想法拷問了我一個小時，而不是給我看選項。我可以關掉這個嗎？**

可以。呼叫它時就說出來（「不要拷問我，只要給我看報告」）。這是對這個 skill 最常見的抱怨。有一位使用者原本喜歡它，認為它是「取得完整改善分析的方便方法」，但在加入 grilling 迴圈後，覺得它「幾乎沒辦法用」。在他們的 session 中，它只提出一個解法，然後問了「幾十甚至幾百個問題」。設計的本意是報告先出來，grilling 只在你選定的候選上開始。但比較弱的 [models](https://www.aihero.dev/ai-coding-dictionary/model)（模型）會直接跳到針對它們想到的第一個點子的訪談。在那個討論串中，結果因 model 不同而差異很大。這是一個尚未關閉的 issue（議題），而且這個 skill 目前還沒有文件記載的不拷問模式。

**報告打開後是沒有樣式的原始 HTML，也沒有圖。發生了什麼事？**

報告從 CDN 載入 Tailwind 和 Mermaid，所以你打開它時需要網路連線。如果有東西擋住這些腳本，頁面就會壞掉，而且不會有任何錯誤訊息。在被回報的案例中，一個資安 hook 要求 SRI 雜湊。agent 加上了這些雜湊，但 CDN 送給瀏覽器的位元組，和送給計算雜湊的那個 `curl` 的不一樣，所以瀏覽器擋下了腳本。離線和受鎖定的環境也有同樣的問題。agent 看不到這個問題，因為它從不渲染這個頁面。變通方法是要求改用 inline CSS 和手工製作的 SVG 圖，而不是 CDN 的設定。這是一個尚未關閉的 issue。

**它給了我十二個候選。我要在同一個 session 中逐一處理，還是開一個新的？**

每個 session 處理一個候選。如果你在一段對話中處理好幾個，[context window](https://www.aihero.dev/ai-coding-dictionary/context-window)（上下文視窗）會同時塞滿報告、grilling、domain model（領域模型）的修改以及程式碼變更。報告只是一個暫存檔，所以往下帶的是候選本身，而不是檔案。挑一個，grill 它，然後把決策帶進 `/to-spec`。把其餘的轉成 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（工作單），之後可以分別處理。把選定的改善寫進 spec，而不是直接進入實作。大家常問這個問題，而這個 skill 本身沒有記載任何對應的工作流程。

**我該怎麼對它下 prompt？**

用你接下來要建構的東西當 prompt。如果有大型建構即將開始，把它指向 spec，然後問「我們要怎麼讓這個變更變容易？」沒有 prompt 的執行會自己去找熱點。這對例行維護來說沒問題，但給一個方向能讓報告變得可以付諸行動。

**它在大型舊有 codebase 上有用嗎？**

部分有用。它在缺乏一致結構的大型既有 codebase 上效果很好，而且在任何一次性的結構整理之後，它都是建議使用的維護工具。但專案已經失控的使用者回報它「幫了一點，但似乎還是不夠」。有一位維護八年舊 codebase 的開發者回報，model 一直在原地打轉，雖然同一個 skill 在整齊的 repo 上能產出清楚的圖。針對那種情況，目前還沒有專門的 `/refactor` skill。如果 codebase 沒有共享的詞彙，先執行 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 建立一套。這通常會讓這個 skill 的產出好很多。

**這和 `/codebase-design` 有什麼不同？**

`/codebase-design` 是一份參考，而不是 session 的驅動者。它提供詞彙（module、interface、depth、seam、adapter（轉接器）、leverage、locality），這個 skill 則使用這些詞彙。如果你把 `/codebase-design` 當成任務交給一個全新的 agent，它會以一種已知的方式失敗。它自己沒有可依循的流程，所以 agent 會自己發明一個，重新探索程式碼，並在問你任何問題之前跑上非常久。執行這個 skill，讓它去使用那一個。

**它會不會告訴我 codebase 沒問題？**

很少，所以開始之前要先知道這一點。這個 skill 存在的目的是產出發現，所以它傾向產出候選，而不是下結論說沒有任何問題。用強度標章來修正這個傾向。如果一份報告中的每個候選都是 `Speculative`，就代表這個 skill 什麼都沒找到。

**它在 Codex 或其他 harness（執行 agent 的外殼程式，例如 Claude Code）中能用嗎？**

部分可以。探索步驟直接點名 Claude Code 的 `Agent` 工具搭配 `subagent_type=Explore`。沒有那個工具的 [harness](https://www.aihero.dev/ai-coding-dictionary/harness) 可能會跳過平行探索，而不是用它自己的對等工具。skill 仍然會執行，但掃描沒那麼徹底。有人提議了一個不綁定特定 harness 的改寫版本，但還沒有被 merge（合併）。

**我到底要怎麼在 TypeScript 中實作 deep modules？**

這個 skill 沒有附上好的答案。大家常要求一份 `TYPESCRIPT.md`，把這些原則對應到具體的檔案和 module 配置，但它並不存在。skill 會告訴你加深該放在哪裡，以及什麼東西要放到 seam 後面。你必須自己把它轉成套件或目錄結構。

## 運作正常的跡象 (It's working if)

- 候選使用的是你領域中的概念名稱，而不是捏造出來的類別名稱：「Order intake module」，而不是「FooBarHandler」。
- 候選位在你最近編輯過的檔案中，而不是 repo 裡沒人碰的部分。
- 執行期間沒有任何程式碼被修改。唯一的新檔案是你暫存目錄中的 HTML 報告。
- 它在報告之後停下來，問你要哪一個候選。它不會自己繼續。
- 每張卡片都用 locality 或 leverage 來說明回報，並說出哪些測試會變簡單，而不只是「這樣比較乾淨」。
- 當你基於一個長期成立的理由否決某個候選時，它會提議記錄一份 ADR，讓下次執行不會再建議它。

## 它在流程中的位置 (Where it fits)

`improve-codebase-architecture` 是**定期維護**。你每隔幾天在任何流程鏈之外執行它，用來把工作排進佇列，而不是去做那些工作。和它相鄰的有：

- [codebase-design](https://aihero.dev/skills-codebase-design) 掌管每個候選都會用到的 depth 與 seam 詞彙。
- [grilling](https://aihero.dev/skills-grilling) 在你選定候選後，走過整棵決策樹。
- [domain-modeling](https://aihero.dev/skills-domain-modeling) 在你做決策的同時，讓 `GLOSSARY.md` 和 ADR 保持最新。

它的產出是一個想法，這個想法會在 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 或 [to-spec](https://aihero.dev/skills-to-spec) 回到主要建構流程。它在主要流程末端的對應者是 [retro](https://aihero.dev/skills-retro)。這個 skill 改善 agent 工作所在的程式碼，而 `retro` 則在一次建構之後，改善程式碼周圍的環境（檢查、標準、引導 agent 的設定檔）。至於哪個 skill 適合某個情況，[ask-matt](https://aihero.dev/skills-ask-matt) 是涵蓋整套 skill 的路由器。
