> 繁體中文翻譯。原文：[README.md](../../../skills/engineering/README.md)

# Engineering

我每天在程式碼工作上用的 skill（技能包）。

## User-invoked

只有在你輸入它們時才能觸發（Claude Code：`disable-model-invocation: true`；Codex：`agents/openai.yaml` 裡的 `policy.allow_implicit_invocation: false`）。

- **[ask-matt](./ask-matt/SKILL.md)**：問問看哪個 skill 或流程適合你的情況。它是這個 repo（程式碼儲存庫）裡 user-invoked（使用者呼叫）skill 的 router（路由器：幫你導向正確的 skill）。
- **[grill-with-docs](./grill-with-docs/SKILL.md)**：一個 grilling session（拷問式對談），同時建立你專案的 domain model（領域模型），在過程中磨利術語，並直接更新 `GLOSSARY.md` 和 ADR（架構決策紀錄）。
- **[triage](./triage/SKILL.md)**：讓 issue（議題）在由 triage role（分類角色）組成的狀態機裡往前推進。
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)**：掃描 codebase（程式碼庫）找出 deepening opportunities（加深機會：可以把 module 做得更深的地方），把它們呈現成一份視覺化的 HTML 報告，然後針對你挑的那一個進行 grilling。
- **[setup-matt-pocock-skills](./setup-matt-pocock-skills/SKILL.md)**：替這個 repo 設定 engineering skill 需要的東西（issue tracker（議題追蹤工具）、triage 標籤、領域文件的版面配置）。每個 repo 執行一次。
- **[to-spec](./to-spec/SKILL.md)**：把目前的對話轉成 spec（規格），並發布到 issue tracker。
- **[to-tickets](./to-tickets/SKILL.md)**：把任何計畫、spec 或對話拆成一組 tracer-bullet（曳光彈：薄薄一層但端到端打通）ticket（工單），每個 ticket 都宣告自己的 blocking edges（阻擋關係），不管是寫成本機檔案裡的文字，還是寫成真正 tracker 上的原生 blocking 連結。
- **[implement](./implement/SKILL.md)**：完成 spec 或一組 ticket 描述的工作，在事先講好的 seam（接縫：可以觀察行為的公開邊界）上驅動 `/tdd`，並在 commit（提交）之前用 `/code-review` 收尾。
- **[implement-spec](./implement-spec/SKILL.md)**：在一個 integration branch（整合分支）上實作整份 spec。把 ticket 當成 task graph（任務圖）來處理，在已就緒的 frontier（前沿：目前可以開工的 ticket）上同時跑多個 implementer subagent（負責實作的子 agent），達到最大並行度，最後用 `/code-review` 收尾。
- **[wayfinder](./wayfinder/SKILL.md)**：規劃一大塊工作（多到一個 agent session（工作階段）裝不下），把它做成 issue tracker 上由 decision ticket（決策 ticket）組成的 shared map（共享地圖），一次解決一個，直到通往目的地的路變清楚。
- **[retro](./retro/SKILL.md)**：在一個 session 結束後，針對 coding agent 的環境（導覽、自動化檢查、程式碼規範、steering file（引導檔）、工具）提出改進建議，最嚴重的排最前面。

## Model-invoked

model（模型）或使用者都能觸發（使用豐富的 trigger（觸發條件）用語，讓 model 能自動取用它們）。

- **[prototype](./prototype/SKILL.md)**：做一個用完即丟的 prototype（原型）來回答一個設計問題：狀態／邏輯問題就做成單一個可分享的 HTML 檔，或做成幾個可以切換的 UI 版本。

- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)**：針對難纏 bug 與效能退化的紀律化診斷迴圈：建立一個會因為這個 bug 變紅的回饋迴圈 → 縮小範圍 → 提出假設 → 加上量測 → 修正 → 回歸測試。
- **[research](./research/SKILL.md)**：對照高可信度的 primary source（一手來源）調查一個問題，並把發現寫成 repo 裡一份附引用的 Markdown 檔，以 background agent（背景 agent）的方式執行。
- **[tdd](./tdd/SKILL.md)**：用 red-green-refactor（紅燈、綠燈、重構）迴圈進行測試驅動開發。一次一個 vertical slice（垂直切片），建立功能或修正 bug。
- **[domain-modeling](./domain-modeling/SKILL.md)**：主動建立並磨利專案的 domain model，方法是檢驗用語、用情境做壓力測試，並直接更新 `GLOSSARY.md` 和 ADR。
- **[codebase-design](./codebase-design/SKILL.md)**：設計 deep module（深模組）的共同紀律與詞彙：小的 interface（介面）、乾淨的 seam、可以透過 interface 測試。
- **[code-review](./code-review/SKILL.md)**：針對某個固定點之後的 diff（差異）做雙軸審查：**Standards**（標準：是否遵守 repo 的程式碼規範，再加上 Fowler 的 code smell 基準？）和 **Spec**（是否忠實實作了原始的 issue／spec？），兩者用平行的 sub-agent（子 agent）執行。
- **[pr](./pr/SKILL.md)**：pull request 內文應有的樣子：用能讓變更一目了然的最小視覺呈現當摘要，附上前後對照證明它可以運作，再加上合併風險的判斷（單向門或雙向門，以及影響範圍）。
- **[wizard](./wizard/SKILL.md)**：產生一個互動式 bash 精靈，一步步帶人完成只有人能做的步驟：佈建基礎設施、設定憑證或 CI secret、操作不熟悉的第三方儀表板，或執行一次性的遷移或切換。
