> 繁體中文翻譯。原文：[code-review.md](../../../docs/engineering/code-review.md)

## 它做什麼 (What it does)

`code-review` 會沿著兩個面向，審查 `HEAD` 和你指定的固定點（一個 commit（提交）、一個 branch（分支）、一個 tag、`main`、`HEAD~5`）之間的 diff（差異）。**Standards**（標準）問的是程式碼是否遵循這個 repo（儲存庫）的寫法。**Spec**（規格）問的是程式碼是否做到原始 issue（議題）或 [spec](https://www.aihero.dev/ai-coding-dictionary/spec) 所要求的事。每個面向都在自己的 [sub-agent](https://www.aihero.dev/ai-coding-dictionary/subagent)（子代理）中執行，所以彼此都看不到對方的推理。

這個 skill（技能）從不合併兩個面向，也不重新排名。報告最後會給出*每個面向*最嚴重的問題，並拒絕在兩者之間選出單一贏家。一個變更可能通過一個面向、卻沒通過另一個。遵循所有慣例、卻實作了錯誤東西的程式碼，會通過 Standards、沒通過 Spec。完全做到 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket)（工作單）要求、卻破壞了 repo 慣例的程式碼，則剛好相反。混在一起的判決，會讓通過的面向掩蓋掉失敗的那個。

## 什麼時候用它 (When to reach for it)

輸入 `/code-review`，或者當你要求審查一個 branch、一個 PR（合併請求）、進行中的工作，或任何 "since X"（從 X 以來）的東西時，agent（代理）會自動使用它。

