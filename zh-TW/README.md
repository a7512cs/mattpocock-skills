> 繁體中文翻譯。原文：[README.md](../README.md)

<p>
  <a href="https://www.aihero.dev/s/skills-newsletter">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skills-repo-dark_2x.png">
      <source media="(prefers-color-scheme: light)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png">
      <img alt="Skills" src="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png" width="369">
    </picture>
  </a>
</p>

# 真正工程師用的 skill (Skills For Real Engineers)

[![skills.sh](https://skills.sh/b/mattpocock/skills)](https://skills.sh/mattpocock/skills)

我每天用來做真正工程的 agent（AI 代理）skill（技能包），不是 vibe coding（憑感覺寫程式）。

開發真正的應用程式很難。GSD、BMAD 和 Spec-Kit 這類方法想靠接管整個流程來幫忙。但這樣做的同時，它們拿走了你的控制權，也讓流程裡的 bug 很難解決。

這些 skill 的設計是小巧、容易調整、可以組合。它們適用於任何 model（模型）。它們建立在數十年的工程經驗上。盡情拿來改著玩。把它們變成你自己的。好好享受。

如果你想追蹤這些 skill 的變更，以及我之後新做的 skill，可以加入我的電子報，和其他大約 60,000 名開發者一起：

[訂閱電子報](https://www.aihero.dev/s/skills-newsletter)

## 安裝（30 秒設定） (Installation (30-second setup))

plugin（外掛）會自己更新。[skills.sh](https://skills.sh/mattpocock/skills) 會把可編輯的檔案複製到你的專案裡，你要自己手動更新。每個 agent 選一種就好，因為兩種都裝的話，每個 skill 都會出現兩次。

### 1. 取得 skill (Get the skills)

<details>
<summary><strong>Claude Code</strong></summary>

```bash
claude plugin install mattpocock-skills@claude-plugins-official
```

預設會自己更新。

</details>

<details>
<summary><strong>Codex</strong></summary>

```bash
codex plugin marketplace add mattpocock/skills
codex plugin add mattpocock-skills@mattpocock
```

啟動時會自己更新。

</details>

<details>
<summary><strong>GitHub Copilot</strong>（CLI 和 VS Code）</summary>

```bash
copilot plugin marketplace add mattpocock/skills
copilot plugin install mattpocock-skills@mattpocock
```

接著，只需要做一次，把下面這段加到 `~/.copilot/settings.json`：

```json
{
  "extraKnownMarketplaces": {
    "mattpocock": { "source": { "source": "github", "repo": "mattpocock/skills" }, "autoUpdate": true }
  }
}
```

在 VS Code 裡，執行 **Chat: Install Plugin From Source**，然後輸入 `https://github.com/mattpocock/skills`。它每天會更新。

</details>

<details>
<summary><strong>Gemini CLI</strong>（手動更新）</summary>

```bash
gemini skills install https://github.com/mattpocock/skills.git --path skills/engineering
gemini skills install https://github.com/mattpocock/skills.git --path skills/productivity
```

要更新時，重新執行這兩個指令。

</details>

<details>
<summary><strong>其他任何 agent，或可編輯的檔案</strong>（手動更新）</summary>

```bash
npx skills@latest add mattpocock/skills -a <agent>  # cursor, opencode, devin, windsurf, amp, pi; omit -a to choose
```

安裝程式問你要裝哪些 skill 時，記得包含 `setup-matt-pocock-skills`。要更新時，執行 `npx skills@latest update`；要取得新的 skill，就重新執行 `add`。

</details>

### 2. 執行 `/setup-matt-pocock-skills` (Run `/setup-matt-pocock-skills`)

在你的 agent 裡，每個 repo（程式碼儲存庫）執行一次。它會：

- 問你想用哪個 issue tracker（議題追蹤工具）：GitHub、GitLab、本機檔案，或任何你描述的其他工具
- 問你在 triage（分類處理）ticket（工單）時會貼哪些標籤（`/triage` 會用到標籤）
- 問你想把我們產生的文件存在哪裡

### 3. 搞定，你可以開始了。 (Bam - you're ready to go.)

## 為什麼會有這些 skill (Why These Skills Exist)

我做這些 skill，是為了修正我在 Claude Code、Codex 和其他 coding agent 上常看到的失敗模式。

### #1：agent 沒做我想要的事 (#1: The Agent Didn't Do What I Want)

> 「沒有人確切知道自己想要什麼」
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**問題**。軟體開發最常見的失敗模式是沒有對齊。你以為開發者知道你要什麼。接著你看到他們做出來的東西，才發現對方根本沒聽懂你。

在 AI 時代也一樣。你和 agent 之間有溝通落差。解法是 **grilling session**（拷問式對談）：讓 agent 針對你正在做的東西，問你很詳細的問題。

**解法**是使用：

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md)：用在非程式碼的情境
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md)：和 [`/grill-me`](./skills/productivity/grill-me/SKILL.md) 一樣，但多了更多好東西（見下方）

這些是我最受歡迎的 skill。它們幫你在開始之前和 agent 對齊，並深入思考你要做的變更。_每一次_想做變更時都用它們。

### #2：agent 太囉嗦了 (#2: The Agent Is Way Too Verbose)

> 有了 ubiquitous language（通用語言），開發者之間的對話和程式碼的表達，全都來自同一個 domain model（領域模型）。
>
> Eric Evans, [Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**問題**：專案剛開始時，開發者和他們替之開發軟體的人（領域專家）通常說著不同的語言。

我和我的 agent 之間也有同樣的拉扯。agent 通常是被直接丟進一個專案，然後被要求邊做邊搞懂專案裡的行話。所以 1 個字就能說完的事，它們要用 20 個字。

這個問題的**解法**是共享語言。它是一份文件，幫 agent 解讀專案裡用到的行話。

<details>
<summary>
範例
</summary>

這是一個 [glossary](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md)（詞彙表）範例，來自我的 `course-video-manager` repo（在那個固定的 commit（提交）上，它還叫 `CONTEXT.md`，那是 skill 改掉這個命名慣例之前的事）。哪一個比較好讀？

- **之前**：「當課程某個章節裡的一堂課被變成『真的』（也就是在檔案系統裡有了一個位置）時，會出問題」
- **之後**：「materialization cascade（實體化連鎖）有問題」

這種精簡在一個又一個 session（工作階段）裡持續帶來回報。

</details>

這已經內建在 [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) 裡。它是一個 grilling session，但它會幫你和 AI 建立共享語言，並把難以解釋的決策記錄在 ADR（架構決策紀錄）裡。

很難解釋這有多強大。它可能是這個 repo 裡最酷的一個技巧。試試看就知道了。

> [!TIP]
> 共享語言除了減少囉嗦，還有很多其他好處：
>
> - **變數、函式和檔案的命名會一致**，都使用共享語言
> - 因此，對 agent 來說，**codebase（程式碼庫）比較好瀏覽**
> - agent 也會**花比較少的 token（詞元）在思考上**，因為它能使用更精簡的語言

### #3：程式碼不能動 (#3: The Code Doesn't Work)

> 「永遠踏出小而審慎的步伐。回饋的頻率就是你的速限。永遠不要接下太大的任務。」
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**問題**：假設你和 agent 對要做什麼已經達成共識。如果 agent _還是_做出垃圾，怎麼辦？

這時候就該檢查你的回饋迴圈了。如果沒有回饋告訴它，它產出的程式碼實際執行起來如何，agent 就是在盲飛。

**解法**：你需要常見的那一批回饋迴圈：靜態型別、瀏覽器存取，以及自動化測試。

對自動化測試來說，red-green-refactor（紅燈、綠燈、重構）迴圈非常關鍵。也就是 agent 先寫一個會失敗的測試，然後再修好這個測試。這能給 agent 一致程度的回饋，進而產出好得多的程式碼。

我做了一個 **[`/tdd`](./skills/engineering/tdd/SKILL.md) skill**，你可以把它放進任何專案。它鼓勵 red-green-refactor，並給 agent 大量指引，告訴它好的測試和壞的測試差在哪裡。

針對除錯，我也做了一個 **[`/diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md)** skill，把最佳的除錯做法包裝成一個有紀律的迴圈，每個階段都要過關才能往下走。

### #4：我們做出了一團爛泥 (#4: We Built A Ball Of Mud)

> 「_每天_都要投資在系統的設計上。」
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> 「最好的 module（模組）是深的。它們讓你透過簡單的 interface（介面）存取大量功能。」
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**問題**：大多數用 agent 做出來的應用程式都很複雜、很難修改。因為 agent 能大幅加快寫程式的速度，它們也同時加速了軟體的熵增。codebase 以前所未見的速度變得越來越複雜。

這個問題的**解法**，是一種激進的全新 AI 開發方式：在乎程式碼的設計。

這點內建在這些 skill 的每一層裡：

- [`/to-spec`](./skills/engineering/to-spec/SKILL.md) 在建立 spec（規格）之前，會先考問你要動到哪些 module

最關鍵的是，[`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) 會掃描 codebase，找出 deepening opportunities（加深機會：可以把 module 做得更深的地方），然後把候選項目交給你。我建議每隔幾天就對你的 codebase 跑一次。它是一次勘查，不是一次救援：在真正老舊的 codebase 上，它會找到真正的候選項目，但它不會幫你把那團爛泥理清。

### 總結 (Summary)

軟體工程的基本功比以往任何時候都重要。這些 skill 是我盡最大努力，把這些基本功濃縮成可重複的做法，幫你交付職涯中最好的應用程式。好好享受。

## 參考 (Reference)

這些 skill 依一個軸線分成兩類：誰可以呼叫它們。**User-invoked**（使用者呼叫：只有人能觸發）skill 只有在你輸入它們時才能使用（例如 `/grill-me`）；它們的工作是統籌協調。**Model-invoked**（模型呼叫：模型也能自動觸發）skill 可以由你呼叫，_或_在任務合適時由 agent 自動取用；它們承載可重複使用的紀律。user-invoked skill 可以呼叫 model-invoked skill，但絕不能呼叫另一個 user-invoked skill。

### Engineering

我每天在程式碼工作上用的 skill。

**User-invoked**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)**：問問看哪個 skill 或流程適合你的情況。它是這個 repo 裡 user-invoked skill 的 router（路由器：幫你導向正確的 skill）。
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**：一個 grilling session，同時建立你專案的 domain model，在過程中磨利術語，並直接更新 `GLOSSARY.md` 和 ADR。
- **[triage](./skills/engineering/triage/SKILL.md)**：讓 issue（議題）在由 triage role（分類角色）組成的狀態機裡往前推進。
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**：掃描 codebase 找出 deepening opportunities，把它們呈現成一份視覺化的 HTML 報告，然後針對你挑的那一個進行 grilling。
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)**：替這個 repo 設定 engineering skill 需要的東西（issue tracker、triage 標籤、領域文件的版面配置）。在使用其他 engineering skill 之前，每個 repo 執行一次。
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**：把目前的對話轉成 spec，並發布到 issue tracker。不會再訪談你，只是整合你已經討論過的內容。
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**：把任何計畫、spec 或對話拆成一組 tracer-bullet（曳光彈：薄薄一層但端到端打通）ticket，每個 ticket 都宣告自己的 blocking edges（阻擋關係），可以寫成本機檔案裡的文字，或寫成真正 tracker 上的原生 blocking 連結。
- **[implement](./skills/engineering/implement/SKILL.md)**：完成 spec 或一組 ticket 描述的工作，在事先講好的 seam（接縫：可以觀察行為的公開邊界）上驅動 `/tdd`，並在 commit 之前用 `/code-review` 收尾。
- **[implement-spec](./skills/engineering/implement-spec/SKILL.md)**：在一個 integration branch（整合分支）上實作整份 spec。把 ticket 當成 task graph（任務圖）來處理，在已就緒的 frontier（前沿：目前可以開工的 ticket）上同時跑多個 implementer subagent（負責實作的子 agent），達到最大並行度，最後用 `/code-review` 收尾。
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**：規劃一大塊工作，多到一個 agent session 裝不下，把它做成 issue tracker 上由 decision ticket（決策 ticket）組成的 shared map（共享地圖），然後一次解決一個，直到通往目的地的路變清楚。
- **[retro](./skills/engineering/retro/SKILL.md)**：在一個 session 結束後，針對 coding agent 的環境（導覽、自動化檢查、程式碼規範、steering file（引導檔）、工具）提出改進建議，最嚴重的排最前面。

**Model-invoked**

- **[prototype](./skills/engineering/prototype/SKILL.md)**：做一個用完即丟的 prototype（原型）來回答一個設計問題，可以是單一個可分享的 HTML 檔（用於狀態／邏輯問題），也可以是幾個截然不同、能從同一個 route 切換的 UI 版本。
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**：針對難纏 bug 與效能退化的紀律化診斷迴圈：建立一個會因為這個 bug 變紅的回饋迴圈 → 縮小範圍 → 提出假設 → 加上量測 → 修正 → 回歸測試。
- **[research](./skills/engineering/research/SKILL.md)**：對照高可信度的 primary source（一手來源）調查一個問題，並把發現寫成 repo 裡一份附引用的 Markdown 檔，以 background agent（背景 agent）的方式執行。
- **[tdd](./skills/engineering/tdd/SKILL.md)**：用 red-green-refactor 迴圈進行測試驅動開發。一次一個 vertical slice（垂直切片），建立功能或修正 bug。
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**：主動建立並磨利專案的 domain model：拿 glossary 檢驗用語，用邊界情境做壓力測試，並直接更新 `GLOSSARY.md` 和 ADR。
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**：設計 deep module（深模組）的共同紀律與詞彙：小小的 interface 背後藏著大量行為，放在乾淨的 seam 上，可以透過那個 interface 測試。
- **[code-review](./skills/engineering/code-review/SKILL.md)**：針對某個固定點之後的 diff（差異）做雙軸審查：**Standards**（標準：是否遵守 repo 的程式碼規範，再加上 Fowler 的 code smell 基準？）和 **Spec**（是否忠實實作了原始的 issue／spec？），兩者用平行的 sub-agent（子 agent）執行，讓彼此不會互相汙染。
- **[pr](./skills/engineering/pr/SKILL.md)**：pull request 內文應有的樣子：用能讓變更一目了然的最小視覺呈現當摘要，附上前後對照證明它可以運作，再加上合併風險的判斷（單向門或雙向門，以及影響範圍）。
- **[wizard](./skills/engineering/wizard/SKILL.md)**：產生一個互動式 bash 精靈，一步步帶人完成只有人能做的步驟：佈建基礎設施、設定憑證或 CI secret、操作不熟悉的第三方儀表板，或執行一次性的遷移或切換。

### Productivity

通用的工作流程工具，不限於程式碼。

**User-invoked**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**：針對一個計畫或設計被毫不留情地訪談，直到 design tree（設計樹）的每個分支都有結論。
- **[handoff](./skills/productivity/handoff/SKILL.md)**：把目前的對話壓縮成一份 handoff（交接）文件，讓另一個 agent 能接手繼續工作。
- **[teach](./skills/productivity/teach/SKILL.md)**：在多個 session 中教使用者一項新技能或新概念，把目前的目錄當成有狀態的教學工作區。
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**：把一個你無法獨自回答的決策，變成一份 Markdown 問卷，交給那個能回答的人，可以非同步填寫，或在會議中一起填。它 grill 的是你要怎麼送出這份問卷（給誰、你需要拿回什麼），而不是問題本身的主題。
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**：在某則訊息你沒看懂的那一刻，就觸發它。agent 會補上你缺少的 context（脈絡），用淺白的英文和你 `GLOSSARY.md` 裡的詞彙，重新說一次。

**Model-invoked**

- **[grilling](./skills/productivity/grilling/SKILL.md)**：針對一個計畫、決策或想法毫不留情地訪談使用者，直到 design tree 的每個分支都有結論。它是 `grill-me`、`grill-with-docs`、`triage`、`wayfinder` 和 `improve-codebase-architecture` 背後共用、可重複使用的訪談基本元件。
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**：替 agent 撰寫文件：skill、AGENTS.md/CLAUDE.md，以及任何 agent 透過指標連過去的文件。
