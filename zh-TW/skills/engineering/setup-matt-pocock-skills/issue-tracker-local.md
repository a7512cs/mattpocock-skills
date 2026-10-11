> 繁體中文翻譯。原文：[issue-tracker-local.md](../../../../skills/engineering/setup-matt-pocock-skills/issue-tracker-local.md)

# Issue tracker：本機 Markdown (Issue tracker: Local Markdown)

這個 repo（程式碼倉庫）的 Issue（議題）和 spec（規格）以 markdown 檔的形式放在 `.scratch/` 裡。

## 慣例 (Conventions)

- 每個功能一個目錄：`.scratch/<feature-slug>/`
- spec 是 `.scratch/<feature-slug>/spec.md`
- 實作用的 Issue 是每個 ticket（工作單）一個檔案，放在 `.scratch/<feature-slug>/issues/<NN>-<slug>.md`，從 `01` 開始編號，絕對不要做成單一個合併所有 ticket 的檔案
- triage（分類處理）狀態記錄為每個 Issue 檔案頂端附近的一行 `Status:`（role 字串見 `triage-labels.md`）
- 留言和對話紀錄附加在檔案底部的 `## Comments` 標題底下

## 當 skill 說 "publish to the issue tracker" 時 (When a skill says "publish to the issue tracker")

在 `.scratch/<feature-slug>/` 底下建立一個新檔案（需要的話先建立目錄）。

## 當 skill 說 "fetch the relevant ticket" 時 (When a skill says "fetch the relevant ticket")

讀取被參照路徑上的檔案。使用者通常會直接傳入路徑或 Issue 編號。

## Wayfinding 操作 (Wayfinding operations)

由 `/wayfinder` 使用。**map**（地圖）是一個檔案，每個 ticket 有一個 **child**（子項）檔案。

- **Map**：`.scratch/<effort>/map.md`（Notes / Decisions-so-far / Fog 內容，也就是筆記 / 目前為止的決定 / 未知區域）。
- **Child ticket**：`.scratch/<effort>/issues/NN-<slug>.md`，從 `01` 開始編號，問題寫在內容裡。`Type:` 一行記錄 ticket 類型（`research`/`prototype`/`grilling`/`task`）；`Status:` 一行記錄 `claimed`/`resolved`。
- **Blocking**（阻擋關係）：頂端附近的一行 `Blocked by: NN, NN`。當它列出的每個檔案都是 `resolved` 時，ticket 就不再被阻擋。
- **Frontier**（前沿）：掃描 `.scratch/<effort>/issues/`，找出未關閉、未被阻擋、未被認領的檔案；編號最前面的勝出。
- **Claim**（認領）：設定 `Status: claimed`，並在開始任何工作之前存檔。
- **Resolve**（解決）：把答案附加在 `## Answer` 標題底下，設定 `Status: resolved`，然後把一個 context pointer（脈絡指標）（要點 + 連結）附加到 `map.md` 中 map 的 Decisions-so-far。
