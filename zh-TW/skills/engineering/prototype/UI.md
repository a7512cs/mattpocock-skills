> 繁體中文翻譯。原文：[UI.md](../../../../skills/engineering/prototype/UI.md)

# UI Prototype

在單一路由 (route) 上產生**幾個截然不同的 UI 變體**，從一個浮動的底部列切換。使用者在瀏覽器裡在變體之間切換，選出一個（或從每個裡面偷一點），然後把其餘的丟掉。

如果問題是關於邏輯/狀態，而不是某個東西看起來怎樣，這就是錯的分支。請用 [LOGIC.md](LOGIC.md)。

## 什麼時候適合用這個形狀 (When this is the right shape)

- 「這個頁面應該長什麼樣子？」
- 「在定案之前，我想先看看這個 dashboard 的幾個選項。」
- 「幫設定畫面試一個不同的版面。」
- 任何使用者本來會花上一整天，在腦中三個模糊的 mockup 之間做選擇的時候。

## 兩種子形狀：強烈偏好子形狀 A (Two sub-shapes: strongly prefer sub-shape A)

當 UI prototype（原型）**緊貼著 app 的其他部分**時，會容易評斷得多：真的 header、真的 sidebar、真的資料、真的資訊密度。單獨一個拋棄式路由就像真空：每個變體單獨看起來都不錯。只要有一個合理的現有頁面可以承載這些變體，就預設用子形狀 A。只有在 prototype 真的附近沒有家的時候，才動用子形狀 B。

### 子形狀 A：調整現有頁面（首選） (Sub-shape A: adjustment to an existing page (preferred))

路由已經存在。變體**在同一個路由上**渲染，用 `?variant=` 這個 URL search param（查詢參數）來切換。現有的資料抓取、參數和身分驗證全部保留。只有渲染的部分會替換。這是預設；除非有特定理由不這樣做，否則就選它。

如果 prototype 要做的東西還沒有頁面，但*自然會放在某個頁面裡面*（dashboard 的新區塊、設定畫面上的新卡片、現有流程中的新步驟），那它仍然是子形狀 A。把變體掛載在承載它的頁面裡面。

### 子形狀 B：新頁面（最後手段） (Sub-shape B: a new page (last resort))

只有在要原型化的東西真的沒有現有頁面可以放進去時才用這個（例如一個全新的頂層畫面，或一個無法合理嵌入任何地方的流程）。

依照專案現有的路由慣例（不管是哪一種），建立一個**拋棄式路由**。不要發明新的頂層結構。命名要讓人一看就知道是 prototype（例如在路徑或檔名中包含 `prototype` 這個字）。一樣使用 `?variant=` 模式。

在決定採用子形狀 B 之前，先確認一下：真的沒有任何現有頁面可以把它嵌進去嗎？空的路由會把設計問題藏起來，而一個塞滿內容的路由會讓它們暴露出來。

在兩種子形狀中，浮動底部列都完全相同。

## 流程 (Process)

### 1. 寫出問題並選定 N (State the question and pick N)

預設 **3 個變體**。超過 5 個就不再是截然不同，而是開始變成雜訊，所以上限設在 5。

用一行寫下計畫，寫在 prototype 所在的位置，或檔案最上方的註解裡：

> 「設定頁面的三個變體，透過 `?variant=` 切換，放在現有的 `/settings` 路由上。」

不論使用者是否在場、能不能提出異議，這樣做都行得通。

### 2. 產生截然不同的變體 (Generate radically different variants)

為每個變體寫草稿。每個都要符合：

- 這個頁面的目的，以及它能取用的資料。
- 專案的元件庫 / 樣式系統（TailwindCSS、shadcn、MUI、純 CSS，不管是什麼）。
- 一個清楚的 export 元件名稱，例如 `VariantA`、`VariantB`、`VariantC`。

變體必須**在結構上不同**：不同的版面、不同的資訊層次、不同的主要操作方式，不只是顏色不同。三個稍微調整過的卡片網格不是 UI prototype，那只是壁紙。如果有兩份草稿出來太相似，就加上明確的 "do not use a card grid"（不要用卡片網格）指示，重做其中一份。