| 你的情況 | 要用 |
| --- | --- |
| 已經有一個 diff，你想知道它是否做得正確，*而且*做的是正確的東西 | `code-review` |
| 你想在 diff 中找 bug：null 路徑、競態條件、差一錯誤 | Claude Code 自己的內建審查，不是這個（見下方的名稱衝突） |
| 還沒寫任何東西，你想用測試先行的方式來寫 | [tdd](https://aihero.dev/skills-tdd) |
| 需要建構整份 spec，包含審查 | [implement](https://aihero.dev/skills-implement)，它本身就會呼叫這個 skill |
| 偏離的是整個 codebase（程式碼庫），而不是單一個 diff | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) |
| 某個東西壞了，而你不知道原因 | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |

你必須提供固定點。如果你沒有提供，skill 會向你詢問，而不是用猜的。在啟動任何東西之前，它會先確認 ref 能被解析，而且 diff 不是空的，所以打錯的 branch 名稱會在你面前失敗，而不是在兩個 sub-agent 裡面失敗。

## 前置條件 (Prerequisites)

Standards 面向不需要任何東西。它會讀 repo 記錄下來的任何規範（`CODING_STANDARDS.md`、`CONTRIBUTING.md` 之類的），如果 repo 什麼都沒記錄，就退回使用內建的基準。

Spec 面向需要 spec 存在，而且找得到。它依照這個順序尋找：

1. commit message 中的 issue 參照（`#123`、`Closes #45`、GitLab 的 `!67`），透過 tracker 文件取得。
2. 你作為參數傳入的路徑。
3. `docs/`、`specs/` 或 `.scratch/` 底下，符合 branch 或功能名稱的 spec 檔案。
4. 問你。

第 1 步依賴 tracker 文件，它是由 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 寫出的。沒有它的話，只要你給它一個路徑，這個面向仍然能運作。如果完全沒有 spec，skill 會跳過 Spec sub-agent，報告會寫 "no spec available"（沒有可用的 spec），而不是自己發明需求。

## 兩個面向 (The two axes)

| | Standards | Spec |
| --- | --- | --- |
| 問題 | 做得正確嗎？ | 做的是正確的東西嗎？ |
| 讀什麼 | repo 記錄的標準，加上 smell（程式碼異味）基準 | 原始的 issue 或 spec |
| 回報什麼 | 有記錄的違規（可能是硬性的），以及 smell（一定是判斷題） | 缺少或只做了一部分的需求、範圍蔓延、實作錯誤的需求 |
| 每個發現都要引用 | 標準檔案和規則，或 smell 名稱加上 hunk（diff 中的一段變更） | spec 中的那一行 |

這個設計是為了避免一個不懂你的標準的通用審查 skill。那種 skill 會標記你 codebase 中刻意的寫法，卻漏掉你 codebase 所依賴的不變條件。所以在 Standards 面向上，repo 自己的文件就是 [primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source)（第一手資料），而且 **repo 永遠優先**。

**smell baseline**（smell 基準）位在 repo 的標準之下。它是 Fowler 的 _Refactoring_（重構）第 3 章中的十二個 code smell：Mysterious Name、Duplicated Code、Feature Envy、Data Clumps、Primitive Obsession、Repeated Switches、Shotgun Surgery、Divergent Change、Speculative Generality、Message Chains、Middle Man、Refused Bequest。每一個都是帶標籤的經驗法則（"possible Feature Envy"（可能是 Feature Envy）），從來不是硬性違規。每一個都說明這個 smell 是什麼、怎麼修，所以一個發現會附帶修法，而不只是一句抱怨。兩個面向都會跳過任何你的 linter（程式碼靜態檢查工具）已經強制執行的東西。

## 常見問題 (Common questions)

**它和 Claude Code 自己的 `/code-review` 衝突了。我該怎麼辦？**

這是這個 skill 被回報最多的問題，而且還沒修好。Claude Code 內建了自己的 `/code-review`，做的是不同的事：它在 diff 中找 bug，而這個 skill 檢查的是是否符合 spec 和 repo 標準。當你安裝這個函式庫時，其中一個會勝出，哪一個勝出取決於你的安裝方式：

- **Plugin marketplace**（外掛市集）。每個 skill 都會加上 `mattpocock-skills:` 前綴，而內建的那個很難用不加前綴的名稱叫到。
- **單純的 skills 安裝**。本地檔案勝出，這個 skill 會蓋過內建的那個。

一個解法是完全移除 Claude Code 的內建 skill。這能省下很多 [context](https://www.aihero.dev/ai-coding-dictionary/context)（上下文），衝突也就無所謂了。蓋過內建 skill 這件事本身，可以說是 Claude Code [harness](https://www.aihero.dev/ai-coding-dictionary/harness)（執行 agent 的外殼程式）的 bug（skill 作者應該可以自由為 skill 取任何名字），所以另一個解法是把本地的副本改名。`npx skills update` 會把對 frontmatter（檔頭設定區塊）的修改或改過名的目錄還原。使用者回報的持久解法，是把這個 skill fork 成一個新名字，並把 `code-review` 從受管理的集合中移除。記下你 fork 時的 commit，這樣你才能手動重新同步。

**它的 sub-agent 一直重新呼叫 `/code-review`，產生更多 agent。**

這是一個已知、尚未解決的 bug。好幾個人在不只一個 harness 中重現過。Standards 和 Spec 的 prompt（提示詞）沒有禁止委派，所以 sub-agent 可能再次找到這個 skill，又再分出更多 agent。有一份回報達到了超過 50 個 agent。大家在 fork 上套用的修正，是在兩份 sub-agent 指示的最後加上一行："Do not invoke `/code-review` or spawn additional agents: perform this review directly."（不要呼叫 `/code-review` 或產生更多 agent：直接進行這次審查。）有些人偏好在 harness 層級處理，讓每個 skill 都繼承這個防護。兩種做法目前都不在正式發佈的 skill 裡。如果你在無人看管的情況下執行它，要注意 agent 的數量。

**我應該在寫程式碼的同一個 [session](https://www.aihero.dev/ai-coding-dictionary/session)（對話階段）裡執行它嗎？**

最好用一個新的。就像一位讀者說的：「用同一個 context 審查自己不叫審查，那是加上 slash command（斜線指令）的確認偏誤。」在撰寫程式碼的 session 中進行審查的 agent，context 裡有塑造這段程式碼的每一個假設。獨立的審查者不會有那些 context。這也是為什麼有人要求 [implement](https://aihero.dev/skills-implement) 不要內建審查步驟，因為那個步驟是在剛寫完 diff 的那個 session 裡執行審查。獨立的做法是你自己從一個乾淨的 session 呼叫 `/code-review`。

**每張 ticket 之後都跑，還是最後跑一次？**

兩種都可以，skill 不會替你決定。每張 ticket 跑一次，能讓每個 diff 小到讓 Spec 面向只需要對照一份明確的 spec，這是 `implement` 使用的模式。在 branch 的最後一次批次處理，能抓到 ticket 之間的交互作用，那是每張 ticket 各自的審查都會漏掉的。如果你不確定，就每張 ticket 審查一次，最後再針對 branch 分出的起點跑一次完整審查。

**我可以相信這些發現嗎？**

不檢查就不行。sub-agent 的輸出是假設，不是證據。有一個團隊回報，它找到了十幾個純文字敘述式的審查都漏掉的破壞性變更。skill 會把兩份報告照原樣或稍加整理後合在一起。它不會針對檔案重新驗證每一項說法，所以一個發現可能引用錯誤的位置，或誇大影響。在根據每個發現採取行動之前，先讀它的引用。skill 要求每個發現都附上引用（一條標準規則、一個 smell 加上它的 hunk，或一行 spec），正是這一點讓這些發現可以被檢查。

**為什麼我每次執行它都會找到新問題？**

每一次修正都會加入新的程式碼要審查，而 Standards 面向中屬於判斷題的那一半，每次執行的結果都不一樣。一位讀者描述了這個迴圈：「/code-review 和 /improve-code-architecture 每次都會找到新東西。我實作修正，重新執行這些 skill，然後一次又一次。」沒有收斂的保證。把一次審查當成一份線索清單。處理那些背後有引用規則的，然後就停。不要反覆執行直到它回報乾淨為止，因為它永遠不會。

**它會審查我還沒 commit 的工作嗎？**

不會。它比對的是 `<fixed-point>...HEAD`。三個點的形式是從 merge-base 開始計算，並排除已 staged（加入暫存區）的變更和 working tree（工作目錄）中的變更。如果 `implement` 還沒做中途的 commit，審查就看不到即將進入下一個 commit 的工作。先 commit，再審查，然後 amend 或加一個 fixup。

## 運作正常的跡象 (It's working if)

- 遇到錯誤的 ref 或空的 diff 時，它會在產生任何 sub-agent 之前就拒絕開始。
- 報告分成 `## Standards` 和 `## Spec` 底下兩個獨立的區塊，而不是一份合併的清單。
- 每個 Standards 發現都會指出你 repo 檔案中的某條規則，或十二個 smell 之一，並引用 hunk；每個 Spec 發現都會引用 spec 中的一行。
- 結尾摘要會給出每個面向最嚴重的問題，並拒絕選出整體贏家。
- 沒有可用的 spec 時，Spec 區塊會直接說明，而不是列出它從程式碼推斷出來的需求。

## 它在流程中的位置 (Where it fits)

`code-review` 是建構鏈尾端附近的審查步驟：`grill-with-docs → to-spec → to-tickets → implement → code-review → retro`。它也可以單獨用在任何你指給它的 branch 或 PR 上。

- [implement](https://aihero.dev/skills-implement) 是最接近的鄰居。它負責驅動建構，並在 commit 之前呼叫這個 skill，作為自己的收尾審查。[implement-spec](https://aihero.dev/skills-implement-spec) 也一樣，但只在整個 integration branch（整合分支）上做一次。
- [retro](https://aihero.dev/skills-retro) 在它之後，並負責調整它。當某個 session 顯示審查漏掉了某一類錯誤時，`retro` 會提議一項檢查，或一條 `CODING_STANDARDS.md` 規則，之後 Standards 面向就會讀到它。
- [pr](https://aihero.dev/skills-pr) 會在審查過的工作送出時，撰寫 pull request 的內文。
- [to-spec](https://aihero.dev/skills-to-spec) 和 [to-tickets](https://aihero.dev/skills-to-tickets) 產出 Spec 面向所對照的文件，所以模糊的 spec 會讓這個面向也變得模糊。
- [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 是對應的整個 codebase 版本，因為這個 skill 只看一個 diff。

當你不確定情況需要哪個 skill 時，[ask-matt](https://aihero.dev/skills-ask-matt) 會在整個集合中為你指路。
