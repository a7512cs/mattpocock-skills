> 繁體中文翻譯。原文：[codebase-design.md](../../../docs/engineering/codebase-design.md)

## 它做什麼 (What it does)

`codebase-design` 固定你設計 module（模組）時使用的詞彙：**module**、**interface**（介面）、**depth**（深度）、**seam**（接縫：不必修改該處程式碼就能改變行為的位置）、**adapter**（轉接器）、**leverage**（槓桿）、**locality**（局部性）。它精確定義每一個詞，禁止鬆散的替代詞（"component"、"service"、"API"、"boundary"），並說明從這些詞推導出來的少數幾條原則。

它是一份參考資料，不是一個流程。它不跑任何迴圈、不產出任何產出物，也從不停下來問你問題。其他所有涉及設計的 skill（技能）都使用它的詞彙。單獨使用時，它給你這些詞，然後就停止。在呼叫它之前要先知道這點。如果你把一個 [session](https://www.aihero.dev/ai-coding-dictionary/session)（對話階段）指向一個沒有流程、也沒有停止規則的 skill，然後說 "go"（開始），agent（代理）會自己發明一個流程。下面的問題會說明那是什麼樣子。

## 什麼時候用它 (When to reach for it)

輸入 `/codebase-design`，或者當設計任務適合時，agent 會自動使用它。

當你已經知道要重新設計哪段程式碼，而需要思考它的形狀時，就用它：seam 要放在哪裡、interface 可以縮到多小、一次抽取是否能把複雜度從呼叫者身上移走。也可以用它來解決關於某個設計用詞意思的爭論。

有好幾個 skill 和它很接近。依照你遇到的問題來選：

| 問題 | 對應的 skill |
|---|---|
| 單一 module 的形狀：它的 interface、它的 seam、它的 depth | `codebase-design` |
| *領域的用詞*："account"（帳戶）有三種意思，兩個人說 "cancellation"（取消）時指的是不同的東西 | [domain-modeling](https://aihero.dev/skills-domain-modeling) |
| 你還不知道要重新設計*哪一個* module | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture)（找出候選對象的全面檢視） |
| 你希望有人跟你爭論這個設計，而不只是幫它命名 | [grilling](https://aihero.dev/skills-grilling)（拷問式提問） |
| 有一個具體的行為要建構，而你想要能在 refactor（重構）後存活的測試 | [tdd](https://aihero.dev/skills-tdd) |

## 詞彙 (The vocabulary)

glossary（詞彙表）就是這個 skill 本身。skill 把每個術語都對照其他術語來定義，並給出每個詞所取代的那個詞。

| 術語 | 意思 | 不要說 |
|---|---|---|
| **Module** | 任何有 interface 和 implementation（實作）的東西。刻意不限規模：一個函式、一個類別、一個套件、一個跨越多層的切片。 | unit, component, service |
| **Interface** | 呼叫者要正確使用它所必須知道的一切：型別簽章，加上不變條件、順序限制、錯誤模式、必要的設定、效能特性。 | API, signature |
| **Depth** | interface 上的 leverage：呼叫者或測試每學一單位的 interface，能運用多少行為。**Deep**（深）：小小的 interface 背後有大量行為。**Shallow**（淺）：interface 幾乎和 implementation 一樣複雜。 | 無 |
| **Seam** | Michael Feathers 的術語：一個你不必在那裡編輯、就能改變行為的地方。它是 interface 的*位置*，要放在哪裡是一個獨立的決定，和背後放什麼是分開的。 | boundary |
| **Adapter** | 在 seam 上滿足某個 interface 的具體東西。它指的是一種角色，而不是一種東西：記憶體內的 fake 和 Postgres repo 都是 adapter。 | 無 |
| **Leverage** | 呼叫者從 depth 得到的東西：每學一單位的 interface，就得到更多能力。 | 無 |
| **Locality** | 維護者從 depth 得到的東西：變更、bug 和驗證都留在同一個地方，所以修一次就涵蓋所有呼叫者。 | 無 |

這個 skill *不*把 depth 定義為 implementation 行數與 interface 行數的比例，那是 Ousterhout 自己的定義。那個指標會獎勵把 implementation 灌水，所以這個 skill 改用「depth 即 leverage」的定義。

## 四條原則 (The four principles)

- **Depth 是 interface 的屬性，不是 implementation 的屬性。** 一個 deep module（深模組）內部可以由小的、可替換的部分組成。呼叫者只是看不到它們。一個 module 可以有自己的測試會用到的內部 seam，以及位在 interface 上的一個外部 seam。
- **刪除測試。** 想像刪掉這個 module。如果複雜度消失了，這個 module 只是一個單純轉手的中介。如果複雜度重新出現在 N 個呼叫者身上，這個 module 原本是在隱藏真正的複雜度。
- **Interface 就是測試面。** 呼叫者和測試跨越的是同一個 seam。如果你想*越過* interface 去測試，這個 module 的形狀就錯了。
- **一個 adapter 代表假想的 seam。兩個 adapter 才代表真正的 seam。** 在有東西會跨越它而變化之前，不要切出 seam。只有單一 adapter 的 seam 只是多了一層間接。

有兩個輔助檔案講得更深入，skill 會在需要時才讀它們，而不是一開始就讀。[DEEPENING.md](https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/DEEPENING.md) 把候選對象的依賴分成四類（in-process（同一行程內）、local-substitutable（可在本地替代）、remote-but-owned（遠端但由自己擁有）、true-external（真正的外部）），因為類別決定了你要怎麼跨越 seam 去測試深化後的 module。[DESIGN-IT-TWICE.md](https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/DESIGN-IT-TWICE.md) 會啟動平行的 [sub-agents](https://www.aihero.dev/ai-coding-dictionary/subagent)（子代理），為同一個 module 產出三個以上截然不同的 interface，再從 depth、locality 和 seam 位置來比較它們。

## 常見問題 (Common questions)

**我實際上要怎麼在 TypeScript 裡建構一個 deep module？**

這是關於這個 skill 被問最多的問題，而這個 skill 並沒有回答它。它定義 deep module *是什麼*；對於如何阻止一個亂跑的 import 越過 interface，它什麼都沒說。[Issue #458](https://github.com/mattpocock/skills/issues/458) 說得很直白：「假設我們對這個 interface 很滿意，它隱藏了細節等等。但我們要怎麼強制執行它？我認為如果沒有 lint 或明確的防護措施，人類和 LLM 都會隨著時間把它弄亂。」那個討論串中的回答給了三個選項：把它包進一個 class 或 IIFE，並接受這個 class 會變得非常龐大；把它做成 monorepo 中的一個套件，並接受 monorepo 的工具鏈；或使用像 [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) 這樣的 linter（程式碼靜態檢查工具），禁止繞過 interface 的 import。在這些機制中，Effect 最好，dependency-cruiser 次之。repo（儲存庫）的 `in-progress/` bucket（分類資料夾）裡有一個 `setup-ts-deep-modules` skill，它會建立 `src/packages/<name>/index.ts` 的慣例，但它是一個 beta 通道的 skill，沒有文件頁面，也沒有附帶任何 lint 規則。

**我把一個 session 指向它，結果它燒掉了 100k 個 [tokens](https://www.aihero.dev/ai-coding-dictionary/token)（token：模型處理文字的計量單位），重新設計了我根本沒要求的東西。**

這是一個已知問題，登記為 [issue #449](https://github.com/mattpocock/skills/issues/449)。這個 skill 是 model-invoked（由模型自動呼叫）的，並把自己描述為詞彙，但裡面沒有任何東西能硬性阻止 agent 把它當成一個可執行的流程。在被要求「在 /codebase-design 裡接續，並推進那些還沒定案的決定」時，一個 agent 挑了這個 skill 中最接近流程的部分：`DESIGN-IT-TWICE.md` 裡的平行 sub-agent。它重新探索了前一個 session 已經整理過的程式碼，並工作了很久才問任何問題。這個 skill 沒有 driver skill（驅動型 skill）會有的那些防護（檢查點、一次一個問題、不會自動往下推進），因為它是參考資料。解決方法是呼叫一個 driver skill（`/grill-with-docs`、`/improve-codebase-architecture` 或 `/tdd`），並把 `codebase-design` 當成它的詞彙。這個 issue 仍未解決。

**`design-an-interface` 跑到哪去了？還有，有沒有 `/interface-design` 這個 skill？**

這個 skill 取代了 `design-an-interface`，並接手了它的內容。沒有任何東西不見。它的 "design it twice"（設計兩次）技巧（用平行的 sub-agent 產生截然不同的設計，出自 Ousterhout）以 `DESIGN-IT-TWICE.md` 的形式放在這裡。另外，有好幾個人要求一個專門處理 deep-module/thin-interface 理念的 `/interface-design` skill；這個 skill 已經涵蓋了那個理念，也沒有計畫推出另一個 skill。如果你是來找這兩個名字的，就是這一頁。

**這不就是一種檔案結構慣例嗎，像是資料夾、barrel file、feature slice？**

不是。大家已經多次反駁這個看法，而這個 skill 沒有改變。[Issue #95](https://github.com/mattpocock/skills/issues/95) 提議把一種正式化的碎形樹狀檔案結構，作為 deep module 的具體實作；回覆是兩者彼此獨立：「deep module 講的是 interface 的設計，以及透過嚴格的 interface 來存取，不管檔案系統長什麼樣子。用這種做法，看起來完全有可能做出 shallow module（淺模組）。」同樣的問題也在 #458 出現過：「我覺得你可能把 module 的概念和檔案系統綁得太緊了。檔案系統當然可以是 module 形狀的有用提示，但在建構 deep module 時，沒有必要用到檔案系統。」glossary 刻意把 **module** 定義為不限規模的。

**`tdd` 真的有用這套詞彙嗎？**

現在有，但很長一段時間都沒有。v1.0 把 `tdd` 中內嵌的 deep-module 筆記拿掉，改用這個共用的 skill，但沒有人加上一個 pointer（指向其他文件的參照）來取代它們，所以 `tdd` 自己定義了 "seam"，也沒有參照任何東西。現在 pointer 已經在 `tdd` 裡了，當未決的問題是 interface 的形狀、而不是測試時，agent 會跟著它走。`tdd` 仍然擁有 "seam" 作為你*測試*所在之邊界的意義；這個 skill 擁有的是它背後的 module 形狀。

**design-it-twice 模式在 Claude Code 之外有用嗎？**

不太順利。`DESIGN-IT-TWICE.md` 寫的是 "spawn 3+ sub-agents in parallel using the Agent tool"（用 Agent tool 平行產生 3 個以上的 sub-agent），而 "Agent" 是 Claude Code 中一個 [tool](https://www.aihero.dev/ai-coding-dictionary/tool)（工具）的名稱。這個 repo 為其他 [harnesses](https://www.aihero.dev/ai-coding-dictionary/harness)（執行 agent 的外殼程式）提供 metadata，包括 Codex，而那些 harness 可能沒有同名的 tool。所以平行設計階段的可攜性，比這個 skill 的 metadata 所暗示的還低。[Issue #564](https://github.com/mattpocock/skills/issues/564) 在追蹤這個問題，目前仍未解決。

**我可以把自己的概念加進 glossary 嗎，像是 connascence（共生性）、module secrets（模組祕密）、[progressive disclosure](https://www.aihero.dev/ai-coding-dictionary/progressive-disclosure)（漸進式揭露）？**

有人提議過這些。[Issue #180](https://github.com/mattpocock/skills/issues/180) 加入了 Parnas 的 module secrets 和 Page-Jones 的 connascence，作為一個命名層，用來描述*什麼東西*正在越過 seam 洩漏出去，並附上一份可運作的 diff（差異）；[issue #303](https://github.com/mattpocock/skills/issues/303) 提議在 implementation 內部使用 progressive disclosure，讓一個在公開 interface 上很深的 module，內部也有結構。兩者都還沒解決、也沒合併。正式發佈的 glossary 刻意保持精簡，而 skill 本身給出了理由：一致的用語就是全部的重點，而一個沒人能一致使用的術語，比沒有術語還糟。

## 運作正常的跡象 (It's working if)

- 設計討論不再出現 "component"、"service" 和 "boundary" 這些詞，而開始出現 "module"、"interface" 和 "seam"。
- 有人可以指著一個提議中的抽取，毫不含糊地說它是否通過刪除測試。
- 提議一個 seam 時，會一併指出第二個 adapter，而不只是第一個。
- 討論 interface 時會涵蓋不變條件、順序和錯誤模式，而不只是型別簽章。
- 呼叫它不會開啟一段工作 session。如果 agent 光憑 `/codebase-design` 就開始讀檔案、提議 refactor，代表它把參考資料誤當成了 driver（驅動者）。

## 它在流程中的位置 (Where it fits)

`codebase-design` 是一個 **reach-for-it-anytime standalone**（隨時可用的獨立 skill），也是 engineering（工程）skill 底下的詞彙層，而不是任何鏈中的一個步驟。它最接近的鄰居是 [domain-modeling](https://aihero.dev/skills-domain-modeling)，那是針對*問題領域*用詞、而不是 module 形狀的平行參考資料。兩者通常會一起使用，因為要把一個 deep module 命名好，兩者都需要。[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 是另一個：它檢視 codebase（程式碼庫），尋找深化的候選對象，並用這份 glossary 的詞彙寫下每一個，所以它負責找到 module，而你用這個 skill 的詞彙來設計它。當你不確定哪個 skill 或流程適合時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你指路。
