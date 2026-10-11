> 繁體中文翻譯。原文：[retro.md](../../../docs/engineering/retro.md)

## 它做什麼 (What it does)

`retro` 會回顧一次寫程式的 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段），並針對 agent（代理）的 **[environment](https://www.aihero.dev/ai-coding-dictionary/environment)**（環境）提出改善建議，讓下一次執行更順利。它讀取 session 本身的紀錄（預設是目前這一個，或是你在 session 紀錄檔中指定的某一個）。它找出 agent 卡關的時刻，並給你一份候選修正清單，最嚴重的排在最前面。

它改變的是環境，不是程式碼。以 agent 送出的 bug、它花了二十次 [tool calls](https://www.aihero.dev/ai-coding-dictionary/tool-call)（工具呼叫）才找到的檔案，或 reviewer（審查者）漏掉的規則為例。`retro` 不會直接修正其中任何一個。它會問 repo（儲存庫）裡是什麼讓它們發生，並提出能在下次防止它們的檢查、指標或標準。它也只會提出建議。在你挑選某個候選項目之前，什麼都不會改變。

## 什麼時候用它 (When to reach for it)

你要輸入 `/retro` 來呼叫它，agent 不會自行使用它。

在一個比應有的情況更困難的 session 結束時使用它。例如 agent 花太久時間找某樣東西、犯了一個工具本來可以抓到的錯誤，或需要它拿不到的資訊。順利的 session 沒什麼可學的，發現都來自困難的 session。如果你想對 session 產出的程式碼做出評判，請改用 [code-review](https://aihero.dev/skills-code-review)。

## 發現會落在哪裡 (Where the findings land)

每個候選項目都屬於一個類別，而類別決定修正要放在哪裡：

| session 中出了什麼問題 | 用什麼修正 |
| --- | --- |
| agent 花了很久才找到某個檔案或事實 | 從它本來就會讀的檔案加上一個 **navigation pointer**（導覽指標） |
| 它犯了一個工具本來可以抓到的錯誤 | 一個 **[automated check](https://www.aihero.dev/ai-coding-dictionary/automated-check)**（自動化檢查）：lint（程式碼靜態檢查）規則、型別、test、pre-commit hook、CI（持續整合）job |
| reviewer 漏掉了一個需要判斷力的錯誤 | 在 `CODING_STANDARDS.md` 裡為 reviewer agent 加一條規則 |
| `AGENTS.md` 或 `CLAUDE.md` 很大 | 把裡面的引導內容移出去，改放到標準或檢查裡 |
| 某次工具呼叫的成本相對於它回傳的東西太高 | 精簡這個工具，或換掉它 |
| 某個引導檔案充滿了不改變任何事的句子 | 刪掉這些 **no-ops**（無作用的內容） |
| agent 需要它取不到的資訊 | 擴大它的存取權：用 tee 把 dev server 的 log 寫進檔案，給予某個服務的唯讀存取權 |

主要的想法是：標準屬於 **reviewer**，而不是實作者。實作的 agent 承受最大的 context（上下文）壓力，因為它要探索、寫程式碼，還要除錯失敗。審查的 agent 只拿到一份 diff（差異），沒有其他東西。所以新規則要放在有空間套用它的地方，也就是審查。它絕不放進 [AGENTS.md](https://www.aihero.dev/ai-coding-dictionary/agents-md)，因為 AGENTS.md 會被載入每一個 session 的 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window)（上下文視窗），不管相不相關。

在 `retro` 寫下任何規則之前，它會先為違規分類。**mechanical**（機械式）的違規（被禁用的 API、import 的寫法、檔案位置規則）會得到一個確定性的檢查，因為檢查可以失敗，而標準檔案裡的一句話不行。只有真正需要判斷、任何 linter 都無法強制執行的事，才寫成文字。如果 repo 完全沒有防護措施（沒有 pre-commit hook，也沒有執行 lint、typecheck（型別檢查）和 test 的 CI job），`retro` 會把這件事本身當成一項發現回報。

## 常見問題 (Common questions)

**它會自己寫 lint 規則，還是等你同意？我可以設定讓它在每個 session 之後自動執行嗎？**

它會等。`retro` 只提出建議。在你挑選候選項目之前什麼都不會改變，所以它不會自行編輯任何東西，也不會自動安裝任何 hook。這是刻意的。有一位使用者正是在「被擋掉好變更的自動 hook 坑過」之後，要求這樣的設計。判斷什麼值得一個永久的檢查需要判斷力，所以這個 skill（技能）維持 [human-in-the-loop](https://www.aihero.dev/ai-coding-dictionary/human-in-the-loop)（人在迴路中），並且是 user-invoked（只能由使用者呼叫）的。有些使用者確實在每次實作執行後都跑它。但順利的 session 沒什麼可學的，所以在每個 session 之後都執行，多半只會產出沒人需要的規則。沒有 dry-run（試跑）模式。提出的檢查就像其他程式碼一樣，所以在讓它擋下 merge（合併）之前，先在 repo 上試試看。

**這樣不會讓 lint 規則永遠越堆越多嗎？它會建議移除規則嗎？**

部分會，而這是它最弱的地方。它可以移除文字：引導檔案中的 no-ops，以及 `AGENTS.md` 或 `CLAUDE.md` 中應該放在標準或檢查裡的引導內容。當檔案很大時，它會標記這些內容建議刪除。它是根據它讀到的那一個 session 來判斷，所以把每一項都當作刪除測試的候選，而不是定論。它不會稽核它上個月提出的 lint 規則、hook 或 CI job。它只看得到一個 session，所以無法告訴你某條規則現在觸發得太頻繁，或它背後的 bug 已經不存在了。你仍然必須自己修剪檢查。一條在好的程式碼上不斷觸發的規則，就是該移除它的訊號。

**它不會只是編出一些泛泛的建議來填滿它的類別嗎？**

這是對它最強烈的批評。有一位使用者發現：「一旦工作完成，AI 往往會忘記 session 中段遇到的困難，並編出泛泛的建議來滿足 retro 的類別。」每個候選項目都必須來自 session 本身的紀錄，所以建議是針對那個 session 的。這既有好處，也有代價。它很少編出不相關的東西，但可能會過度看重這一個 session 的主題。丟掉任何你無法追溯到特定時刻的候選項目。嚴重程度的排序也要當成初稿看待，因為一個安靜但代價高的錯誤，可能會排在一個醒目但代價低的錯誤後面。

**我的 session 很長。要現在執行，還是重新開始？**

預設它會審查目前的 session。這是最好的情況，因為那些困難還在 context window 裡。如果 session 已經離開了 [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)（聰明區），就 [clear](https://www.aihero.dev/ai-coding-dictionary/clearing)（清除）它，然後讓一個新的 `/retro` 指向 session 紀錄檔中的前一個 session。

**agent 一直犯同樣的錯誤。我應該在 `CLAUDE.md` 加一行嗎？**

通常不應該，而這是 `retro` 最常反對的事。`CLAUDE.md` 裡的一行會被載入每個 session，降低檔案中其他所有內容的份量，而且會隨著程式碼改變而過時。如果錯誤是機械式的，修正方式就是一個會失敗的檢查。如果是需要判斷的事，就放進 reviewer 會讀的程式碼標準裡。`AGENTS.md` 和 `CLAUDE.md` 是用來放 navigation pointer 的，幾乎沒有其他用途。基於同樣的理由，`retro` 不是一個 [memory system](https://www.aihero.dev/ai-coding-dictionary/memory-system)（記憶系統）。它不儲存發生過的事。它改變環境，讓錯誤無法再次發生。

**我的設定裡提到了 `CODING_STANDARDS.md`，但我沒有這個檔案。它是從哪裡來的？**

沒有任何 skill 附帶這個檔案。當某個 session 第一次找到一條給 reviewer 的判斷型規則時，`retro` 會提議建立它。你接受之後，[code-review](https://aihero.dev/skills-code-review) 就會讀它。你已經在維護的任何其他標準文件，例如 `CONTRIBUTING.md`，也以同樣方式運作。

**它和 `improve-codebase-architecture` 有什麼不同？**

輸入不同。[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 只需要程式碼，並尋找對程式碼的結構性改善。`retro` 需要 session 的歷史紀錄，並改善 agent 工作的環境，而不是程式碼。兩個你都會用；誰也不能取代誰。

## 運作正常的跡象 (It's working if)

- 每個候選項目都指回 session 中的某個特定時刻，而不是泛泛的最佳實務。
- 重複的錯誤變成會失敗的檢查，而你的 `AGENTS.md` 隨著時間變短，而不是變長。
- 如果某個檢查早就存在、只是沒有接上，發現的結論會是把它接上，而不是提議再做一個新的。
- 下一個處理同類任務的 session 能更快找到它需要的東西。

## 它在流程中的位置 (Where it fits)

`retro` 是主鏈的最後一步，你在這裡回顧整條鏈進行得如何：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

在一次值得學習的建置之後執行它，可以在同一個 session 裡，或指向那個 session 的紀錄檔。順利的建置之後可以略過它。

- [code-review](https://aihero.dev/skills-code-review) 是 `retro` 最常調整的 reviewer agent。新的程式碼標準會放在它的 Standards 軸會讀取的地方。
- [writing-for-agents](https://aihero.dev/skills-writing-for-agents) 為 `retro` 提出的每個引導檔案和 skill 設定寫作風格，而 `retro` 在開始之前會載入它。

當你不確定當下情況需要哪個 skill 時，[ask-matt](https://aihero.dev/skills-ask-matt) 會在整套 skill 中幫你指路。
