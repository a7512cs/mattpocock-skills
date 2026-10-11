> 繁體中文翻譯。原文：[CHANGELOG.md](../CHANGELOG.md)

# mattpocock-skills

## 1.3.1

### 修補變更 (Patch Changes)

- [#1121](https://github.com/mattpocock/skills/pull/1121) [`c5b9869`](https://github.com/mattpocock/skills/commit/c5b98691982c4f0d3a5e40ab09566b3b84721e00) 感謝 [@mattpocock](https://github.com/mattpocock)！ - `ask-matt` 不再說 `diagnosing-bugs` 會在事後檢討（post-mortem）時交接給 `improve-codebase-architecture`；那個步驟已經移除了。它現在會在修正完成後引導你使用 `/retro`，去問什麼本來可以預防這個 bug；而當發現的問題是缺少某個 seam（接縫：可以觀察行為的公開邊界）時，則引導你使用 `/improve-codebase-architecture`。`diagnosing-bugs` 的 docs 頁面也拿掉了同樣過時的 hand-off（交接）。感謝 @Ygilany 發現這個問題（[#1117](https://github.com/mattpocock/skills/issues/1117)）。

## 1.3.0

### 次要變更 (Minor Changes)

- [#1120](https://github.com/mattpocock/skills/pull/1120) [`2aecca1`](https://github.com/mattpocock/skills/commit/2aecca12ea9ff047f76c8178cb64dfeafd192abe) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 **`implement-spec`** 畢業，進入 **Engineering**（工程）bucket（分類資料夾），這樣它會隨 Claude Code plugin（Claude Code 外掛）一起發佈、擁有 docs 頁面，並由 `ask-matt` 導引為逐張 ticket（工單）執行 `implement` 的平行替代方案。

  `implement-spec`（user-invoked，只能由使用者呼叫）一次執行就實作完整個 spec（規格）。它把 tickets 當作一張 **task graph**（任務圖）來讀，在已就緒的 **frontier**（前沿：前置條件都已完成、可以開始做的工作）上，讓多個 implementer subagent（負責實作的子 agent）各自在自己的 worktree 中工作，最後把所有成果落在同一條 **integration branch**（整合分支）上，並以 `code-review` 收尾。畢業之前做了這些調整：

  - 目標現在是 integration branch，而不是 PR（pull request）。只有在 issue tracker（議題追蹤系統）是透過 PR 來結案工作、或是你要求時，才會開一個 draft PR，而且只會在第一次 merge（合併）之後才開（一條沒有任何 commit（提交）領先 main 的 branch（分支）無法開 PR）。沒有 PR 時，tickets 會依照 tracker 結案工作的方式來結案。
  - 它和其他同系列的 skill（技能）一樣指向 issue tracker：在還沒提供 tracker 時，告訴你去執行 `/setup-matt-pocock-skills`，而不是默默預設使用 `gh`。
  - 每個 implementer 都會確認自己的 worktree 是以 integration branch 為基礎，用 `tdd` 實作自己的 ticket，並在回報完成之前，把 integration branch 的最新端（tip）merge 進自己的 branch，讓每次 merge 都是 fast-forward。

- [#1120](https://github.com/mattpocock/skills/pull/1120) [`2aecca1`](https://github.com/mattpocock/skills/commit/2aecca12ea9ff047f76c8178cb64dfeafd192abe) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 **`pr`** 畢業，進入 **Engineering** bucket，這樣它會隨 Claude Code plugin 一起發佈、擁有 docs 頁面，並由 `ask-matt` 導引為撰寫 PR 內文的收尾步驟。

  `pr`（model-invoked，模型也能自動呼叫）定義了 pull request 內文應有的樣貌：摘要要用能讓變更一目了然的最小視覺呈現（pseudocode、call tree、檔案樹、Mermaid、diff（差異）），提供改動前後確實可以運作的證據，以及 merge 風險的判斷（單向門或雙向門，加上 blast radius（爆炸半徑：影響範圍））。Summary 區段的視覺呈現改編自 Dex Horthy 的 `show-me`，並在這個 skill 的 `CREDITS.md` 中註明出處。

- [#1120](https://github.com/mattpocock/skills/pull/1120) [`2aecca1`](https://github.com/mattpocock/skills/commit/2aecca12ea9ff047f76c8178cb64dfeafd192abe) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 **`retro`** 畢業，進入 **Engineering** bucket，這樣它會隨 Claude Code plugin 一起發佈、擁有 docs 頁面，並由 `ask-matt` 導引為主流程的最後一步，排在 `code-review` 之後。

  `retro`（user-invoked）會回顧一次寫程式的 session（工作階段），並針對 agent（代理）的環境而不是程式碼提出修改建議：navigation pointer（導覽指標）、自動化檢查、程式碼規範、steering 檔案、工具使用效率、資訊取得。它會先把每一個與程式碼規範有關的發現分類：機械性的違規要配上一個確定性的檢查（linter 規則、pre-commit hook 或 CI（持續整合）job），而 `CODING_STANDARDS.md` 只保留給真正需要判斷的情況。一個完全沒有任何防護機制的 repo（程式庫），本身就是一項發現。

- [#1120](https://github.com/mattpocock/skills/pull/1120) [`daa01d8`](https://github.com/mattpocock/skills/commit/daa01d8aa68ad5c61b68970ec2018d0ce9567be6) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 移除 **`resolving-merge-conflicts`** skill。它已經不再需要，也沒有任何東西取代它：agent 不需要專用的 skill，就能處理進行中的 merge 或 rebase（變基）衝突。它會從 Claude Code plugin、README 和 `ask-matt` router（導引器）中移除。它位於 `https://aihero.dev/skills-resolving-merge-conflicts` 的 docs 頁面會繼續保留，並標記為已封存。

- [#1120](https://github.com/mattpocock/skills/pull/1120) [`006a52b`](https://github.com/mattpocock/skills/commit/006a52be23e0178375e083e30535fa8224471f3e) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 把 `CONTEXT.md`/`CONTEXT-MAP.md` 這個 domain doc（記錄領域知識的檔案）慣例，在所有 skill 讀寫它的地方都改名為 `GLOSSARY.md`/`GLOSSARY-MAP.md`（`domain-modeling`、`grill-with-docs`、`improve-codebase-architecture`、`setup-matt-pocock-skills`、`triage`、`tdd`、`diagnosing-bugs`、`ask-matt`、`codebase-design`、`wait-what`、`pr`），另外也包括 docs 頁面，以及本 repo 自己根目錄的 glossary（詞彙表）。

  如果你有這次變更之前就存在的 `CONTEXT.md`（或 `CONTEXT-MAP.md`），請用 `git mv` 把它改成新名稱：之後 skill 只會尋找 `GLOSSARY.md`/`GLOSSARY-MAP.md`。

### 修補變更 (Patch Changes)

- [#848](https://github.com/mattpocock/skills/pull/848) [`f02e2ed`](https://github.com/mattpocock/skills/commit/f02e2ed3624d031272f8547742d23bf6bca8b072) 感謝 [@mattpocock](https://github.com/mattpocock)！ - domain-modeling：在討論 codebase（程式碼庫）術語時，以及直接撰寫或編輯 GLOSSARY.md 或 ADR（架構決策紀錄）時 trigger（觸發），取代原本範圍較窄的 "pin down domain terminology or a ubiquitous language"（確立領域術語或通用語言）/ "record an architectural decision"（記錄架構決策）寫法。另外也拿掉了 "another skill needs to maintain the domain model"（另一個 skill 需要維護領域模型）這個但書，因為那是呼叫它的 skill 應該明確說明的事，而不是這段 description（描述）的工作。

- [#911](https://github.com/mattpocock/skills/pull/911) [`4f28947`](https://github.com/mattpocock/skills/commit/4f289474bad013fe2be8f8769d733f59d9103d6b) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 替 `to-spec`、`code-review`、`setup-matt-pocock-skills`、`writing-fragments`、`writing-shape` 和 `wait-what` 的 `description` front matter（檔頭設定區）加上引號。[#905](https://github.com/mattpocock/skills/issues/905) 清除 em-dash（破折號）時，遺留了一個沒有引號的「冒號加空格」，讓每個區塊都變成無效的 YAML，所以 `skills.sh` 在探索階段跳過了全部六個 skill，導致它們無法透過 `npx skills` 列出或安裝。

- [#917](https://github.com/mattpocock/skills/pull/917) [`85f83d3`](https://github.com/mattpocock/skills/commit/85f83d3fde1d3a90d5c9a657f6998c79a6c37308) 感謝 [@mattpocock](https://github.com/mattpocock)！ - grilling：更新 round（回合）範本，讓連續的問題之間用水平分隔線（`---`）隔開，而不是全部連在一起。

- [#879](https://github.com/mattpocock/skills/pull/879) [`d419977`](https://github.com/mattpocock/skills/commit/d419977fe07d9e1607d3523f3579310bbb076b93) 感謝 [@mattpocock](https://github.com/mattpocock)！ - grilling：移除 `SKILL.md` 中的 em-dash，改用冒號和分號，讓指令讀起來就是一般的文字。

- [#905](https://github.com/mattpocock/skills/pull/905) [`e6e9577`](https://github.com/mattpocock/skills/commit/e6e957797d8cceb5b351c0dc840369523f9fb8fb) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 移除 repo 敘述文字中的每一個 em-dash（docs、`SKILL.md` 檔案、ADR、`README.md`、腳本、JSON/YAML metadata），每個句子都用逗號、冒號、句號、括號或連接詞手動改寫，而不是機械式地替換那個字元。`CLAUDE.md`/`AGENTS.md` 現在寫明不要再把它們加回來。

- [#878](https://github.com/mattpocock/skills/pull/878) [`e3e547b`](https://github.com/mattpocock/skills/commit/e3e547b57d549110a0aa6ff40fd7b871c01c76c9) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 把跨 skill 的呼叫方式統一成明確的 "call the Skill tool"（呼叫 Skill 工具）指令，而不是只寫 `/skill` 形式的敘述，範圍涵蓋 `code-review`、`diagnosing-bugs`、`grill-with-docs`、`grill-me`、`improve-codebase-architecture`、`tdd`、`to-spec`、`to-tickets`、`triage` 和 `wayfinder`。

  - 一個 skill 如果只在敘述中提到另一個 skill（"run the `/grilling` skill"（執行 `/grilling` skill）），並不能可靠地讓它被載入。這是一個已記錄的不完善之處，也是 `grill-with-docs` 最常被回報的問題背後的原因。直接點名工具（`Call the Skill tool with "grilling"`）是為了提高命中率。拿掉開頭的 `/` 也讓這個指令變得與 harness（執行環境）無關，而不是更依賴某個 harness：它不再假設 Claude Code 的 trigger 語法。
  - 需要多個 skill 的步驟，現在會寫成多次呼叫（"Call the Skill tool twice, for `grilling` and `domain-modeling`"（呼叫 Skill 工具兩次，分別載入 `grilling` 和 `domain-modeling`）），而不是一次呼叫裡帶兩個名字。
  - 在 `.agents/invocation.md` 中記錄這個慣例，讓之後的 skill 遵循。

- [#880](https://github.com/mattpocock/skills/pull/880) [`1dab982`](https://github.com/mattpocock/skills/commit/1dab98299c3b81f560026c01b7ebf55ed5d91373) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 阻止 skill 透過 Skill 工具去呼叫 user-invoked skill：修正 `to-spec`、`wayfinder`、`to-tickets`、`triage`、`code-review` 和 `diagnosing-bugs` 中，違反 `.agents/invocation.md` 裡 "no other skill can call it"（其他 skill 都不能呼叫它）這條不變規則的跨 skill 參照。

  - `to-spec`、`wayfinder`、`to-tickets`、`triage` 和 `code-review` 各自帶有一個前置條件（"...run `/setup-matt-pocock-skills` if not"（……若沒有，就執行 `/setup-matt-pocock-skills`）），而 PR [#878](https://github.com/mattpocock/skills/issues/878) 把它改寫成字面上的 `Call the Skill tool with "setup-matt-pocock-skills"` 指令。`setup-matt-pocock-skills` 是 user-invoked，所以這些 skill（不論是 user-invoked 還是 model-invoked）都不能呼叫它。五處都已改寫成指示 agent 改為告訴人類去執行它。
  - `diagnosing-bugs` 的 Phase 6 事後檢討也用同樣的方式交接給 `improve-codebase-architecture`（同樣是 user-invoked），而且是在一個自主執行、經常無人看管的修 bug 流程中，沒有人類在迴圈中接住失敗的呼叫。直接移除了這個 hand-off，而不是把它改得溫和一點，因為實際上它很少觸發。Phase 6 現在只剩 "Cleanup"（清理）；機械式的檢查清單沒有變動。
  - 在 `.agents/invocation.md` 的 "Dependencies between them"（它們之間的相依關係）區段加了一段例外說明：`Call the Skill tool with "name"` 這個慣例只適用於被點名的 skill 是 model-invoked 的情況。這個區段是 PR [#878](https://github.com/mattpocock/skills/issues/878) 加入的，但當時沒有和它上方八行處寫明的 user-invoked/model-invoked 不變規則對齊；這個落差就是這個 bug 擴散到六個呼叫點、而不是只有一個的主要原因。

  修正 [#453](https://github.com/mattpocock/skills/issues/453)。

- [#904](https://github.com/mattpocock/skills/pull/904) [`594f0f8`](https://github.com/mattpocock/skills/commit/594f0f83188921a60d45d63d6cdac509de20df2c) 感謝 [@mattpocock](https://github.com/mattpocock)！ - wait-what：當 repo 用 `GLOSSARY-MAP.md` 來索引多個 context（領域範圍），而不是在根目錄只放一個 `GLOSSARY.md` 時，會順著 `GLOSSARY-MAP.md` 找到正確的 `GLOSSARY.md`。

## 1.2.3

### 修補變更 (Patch Changes)

- [#779](https://github.com/mattpocock/skills/pull/779) [`efce423`](https://github.com/mattpocock/skills/commit/efce423018fc6468a3239621f1c1bcaacc723801) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 `diagnosing-bugs` 遮蔽機密資訊（redact secrets）。

  - 在 `SKILL.md` 中加入 **Redact**（遮蔽）區段。這個 skill 會讓 agent 顯示指令、輸出和擷取到的產物；這個區段讓遮蔽成為處理每一項時的第一步：寫成 `<REDACTED>`、建立迴圈時改用環境變數，讓憑證留在環境中，並且只引用擷取產物中帶有關鍵訊號的那幾行。
  - Phase 1 的完成條件原本寫著 "paste the invocation and its output"（貼上呼叫指令和它的輸出）。現在改成要顯示遮蔽過的版本，而且 Phase 1 會向使用者要一份**遮蔽過的**擷取產物。
  - 在 `scripts/hitl-loop.template.sh` 中註明 `capture` 會把它的值印回終端機，所以它用來記錄觀察結果，而登入仍然要用 `step`。

- [#781](https://github.com/mattpocock/skills/pull/781) [`14bfbbd`](https://github.com/mattpocock/skills/commit/14bfbbd8654a8d2910299e1a004c19c1979687d8) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 從 `code-review`、`codebase-design` 和 `improve-codebase-architecture` 派發 subagent 的指令中，拿掉 Claude Code 專屬的工具名稱和 agent 類型名稱，讓這個步驟在 Codex 和其他 harness 上也能照著做。

- [#783](https://github.com/mattpocock/skills/pull/783) [`c0fd1e9`](https://github.com/mattpocock/skills/commit/c0fd1e973e040347d424e09934099f1bd6c2dee0) 感謝 [@mattpocock](https://github.com/mattpocock)！ - wizard：移除時間預估。範本拿掉了 `TOTAL_MINUTES` 和剩餘時間的顯示，`stage` 只接受名稱，而進度改以 stage 的數量計算。

## 1.2.2

### 修補變更 (Patch Changes)

- [#766](https://github.com/mattpocock/skills/pull/766) [`4aaccb5`](https://github.com/mattpocock/skills/commit/4aaccb58d40559d7e3c59a029b2290ae5ba538de) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 `writing-for-agents` 在 Codex 中再次可以由 model（模型）自動呼叫（model-invokable）。

  - 從 `agents/openai.yaml` 拿掉 `policy.allow_implicit_invocation: false`。Codex 原本會把這個 skill 從 model 看得到的 skill 清單中過濾掉，所以它的 description 無法 trigger 它：只有明確寫出 `$writing-for-agents` 才有用。
  - 更新過時的 `interface.display_name` 和 `interface.short_description`，它們還寫著舊的 `writing-great-skills` skill。
  - 在 `README.md` 和 `skills/productivity/README.md` 中，把這個 skill 從 **User-invoked** 清單移到 **Model-invoked** 清單。

## 1.2.0

### 次要變更 (Minor Changes)

- [#551](https://github.com/mattpocock/skills/pull/551) [`697d4ce`](https://github.com/mattpocock/skills/commit/697d4ce9742da558fd1ba6697c8e9775e2e302dd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 在每個 skill 的 Claude Code frontmatter 旁邊加上 Codex metadata，讓整套 skill 不需要產生副本，就能在兩種 harness 中運作。

  - 在每個 `SKILL.md` 旁邊加一個 `agents/openai.yaml`，內含 Codex UI metadata（`interface.display_name`、`interface.short_description`）。
  - 把每個 user-invoked skill 標上 `policy.allow_implicit_invocation: false`，這是 Codex 中對應 `disable-model-invocation: true` 的設定，讓 Codex 把它排除在隱式呼叫之外，同時明確的 `$skill` 呼叫仍然有效。
  - 在 `.agents/invocation.md`、`CLAUDE.md` 和 promoted（正式推出的）bucket 的 README 中，記錄雙 harness 的呼叫模式。
  - 新增 `AGENTS.md`，作為指向 `CLAUDE.md` 的 symlink，讓 Codex 讀到同一份 repo 指示。

- [#593](https://github.com/mattpocock/skills/pull/593) [`0f2bdbd`](https://github.com/mattpocock/skills/commit/0f2bdbdb06220d2df3718b8f0483157c6c8a8600) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 **`to-questionnaire`** 從 `in-progress/` 畢業，進入 **Productivity**（生產力）bucket，這樣它會隨 plugin 一起發佈。它會把一個你無法獨自回答的決定，轉成一份 Markdown 問卷，交給唯一能回答的那個人：可以非同步填寫，也可以在會議中一起討論完成。

  它最關鍵的做法是：它拷問你的是 **send**（寄送這件事），而不是主題本身。一般的 grilling（拷問式提問）session 會追問主題，而那正是你在這裡答不出來的，所以這個訪談只問這份問卷要給誰、你需要拿回什麼，然後把每個問題都對準兩者之間的落差。

  現在已經以 promoted skill 的身分接好所有設定：plugin 條目、頂層與 Productivity 的 README 中列在 **User-invoked** 底下、位於 `docs/productivity/to-questionnaire.md` 的 docs 頁面，以及 `ask-matt` 中的一條 Standalone（獨立使用）路線，把它定位為 `/grill-me` 的反向版本（挖掘別人，而不是你自己）。

- [#680](https://github.com/mattpocock/skills/pull/680) [`b3376f8`](https://github.com/mattpocock/skills/commit/b3376f8d39848dd08572ec2667da4739a67c8c04) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 **`wizard`** 從 `in-progress/` 畢業，進入 **Engineering** bucket，這樣它會隨 plugin 一起發佈，並且把它改成 model-invoked。它會產生一個互動式的 bash 腳本，帶著人類一步步完成手動程序（第三方服務設定、一次性的遷移、A→B 的狀態轉換）：打開每個 URL、說明要點哪裡、擷取數值，並把它們寫進 `.env` 檔案和 GitHub Actions secrets。

  令人愉快的 UX 已經由附帶的 `template.sh` 預先解決（帶剩餘時間的進度顯示、確認關卡、跨平台開啟 URL（包含 WSL）、隱藏輸入的 secret、冪等的 `.env` upsert、可以優雅降級的 `gh secret`/`gh variable` 寫入、結尾的略過摘要）。`STAGES` 標記以上的所有內容都是固定的函式庫，永遠不手動編輯：這個 skill 的工作只是界定程序的範圍，並撰寫它的 **stages**（階段）。

  放在 Engineering 而不是 Productivity：它會讀取 `.env*`、`docker-compose*`、框架設定，以及 `.github/workflows/` 中每一個 `secrets.*`/`vars.*` 參照來界定自己的範圍，會寫入 CI secrets，並用 `bash -n` 和 `shellcheck` 驗證自己的輸出。

  因為它是 model-invoked，agent 一碰到只有人類能完成的步驟，就能馬上使用它，而不是把一串編號指示丟進聊天中，然後希望你照著做。輸入 `/wizard` 的效果和以前完全一樣：model-invocation 只會 _增加_ agent 能觸及的範圍。description 被寫成決定它何時觸發的指標：它會產出什麼、四個 trigger 分支（佈建基礎設施、設定憑證或 CI secrets、走過不熟悉的第三方 dashboard、一次性的遷移或切換），以及一個明確的不觸發條件：agent 自己能完成的步驟，不要呼叫它。agent 能做的工作，就該由 agent 做；wizard 是給那些你不會交給 agent 的點擊、核准和 dashboard 操作用的。在寫下任何一行之前的 stage 清單確認，現在在 agent 於建置途中觸發它時，也同時作為提案。

  現在已經以 promoted skill 的身分接好所有設定：plugin 條目、頂層與 Engineering 的 README 中列在 **Model-invoked** 底下、位於 `docs/engineering/wizard.md` 的 docs 頁面，以及 `ask-matt` 中一條給只有人類能做的步驟使用的 Standalone 路線。改成 model-invoked 也讓它不受 [#693](https://github.com/mattpocock/skills/issues/693) 影響，該問題會讓 Claude 桌面版和網頁版的 skill 清單中不顯示 user-invoked skill。

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 圍繞兩個概念重塑 **`prototype`** skill：展示用的成品是**單一一個可分享的 HTML 檔案**，而 prototype（原型）本身是**一份 primary source（第一手資料）**。

  邏輯分支現在會產出一個自給自足的檔案（純 HTML/CSS/JS，不用 build、不用 server），而不是終端機 app：非開發者雙擊就能打開它，並用他們自己的領域語言來操作：一個有標籤的狀態面板、隨時可用的自由操作按鈕，以及一組分頁式的 **guided walkthroughs**（引導式操作流程），每一個都是一個情境，下方列出依序要按的按鈕。可攜的純邏輯 module（模組）仍然可以搬進真正的程式碼中；HTML 外殼才是用完即丟的部分。

  用完即丟不再代表刪除。prototype 在回答完它的問題之後不會被移除，而是以可執行證據的形式，保存在一條從 main 分出去的拋棄式 branch（`prototype/<name>`）上，並在實作用的 issue（議題）上留下一個指向它的 context pointer（上下文指標）：這樣 main branch 只保留驗證過的決定，而探索的過程仍然找得到。答案（結論 + 問題）仍然會持久地記錄在 issue/ADR/commit 中。

- [#536](https://github.com/mattpocock/skills/pull/536) [`42a5b70`](https://github.com/mattpocock/skills/commit/42a5b70fcacc7baff1977b13f3919fb2f63af14e) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 把這套 skill 以原生 **Claude Code plugin** 的形式發佈，並列在 Claude Code 官方的 marketplace（市集）上。你現在可以把 promoted skill 當作一個受管理、唯讀的套件來訂閱，而不用複製可編輯的檔案：

  ```bash
  claude plugins install mattpocock-skills
  ```

  或者，在 session 內執行：

  ```
  /plugin install mattpocock-skills
  ```

  不需要先加入任何 marketplace：官方 marketplace 預設就已經設定好了。

  `.claude-plugin/plugin.json` 帶有完整的 plugin metadata（version、description、author、license、keywords），以及明確列出的 promoted skill 清單。`skills.sh` 仍然是通用的安裝工具（也是目前 Codex 和其他 harness 的安裝途徑）；原生的 Codex plugin 延後處理，原因請見 `.agents/adr/0002-ship-as-a-claude-code-plugin.md`。

- [#751](https://github.com/mattpocock/skills/pull/751) [`355fa74`](https://github.com/mattpocock/skills/commit/355fa7420b418af838998f7ec4365ceda1c8dfcc) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 新增 **`wait-what`**：一個只用一個詞來矯正 model 囉嗦的工具。當某則訊息讓你看不懂時，馬上輸入它，agent 就會重新表達一次：補上一點 context（上下文）、使用 ASD-STE100 簡化技術英文（Simplified Technical English），以及你 `CONTEXT.md` 中的 ubiquitous language（通用語言）。User-invoked，只有三行。

  機制就在名字本身。追求簡潔的 skill 會因為越長越大而失敗（一個 400 行的 skill 還是會讓 model 很囉嗦），所以這個 skill 就只是一個精準的 leading word（引導詞），沒有別的。描述 _輸出_ 的名字（`/tldr`、`/no-fluff`）會讓 model 刪減字數，反而讓你更看不懂；點出 _聽者_ 的狀態，則能一次要到兩半：更少的字，**以及**你原本缺少的 context。它也重複使用你全域 `CLAUDE.md` 中已經有的 leading word，讓這個 skill、`CLAUDE.md` 和每個 `CONTEXT.md` 都用同樣的 token（詞元）。

  它修補的是一則訊息；它無法預防下一則。治療術語過多的方法，是事先用 `/grill-with-docs` 建立一套共同語言；這個 skill 是你還沒有共同語言時用的。

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 把 `/wayfinder` 的單位命名為 **decision ticket**（決策工單），並用 subagent 消化 research ticket。

  大家一直把 wayfinder 的 ticket 讀成一般的 _實作_ ticket（要執行的一小段建置工作），但 wayfinder 其實是把它們當作 **decision tickets** 使用：這些 ticket 是問題，而問題的解答就是一個決定。skill 的 description 和它的開頭第一行現在會介紹這個術語（並說明什麼讓它成為 decision ticket），`ask-matt` 與 engineering README 的簡介以及 docs 頁面也同步配合；術語建立之後，"ticket" 仍然是日常用詞。`CONTEXT.md` 把 **Decision ticket** 記錄為領域術語，所以 "avoid: ticket"（避免使用：ticket）這條指引，不再和 wayfinder 刻意使用這個詞相衝突。

  research ticket 不再被擱置著，等另外啟動的 session 來處理。research 仍然是一種真正的 ticket 類型：它是下游決策所依賴的真正共同阻礙，而這種相依關係，正是 frontier 的 blocking edges（阻擋關係）存在要呈現的東西。改變的是它被解決的方式：因為 research 是 AFK（agent 可以獨自完成，不需要人類在場），繪製地圖（charting）的過程不會停下來讀它。建立 tickets 之後，負責繪製的 session 會為每個 research ticket 啟動一個 `/research` subagent，平行消化它們，把發現記錄在拋棄式的 `research/<name>` branch 上，並附上 context pointer。research ticket 是 _每個 session 一個 ticket_ 這條規則的唯一例外。

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) 感謝 [@mattpocock](https://github.com/mattpocock)！ - **Breaking（破壞性變更）：** 把 **`writing-great-skills`** 改名為 **`writing-for-agents`**、重新調整它的結構，並加入一個新的 leading word。

  這份參考資料現在涵蓋 agent 會讀取的任何文字資料（skill、`AGENTS.md` / `CLAUDE.md`、透過指標連到的 docs），而不只是 skill。`GLOSSARY.md` 已併入 `SKILL.md`（每個術語只有一處權威說明；`_Avoid_` 同義詞清單和獨立的 Predictability（可預測性）定義都拿掉了）；只和 skill 有關的機制（frontmatter、model-invoked 與 user-invoked 的差異、router skill、依呼叫方式拆分 skill）則移到新的 `SKILL-MECHANICS.md` 中，需要時再讀。這個 skill 現在是 **model-invoked**：在建立或編輯 skill，或修改 `AGENTS.md`/`CLAUDE.md` 時觸發。`ask-matt` 的指標已更新。請用新名稱重新安裝；舊名稱已經移除（沒有別名）。

  精簡（pruning）區段新增了 **cache**（快取）。單一事實來源（single source of truth）現在延伸到文字之外的環境中：`package.json` 的 scripts、設定檔、目錄結構、`--help` 的輸出本身就是權威來源，所以重述它們的說明只是查詢結果的快取，只有在查詢成本很高時才值得被載入。正面的目標是：把 agent 靠查看找不到的東西寫成快取（沒寫下來的慣例、某個選擇背後的理由、任何設定檔都不會透露的陷阱），而只需看一個檔案、跑一個指令就能查到的東西，就留給環境，在那裡它們不會過時。

- [#533](https://github.com/mattpocock/skills/pull/533) [`45afd80`](https://github.com/mattpocock/skills/commit/45afd8074a8b7de5fe073845d080fa9dd6c429fa) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 替 **`improve-codebase-architecture`** skill 的 Explore 步驟加入一個 YAGNI 範圍篩選。它不再平均地掃描整個 repo，而是聚焦在實際發生變更的地方：如果你指定了方向，它就照著走；否則它會讀取最近約 20 筆 commit 訊息，讓探索偏向正在積極開發的路徑。在沒人碰的程式碼中找到的 deepening opportunity（深化機會），是一個你永遠兌現不了的 refactor（重構）：leverage（槓桿效益）只有在你持續編輯的地方才會回本。所以報告不再整理 repo 中沉寂的角落。

### 修補變更 (Patch Changes)

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 強化 `/ask-matt`：router 現在涵蓋 phase boundary（階段邊界）、wayfinder 的兩個常見錯誤，以及兩個它從未提過的 skill。

  **階段邊界（Phase boundaries）。** **phase**（階段）是 session 中的一段工作（grilling、實作、QA），而兩個 phase 之間的邊界，就是你決定如何處理已經建立起來的 context 的地方。原本只有兩個清單項的 `Crossing sessions` 區段，換成了一個依序列出全部五個選項的決策樹（**continue**、`/clear`、`/handoff`、**subagent**、`/compact`），推理過程則放在新的 `PHASE-BOUNDARIES.md` 中。同時帶來三個修正：

  - **`/handoff` 被過度推銷了。** 它讀起來像是在不同 context window（上下文視窗）之間通用的橋樑。但它的用途很窄：只有當某些東西需要 _移動_ 時才需要它，也就是換到新的 harness、新的目錄、交給同事，或是在 phase 中途分出的支線任務。它帶來的是可攜性。
  - **`/compact` 是兜底的預設選項，不是第一個該用的。** 它位於決策樹的最底部，排在上面四個更便宜或更精確的問題之後。一開始就用它，會產生一個對摘要所壓扁的內容自信地出錯的 session。
  - **有兩個分支完全不見了。** **Continue**（繼續）是第一個要先考慮並排除的選項：它是唯一能讓對話保持為 primary source（第一手資料）、而不是變成某份摘要的做法；而 **subagent** 則處理任何範圍夠明確、可以 AFK 執行的事。

  Context hygiene（context 清潔習慣）的緊急出口現在寫的是 `/compact`，而不是 `/handoff`（同一個 harness、同一個目錄、在邊界上：handoff 的適用條件不成立），而 smart zone（聰明區間）的數字也從約 120k 更新為約 150k token。

  **Wayfinder 的導引（Wayfinder routing）。** 大家在這個最重、最耗腦力的流程上最常犯的兩個錯誤：

  - **太輕易就用它。** 它比單次 grill 更慢、更密集，所以被標為最重的流程，只留給真的塞不進一個 session 的想法：範圍明確的功能應該用 `/grill-with-docs`，而不是這裡。
  - **在 handoff 時迷了路。** 當 map（地圖）完成時，wayfinder 是交接出去，而不是自己動手建置：在 `/to-spec` 匯入主流程（它會把 map 中相互連結的決策收斂成一份可以建置的計畫），而不是讓 map 直接接到 `/implement`。直接進 `/implement` 只適用於最後發現其實真的很小的工作。

  **缺少的路線（Missing routes）。** `/grilling` 和 `/resolving-merge-conflicts` 原本完全不在 router 中，現在已經加進去了；而 `grill-me` 和 `grill-with-docs` 的分界在於你是否處在一個工作目錄中。

- [#502](https://github.com/mattpocock/skills/pull/502) [`44eed54`](https://github.com/mattpocock/skills/commit/44eed545186ffd0263e8004867750b80cfddd215) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 `/setup-matt-pocock-skills` 更友善，並讓 local-markdown tracker 和目前的 spec 一致。

  - **Triage labels**（分流標籤）現在只有在安裝了 `triage` skill 時才會詢問，而且只問一個建議回答 yes 的問題（"keep the default triage labels?"（要保留預設的 triage labels 嗎？）），而不是一連串要你決定是否覆寫的盤問。沒有安裝 `triage` 時，這個區段（以及 `docs/agents/triage-labels.md`）會被跳過。
  - **External PRs as a request surface**（把外部 PR 當作請求來源）不再是設定時會問的問題。GitHub/GitLab 範本仍然帶有這個旗標，預設為關閉；使用者之後可以在 `docs/agents/issue-tracker.md` 中切換它。
  - **Domain docs**（領域說明檔）預設為單一 context，不會詢問；只有在 repo 顯示出 monorepo 的跡象時，才會提供多 context 的選項。
  - **Local-markdown tickets**（本機 Markdown ticket）現在是每個 ticket 一個檔案，放在 `.scratch/<feature>/issues/<NN>-<slug>.md` 底下，絕不會是單一一個合併的 `tickets.md`。`/to-tickets` 和本機 issue tracker 範本現在一致了，而 spec 檔案是 `spec.md`（不是 `PRD.md`），以配合 `/to-spec`。

  `setup-matt-pocock-skills` 和 `to-tickets` 的 docs 頁面已重新同步。

- [#532](https://github.com/mattpocock/skills/pull/532) [`170ad48`](https://github.com/mattpocock/skills/commit/170ad48655825783d0193e850e31a9aac957bb95) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 改寫 **`grilling`** 的用字，讓它適用於一般用途。它的 description 和內文不再把訪談限定在軟體計畫上："this plan"（這個計畫）→ "this"（這個）、"enact the plan"（執行計畫）→ "act on it"（付諸行動）、"exploring the codebase"（探索 codebase）→ "exploring the environment"（探索環境）。技巧本身沒有改變；它現在讀起來就是對任何計畫、決定或想法的壓力測試。

- [#593](https://github.com/mattpocock/skills/pull/593) [`a4b2009`](https://github.com/mattpocock/skills/commit/a4b2009a1a3ac9575506c10b4c84f08f9bba7a38) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 把 **`grilling`** 從一次問一題改成一回合一回合地問。它現在會畫出決策樹，並在一個編號的回合中問完整個 **frontier**（所有前置條件都已確定的問題），然後根據使用者的回答重新計算 frontier，再問下一回合。同樣的 13 個問題，大約 3 回合就能問完，而不是 13 回合。環境本身能回答的事實，會派給 background sub-agent（在背景執行的子 agent）處理，所以研究永遠不會卡住回合：只有依賴某個進行中探索的問題才需要等它。frontier 清空時，session 就結束。

  回合中的每個問題都用同一個固定格式輸出：先是 `❓ **Q1** - **<title>**`，接著是內文（敘述或多選項），然後是單獨放在 `➡️` 那一行的建議。一個回合讀起來就是一份容易掃讀的編號清單，每個建議都在視覺上和問題分開，所以你可以直接用編號回答，而不用把問題引用回去。

  `grill-me`、`grill-with-docs` 和 `triage` 也同樣一次跑一回合 frontier：`triage` 的 grill 步驟和 `grilling` 的 Codex `short_description` 現在都改成這樣寫，而不是描述舊的節奏。想維持一次問一題的退出設定（在你全域 `CLAUDE.md` 中加一行）沒有改變。

- [#752](https://github.com/mattpocock/skills/pull/752) [`c66bdee`](https://github.com/mattpocock/skills/commit/c66bdeeee002d81e3f8b21403c07f9a0d7bea6da) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 從 repo 中移除六個 skill。它們都不在 Claude Code plugin 中，但六個都可以透過 [skills.sh](https://skills.sh/mattpocock/skills) 安裝，而它會提供 repo 中的每一個 skill。所以以下就是從那份清單中消失的 skill，以及它們各自的去向。

  四個退役的 skill，每一個都已經被做得更好的 skill 吸收：

  - **`ubiquitous-language`** → **`/domain-modeling`**，它會建立並維護整個 domain model（領域模型），而不是從一段對話中傾倒出一份 glossary。
  - **`design-an-interface`** → **`/codebase-design`**。沒有任何東西遺失："design it twice"（設計兩次）技巧（讓平行的 sub-agent 產生截然不同的設計，出自 Ousterhout）以 `DESIGN-IT-TWICE.md` 的形式包含在那個 skill 裡。
  - **`qa`** → **`/triage`** 和 **`/to-tickets`**。
  - **`request-refactor-plan`** → **`/to-spec`** 和 **`/improve-codebase-architecture`**。

  還有兩個從頭到尾都只屬於我自己的 skill：綁定在我自己的機器上，從來就不是給別人用的。`personal/` bucket 也跟著一起移除：

  - **`edit-article`**
  - **`obsidian-vault`**，它把我自己 Obsidian vault 的路徑寫死在裡面。

  `skills/deprecated/` 仍然保留為一個 bucket，現在是空的。`skills/in-progress/` 沒有變動，現在的描述也符合它實際的定位：一個刻意公開的 beta 管道，可以透過 skills.sh 一次安裝一個 skill。

- [#734](https://github.com/mattpocock/skills/pull/734) [`a2f9333`](https://github.com/mattpocock/skills/commit/a2f9333669ff53db762c87ecda5a15442060a3be) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 完成 `to-prd` → `to-spec` 的改名："spec" 現在是發佈內容中唯一使用的詞。

  - **`to-spec`** 不再以 "you may know this document as a PRD"（你可能知道它叫做 PRD）開頭：這段括號說明已經從 skill 和它的 docs 頁面中拿掉。local-markdown tracker 範本也拿掉了同樣的保留說法。
  - **`code-review`** 在它的 frontmatter description、雙軸摘要，以及 spec 來源的搜尋順序中，都改成講原始的 issue/spec，而不是 issue/PRD。兩份 README 都已重新同步。
  - **GitHub 和 GitLab 的 tracker 範本**現在寫的是 "Issues and specs for this repo live as GitHub/GitLab issues"（這個 repo 的 issue 和 spec 以 GitHub/GitLab issue 的形式存放）：更新本機範本時，它們還停留在 "PRDs"，所以這個過時的詞擴散到了每一個寫入這些範本的 repo。
  - **`docs/engineering/research.md`** 原本指向 `https://aihero.dev/skills-to-prd`，這是改名後的 skill 已經失效的網址；現在它像其他十九個 docs 頁面一樣連到 `to-spec`。

  CHANGELOG（變更紀錄）和現有的 changeset（變更集）在記錄這次改名本身的地方，仍然會提到 PRD，這是正確的。

## 1.1.0

### 次要變更 (Minor Changes)

- [#406](https://github.com/mattpocock/skills/pull/406) [`930a450`](https://github.com/mattpocock/skills/commit/930a450089f77a49af09001d955db8452a4b867d) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 **`ask-matt`** router 跟上完整的 skill 組合。它現在納入了五個原本缺少的 skill：**`tdd`**（編進主流程，作為 `implement` 所驅動的 red-green（紅燈→綠燈）引擎）、**`diagnosing-bugs`**（新的 "Something's broken"（有東西壞了）入口，之前沒有任何處理 bug 的路線）、**`domain-modeling`** 和 **`codebase-design`**（新的 "Vocabulary underneath"（底層詞彙）區段），以及 **`grilling`**（共用的訪談基本元件）。`prototype` 被充實為一個 standalone（獨立使用）條目，而 description 也從 "user-invoked skills"（所有 user-invoked skill）擴大為 "the skills"（這些 skill）。`CLAUDE.md` 新增一條維護規則：未來任何 skill 的新增、改名、移除或流程變更，都會觸發重新檢查 `ask-matt`，和既有的 docs 頁面重新同步規則並列。

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 把 **`code-review`** promote（升為正式推出的 skill）並強化。原本在 in-progress（測試中）的 **`review`** skill 改名為 **`code-review`**，並從 `in-progress/` 移到 `engineering/`：它現在會隨 plugin 一起發佈，列在頂層與 Engineering 的 README 中（Model-invoked），並在 `docs/engineering/code-review.md` 有 docs 頁面。`/implement` skill 和 docs 都改為指向 `/code-review`。

  它也在 Standards 軸上加入一個永遠開啟的 **Fowler smell baseline**（Fowler 程式碼異味基準）：精選約 12 個高訊號的 "Bad Smells in Code"（程式碼壞味道：Mysterious Name、Duplicated Code、Feature Envy、Data Clumps、Primitive Obsession、Repeated Switches、Shotgun Surgery、Divergent Change、Speculative Generality、Message Chains、Middle Man、Refused Bequest），直接寫進 `SKILL.md`，作為和 repo 自己記錄的規範並列的固定基準，而不是新的第三個軸。兩條強制規則確保它的安全：repo 有記錄的規範優先於這個基準，而且每個 smell 都以需要判斷的問題來回報，絕不當成硬性違規。

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 從兩方面強化 **`grilling`**。

  **確認關卡（A confirmation gate）。** 在你確認已經達成共同理解之前，agent 不會執行計畫：這把 skill 原本的 "shared understanding"（共同理解）完成條件，變成一個明確的停止關卡。`description` 也借用了預訓練中就有的 **`grill`** leading word（"Grill the user relentlessly"（毫不留情地拷問使用者）），讓呼叫更精準，docs 頁面也已重新同步。

  **事實與決定（Facts vs. decisions）。** grilling 現在把 _事實_（去查：探索 codebase）和 _決定_（每一個都交給人類，並等待他們的回答）分開。舊的那條一體適用的規則（"if a question can be answered by exploring the codebase, explore the codebase instead"（如果某個問題可以靠探索 codebase 回答，就改去探索 codebase））是為了有真人在場的情況寫的，但一旦另一個 skill 在「解決這張 ticket」的框架中執行 grilling，它讀起來就像也允許 agent 自主回答 _決定_。把兩者分開，可以避免 grilling 的 agent 搶先一步，自己回答自己的問題。

- [#463](https://github.com/mattpocock/skills/pull/463) [`af6d692`](https://github.com/mattpocock/skills/commit/af6d6922c3e2b5288eef155346cbe319e4ed3bd0) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 在 **`writing-great-skills`** 中加入兩個相鄰的 Steering（引導）失敗模式，兩者講的都是：你以為已經「關掉」的語言，其實仍在引導 agent。**Negation**（否定），也就是 _大象_，是用禁止來引導：說出 _不要_ 做什麼，會把被禁止的行為拉進 context，讓它 _更_ 容易出現，而不是更少（_不要去想大象_），所以解法是用 **positive**（正面）的方式來下 prompt（提示詞）。**Negative Space**（負空間），也就是空白處，是看不見你 _省略_ 的東西所造成的引導：skill 每拒絕做一個決定，就是把它交給 agent 的既有傾向（priors），而不是保持中立，所以解法是閱讀草稿時找出它沉默的地方，並刻意決定每一處省略（補上，或作為真正的 **branch**（分支）保留開放）。保留成兩個條目而不是一個（它們有不同的診斷方式和不同的解法），每個都是完整的 `GLOSSARY.md` 條目，外加一個 `SKILL.md` 中的失敗模式清單項，和其他所有失敗模式的寫法一致。

- [`850873c`](https://github.com/mattpocock/skills/commit/850873cd73d5f81826ebf512ad35d2b1e113001f) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 **`prototype`** skill 變成 model-invoked，讓 agent 可以自主使用它（其他 skill 也可以）。它的 description 圍繞 leading word _prototype_ 重寫（用完即丟、用來回答設計問題的程式碼），每個分支各有一個 trigger（狀態/邏輯的合理性檢查，或 UI 探索）。

- [#409](https://github.com/mattpocock/skills/pull/409) [`0d74d01`](https://github.com/mattpocock/skills/commit/0d74d01cbc64ca27778a49b38599f70c534e76a0) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 新增 **`research`** skill：一個小型、model-invoked 的 skill，會啟動一個 **background agent**（背景 agent），根據 **primary sources** 調查某個問題（官方 docs、原始碼、spec、第一方 API），然後在 repo 存放這類筆記的地方，留下一個附有引用來源的 Markdown 檔案。它是可以委派出去的閱讀苦工：它在閱讀時你可以繼續工作，最後拿回一份可以拿來 grill、規劃或設計的文字資料。已列入頂層與 Engineering 的 README（Model-invoked）、加入 `.claude-plugin/plugin.json`、在 `docs/engineering/research.md` 有 docs 頁面，並在 `ask-matt` 中作為 Standalone 路線。

- [#469](https://github.com/mattpocock/skills/pull/469) [`a0329ba`](https://github.com/mattpocock/skills/commit/a0329ba95751f58566ed7ab484475917a68f1629) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 把 **`to-issues`** skill 拆成精簡的 **Process**（流程）和 **Reference**（參考）兩個區段，並教它處理 **wide refactor**（大範圍重構）：一個單一的機械性變更（例如重新命名一個欄位），它的 **blast radius** 擴散到整個 codebase，一次弄壞數千個呼叫點，導致沒有任何 vertical slice（垂直切片）能以綠燈狀態落地。草擬步驟現在指向兩個放在一起的參考區塊：給一般 tracer bullet（曳光彈：先打通端到端的最小實作）用的 **Vertical slice rules**（垂直切片規則），以及 **Wide refactors**（大範圍重構），它用 **expand-contract**（先擴展、後收縮）來切分變更（先在舊形式旁邊擴展出新形式，依 blast radius 決定批次大小來分批遷移呼叫點，最後把舊形式收縮移除），讓 CI 每一批都保持綠燈；或者，做不到的時候，只在最後一個整合與驗證的 issue 才轉為綠燈。issue 內文範本也移到 Reference 中。

- [#464](https://github.com/mattpocock/skills/pull/464) [`386d4ff`](https://github.com/mattpocock/skills/commit/386d4ff719a7c420ad1454232d0436b01f1b8c17) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 統一規劃類的 skill。**`to-prd` 改名為 `to-spec`**："spec" 現在是貫穿全程的唯一術語（為了讓人找得到，它開頭仍寫著 "you may know this document as a PRD"（你可能知道它叫做 PRD））。**`to-plan` 和 `to-issues` 合併成一個 `to-tickets` skill，並刪除 `to-issues`。**

  `to-tickets` 會把一個計畫、spec 或對話拆成一組 **tickets**：以 tracer bullet 方式切出的 vertical slice，每一張都宣告自己的 **blocking edges**。同一份產物會依 `/setup-matt-pocock-skills` 設定的 tracker 有兩種讀法：**本機檔案**（`tickets.md`）把 edges 寫成文字，由你手動從上到下處理；**真正的 tracker** 則把它們寫成原生的 blocking 連結，所以任何阻擋項都已完成的 ticket 就在 frontier 上，可以同時跑好幾個 agent。不論哪種方式，edges 都存在 ticket 裡：媒介只決定是否有東西會平行地依據它們行動。

  發佈時，若 tracker 支援，會優先用 tracker 的 **native sub-issues**（原生子 issue）表示 parent → slice 的關係，並用 **native blocking edges**（原生阻擋關係）表示 `Blocked by`，`## Parent` / `## Blocked by` 這兩個內文區段則保留作為備案。"What to build"（要建置什麼）範本會指向 `/prototype` 的程式碼所在位置，而不是把其中一段程式碼直接貼進來。

  `ask-matt` 的主流程現在導引為 `idea → /to-spec → /to-tickets → /implement`，並且在 `docs/engineering/to-spec.md` 和 `docs/engineering/to-tickets.md` 有給人看的 docs 頁面。

- [#464](https://github.com/mattpocock/skills/pull/464) [`0557d57`](https://github.com/mattpocock/skills/commit/0557d57579d9b3d39839fdaf8d4a6542b17539ce) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 在 docs 中確立 wayfinder 的定位：它是 **situational on-ramp**（視情況使用的入口），而不是新的主要入口流程。由 grill 帶頭的 _idea → ship_ 鏈仍然是正門（把 wayfinder 立為預設主幹是 v2 等級的大改動，不是 1.1 的事）。**`ask-matt`** router 現在會點出 wayfinder 的具體 trigger（全新的專案，或是一次塞不進一個 session 的巨大功能開發），而兩個 grill 正門（**`grill-me`**、**`grill-with-docs`**）會針對大到一個 session 裝不下的工作，_往上_ 指向 wayfinder，讓讀者從實際開始的地方就能發現這個入口。

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 **`wayfinder`** 畢業並重新定位：這是用來規劃一大塊工作的 skill，工作量超過一個 agent session 能承載的範圍。它從 `in-progress/` 移到 `engineering/`（plugin 條目、頂層與 Engineering 的 README 中列在 **User-invoked** 底下、位於 `docs/engineering/wayfinder.md` 的 docs 頁面，以及 `ask-matt` 中的一條路線），以成熟 skill 的身分登場。讓它走到這一步的改名與重新定位如下：

  - **`decision-mapping` 改名為 `wayfinder`**，以 `/wayfinder` 呼叫。"Decision map"（決策地圖）這個說法太術語化又不準確：只有一種 ticket 類型真的是決策。新的定位改為在一個迷霧重重的問題中規劃出一條路線，提供一個一致的 leading-word 框架（**fog of war**（戰爭迷霧）、**frontier**、**the map**（地圖）），而不是在上面再疊一個自創的術語。
  - **以 Destination（目的地）作為 leading word。** Wayfinding（尋路）是找到通往目的地的 _路_；它不會直接衝去建造。為目的地命名是繪製地圖的第一步（它決定範圍，並形塑每一張 ticket），所以 map 新增了一個 `## Destination` 欄位，每個 session 都以它為方向，而 triage（分流）會在任何 ticket 存在之前先把它定下來。
  - **規劃，而不是執行（Plan, don't do）。** map 產出的是 **決策，而不是交付物**；當有人開始建造之前已經沒有任何事需要決定時，它就完成了。個別工作可以在它的 Notes 中覆寫這條規則。
  - **map 是索引，不是儲存處。** 一個決策只存在於唯一一個地方：它的 ticket。所以 map 只寫重點並附上連結，從不重述；把迷霧升級成 ticket 時，會清掉已升級的那一塊，讓沒有任何內容同時留在兩個地方。
  - **預設就是協作式的。** map 從本機的 Markdown 檔案搬到 repo 的 issue tracker 上：一個單一的 `wayfinder:map` issue，它的 tickets 就是它的子 issue，團隊可以關注同一個共用網址。session 會以低解析度載入 map，需要時再放大查看個別 ticket。透過 `docs/agents/issue-tracker.md` 中的指標，Wayfinder 不綁定特定 tracker（GitHub、GitLab、local-markdown），而 `setup-matt-pocock-skills` 會預先建立 "Wayfinding operations"（Wayfinding 操作）區段。
  - **用指派來認領，而不是用 label。** session 透過把 ticket 指派給主導的開發者來認領它（被指派者 _就是_ 認領本身），讓 label 詞彙只剩下 `wayfinder:<type>`。
  - **原生阻擋關係（Native blocking）。** 阻擋關係優先使用 tracker 原生的相依關係，這樣 frontier 就會在 tracker 自己的 UI 中視覺化呈現，人類不用打開 map 就能看到哪些可以接手。GitHub 和 GitLab 範本詳細寫出原生的做法，並以內文慣例作為備案。
  - **把迷霧（fog）和 out of scope（範圍外）分開。** 兩個名稱直白的 map 區段：`## Not yet specified`（範圍內、會隨 frontier 推進而升級的迷霧）和 `## Out of scope`（被判定超出目的地的工作，已關閉，永遠不會升級），讓超出目的地的工作不再被讀成可以接手的 frontier。
  - **第四種 `task` ticket 類型。** 用於真的需要手動完成、而且會阻擋某個決策的工作（開通存取權限、搬移資料、註冊某項服務）：這是唯一一種是在 _做事_ 而不是做決定的類型，它的存在價值在於解除決策的阻擋。
  - **HITL / AFK ticket 分類。** 每種 ticket 類型都是 **HITL**（human in the loop，人類在迴圈中：grilling、prototype）或 **AFK**（agent 獨自完成：research；task 兩者皆可）。HITL ticket 只能透過即時的互動來解決，所以 "wait for the human"（等待人類）自然就從這個 label 推導出來：一個自己回答自己問題的 grilling agent，按定義就是破壞了 HITL。（這修正了學員回報的 `/wayfinder` 在 grill _它自己_ 而不是人類的問題。）
  - **恢復「沒有迷霧就提早結束」。** 如果一開始的廣度優先 grilling 沒有發現任何迷霧，這趟旅程就小到一個 session 就能完成，所以它會停下來問你想怎麼繼續，而不是建一張沒人需要的 map。

### 修補變更 (Patch Changes)

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 把 **`tdd`** 重塑成純參考型的 skill，並加入一個原本缺少的 anti-pattern（反模式）。

  **純參考（Reference-only）。** red → green → refactor 的迴圈已經由 model 本來就懂的 leading word 撐住了，所以一步一步的 Workflow 大部分只是在重述這個迴圈。拿掉了 Workflow 和每個循環的檢查清單；把它們唯一有長久價值的概念（vertical slice / tracer bullet）併入 Anti-patterns 區段和一份簡短的 Rules-of-the-loop（迴圈規則）清單中。引入 **seam** 作為決定測試放在哪裡的 leading word：只在事先講好的 seam 上測試，並在寫任何測試之前先和使用者確認。也拿掉了 refactor 階段：TDD（測試驅動開發）現在是 red → green；refactor 屬於 review 階段，所以 refactor 規則和 `refactoring.md` 都移出去了（它的歸屬是 `code-review`）。

  **套套邏輯測試（Tautological tests）。** 新增 tautological-test anti-pattern：如果一個測試的斷言是用和程式碼相同的計算方式重新算出來的，那它必然會通過，完全提供不了信心；這和已經涵蓋的「與 implementation（實作細節）耦合」anti-pattern 不同。它以同等地位加在相同的位置：一條 Philosophy（理念）原則（期望值必須來自獨立的事實來源）、一個檢查清單關卡，以及 `tests.md` 中的一組 BAD/GOOD 範例。

- [`e00eadb`](https://github.com/mattpocock/skills/commit/e00eadb4bb32c3d5a631ead1a5ed5d6a7c5f74e2) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 擴充 **`triage`** skill，讓它可以 triage 外部的 pull request：把 PR 視為附帶程式碼的 issue，走同樣的角色和狀態機。PR 和 issue 一起依序處理（由每個 repo 的設定開關控制），搜尋時只會列出外部 PR，原本只針對 bug 的 "reproduce"（重現）步驟被一般化成單一的 "verify the claim"（驗證這個說法）步驟，而且有一個重複檢查，會把已經實作過的請求標為 `wontfix`，而不會汙染 out-of-scope 知識庫。`setup-matt-pocock-skills` 新增了針對 GitHub/GitLab 的「把 PR 當作請求來源」開關。

- [#472](https://github.com/mattpocock/skills/pull/472) [`d869d45`](https://github.com/mattpocock/skills/commit/d869d45afc32beab1c2d1350f8de5e81589512cd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 修正 **`wayfinder`** 把 issue tracker 說明檔路徑寫死的問題，這破壞了整套 skill 其他部分所依賴的間接參照。

  `to-issues`、`to-prd` 和 `triage` 從不直接寫出路徑：它們透過 `setup-matt-pocock-skills` 寫進 `CLAUDE.md` / `AGENTS.md` 的 `### Issue tracker` 區塊來找到 tracker，而這個區塊會指向 tracker 說明檔，不管它放在哪裡。Wayfinder 卻寫死了 `docs/agents/issue-tracker.md` 這個字面路徑，所以在把 agent 說明檔放在其他地方的 repo 中，它會默默退回使用 local-markdown tracker，即使該 repo 的 `CLAUDE.md` 明確宣告使用 GitHub issues 也一樣。它現在透過同一個指標找到說明檔，並依名稱讀取其中的 "Wayfinding operations" 區段，讓整套 skill 的間接參照保持一致。

## 1.0.1

### 修補變更 (Patch Changes)

- [`d20ee26`](https://github.com/mattpocock/skills/commit/d20ee2684e2a9442698ac3c1e0f2c5b68c4cf296) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 讓 **`teach`** skill 以重用為優先。課程現在由 `./assets/` 中可重用的 **components**（元件）組成：樣式表、測驗小工具、模擬器、圖表輔助工具。重用是預設做法：agent 在撰寫課程前會先讀 `./assets/`，用現有的東西來建構，並把任何新的、可重用的內容抽出成元件，而不是直接寫在課程裡。

## 1.0.0

### 主要變更 (Major Changes)

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 新增 **`ask-matt`** skill：一個 user-invoked 的 router，會根據你的情況指引你使用正確的 skill 或流程。

  **Breaking（破壞性變更）：** `ask-matt` 會在本 repo 其他 user-invoked skill 之間做導引，所以它預期這些 skill 都已安裝。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 新增共用的設計類 skill，並讓既有的 skill 改為使用它們。

  - 新的 **`codebase-design`** skill：deep module（深模組）的詞彙（module、interface（介面）、depth（深度）、seam、adapter（轉接器））以及把大量行為放在小 interface 後面的原則。原本放在 `improve-codebase-architecture/LANGUAGE.md` 的語言現在搬到這裡，並一般化以便在各個 skill 間重用。
  - 新的 **`domain-modeling`** skill：主動建立並磨練專案的 domain model，拿 glossary 來對術語做壓力測試，並讓 `CONTEXT.md` 和 ADR 保持最新。
  - `improve-codebase-architecture` 現在從 `/codebase-design` 取得架構詞彙，從 `/domain-modeling` 取得 domain model。
  - `tdd` 現在依靠 `/codebase-design` 提供 interface 設計指引：它內建的 `deep-modules.md` / `interface-design.md` 筆記已經移除，改用共用的 skill。
  - `grill-with-docs` 現在透過 `/domain-modeling` 直接在流程中建立 domain model。

  **Breaking（破壞性變更）：** 這些 skill 現在相依於新的 `codebase-design` / `domain-modeling` skill，所以你也必須安裝它們。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 移除 **`caveman`** 和 **`zoom-out`** skill。

  - `caveman` 是我正在測試的另一個 skill 的重複版本，本來就不打算公開。
  - `zoom-out` 實際上沒人使用，所以已從 repo 中移除。

  **Breaking（破壞性變更）：** 這兩個 skill 都已移除。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 把 **`diagnose`** skill 改名為 **`diagnosing-bugs`**。

  **Breaking（破壞性變更）：** 請用 `/diagnosing-bugs` 呼叫它：舊的 `/diagnose` 名稱已經不存在。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 用 **`writing-great-skills`** 取代 **`write-a-skill`**。

  - 移除 `write-a-skill`。
  - 新增 `writing-great-skills`（以及它的 `GLOSSARY.md`）：一份把 skill 寫好、改好的參考資料，包含讓 skill 行為可預測的詞彙和原則，並細到逐句找出沒有作用的內容（no-op）。
  - 把 `grilling` 公開為 model-invoked skill：它是 `grill-me` 和 `grill-with-docs` 背後可重用的訪談迴圈。

  **Breaking（破壞性變更）：** `write-a-skill` 已移除；請改用 `writing-great-skills`。

### 次要變更 (Minor Changes)

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 新增 **`resolving-merge-conflicts`** skill：一個用來解決進行中 git merge 或 rebase 衝突的迴圈。獨立運作，不相依於其他 skill。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 在所有 docs 中，把 skill 的分類從 **Commands / Skills** 改名為 **User-invoked / Model-invoked**，並新增 `docs/invocation.md` 定義這個區分：user-invoked skill 只有在你輸入它時才會被使用，用途是統籌協調；model-invoked skill 則在任務合適時也能被自動使用。user-invoked skill 可以呼叫 model-invoked skill，但絕不能呼叫另一個 user-invoked skill。

### 修補變更 (Patch Changes)

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 收緊 **`review`** skill：快速失敗的 ref 檢查、單一來源的規則，以及刪除沒有作用的內容。
