> 繁體中文翻譯。原文：[HTML-REPORT.md](../../../../skills/engineering/improve-codebase-architecture/HTML-REPORT.md)

# HTML 報告格式 (HTML Report Format)

架構審查會被渲染成作業系統暫存目錄裡的單一個自足 HTML 檔。Tailwind 和 Mermaid 都從 CDN 載入。Mermaid 能可靠地處理圖形狀的圖表；手工打造的 div 和 inline SVG 則處理更有編輯感的視覺（量體圖、剖面圖）。兩者混用：不要什麼都靠 Mermaid，不然看起來會開始很制式。

## 骨架 (Scaffold)

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review for {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* small custom layer for things Tailwind doesn't cover cleanly:
         dashed seam lines, hand-drawn-feeling arrow heads, etc. */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## 頁首 (Header)

Repo（儲存庫）名稱、日期，以及一個精簡的圖例：實線框 = module（模組）、虛線 = seam（接縫）、紅色箭頭 = 洩漏、粗的深色框 = deep module（深模組）。不要有介紹段落。直接進入候選。

## 候選卡片 (Candidate card)

圖表承擔主要份量。文字要少、要白話，並且不拘形式地使用 glossary（詞彙表）術語（來自 `/codebase-design` skill（技能））。

每個候選是一個 `<article>`：

- **Title**（標題）：簡短，說出這個深化的名字（例如 "Collapse the Order intake pipeline"（收合 Order intake 管線））。
- **Badge row**（徽章列）：建議強度（`Strong` = emerald、`Worth exploring` = amber、`Speculative` = slate），再加上一個依賴類別的標籤（`in-process`、`local-substitutable`、`ports & adapters`、`mock`）。
- **Files**（檔案）：等寬字體的清單，`font-mono text-sm`。
- **Before / After diagram**（前後對照圖）：重頭戲。兩欄，並排。見下面的模式。
- **Problem**（問題）：一句話。痛在哪裡。
- **Solution**（解法）：一句話。改變什麼。
- **Wins**（收穫）：條列，每條 ≤6 個單字。例如 "Tests hit one interface"（測試只打一個 interface）、"Pricing logic stops leaking"（定價邏輯不再洩漏）、"Delete 4 shallow wrappers"（刪掉 4 個 shallow wrapper）。
- **ADR callout**（ADR 提示框，如果適用）：琥珀色底色框裡的一行字。

不要寫解釋性的段落。如果圖表需要一段文字才能看懂，就重畫圖表。

## 圖表模式 (Diagram patterns)

挑選適合這個候選的模式。混著用。不要讓每張圖看起來都一樣。多樣性本身就是重點之一。

### Mermaid 圖：處理依賴 / 呼叫流程的主力 (Mermaid graph (the workhorse for dependencies / call flow))

當重點是「X 呼叫 Y 呼叫 Z，看看這團亂」時，用 Mermaid 的 `flowchart` 或 `graph`。把它包在一張 Tailwind 樣式的卡片裡，讓它不會像是空降進來的。用 classDef 把洩漏的邊塗成紅色、把 deep module 塗成深色。序列圖很適合「之前：6 次往返；之後：1 次」。

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### 手工打造的方框與箭頭：當 Mermaid 的排版跟你作對時 (Hand-built boxes-and-arrows (when Mermaid's layout fights you))

把 module 做成帶有邊框和標籤的 `<div>`。箭頭用 inline SVG 的 `<line>` 或 `<path>` 元素，絕對定位在一個相對定位的容器上。當你想讓「之後」的圖感覺像一個粗邊框的 deep module、裡面的內部構造呈現灰色時，就用這種方式，因為 Mermaid 無法用對的份量渲染出那種效果。

### 剖面圖：適合層層堆疊的 shallow (Cross-section (good for layered shallowness))

堆疊水平的色帶（`h-12 border-l-4`）來呈現一次呼叫會穿過的各層。之前：6 個薄薄的層，每層都沒做事。之後：1 條粗色帶，標上整合後的職責。

### 量體圖：適合「interface 跟 implementation 一樣寬」 (Mass diagram (good for "interface as wide as implementation"))

每個 module 兩個長方形：一個代表 interface（介面）的表面積，一個代表 implementation（實作）。之前：interface 長方形幾乎和 implementation 長方形一樣高（shallow，淺）。之後：interface 長方形很矮，implementation 長方形很高（deep，深）。

### 呼叫圖收合 (Call-graph collapse)

之前：一棵函式呼叫樹，渲染成巢狀的方框。之後：同一棵樹收合成一個方框，現在變成內部的呼叫以淡化的方式顯示在裡面。

## 樣式指引 (Style guidance)

- 偏向編輯風格，不要企業儀表板風格。大量留白。標題可以選用襯線字體（`font-serif` 搭配 stone/slate 效果很好）。
- 節制地用色：一個強調色（emerald 或 indigo），加上紅色表示洩漏、琥珀色表示警告。
- 圖表高度維持在約 320px，讓前後對照能舒服地並排，不需要捲動。
- 圖表內的 module 標籤使用 `text-xs uppercase tracking-wider`，讓它們讀起來像示意圖，而不像 UI。
- 唯一的 script 是 Tailwind CDN 和 Mermaid ESM import。除此之外報告是靜態的：沒有應用程式碼，除了 Mermaid 自己的渲染之外沒有任何互動。

## 首要建議段落 (Top recommendation section)

一張較大的卡片。候選名稱、一句話說明原因、一個指向它卡片的錨點連結。就這樣。

## 語氣 (Tone)

淺白的英文、精簡，但架構上的名詞和動詞要直接來自 `/codebase-design` skill。精簡不是漂移的藉口。

**精確使用：** module、interface、implementation、depth（深度）、deep、shallow、seam、adapter（轉接器）、leverage（槓桿）、locality（局部性）。

**絕不用這些替代：** component、service、unit（替代 module）· API、signature（替代 interface）· boundary（替代 seam）· layer、wrapper（替代 module，當你指的是 module 時）。

**符合這種風格的說法：**

- "Order intake module is shallow: interface nearly matches the implementation."（Order intake module 是 shallow 的：interface 幾乎等同於 implementation。）
- "Pricing leaks across the seam."（Pricing 跨過 seam 洩漏。）
- "Deepen: one interface, one place to test."（深化：一個 interface，一個測試的地方。）
- "Two adapters justify the seam: HTTP in prod, in-memory in tests."（兩個 adapter 證明了這個 seam 的必要：正式環境用 HTTP，測試用記憶體內的。）

**Wins 條列**用 glossary 術語說出收穫：*"locality: bugs concentrate in one module"*（locality：bug 集中在一個 module）、*"leverage: one interface, N call sites"*（leverage：一個 interface，N 個呼叫點）、*"interface shrinks; implementation absorbs the wrappers"*（interface 縮小；implementation 吸收那些 wrapper）。不要寫 *"easier to maintain"*（更容易維護）或 *"cleaner code"*（更乾淨的程式碼），因為這些用語不在 glossary 裡，沒資格佔一個位置。

不要含糊其辭，不要清喉嚨式的開場，不要 "it's worth noting that…"（值得注意的是…）。如果一句話可以變成一個條列點，就把它變成條列點。如果一個條列點可以刪，就刪掉。如果某個用語不在 `/codebase-design` 的 glossary 裡，在發明新用語之前，先找一個在 glossary 裡的。
