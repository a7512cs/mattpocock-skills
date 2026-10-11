---
name: ask-matt
description: Ask which skill or flow fits your situation. A router over the skills in this repo.
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/ask-matt/SKILL.md)
>
> **description 中譯：** 問問看哪個 skill（技能）或 flow（流程）適合你的情況。這是本 repo（儲存庫）所有 skill 的路由器。

# Ask Matt

你不會記得每一個 skill，所以就問吧。

在說明某個 skill 做什麼、或建議跳過某個步驟之前，先讀那個 skill 的 SKILL.md：這裡的摘要只是用來幫你找方向。

**flow** 是穿過這些 skill 的一條路徑。大部分路徑都沿著一條 **main flow**（主流程）走，另有兩條 **on-ramps**（匝道）匯入它。其他的不是獨立使用，就是在底下運作的詞彙層。

## 主流程：點子 → 上線 (The main flow: idea → ship)

大部分工作走的路線。你有一個點子，想把它做出來。

1. **`/grill-with-docs`** 透過訪談把點子磨利。只要你是**在一個工作目錄裡工作**，就從這裡開始：它是有狀態的，會把學到的東西保留在 `GLOSSARY.md` 和 ADR（架構決策紀錄）裡。（沒有工作目錄？改用 `/grill-me`，見 Standalone 一節。兩者跑的是同一個 `/grilling` 基本元件；`grill-with-docs` 是會留下書面紀錄的那個，所以只要有 repo 可以留下紀錄，它就是兩者中比較好的選擇。）
2. **分岔：你能在對話中解決每一個問題嗎？** 如果某個問題需要一個可執行的答案（狀態、商業邏輯、一個你必須親眼看到的 UI），就繞道去做 prototype（原型），兩個方向都用 **`/handoff`**（交接）銜接（prototype 住在它自己的目錄裡，這正是 `/handoff` 的用途；見 Phase boundaries 一節）：
   - 先 **`/handoff`** 出去，然後針對那個檔案開一個全新的 session（工作階段），
   - 用 **`/prototype`** 以用完即丟的程式碼回答這個問題，
   - 再把學到的東西 **`/handoff`** 回來，並在原本的點子討論串中引用它。
3. **分岔：這是需要跨多個 session 的建置嗎？**
   - **是** → **`/to-spec`**（把討論串變成 spec（規格）），然後用 **`/to-tickets`** 把它拆成 tracer-bullet（曳光彈）ticket（工單），每張都宣告自己的 **blocking edges**（阻擋關係）。接著用以下兩種方式之一處理這些 ticket：
     - 每張 ticket 跑一次 **`/implement`**，**每張之間都用 `/clear` 清掉 context（上下文）**。在本地 tracker（議題追蹤系統）上，就是 `.scratch/<feature>/issues/` 底下每張 ticket 一個檔案，由你手動、先處理 blocker 再往下做；在真正的 tracker 上，這些 edge 會變成原生的 blocking 連結，所以任何 blocker 都已完成的 ticket 都可以拿來做。每張 ticket 都是自足的，所以上一張的 context 可以丟掉。
     - 用 **`/implement-spec`** 一次跑完整份 spec。它把 ticket 當成 **task graph**（任務圖）來讀，在已就緒的 **frontier**（前沿）上平行執行 implementer subagent（負責實作的子代理），並把所有東西落在同一條 **integration branch**（整合分支）上。當你寧願編排整個建置、而不是自己逐張推動 ticket 時，就用它。
   - **否** → 就在這裡、在同一個 context window（上下文視窗）裡跑 **`/implement`**。

   不管哪種方式，程式碼都是透過驅動 **`/tdd`**（一次一個 red-green（紅綠循環）slice）建出來的，並以 **`/code-review`** 收尾，也就是對 diff（差異）做的雙軸審查（Standards + Spec）。`/implement` 每張 ticket 都會跑這兩個；`/implement-spec` 的每個 implementer 各自驅動 `/tdd`，最後在 integration branch 上跑一次 `/code-review`。當你只想先寫測試、做出某個具體的行為，而不需要完整的 spec 時，就單獨使用 **`/tdd`**；當你想針對一個固定點審查某個 branch（分支）或 PR（pull request）時，就單獨使用 **`/code-review`**。

   當工作要以 pull request 送出時，**`/pr`** 負責整理 PR 內文：能呈現這個改動的最小視覺化、證明它可行的前後對照證據，以及判斷這是單向門 (one-way door) 還是雙向門 (two-way door)。它是 model-invoked（由模型主動叫用）的，所以 agent（代理）每次寫 PR 都會用它。

4. **`/retro`** 為這個迴圈收尾。建置完成後，尤其是出了狀況的建置，它會回顧整個 session，並建議修改 agent 的 **environment**（環境），而不是程式碼：navigation pointer（導航指標）、自動化檢查、`/code-review` 所執行的程式規範、steering 檔案（引導用檔案）、工具。機械性的錯誤變成確定性的檢查；需要判斷的事變成程式規範。下一次建置就會從更好的環境開始。

