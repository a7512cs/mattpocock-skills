> 繁體中文翻譯。原文：[triage-labels.md](../../../docs/agents/triage-labels.md)

# Triage 標籤 (Triage Labels)

skill（技能包）是用五個標準的 triage role（分類角色）來表達的。這個檔案把那些 role 對應到這個 repo（程式碼儲存庫）的 issue tracker（議題追蹤工具）裡實際使用的標籤字串。

| mattpocock/skills 裡的標籤 | 我們 tracker 裡的標籤 | 意思 |
| -------------------------- | -------------------- | ---------------------------------------- |
| `needs-triage`             | `needs-triage`       | 維護者需要評估這個 issue |
| `needs-info`               | `needs-info`         | 等待回報者提供更多資訊 |
| `ready-for-agent`          | `ready-for-agent`    | 規格已完整，可以交給 AFK（無人值守）agent |
| `ready-for-human`          | `ready-for-human`    | 需要由人來實作 |
| `wontfix`                  | `wontfix`            | 不會處理 |

當某個 skill 提到某個 role 時（例如 "apply the AFK-ready triage label"（貼上 AFK-ready 的 triage 標籤）），使用這張表裡對應的標籤字串。

在選擇狀態之前，先用 [`SCOPE.md`](../../SCOPE.md) 評斷每個 issue。被拒絕的 issue 會以「not planned」關閉。
