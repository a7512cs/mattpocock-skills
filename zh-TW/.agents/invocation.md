> 繁體中文翻譯。原文：[invocation.md](../../.agents/invocation.md)

# Model-invoked 與 user-invoked (Model-invoked vs user-invoked)

這個 repo（程式碼儲存庫）裡的每個 `SKILL.md` 都是一個 skill（技能包）。唯一把它們分開的軸線是 **invocation**（呼叫方式），也就是誰能觸發它：

- **User-invoked**（使用者呼叫）：**只有人輸入它的名稱時**才能觸發。在 frontmatter（檔頭設定區）裡設定 `disable-model-invocation: true`（Claude Code），並在 `agents/openai.yaml` 裡設定 `policy.allow_implicit_invocation: false`（Codex）。`description` 是**給人看的**：一行摘要，給瀏覽 slash command（斜線指令）的人閱讀。拿掉 trigger（觸發條件）清單（"Use when the user says…"）。
- **Model-invoked**（模型呼叫）：**model（模型）或使用者**都能觸發。這是預設值：省略 `disable-model-invocation`，也省略 `agents/openai.yaml` 裡的 `policy` 區塊。`description` 是**給 model 看的**，保留豐富的 trigger 用語（"Use when the user wants…, mentions…, asks for…"），讓自動呼叫能被觸發。判斷一個 skill 是否該維持 model-invoked 的測試是：_model 能不能有用地自主取用它？_（重複使用是把東西抽成 skill 的理由，而不是這個測試。）

每個 harness（執行環境）都用自己的方式，讓 model 碰不到 user-invoked skill，所以除了人以外，沒有任何東西能觸發它：其他 skill 也不行。user-invoked skill 可以呼叫 model-invoked skill，但它永遠無法觸及另一個 user-invoked skill。

每個 skill 在它的 `SKILL.md` 旁邊也都帶著一個 `agents/openai.yaml`。它存放 Codex 的 UI metadata：給 skill 選擇器用的 `interface.display_name` 和 `interface.short_description`，以及（對 user-invoked skill 來說）與 `disable-model-invocation` 成對的 `policy.allow_implicit_invocation: false`。讓這兩者保持同步：一個 skill 要嘛在兩個 harness 裡都是 user-invoked，要嘛兩個都不是。

bucket（分類資料夾）的 `README.md` 和最上層的 `README.md`，會把項目分成 **User-invoked** 和 **Model-invoked** 兩組。

## 它們之間的相依關係 (Dependencies between them)

相依關係要寫成明確的指令，要求用指定的 skill 去**呼叫 Skill tool**（`Call the Skill tool with "grilling"`），而不是用很深的 `../other-skill/FILE.md` 交叉引用，也不是只寫一個 `/skill` 形式的名稱，留給 model 自己解讀。點出工具的名字，才是讓它真的被觸發的關鍵：大多數 harness 把 skill 呼叫做成一個讓 model 呼叫的工具，把這點明白寫出來，命中率會比在文字裡丟一個 `/name`、然後期望它被當成指令來讀還要高。拿掉開頭的 `/`，也讓這種寫法保持不綁定任何 harness，而不是更綁定：單獨一個 skill 名稱，不帶有任何關於它屬於哪個 harness 觸發語法的假設。共用的參考文件放在擁有它們的那個 skill 裡；其他 skill 要取得那些內容，就用那個 skill 去呼叫 Skill tool，而不是跨資料夾連結。

這裡講的是 **operative**（操作性）指令：skill 自己的步驟告訴 agent（AI 代理）現在就去執行另一個 skill。router（路由）文字只是列出 skill 名稱讓人挑選（`ask-matt`、bucket 的 `README.md`），並沒有呼叫任何東西，所以它保留 `/skill` 形式的名稱，當成單純的標籤。

Skill tool 每次呼叫只接受一個 skill。需要兩個 skill 的步驟就是兩次呼叫，不是一次呼叫帶兩個名稱：要明白寫出來（`Call the Skill tool twice, for "grilling" and "domain-modeling"`），而不是寫 "call it with X and Y,"，那會被讀成一次呼叫同時帶兩個。

這整套慣例只在被指定的 skill 是 **model-invoked** 時才成立。user-invoked skill 永遠無法用這種方式觸及，沒有例外：依照上面的不變條件，沒有其他 skill 能呼叫它，包括把它的名字交給 Skill tool 也不行。當某個步驟的前置條件是一個 user-invoked skill（例如 `setup-matt-pocock-skills`）時，要把它寫成讓人去執行的指示："tell the user to run `/setup-matt-pocock-skills`"（告訴使用者去執行 `/setup-matt-pocock-skills`），絕對不要寫成 Skill tool 呼叫。

## 被動與主動的領域工作 (Passive vs active domain work)

只是為了詞彙而_讀_ `GLOSSARY.md`，用一行文字指引就好，不是 `domain-modeling` skill。只有主動建立／磨利的紀律（檢驗用語、邊界情境、撰寫 ADR（架構決策紀錄）、直接更新 `GLOSSARY.md`）才是 `domain-modeling`。
