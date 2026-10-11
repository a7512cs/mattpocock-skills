> 繁體中文翻譯。原文：[triage-labels.md](../../../../skills/engineering/setup-matt-pocock-skills/triage-labels.md)

# Triage Labels

skill（技能）用五個標準的 Triage role（分類角色）來表達。這個檔案把這些 role 對應到這個 repo（程式碼倉庫）的 Issue tracker（議題追蹤系統）實際使用的 label 字串。

| mattpocock/skills 中的 label | 我們 tracker 中的 label | 意義 |
| -------------------------- | -------------------- | ---------------------------------------- |
| `needs-triage`             | `needs-triage`       | 維護者需要評估這個 Issue |
| `needs-info`               | `needs-info`         | 等待回報者提供更多資訊 |
| `ready-for-agent`          | `ready-for-agent`    | 規格已完整，可以交給 AFK（不在場、非同步執行的）agent |
| `ready-for-human`          | `ready-for-human`    | 需要人工實作 |
| `wontfix`                  | `wontfix`            | 不會處理 |

當 skill 提到一個 role 時（例如 "apply the AFK-ready triage label"（套用 AFK-ready 的 triage label）），使用這張表中對應的 label 字串。

編輯「我們 tracker 中的 label」這一欄，讓它符合你實際使用的詞彙。
