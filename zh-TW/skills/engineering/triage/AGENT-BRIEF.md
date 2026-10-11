> 繁體中文翻譯。原文：[AGENT-BRIEF.md](../../../../skills/engineering/triage/AGENT-BRIEF.md)

# 撰寫 Agent Brief (Writing Agent Briefs)

agent brief（給 agent 的任務說明）是一則結構化的留言，在某個 GitHub Issue（議題）或 PR 移到 `ready-for-agent` 時發布在上面。它是 AFK（不在場、非同步執行的）agent（代理程式）工作時所依據的權威規格。原本的內容和討論是 context（上下文）：agent brief 才是合約。

brief 說明 **agent 應該做什麼**，這同時延伸到兩種入口：針對 Issue，就是從零開始建立這個改變；針對 PR，就是*對現有的 diff（差異內容）*還剩下什麼要做：完成它、補上缺口、處理 review 意見。不論哪一種，原則都一樣；下面的 PR 範例會展示差別。

## 原則 (Principles)

### 持久性優先於精確性 (Durability over precision)

Issue 可能會在 `ready-for-agent` 停留好幾天或好幾週。這段期間 codebase（程式碼庫）會改變。寫 brief 時要讓它即使在檔案被重新命名、移動或 refactor（重構）之後，仍然有用。

- **要**描述 interface（介面）、型別和行為合約
- **要**點名 agent 應該尋找或修改的具體型別、函式簽名或設定形狀
- **不要**參照檔案路徑：它們會過時
- **不要**參照行號
- **不要**假設目前的 implementation（實作）結構會維持不變

### 描述行為，不描述步驟 (Behavioral, not procedural)

描述系統應該做**什麼**，而不是**怎麼**實作它。agent 會重新探索 codebase，並做出它自己的實作決定。

- **好：** 「`SkillConfig` 型別應該接受一個型別為 `CronExpression` 的選擇性 `schedule` 欄位」
- **壞：** 「打開 src/types/skill.ts，在第 42 行加上一個 schedule 欄位」
- **好：** 「當使用者不帶任何引數執行 `/triage` 時，他們應該看到需要注意的 Issue 摘要」
- **壞：** 「在 main handler 函式中加一個 switch 敘述」

### 完整的驗收條件 (Complete acceptance criteria)

agent 需要知道什麼時候算完成。每份 agent brief 都必須有具體、可測試的驗收條件。每一個條件都應該可以獨立驗證。

- **好：** 「執行 `gh issue list --label needs-triage` 會回傳已經過初步分類的 Issue」
- **壞：** 「Triage 應該正確運作」

### 明確的範圍邊界 (Explicit scope boundaries)

說明哪些是 out of scope（範圍之外）。這能防止 agent 過度打磨，或對相鄰的功能做出假設。

## 範本 (Template)

```markdown
## Agent Brief

**Category:** bug / enhancement
**Summary:** 一行描述需要發生什麼

**Current behavior:**
描述現在會發生什麼。如果是 bug，這就是壞掉的行為。
如果是 enhancement，這就是這個功能要建立在其上的現狀。

**Desired behavior:**
描述 agent 的工作完成後應該發生什麼。
對邊界情況和錯誤狀況要具體。

**Key interfaces:**
- `TypeName`：需要改變什麼，以及為什麼
- `functionName()` 回傳型別：它目前回傳什麼 vs 它應該回傳什麼
- 設定形狀：任何需要的新設定選項

**Acceptance criteria:**
- [ ] 具體、可測試的條件 1
- [ ] 具體、可測試的條件 2
- [ ] 具體、可測試的條件 3

**Out of scope:**
- 在這個 Issue 中不應該（NOT）被改變或處理的東西
- 看起來可能相關、但其實是分開的相鄰功能
```

## 範例 (Examples)

### 好的 agent brief（bug） (Good agent brief (bug))

```markdown
## Agent Brief

**Category:** bug
**Summary:** Skill description 截斷時會切在單字中間，產生壞掉的輸出

**Current behavior:**
當 skill description 超過 1024 個字元時，它會在剛好 1024 個字元處被截斷，
不管單字邊界在哪裡。這會產生結尾切在單字中間的 description
（例如 "Use when the user wants to confi"）。

**Desired behavior:**
截斷應該在 1024 個字元之前的最後一個單字邊界處斷開，
並附加 "..." 來表示有截斷。

**Key interfaces:**
- `SkillMetadata` 型別的 `description` 欄位：不需要改變型別，
  但填入它的驗證/處理邏輯需要尊重單字邊界
- 任何讀取 SKILL.md frontmatter 並擷取 description 的函式

**Acceptance criteria:**
- [ ] 低於 1024 個字元的 description 維持不變
- [ ] 超過 1024 個字元的 description 會在 1024 個字元之前的
      最後一個單字邊界處截斷
- [ ] 被截斷的 description 以 "..." 結尾
- [ ] 包含 "..." 在內的總長度不超過 1024 個字元

**Out of scope:**
- 改變 1024 字元這個上限本身
- 多行 description 支援
```