### 3. 把它們接在一起 (Wire them together)

在路由上建立單一個切換器元件：

```tsx
// pseudo-code, adapt to the project's framework
const variant = searchParams.get('variant') ?? 'A';
return (
  <>
    {variant === 'A' && <VariantA {...data} />}
    {variant === 'B' && <VariantB {...data} />}
    {variant === 'C' && <VariantC {...data} />}
    <PrototypeSwitcher variants={['A','B','C']} current={variant} />
  </>
);
```

子形狀 A（現有頁面）：把所有現有的資料抓取保留在切換器上方；每個變體只改變被渲染的子樹。

子形狀 B（新頁面）：在 `/prototype/<name>` 底下的拋棄式路由掛載同一個切換器。

### 4. 建立浮動切換器 (Build the floating switcher)

一個固定在螢幕底部中央的小列，由三個部分組成：

- **左箭頭**：循環切到上一個變體（到頭會繞回去）。
- **變體標籤**：顯示目前的變體代號，如果該變體有 export 一個名稱，也一併顯示那個名稱。例如 `B (Sidebar layout)`。
- **右箭頭**：往前循環（到頭會繞回去）。

行為：

- 點箭頭會更新 URL search param（使用框架的 router，例如 Next 的 `router.replace`、React Router 的 `navigate` 等等），讓變體可以分享，重新載入後也維持不變。
- 鍵盤：`←` 和 `→` 方向鍵也能循環切換。當 `<input>`、`<textarea>` 或 `[contenteditable]` 取得焦點時，不要攔截方向鍵。
- 在視覺上和頁面區隔開來（例如高對比的膠囊形狀、淡淡的陰影），讓人一看就知道它不屬於正在評估的設計。
- 在 production build 中隱藏：用 `process.env.NODE_ENV !== 'production'` 或等效的檢查來控制，這樣就算一個 prototype 不小心被 merge（合併）進去，也不會把這個列送到使用者面前。

把切換器放在單一個共用元件裡，讓兩種子形狀都能重複使用。把它放在專案裡放共用 UI 的地方。

### 5. 交給對方 (Hand it over)

把 URL（以及 `?variant=` 的代號）提供出來。使用者有空時會切換瀏覽。有趣的回饋通常是「**我想要 B 的 header 配上 C 的 sidebar**」，那才是他們真正想要的設計。

### 6. 保存答案並清理 (Capture the answer and clean up)

一旦某個變體勝出，就保存答案（哪個變體，以及為什麼），然後依照 [SKILL](SKILL.md) 描述的方式保存 prototype。把勝出者併入真正的程式碼，其餘的移到拋棄式 branch（git 分支）上，不要放進 main：

- **子形狀 A**：把勝出者併入現有頁面；從 main 移除落選的變體和切換器。
- **子形狀 B**：把勝出的變體升級成真正的路由；從 main 移除拋棄式路由和切換器。

完整的變體集合就是 primary source（第一手資料），所以它要放到拋棄式 branch 上，而不是丟進垃圾桶，因為留在 main branch 裡的變體元件和切換器很快就會腐爛，並讓下一個讀者困惑。

## 反模式 (Anti-patterns)

- **只有顏色或文案不同的變體。** 那是微調，不是 prototype。真正的變體在結構上有不同主張。
- **變體之間共用太多程式碼。** 共用一個 `<Header>` 沒問題；共用一個 `<Layout>` 就失去意義了。每個變體都應該可以自由丟掉原本的版面。
- **把變體接到真正的寫入操作 (mutation)。** 唯讀的 prototype 沒問題。如果某個變體需要寫入，就把它指向一個 stub：問題是「這個應該長什麼樣子」，而不是「後端能不能運作」。
- **把 prototype 直接升級到正式環境。** 變體程式碼是在 prototype 的限制下寫的（沒有測試、極少的錯誤處理）。把它併入時要好好重寫。
