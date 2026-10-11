> 繁體中文翻譯。原文：[pr.md](../../../docs/engineering/pr.md)

## 它做什麼 (What it does)

`pr` 定義 pull request 內文的形式：一個呈現變更的 **Summary**（摘要）、證明它可以運作的 **Evidence**（證據），以及一個判斷落地風險有多高的 **Merge Danger**（合併風險）。它是一份格式參考，而不是一個工作流程。它不會 push branch（分支）、不會開 PR，也不會決定 PR 裡要放什麼。它告訴 [agent](https://www.aihero.dev/ai-coding-dictionary/agent)（代理）在寫 PR 內文時，內文應該長什麼樣子。

摘要是一張視覺圖，而不是一段文字。預設的 PR 內文是用文字描述 diff（差異）。這一份則會挑出能把重點說清楚的 **smallest view**（最小視圖：虛擬碼、呼叫樹、元件樹、檔案樹、Mermaid 圖，或經過整理的 diff），並讓周圍的文字保持簡短。審查者已經把 diff 打開了，所以內文要在他們閱讀之前，先讓他們看到它的形狀。

## 什麼時候用它 (When to reach for it)

輸入 `/pr`，或是每當 agent 在寫 PR 內文時，它會自動使用這個 skill（技能）。

| 你的情況 | 該用什麼 |
| --- | --- |
| 一個 branch 準備好了，需要一份審查者能快速瀏覽的內文 | `pr` |
| 程式碼寫好了，但還沒有人審查過 | 先用 [code-review](https://aihero.dev/skills-code-review)，再用 `pr` |
| PR 已經開了，審查意見陸續回來 | 這套 skill 目前沒有對應的；`pr` 只負責寫內文 |

## 範本 (The template)

三個區段，依照這個順序：

- **Summary**：一個或多個小型視覺圖，每個都放在它所支撐的簡短文字旁邊。用一個，有時用好幾個，很少全部都用。只保留審查者需要的呼叫、檔案、props 和邊界。
- **Evidence**：一組之前與之後的對照。當變更是視覺上的，而且 [environment](https://www.aihero.dev/ai-coding-dictionary/environment)（環境）可以截圖時，截圖是最有力的證據。否則，就用那個原本失敗、現在通過的確切測試（以虛擬碼寫出），或是有變化的 console 輸出。
- **Merge Danger**：這個變更是 **one-way door**（單向門：做了就難以回頭）還是 **two-way door**（雙向門：可以輕易回頭），以及它的 **blast radius**（爆炸半徑：出錯時的影響範圍）。two-way door 撤回的成本很低；one-way door（破壞性的資料遷移、移除公開 API、難以反悔的決策）則不然。blast radius 指出變更出錯時可能壞掉的東西：版面位移、API 的使用者、行動裝置的響應式版面。

門的判斷是最主要的概念。它把「這可以安全 merge（合併）嗎？」從一種直覺，變成一個審查者可以提出異議的明確主張。它也告訴審查者該把他們的 [human review](https://www.aihero.dev/ai-coding-dictionary/human-review)（人工審查）花在哪裡。blast radius 小的 two-way door 快速瀏覽就好，one-way door 則要慢慢讀。

## 常見問題 (Common questions)

**我可以相信 agent 自己對門的判斷嗎？**

不能盲目相信，而這正是要把它寫出來的原因。寫這個變更的 agent 就是給它打分數的那個，所以當它說 "two-way, small blast radius"（雙向門，影響範圍小）時，要最提高警覺。diff 也常常掩蓋一個變更能不能撤回。如同一位使用者說的，「回滾一個 commit（提交），並不會把一批已寄出的 email 收回來」，而一個用 flag 控制的上線，只有在第一筆資料以新格式寫入之前，才保持是 two-way。這個 skill 給 agent 的是一個定義（破壞性的動作和難以反悔的決策屬於 one-way），而不是一份檢查清單，所以要最仔細地檢查 Merge Danger 那一行。有兩件事有幫助：確保 agent 面前有 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket)（工作單）或 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格），而不只是 diff；並把你的 repo（儲存庫）一律視為 one-way 的變更（schema 遷移、任何會對外發布或會刪除東西的變更），寫在 agent 做判斷之前會讀到的地方。

**它會幫我開 PR 嗎？**

不會。`pr` 只涵蓋內文。[implement](https://aihero.dev/skills-implement) 的結尾是 commit 到目前的 branch。要求一個能開 PR 的 skill 或選項（一個 `/to-pr`，或讓 `implement` 開 PR 而不是 commit），目前都還是尚未關閉的提案。有一位使用者的變通方法，是在本地對 `implement` 加一句覆寫，叫它開 PR。[implement-spec](https://aihero.dev/skills-implement-spec) 是例外：當你的 issue tracker（議題追蹤系統）透過 PR 結束工作，或你要求開 PR 時，它會開一個 draft PR。因為 `pr` 是 model-invoked（可由 model 自動呼叫）的，所以每當你要求 agent 開 PR，它都會用這個形式來寫內文。

**它不會又產出一大堆文字和圖嗎？**

這個 skill 的設計就是要防止這種情況，但它仍可能發生。使用者對 agent 寫的 PR 內文，抱怨一向都一樣：「一大段摘要，但我只需要知道改了什麼、怎麼驗證的、什麼可能會壞掉，以及能不能安全地 merge。」這個 skill 要求 agent 省略開場白、讓文字保持簡短，並挑選最小的視圖，通常是一張視覺圖，很少全部都用。如果你還是拿到一疊圖，那就是 agent 忽略了這一點。如果內文很大是因為 diff 很大，那問題在於 PR 的大小，而 `pr` 不會幫你拆分它。

**我的 repo 已經有 PR 範本了。哪一個優先？**

預設情況下，兩個都不是。`pr` 有自己的範本，而且不會去找 `.github/pull_request_template.md` 或任何類似的東西。有好幾位使用者要求讓這個 skill 使用 repo 的範本。如果你什麼都不做，agent 對同一份文件就會有兩個互相競爭的指示。請在你 repo 的 agent 說明文件中把這件事定下來，例如填寫 repo 範本，並把 Summary、Evidence 和 Merge Danger 放在它底下。

**產出是 HTML 嗎？為什麼 Mermaid 圖沒有渲染出來？**

產出是一份 markdown 格式的 PR 內文，而不是 HTML 頁面。GitHub 和 GitLab 會在 PR 描述中渲染 Mermaid 區塊，但終端機不會，所以當 agent 還在本地給你看的時候，圖看起來就像原始文字。使用 CLI harness（執行 agent 的外殼程式，例如 Claude Code）的使用者，會用 ASCII 版的 Mermaid 渲染器，或讓 agent 把 HTML 版本附加到 PR 上，來繞過這個問題。Mermaid 只是六種視圖之一。呼叫樹、檔案樹或經過整理的 diff，在哪裡讀起來都一樣。

**它能幫忙整理回來的審查意見嗎？**

不能。它寫完內文就停了。使用者不只一次要求一種方法，來 triage（分流）其他開發者或審查機器人留下的意見（哪些值得處理、哪些不是問題）。這個 skill 不做這件事。

**PR 變動時，它會讓內文保持最新嗎？**

不會。它只在某個時間點寫內文，而一個在審查中持續變動的 PR，會讓那份內文過時。在大幅變更之後，請 agent 重寫內文。agent 又是在寫 PR 內文，所以它會用同樣的形式。

**我的變更沒有 UI。Evidence 要放什麼？**

除了截圖以外的一切。只有在變更是視覺上的時候，截圖才是最有力的證據。對於資料遷移、背景工作或 refactor（重構），證據是那個之前失敗、現在通過的確切測試，或是有變化的 console 輸出。單單一句「測試都是綠的」只是一個主張，不是之前與之後的對照。

**它能把內文標記為由 LLM 撰寫的嗎？**

它自己不會。有一位使用者的做法，是在 repo 的 agent 說明文件中放一條常設指示：agent 寫的每個 issue（議題）、留言和 PR，結尾都要加上一行揭露聲明。這條規則應該放在 repo 裡，讓它涵蓋 agent 發布的所有東西，而不是放在只針對一種文件的範本裡。

## 運作正常的跡象 (It's working if)

- 在打開 diff 之前，你光看 Summary 的視覺圖，就能知道這個 PR 改了什麼。
- 內文沒有開場白：它從 Summary 標題開始。
- Evidence 區段呈現的是之前與之後的對照，而不是聲稱測試通過。
- 每個 PR 都說明了是哪種門和 blast radius，而 one-way door 就是你會放慢速度去看的那些。

## 它在流程中的位置 (Where it fits)

當建構成果以 pull request 的形式出貨時，`pr` 位在審查和 retro 之間：`to-spec → to-tickets → implement → code-review → pr → retro`。它是 model-invoked 的，所以每當 agent 在那條流程鏈之外寫 PR 內文時，它也會自己觸發。

- [code-review](https://aihero.dev/skills-code-review) 在它之前執行，因為 PR 內文應該描述一份已經審查過的 diff。
- [implement](https://aihero.dev/skills-implement) 產出內文所描述的 commits。

當你不確定這個情況需要哪個 skill 時，[ask-matt](https://aihero.dev/skills-ask-matt) 會在整套 skill 中幫你導向。