### Context 衛生 (Context hygiene)

把步驟 1 到 3 保持在**同一個不中斷的 context window** 裡（在 `/to-tickets` 之前不要 compact 或 clear），這樣 grilling（拷問式訪談）、spec 和 ticket 才會都建立在同一套思考上。之後每次 `/implement` 都重新開始，以 ticket 為依據。在 `/retro` 要回顧的那個 session 裡、在 clear 之前執行它；clear 之後，就改成把它指向那個 session 的 log。

這件事的限制是 **[smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)**（聰明區）：模型仍然能清晰推理的那段視窗（在最先進的模型上約 150k token）。如果某個 session 在 `/to-tickets` 之前就快接近它了，不要在品質下降的狀態下硬撐；在最近的 phase boundary（階段邊界）`/compact`，然後繼續（見 Phase boundaries 一節）。

## 匝道 (On-ramps)

一個會產生工作的起始情境，接著匯入主流程。

- **Bug 和需求越堆越多** → **`/triage`**。它把 issue（議題）在各個 triage role（分流角色）之間推進，產出 agent 可以直接處理的 issue，之後由 **`/implement`** 接手。

  Triage 只用於**不是你建立的** issue：bug 回報、外部送來的功能需求，任何以原始狀態送進來的東西。`/to-tickets` 產出的 ticket 已經是 agent 可以直接處理的，所以**不要對它們做 triage**。

- **有東西壞了** → **`/diagnosing-bugs`**。用於難搞的那些：第一眼看不出來的 bug、時好時壞的 flake（不穩定問題）、在兩個已知正常的狀態之間悄悄出現的 regression（退化）。在擁有 **tight feedback loop**（緊密的回饋迴圈，也就是一個已經會在*這個* bug 上變紅的指令）之前，它拒絕提出理論，之後再搭配回歸測試來修正。修好之後，在同一個 session 裡跑 **`/retro`**，問問什麼可以預防這個 bug；如果真正的發現是沒有好的 seam（接縫）可以把它鎖住，那就是 **`/improve-codebase-architecture`** 的工作。

- **一個巨大、模糊的工作：全新 (greenfield) 專案或龐大的功能建置，大到一個 session 裝不下** → **`/wayfinder`**，這裡最耗腦力的 flow。當從這裡到目的地的路還看不見時，它會在 issue tracker 上畫出一張由 **decision tickets**（決策 ticket）組成的 **shared map**（共享地圖），並一次解決一張，產出的是**決策，不是交付物**，直到迷霧被推開、路變清楚為止。**`/grill-with-docs`** 用來磨利你能在一個 session 裡掌握的點子，wayfinder 則是給你掌握不了的點子；而且它比較慢、比較密集，所以只把它留給這種情況，絕不要用在範圍明確的功能上。

  當 map 變清楚時，**它會交接，不會建置**：在 **`/to-spec`** 匯入主流程，`/to-spec` 會把 map 上互相連結的決策收斂成一份可以建置的計畫，然後照常 `/to-tickets` 和 `/implement`。把 map 直接接進 `/implement` 會跳過那次收斂，並把連結的細節丟掉，所以只有在這個工作最後真的很小時，才直接去 `/implement`。

## Codebase 健康 (Codebase health)

不是功能開發，只是日常維護。

- **`/improve-codebase-architecture`** 在你有空檔時就跑，讓 codebase（程式碼庫）保持在適合 agent 操作的狀態。它會找出 **deepening opportunities**（深化機會）；挑出其中一個會*產生一個點子*，你可以帶著它從 `/grill-with-docs` 進入主流程。它是找出候選的勘查；**`/codebase-design`**（見下方）則是你設計被選中那一個的工作台。

## 底層詞彙 (Vocabulary underneath)

兩個 model-invoked 的參考 skill，在其他 skill 的*底下*運作，各自是自己那套詞彙的唯一事實來源。當問題出在**用詞**而不是流程時，就直接用它們；或者讓上面那些 skill 把它們拉進來。

- **`/domain-modeling`**：磨利專案的*領域*語言：挑戰模糊的用詞、解決一詞多義（"account" 一個詞做三份工作）、把難以反悔的決定記錄成 ADR。它是 `/grill-with-docs` 所驅動的那套主動紀律，用來讓 `GLOSSARY.md` 保持為一份乾淨的 glossary（詞彙表）。
- **`/codebase-design`** 是 deep module（深模組）的詞彙（module（模組）、interface（介面）、depth（深度）、seam、adapter（轉接器）、leverage（槓桿）、locality（局部性）），用來設計一個 module 的*形狀*：在乾淨的 seam 上，用小小的 interface 包住大量的行為。`/tdd` 和 `/improve-codebase-architecture` 都說這套語言。

## 階段邊界 (Phase boundaries)

**phase**（階段）是 session 裡的一段工作：grilling、實作、QA。在兩個 phase 之間的 **boundary**（邊界）上，你有五個選項，而在它們之間做選擇，是這整張地圖裡最模糊的決定：

