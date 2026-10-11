> 繁體中文翻譯。原文：[DESIGN-IT-TWICE.md](../../../../skills/engineering/codebase-design/DESIGN-IT-TWICE.md)

# 設計兩次 (Design It Twice)

當使用者想為選定的深化候選探索替代的 interface（介面）時，使用這個平行 sub-agent（子代理）模式。根據 Ousterhout 的 "Design It Twice"（設計兩次）：你的第一個點子不太可能是最好的。

使用 [SKILL.md](SKILL.md) 裡的詞彙：**module**（模組）、**interface**、**seam**（接縫）、**adapter**（轉接器）、**leverage**（槓桿）。

## 流程 (Process)

### 1. 框定問題空間 (Frame the problem space)

在啟動 sub-agent 之前，先為選定的候選寫一段給使用者看的問題空間說明：

- 任何新的 interface 都必須滿足的限制條件
- 它會依賴哪些東西，以及這些依賴屬於哪一類（見 [DEEPENING.md](DEEPENING.md)）
- 一段粗略的示意程式碼草稿，用來讓限制條件有個依據，它不是提案，只是讓限制條件具體化的一種方式

把這段給使用者看，然後立刻進行步驟 2。使用者在 sub-agent 平行工作的同時閱讀和思考。

### 2. 啟動 sub-agent (Spawn sub-agents)

平行啟動 3 個以上的 sub-agent。每一個都必須為深化後的 module 產出一個**截然不同**的 interface。

給每個 sub-agent 一份各自獨立的技術說明（檔案路徑、耦合細節、[DEEPENING.md](DEEPENING.md) 裡的依賴類別、seam 後面放了什麼）。這份說明和步驟 1 給使用者看的問題空間說明是分開的。給每個 agent（代理）不同的設計限制：

- Agent 1："Minimize the interface: aim for 1-3 entry points max. Maximise leverage per entry point."（把 interface 縮到最小：最多 1 到 3 個進入點。讓每個進入點的 leverage 最大化。）
- Agent 2："Maximise flexibility: support many use cases and extension."（把彈性最大化：支援多種使用情境和擴充。）
- Agent 3："Optimise for the most common caller: make the default case trivial."（為最常見的呼叫端最佳化：讓預設情況變得極其簡單。）
- Agent 4（如果適用）："Design around ports & adapters for cross-seam dependencies."（針對跨 seam 的依賴，圍繞 ports & adapters 來設計。）

在說明裡同時放進 [SKILL.md](SKILL.md) 的詞彙和 GLOSSARY.md 的詞彙，讓每個 sub-agent 命名時都和架構語言以及專案的領域語言一致。

每個 sub-agent 輸出：

1. Interface（型別、method、參數，再加上不變條件、順序、錯誤模式）
2. 示範呼叫端如何使用它的使用範例
3. implementation（實作）在 seam 後面藏了什麼
4. 依賴策略與 adapter（見 [DEEPENING.md](DEEPENING.md)）
5. 取捨：哪裡 leverage 高，哪裡薄弱

### 3. 呈現並比較 (Present and compare)

依序呈現各個設計，讓使用者能一個一個消化，然後用文字比較它們。從 **depth**（深度，即 interface 上的 leverage）、**locality**（局部性，即改動集中在哪裡）和 **seam 的位置**來對照。

比較完之後，給出你自己的建議：你認為哪個設計最強，以及為什麼。如果不同設計的元素組合起來效果會很好，就提出一個混合版。要有主見：使用者要的是明確的判斷，不是一份選單。
