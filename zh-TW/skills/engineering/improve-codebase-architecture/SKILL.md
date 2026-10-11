---
name: improve-codebase-architecture
description: Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick.
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/improve-codebase-architecture/SKILL.md)
>
> **description 中譯：** 掃描 codebase（程式碼庫）找出 deepening opportunities（深化機會），把它們呈現成一份視覺化的 HTML 報告，然後針對你挑中的那一個進行 grilling（拷問式訪談）。

# Improve Codebase Architecture

找出架構上的摩擦點，並提出 **deepening opportunities**：把 shallow module（淺模組）變成 deep module（深模組）的 refactor（重構）。目標是可測試性和 AI 可導覽性。

這個指令以專案的 domain model（領域模型）為*依據*，並建立在一套共同的設計詞彙上：

- 用 "codebase-design" 呼叫 Skill 工具，取得架構詞彙：**module**（模組）、**interface**（介面）、**depth**（深度）、**seam**（接縫）、**adapter**（轉接器）、**leverage**（槓桿）、**locality**（局部性），以及它的原則：the deletion test（刪除測試）、"the interface is the test surface"（interface 就是測試面）、"one adapter = hypothetical seam, two = real"（一個 adapter = 假想的 seam，兩個 = 真的 seam）。每個建議都要精確使用這些術語，不要漂移成 "component"、"service"、"API" 或 "boundary"。
- `GLOSSARY.md` 裡的領域語言為好的 seam 命名；`docs/adr/` 裡的 ADR（架構決策紀錄）記錄了這個指令不應該重新爭論的決定。

## 流程 (Process)

### 1. 探索 (Explore)

**掃描之前先界定範圍：YAGNI**。深化一個 module 的回報，是讓它未來的改動變得更容易，所以要特別看重 codebase 中最近有變動的部分。在看之前，先決定要看*哪裡*：

- 如果使用者指定了方向（一個 module、一個子系統、一個痛點），就照著走，並跳過下面的推斷。
- 否則，往回看一大段 commit（提交）歷史（`git log --oneline`），找出 codebase 的熱點，也就是一直反覆出現的檔案和區域，讓這些路徑先吸引你的注意力。如果改動很分散、沒有明顯的熱點，就把網撒大一點。

先讀專案的領域 glossary（詞彙表，即 `GLOSSARY.md`），以及你要碰的區域裡的所有 ADR。

然後啟動一個 sub-agent（子代理）去走遍 codebase。不要遵循死板的經驗法則；自然地探索，並記下你在哪裡感到摩擦：

- 哪裡要理解一個概念，就得在許多小 module 之間跳來跳去？
- 哪裡的 module 是 **shallow** 的，interface 幾乎跟 implementation（實作）一樣複雜？
- 哪裡為了可測試性而抽出了純函式，但真正的 bug 卻藏在它們被呼叫的方式裡（沒有 **locality**）？
- 哪裡有緊密耦合的 module 跨過它們的 seam 洩漏出去？
- codebase 的哪些部分沒有測試，或很難透過目前的 interface 測試？

對任何你懷疑是 shallow 的東西套用 **deletion test**：刪掉它會讓複雜度集中，還是只是把它移到別處？"yes, concentrates"（是，會集中）就是你要找的訊號。

### 2. 以 HTML 報告呈現候選 (Present candidates as an HTML report)

把一個自足的 HTML 檔寫到作業系統的暫存目錄，這樣就不會有任何東西落進 repo（儲存庫）。從 `$TMPDIR` 解析暫存目錄，退而求其次用 `/tmp`（Windows 上用 `%TEMP%`），並寫到 `<tmpdir>/architecture-review-<timestamp>.html`，讓每次執行都得到一個新檔案。幫使用者打開它（Linux 上用 `xdg-open <path>`、macOS 上用 `open <path>`、Windows 上用 `start <path>`），並告訴他們絕對路徑。

報告使用 **透過 CDN 載入的 Tailwind** 來排版和設定樣式，並在圖形 / 流程 / 序列能可靠傳達結構的地方，使用 **透過 CDN 載入的 Mermaid** 來畫圖表。把 Mermaid 和手工打造的 CSS/SVG 視覺混著用：當關係是圖形狀的（呼叫圖、依賴、序列）時用 Mermaid；當你想要更有編輯感的東西時（量體圖、剖面圖、收合動畫），就用手工打造的 div/SVG。每個候選都有一個**前 / 後對照的視覺化**。要多用視覺呈現。

對每個候選，渲染一張卡片，包含：

- **Files**（檔案）：牽涉到哪些檔案 / module
- **Problem**（問題）：為什麼目前的架構造成摩擦
- **Solution**（解法）：用淺白的英文描述會改變什麼
- **Benefits**（好處）：用 locality 和 leverage 來解釋，以及測試會如何改善
- **Before / After diagram**（前後對照圖）：並排、客製繪製，呈現 shallow 的狀況和深化後的樣子
- **Recommendation strength**（建議強度）：`Strong`、`Worth exploring`、`Speculative` 其中之一，以徽章的形式呈現

報告最後放一個 **Top recommendation**（首要建議）段落：你會先處理哪個候選，以及為什麼。

**領域的部分使用 GLOSSARY.md 的詞彙，架構的部分使用 `/codebase-design` 的詞彙**。如果 `GLOSSARY.md` 定義了 "Order"，就說 "the Order intake module"，不要說 "the FooBarHandler"，也不要說 "the Order service"。

**ADR 衝突**：如果某個候選跟既有的 ADR 矛盾，只有在摩擦真實到值得重新檢視那份 ADR 時才提出來。在卡片上清楚標示（例如一個警告提示框：_"contradicts ADR-0007, but worth reopening because…"_（與 ADR-0007 矛盾，但值得重新討論，因為…））。不要列出每一個被 ADR 禁止的理論上的 refactor。

完整的 HTML 骨架、圖表模式和樣式指引，見 [HTML-REPORT.md](HTML-REPORT.md)。

現在還**不要**提出 interface。檔案寫好之後，問使用者："Which of these would you like to explore?"（你想深入探索其中哪一個？）

### 3. Grilling 迴圈 (Grilling loop)

一旦使用者挑了一個候選，就用 "grilling" 呼叫 Skill 工具，和他們一起走過決策樹：限制條件、依賴、深化後 module 的形狀、seam 後面放什麼、哪些測試會留下來。

副作用會在決策成形時就地發生；用 "domain-modeling" 呼叫 Skill 工具，讓 domain model 一路保持最新：

- **要用一個不在 `GLOSSARY.md` 裡的概念來命名深化後的 module？** 把這個用語加進 `GLOSSARY.md`。如果檔案不存在，就延遲建立它。
- **在對話中把一個模糊的用語磨利了？** 當下就更新 `GLOSSARY.md`。
- **使用者以一個關鍵的理由否決了這個候選？** 提議建立一份 ADR，措辭是：_"Want me to record this as an ADR so future architecture reviews don't re-suggest it?"_（要我把這個記錄成一份 ADR，讓未來的架構審查不會再次建議它嗎？）只有在未來的探索者確實需要這個理由、才能避免再次建議同一件事時才提議；跳過短暫性的理由（「現在不值得做」）和不言自明的理由。
- **想為深化後的 module 探索替代的 interface？** 用 "codebase-design" 呼叫 Skill 工具，並使用它的 design-it-twice 平行 sub-agent 模式。
