> 繁體中文翻譯。原文：[diagnosing-bugs.md](../../../docs/engineering/diagnosing-bugs.md)

## 它做什麼 (What it does)

`diagnosing-bugs` 針對難纏的 bug 或效能退化（performance regression），執行六個階段的診斷：建立重現案例、把它縮到最小、為假設排序、加入觀測程式碼（instrumentation）、修正並加上回歸測試、清理。

在一個 **tight**（緊密）的回饋迴圈存在之前，它不會讓 agent（代理：會自己執行工具、完成任務的 AI）形成任何理論：這個迴圈是一個有名字的指令，已經執行過一次，在*這個* bug 上會變 red（紅燈：測試失敗），修好後會變 green（綠燈：測試通過）。拿到一份 bug 回報時，coding agent 預設會讀程式碼然後猜。這個 skill（技能）擋下這件事。如果不存在能變 red 的指令，就沒有第 2 階段。這個 skill 存在的目的就是那一道關卡。迴圈一旦存在，之後的一切（二分搜尋、驗證假設、觀測程式碼）都是機械性的工作。

## 什麼時候用它 (When to reach for it)

輸入 `/diagnosing-bugs`，或是當任務合適時，agent 會自己使用它。它是 model-invoked（可由 model 自動呼叫）的，會在 "diagnose"（診斷）或 "debug this"（除錯這個）時觸發，或是在有人回報某個東西壞了、丟出例外、失敗或很慢時觸發。

把它用在難的問題上：第一眼解不了的 bug、時有時無的不穩定失敗、在兩個已知正常的狀態之間引入的退化。它刻意設計得又慢又徹底，所以如果你想要一則訊息就得到答案，它就是錯的工具。