- **Continue**（繼續）：留在原地。不花任何成本，也不損失任何東西。
- **`/clear`**：清空視窗，用在這裡的東西對接下來的事都不重要時。
- **`/handoff`** 寫出一個可攜帶的 markdown 檔。用途很窄：只用於**新的 harness**（代理執行環境）、**新的目錄**、**同事**，或在 **phase 進行中**分出一個支線任務。它換來的是可攜性。
- **Subagent**（子代理）：把一個範圍嚴格限定的任務送到它自己的視窗，然後拿回一份報告。
- **`/compact`** 壓縮這個 context，並用它來啟動一個新的 session。這是**預設選項**，位於決策樹的最底部，而不是第一個伸手去拿的。

讀 [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) 看排好順序的決策樹：五個問題、每個分支背後的理由，以及為什麼 primary source（第一手來源）的成本讓 **Continue** 成為最先要排除的那個。在 boundary **上**做決定；在 phase 進行中，就繼續，或把剩下的工作拆給 subagent。

## 獨立使用 (Standalone)

完全不在主流程上。

- **`/grill-me`**：和 `/grill-with-docs` 一樣毫不留情的訪談，但它是**無狀態的**：它不會在本地儲存任何東西，也不會建立 `GLOSSARY.md`。當你**不是在一個工作目錄裡工作**時（磨利一個計畫、一個設計、一篇文章，任何底下沒有 repo 的東西），就用它。如果你是在一個工作目錄裡，就改用 `/grill-with-docs`：它跑同樣的訪談，而且會留下書面紀錄，所以它完全就是比較好的那個。
- **`/grilling`** 是訪談的基本元件本身：rounds（回合）、frontier、事實是 agent 的工作而決定是你的。`/grill-me` 和 `/grill-with-docs` 是兩個有名字的入口，而 `/triage`、`/wayfinder` 和 `/improve-codebase-architecture` 內部都會執行它。只有當你想要沒有任何外層包裝的訪談時，才直接用它。
- **`/prototype`** 是一個小小的、用完即丟的程式，用來回答一個設計問題：這個狀態模型感覺對不對，或這個 UI 應該長什麼樣子。用完即丟是對程式碼寫法的限制，不是承諾要把它銷毀：答案會融入真正的程式碼，而 prototype 本身會作為 **primary source** 保留在一個從 main 分出來的 `prototype/<name>` branch 上，並在實作的 issue 裡指向它。它是主流程步驟 2 裡的那個繞道，但任何時候只要某個設計問題很難在紙上定案，都可以用它。
- **`/research`**：把閱讀的跑腿工作委派給一個 **background agent**（背景代理）：它會根據 **primary sources** 調查一個問題，然後在 repo 裡留下一份附有引用來源的 Markdown 檔。它在讀的時候你可以繼續工作。它產出的檔案是要帶*進*主流程、從 `/grill-with-docs` 開始使用的東西，因為研究是用來餵養思考，而不是取代思考。
- **`/to-questionnaire`** 用在擋住你的東西不在你腦袋裡、也不在 codebase 裡，而是在**別人的**腦袋裡時，它會寫一份問卷讓對方填。它是 `/grill-me` 的反面：它不是針對主題訪談你，而是針對這次**寄送**訪談你（要寄給誰、你需要拿回什麼），然後把問題瞄準那個缺口。拿回來的東西是 `/grill-with-docs` 或 `/to-spec` 的材料。
- **`/wizard`** 用於只有**人類**才能做的步驟：佈建基礎設施、設定憑證或 CI secret、在不熟悉的第三方 dashboard 上一路點過去、執行一次性的遷移或切換。它會產生一個互動式的 bash script，打開每個 URL、擷取每個值，並把它們寫進 `.env` 和 GitHub secrets，讓這個程序不再是你每次都要重新跟 agent 解釋一遍的東西。它是 model-invoked 的，所以 agent 一碰到只有你才能通過的牆，就會用它。如果 agent 自己就能做，那它就應該自己做；這個是給真的需要人類參與其中的地方用的。
- **`/wait-what`** 是用來修正一則沒有傳達到的訊息。在對話中途、在任何其他 skill 裡面都可以用，agent 會補上你缺少的 context，用淺白的英文、使用 `GLOSSARY.md` 的詞彙，重新說明它剛剛說的話。它是事後補救；`/grill-with-docs` 才是事前的解藥，因為早早約定好的共同語言，才是讓術語根本不會冒出來的方法。
- **`/teach`**：跨多個 session 學習一個概念，把目前的目錄當成有狀態的工作空間。
- **`/writing-for-agents`** 是撰寫給 agent 讀的文件時的參考：skill、AGENTS.md、被其他地方指向的文件。

## 前置條件 (Precondition)

**`/setup-matt-pocock-skills`**：在你第一次跑 engineering（工程）flow 之前執行，用來設定其他 skill 預設會有的 issue tracker、triage label（分流標籤）和文件結構。自訂的 issue tracker 也可以用。
