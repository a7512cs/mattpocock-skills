> 繁體中文翻譯。原文：[0001-explicit-setup-pointer-only-for-hard-dependencies.md](../../../.agents/adr/0001-explicit-setup-pointer-only-for-hard-dependencies.md)

# 只有硬相依才放明確的 `/setup-matt-pocock-skills` 指引 (Explicit `/setup-matt-pocock-skills` pointer only for hard dependencies)

Engineering skill（技能包）依賴由 `/setup-matt-pocock-skills` 預先建立的各 repo（程式碼儲存庫）設定（issue tracker（議題追蹤工具）、triage（分類處理）標籤詞彙、領域文件的版面配置）。有些 skill 沒有這份設定就無法有意義地運作：它們必須發布到特定的 issue tracker，或貼上特定的標籤字串。其他 skill 只是用它來讓輸出更精準（詞彙、對 ADR（架構決策紀錄）的認識），沒有它時也能優雅地降級。

我們把它們分成 **hard-dependency**（硬相依）和 **soft-dependency**（軟相依）兩種 skill：

- **Hard dependency**（`to-tickets`、`to-spec`、`triage`）：加上一句明確的話：_"… should have been provided to you; run `/setup-matt-pocock-skills` if not."_（「……應該已經提供給你了；如果沒有，請執行 `/setup-matt-pocock-skills`。」）沒有這份對應，輸出就是錯的，而不只是模糊而已。
- **Soft dependency**（`diagnose`、`tdd`、`improve-codebase-architecture`）：只用模糊的文字提到 "the project's domain glossary"（專案的領域詞彙表）和 "ADRs in the area you're touching"（你正在動的區域裡的 ADR）。如果那些文件不存在，skill 仍然能運作；只是輸出沒那麼精準。

這樣的區分讓 soft-dependency skill 保持省 token（詞元），也避免把 setup 指引照抄（cargo-culting：只模仿形式而不懂原因）到它根本不承擔作用的地方。