| 你的情況 | 該去哪裡 |
| --- | --- |
| 一個你能用症狀描述的具體缺陷 | 這個 skill |
| 一個很慢的 endpoint，或一個已知前後狀態的時間效能退化 | 這個 skill。它有一個效能分支（先量測基準值，再二分搜尋） |
| 「這個 codebase（程式碼庫）的瓶頸在哪？」，沒有具體症狀 | 不是這個 skill。它診斷一個已知的失敗，它不做稽核 |
| 別人給的原始 bug 回報，還沒確認，也還沒整理成文 | 先用 [triage](https://aihero.dev/skills-triage) |
| 用來回答設計問題的拋棄式程式碼，不是追查缺陷 | [prototype](https://aihero.dev/skills-prototype) |
| 以測試先行的方式實作一個規劃好的行為 | [tdd](https://aihero.dev/skills-tdd) |
| bug 修好後，想問什麼原本可以預防它 | [retro](https://aihero.dev/skills-retro)，在同一個 session（工作階段）裡執行 |
| 沒有好的 seam（接縫：可以觀察行為的公開邊界）能把 bug 鎖住 | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture)，由你自己啟動 |

## Tight 迴圈就是這個 skill 本身 (The tight loop is the skill)

第 1 階段花最多力氣，因為它是唯一困難的階段。這個 skill 列出建立迴圈的方法，大致依偏好順序排列：

1. 在任何能碰到這個 bug 的 seam 上寫一個會失敗的測試。
2. 對執行中的開發伺服器跑 curl 或 HTTP 腳本。
3. 用 fixture（測試用的固定資料）當輸入呼叫 CLI，再和已知正確的 snapshot 做 diff（比對差異）。
4. 一個 headless 瀏覽器腳本，對 DOM、console 或網路請求做斷言。
5. 重播擷取下來的資料：把存下來的 request、payload 或事件 log，單獨送進該段程式碼路徑執行。
6. 拋棄式的 harness（測試用的執行外殼）：系統的最小子集，一次函式呼叫。
7. property 測試或 fuzz（模糊測試）迴圈，用於「有時輸出錯誤」的情況。
8. 一個可以交給 `git bisect run` 的二分搜尋 harness。
9. 差異比對迴圈：同樣的輸入，舊版對新版。
10. 一個 [human-in-the-loop](https://www.aihero.dev/ai-coding-dictionary/human-in-the-loop)（需要人參與的）bash 腳本，最後手段。這個 skill 為此附了 `scripts/hitl-loop.template.sh`：agent 執行這個腳本，你在終端機裡照著提示操作，你的回答會以可解析的輸出傳回來。

目標不是*有*一個迴圈。目標是 **tight**：快（幾秒內）、確定性（每次執行都得到同樣的判定）、精準（斷言的是你確切的症狀，而不是「沒有 crash」），而且 agent 不需要你就能自己執行。一個 30 秒又時好時壞的迴圈，只比沒有好一點點。對於只是偶爾出現的 bug，目標不是乾淨的重現，而是**更高的重現率**：重複觸發、平行執行、加壓、插入 sleep，直到失敗率高到足以拿來除錯。

當 agent 建不出迴圈時，skill 要它停下來並說明，列出它試過什麼，然後向你要求 [environment](https://www.aihero.dev/ai-coding-dictionary/environment)（環境）的存取權、一份擷取下來的產物，或加入暫時性觀測程式碼的許可。它絕不可以照樣繼續形成假設。

## 階段之間的關卡 (The gates between phases)

這些階段是關卡，不是檢查清單。在某個特定條件成立之前，agent 不能進入該階段。

| 關卡 | 必須成立的條件 |
| --- | --- |
| 進入第 2 階段 | 一個有名字的指令，已經執行過並連同輸出貼出來，而且在這個 bug 上能變 red |
| 進入第 3 階段 | 重現案例已經重現，*而且*已經縮到最小：剩下的每個元素都是重現 bug 所必需的 |
| 進入第 4 階段 | 已有 3 到 5 個排好序、可證偽的假設，每個都寫出它的預測，並在任何一個被測試之前給你看過 |
| 進入第 5 階段 | 每個探測都對應到一個具體預測，一次只改一個變數，每一條 debug log 都有像 `[DEBUG-a4f2]` 這樣的標籤，所以一次 grep 就能全部找出來清掉 |
| 完成 | 原本的重現案例不再重現，觀測程式碼已移除，而且 commit（提交）訊息寫出最後證實正確的那個假設 |

第 5 階段有一個例外。agent 會在修正之前先寫回歸測試，但前提是存在一個 **correct seam**（正確的 seam）：在這個 seam 上，測試會以 bug 在呼叫端實際發生的方式，去執行真正的 bug 模式。如果唯一可用的 seam 太淺，skill 會要 agent 直接說明，而不是寫一個帶來虛假信心的測試。缺少 seam 本身就是一項發現，agent 會把它記錄下來，而不是藏起來。

## 常見問題 (Common questions)

**我只是想要一個直接的回答，它卻在簡單的問題上被觸發。**
這是這個 skill 被回報最多的問題。尤其在 GPT-5.6-Sol 上，使用者回報它光是看到對問題的單純描述就被觸發：「model（模型）反而觸發了相當正式的 diagnosing-bugs skill。接著它會先建構一個重現情境（常常是建一個價值有限的 mock（模擬物件）情境），才給我回應或建議。這造成相當大的回覆延遲。」有四個不同的人在 [issue #578](https://github.com/mattpocock/skills/issues/578)（議題）回報了同樣的問題。大家接受的修正方式是先用較輕量的做法，只有在問題真的需要時才進入完整診斷，但這個改動還沒發布。這個 skill 是針對 Claude Code 的呼叫行為調校的，而觸發門檻較低的 [model](https://www.aihero.dev/ai-coding-dictionary/model) 會太常觸發它。在修正發布之前，變通方法是直接說出你要什麼（「直接回答就好，不要診斷」），或是在你的 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)（執行 agent 的外殼程式，例如 Claude Code）中關掉 model 對它的自動呼叫。

**我可以把它指向一個 codebase，問它效能問題在哪裡嗎？**
不行。它診斷的是一個你已經能說出名字的失敗。它的效能分支是給有症狀的退化用的（先建立基準量測，再二分搜尋，先量測、後修正），不是用來主動全面掃描的。主動版本的 skill 曾經[被提出並關閉](https://github.com/mattpocock/skills/issues/431)；目前沒有任何 skill 做這件事。

**它在寫修正之前會停下來問我嗎？**
不會。只有第 3 階段有人工檢查點：排好序的假設清單會在任何一個被測試之前給你看，如果你不在，agent 會照它自己的排序繼續。觀測程式碼和修正之間沒有關卡，所以 agent 可能在你同意它找到的根本原因之前，就開始寫程式碼。[Issue #124](https://github.com/mattpocock/skills/issues/124) 要求加上這道關卡，目前仍未關閉。如果你需要它，在呼叫 skill 時就說出來。

**我已經對這份 bug 回報執行過 `/triage` 了。這是在重做同樣的工作嗎？**
部分是，而且兩個 skill 都沒說明這一點。如同一位讀者說的：「Triage 的第 3 步本質上就是 diagnosing-bugs 第 1 到 2 階段的一個淺層、有範圍限制的版本，但兩個檔案都沒提到對方。」Triage 做的是有範圍限制的一輪檢查：「這真的是 bug 嗎，影響的表面在哪裡」；這個 skill 做的是徹底的版本。先執行 triage 不算浪費，因為它的驗證常常能提供第 1 階段大部分的原始材料。但要預期這個 skill 會把那些工作完整重做一次，也要預期不會有任何交叉參照告訴你這件事。

**它貼出的重現輸出會洩漏機密嗎？**
有可能。這個 skill 要求 agent 貼出呼叫指令和它的輸出，並索取 HAR 檔、log dump、core dump 這類產物。沒有任何指示要 agent 把它們去除敏感資訊。[Issue #674](https://github.com/mattpocock/skills/issues/674) 正是在講這件事（憑證、token（存取權杖）、cookie 和個人資料被複製進聊天、issue 或 PR（pull request）裡），並提議加一道遮蔽機密的防護機制。它仍未關閉，也還沒實作。目前請把遮蔽機密當成你自己的工作，尤其是在輸出要放到任何公開地方之前。

**我的資安掃描工具把這個 skill 標記為高風險。**
Snyk 會標記它，而這個標記是誤判。它是整套 skill 中唯一附帶可執行 shell 腳本（`hitl-loop.template.sh`）的 skill，同時還附有執行它、以及對開發伺服器下 curl 的指示。附帶的 `.sh` 檔、執行它的指示，加上對外的 HTTP，三者合起來就足以觸發靜態掃描工具。這個腳本本身大約 30 行，都是 `read -r -p` 提示，用來暫停等待人的輸入。掃描工具評估的是這個 skill 可能做什麼，而不是一個已被證實的漏洞利用。

**`/diagnose` 怎麼了？**
v1.0.0 把它改名為 `/diagnosing-bugs`。舊名稱已不存在。你任何串接了 `/diagnose` 的東西（包裝用的 skill、存下來的 prompt（提示詞））都需要更新。

## 運作正常的跡象 (It's working if)

- 它在提出任何一個理論之前，先給你看一個指令和它的 red 輸出。如果理論先出現，代表這個 skill 沒有在執行。
- 它重現的失敗就是你回報的那個，而不是它途中找到的某個相近的失敗。
- 它在開始猜測之前會先縮小重現案例，而且能告訴你為什麼需要剩下的每一部分。
- 在測試任何假設之前，它會給你看一份 3 到 5 個假設的排序清單，每個都附有一個你可以證偽的預測。
- 它加入的每一條 debug log 都帶有像 `[DEBUG-a4f2]` 這樣的標籤，而它宣告完成時，grep 這個標籤會找不到任何結果。
- commit 或 PR 訊息寫出哪個假設是對的。
- 當它無法用測試鎖住 bug 時，它會直接說明，而不是寫一個淺層的測試。

## 它在流程中的位置 (Where it fits)

`diagnosing-bugs` 是一個隨時都能拿來用的獨立 skill。東西壞掉時你啟動它，修正和它的回歸測試都進去之後它就結束。它不保留狀態，也不需要事先設定。[ask-matt](https://aihero.dev/skills-ask-matt) 會把 "Something's broken"（有東西壞了）導到這裡。

有兩個相鄰的 skill 很重要。[retro](https://aihero.dev/skills-retro) 在它之後：修正進去後，在同一個 session 裡執行它，問問什麼原本可以預防這個 bug，趁這個 session 擁有的資訊比一開始多的時候。`diagnosing-bugs` 自己絕不會呼叫 `retro`，因為 `retro` 是 user-invoked（只能由使用者呼叫）的。對於以別人的原始回報形式送來的 bug，[triage](https://aihero.dev/skills-triage) 在它之前，做的是同樣前兩個階段的淺層版本。