### 好的 agent brief（enhancement） (Good agent brief (enhancement))

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** 新增 `.out-of-scope/` 目錄支援，用來追蹤被拒絕的功能請求

**Current behavior:**
當一個功能請求被拒絕時，Issue 會帶著 `wontfix` label 和一則留言被關閉。
這個決定或理由沒有任何持久的紀錄。
之後類似的請求，需要維護者回想或搜尋先前的討論。

**Desired behavior:**
被拒絕的功能請求應該記錄在 `.out-of-scope/<concept>.md` 檔案中，
記下決定、理由，以及所有請求過這個功能的 Issue 的連結。
在 triage 新的 Issue 時，應該檢查這些檔案有沒有符合的項目。

**Key interfaces:**
- `.out-of-scope/` 中的 Markdown 檔案格式：每個檔案都應該有一個
  `# Concept Name` 標題、一行 `**Decision:**`、一行 `**Reason:**`，
  以及一個附有 Issue 連結的 `**Prior requests:**` 清單
- triage workflow 應該在早期就讀取所有 `.out-of-scope/*.md` 檔案，
  並依概念相似度把新進的 Issue 跟它們比對

**Acceptance criteria:**
- [ ] 把一個功能以 wontfix 關閉時，會在 `.out-of-scope/` 中建立/更新一個檔案
- [ ] 檔案包含決定、理由，以及被關閉 Issue 的連結
- [ ] 如果已經存在符合的 `.out-of-scope/` 檔案，新的 Issue 會被
      附加到它的 "Prior requests" 清單，而不是建立一個重複的檔案
- [ ] triage 期間，會檢查現有的 `.out-of-scope/` 檔案，並在新 Issue
      符合先前的拒絕時把它提出來

**Out of scope:**
- 自動比對（由人類確認比對結果）
- 重新開啟先前被拒絕的功能
- Bug 回報（只有 enhancement 的拒絕會進到 `.out-of-scope/`）
```

### 好的 agent brief（PR） (Good agent brief (PR))

針對 PR，"Current behavior" 描述的是 diff 的狀態，而 brief 要求 agent 完成或修正它，而不是從頭建立。

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** 完成貢獻者為 `triage list` 加的 `--json` 輸出旗標

**Current behavior:**
這個 PR 加了一個 `--json` 旗標，把 Issue 清單序列化成 JSON。正常路徑
可以運作，而且 diff 符合專案的指令結構。還剩兩個缺口：
錯誤仍然以給人看的文字印出（不是 JSON），而且新旗標沒有任何測試覆蓋。

**Desired behavior:**
使用 `--json` 時，所有輸出（包括錯誤）都是 stdout 上格式正確的 JSON，
而且指令的 exit code 不變。沒有這個旗標時，現有的人類可讀輸出完全不受影響。

**Key interfaces:**
- 在 `--json` 下，指令的錯誤路徑應該輸出 `{ "error": string }`，
  而不是純文字錯誤
- 重複使用 PR 已經加入的現有 serializer；不要再引入第二個

**Acceptance criteria:**
- [ ] `triage list --json` 在成功和錯誤的情況下都輸出有效的 JSON
- [ ] exit code 跟非 JSON 的指令一致
- [ ] 有一個測試涵蓋 `--json` 的成功輸出和一個錯誤情況
- [ ] 預設（非 JSON）輸出逐位元組完全不變

**Out of scope:**
- 為任何其他指令加上 `--json`
- 改變 PR 已經定義的成功 payload 的 JSON 形狀
```

### 壞的 agent brief (Bad agent brief)

```markdown
## Agent Brief

**Summary:** 修好 triage 的 bug

**What to do:**
triage 那個東西壞了。去看主要的檔案然後修好它。
大約第 150 行的那個函式有問題。

**Files to change:**
- src/triage/handler.ts（第 150 行）
- src/types.ts（第 42 行）
```

這份很糟，因為：
- 沒有 category
- 描述很模糊（「triage 那個東西壞了」）
- 參照了會過時的檔案路徑和行號
- 沒有驗收條件
- 沒有範圍邊界
- 沒有描述目前行為 vs 期望行為
