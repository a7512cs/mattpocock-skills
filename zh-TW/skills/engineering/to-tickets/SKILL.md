---
name: to-tickets
description: Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the configured tracker (edges as text in one file per ticket locally, or native blocking links on a real tracker).
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/to-tickets/SKILL.md)
>
> **description 中譯：** 把一份計畫、spec（規格）或目前的對話拆成一組 tracer bullet（曳光彈：先打通整條路徑的最小實作）式的 ticket（工作單），每個 ticket 都宣告它的 blocking edges（阻擋邊：哪些 ticket 必須先完成），並發布到已設定的 tracker（在本機時，edge 以文字形式寫在每個 ticket 各自的檔案裡；在真正的 tracker 上則用原生的阻擋連結）。

# To Tickets

把一份計畫、spec 或對話拆成一組 **tickets**：tracer bullet 式的 vertical slice（垂直切片），每個都宣告會 **block**（阻擋）它的那些 ticket。

Issue tracker（議題追蹤系統）和 triage（分類處理）label 詞彙應該已經提供給你了。如果沒有，告訴使用者執行 `/setup-matt-pocock-skills`。

## 流程 (Process)

### 1. 蒐集 context (Gather context)

從對話 context（上下文）中已經有的任何東西開始。如果使用者以引數形式傳入一個參照（spec 路徑、Issue 編號或 URL），就去抓取它，並讀它的完整內容和留言。

### 2. 探索 codebase（選擇性） (Explore the codebase (optional))

如果你還沒探索過 codebase（程式碼庫），就去探索，了解程式碼目前的狀態。ticket 的標題和描述應該使用專案領域 glossary（詞彙表）的詞彙，並尊重你正在修改的區域中的 ADR（架構決策紀錄）。

尋找 prefactor（預先重構）程式碼的機會，讓實作變得更容易。「先讓改變變得容易，再做那個容易的改變。」

### 3. 草擬 vertical slice (Draft vertical slices)

把工作拆成 **tracer bullet** ticket。

<vertical-slice-rules>

- 每個 slice 都切出一條窄但完整（COMPLETE）的路徑，穿過每一層（schema、API、UI、測試）：是垂直的，而不是（NOT）某一層的水平切片
- 一個完成的 slice 可以單獨展示或驗證
- 每個 slice 的大小要能放進單一個全新的 context window（上下文視窗）
- 任何 prefactoring 都應該先做

</vertical-slice-rules>

為每個 ticket 標出它的 **blocking edges**：在它能開始之前必須完成的其他 ticket。沒有 blocker 的 ticket 可以立刻開始。

**wide refactor（大範圍重構）是 vertical slicing 的例外。** **wide refactor** 是一個機械式的改變（重新命名一個欄位、改變一個共用符號的型別），它的 **blast radius**（爆炸半徑：影響範圍）會擴散到整個 codebase，所以一次編輯就會同時弄壞成千上萬個呼叫點，沒有任何 vertical slice 能以 green（測試全過）的狀態落地。不要硬把它塞進 tracer bullet；把它排成 **expand-contract**（先擴張、再收縮）的順序。首先 expand（擴張）：在舊形式旁邊加上新形式，讓什麼都不會壞。接著依 blast radius 決定批次大小（每個 package、每個目錄），分批把呼叫點遷移過去，每個批次都是自己的一張 ticket，被 expand 阻擋，而且因為舊形式仍然存在，每個批次之間 CI（持續整合）都保持 green。最後 contract（收縮）：一旦沒有任何呼叫者留下，就在一張被每個遷移批次阻擋的 ticket 中刪除舊形式。當連批次都無法單獨保持 green 時，保留這個順序，但讓它們共用一個 integration branch（整合分支），這些批次全都阻擋最後一張 integrate-and-verify（整合並驗證）ticket；只有在那裡才保證 green。

### 4. 考考使用者 (Quiz the user)

把提議的拆分以編號清單呈現。對每個 ticket，顯示：

- **標題 (Title)**：簡短的描述性名稱
- **Blocked by**（被誰阻擋）：哪些其他 ticket（如果有的話）必須先完成
- **交付什麼 (What it delivers)**：這個 ticket 讓哪個端到端的行為能運作

詢問使用者：

- 粒度感覺對嗎？（太粗 / 太細）
- blocking edges 正確嗎：每個 ticket 是不是只依賴那些真的會擋住它的 ticket？
- 有沒有哪些 ticket 應該合併，或再拆得更細？

反覆修改，直到使用者核可這個拆分。

### 5. 把 ticket 發布到已設定的 tracker (Publish the tickets to the configured tracker)

發布已核可的 ticket。**怎麼做**取決於 `/setup-matt-pocock-skills` 設定的 tracker；不論哪一種，ticket 都一樣，只有 blocking edges 的形狀會改變：

- **本機檔案** → 每個 ticket 寫一個檔案，放在 `.scratch/<feature-slug>/issues/<NN>-<slug>.md`，依相依順序從 `01` 開始編號（blocker 在前）。每個檔案的 "Blocked by" 列出它依賴的編號/標題。使用下面的單一 ticket 檔案範本：一個檔案一個 ticket，絕對不要做成單一個合併的檔案。
- **真正的 Issue tracker（GitHub、Linear、…）** → 依相依順序（blocker 在前）為每個 ticket 發布一個 Issue，讓每個 ticket 的 blocking edges 能參照真實的識別碼。平台有原生阻擋關係的地方就用它；否則把每個 ticket 的 "Blocked by" 設為阻擋它的那些 Issue。如果來源是一個現有的 Issue，就把每個 ticket 設為它的 sub-issue（tracker 文件中的操作）。除非另有指示，否則套用 `ready-for-agent` triage label；這些 ticket 在設計上就是 agent 可以直接拿去做的。

處理 **frontier**（前沿）：任何所有 blocker 都已完成的 ticket。對純線性的鏈來說，就是從上到下。

不要（NOT）關閉或修改任何 parent Issue。

<local-ticket-template>

# <NN>: <Ticket 標題>

**What to build:** 這個 ticket 讓哪個端到端的行為能運作，從使用者的角度描述，而不是一層一層的實作清單。

**Blocked by:** 擋住這個 ticket 的那些 ticket 的編號/標題，或 "None (can start immediately)"（無，可以立刻開始）。

**Status:** ready-for-agent

- [ ] 驗收條件 1
- [ ] 驗收條件 2

</local-ticket-template>

<issue-template>

## 上層 Issue (Parent)

tracker 上 parent Issue 的參照（如果來源是現有的 Issue 才放；否則省略這個區段）。

## 要做什麼 (What to build)

這個 ticket 讓哪個端到端的行為能運作，從使用者的角度描述，而不是一層一層的實作。

## 驗收條件 (Acceptance criteria)

- [ ] 條件 1
- [ ] 條件 2

## Blocked by

- 每個阻擋它的 ticket 的參照，或 "None (can start immediately)"（無，可以立刻開始）。當 blocker 已經設為原生 edge 時，省略這個區段。

</issue-template>

不論哪種形式，都要避免具體的檔案路徑或程式碼片段：它們很快就會過時。例外：如果某個 prototype（原型）產出了一段比文字更能精確表達某個決定的程式碼片段（狀態機、reducer、schema、型別形狀），就把它內嵌進去，並簡短註明它來自 prototype。修剪到只剩富含決定的部分：不是一個能運作的示範，只留重要的片段。
