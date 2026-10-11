---
name: wizard
description: Generate an interactive bash wizard that walks a human through steps only they can perform. Use when provisioning infrastructure, setting up credentials or CI secrets, walking an unfamiliar third-party dashboard, or running a one-off migration or cutover. Don't invoke this for steps the agent can perform itself.
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/wizard/SKILL.md)
>
> **description 中譯：** 產生一個互動式 bash wizard（精靈），一步步帶人類完成只有他們自己能做的步驟。在佈建基礎設施、設定憑證或 CI（持續整合）的 secret（機密值）、走過不熟悉的第三方控制台（dashboard），或執行一次性的遷移或切換時使用。不要為了 agent（AI 代理）自己就能完成的步驟呼叫它。

# Wizard

**wizard** 是一個 bash 腳本，一步一步帶人類完成某個手動程序，這種程序親手做很繁瑣，每次重新向 AI 解釋也很繁瑣。它會打開每個 URL，明確說出要點什麼、複製什麼，擷取這些值，把它們寫到該放的地方（`.env`、GitHub secrets），在每個階段確認，並顯示還剩幾個階段。它可能用來設定第三方服務、執行一次性遷移，或把專案從一個狀態移到另一個狀態。

令人愉快的 UX 已經由 [template.sh](../../../../skills/engineering/wizard/template.sh) 解決了：逐階段的進度顯示、確認關卡、跨平台開啟 URL（包括 WSL）、隱藏式 secret 輸入、可重複執行（idempotent）的 `.env` upsert、`gh secret`/`gh variable` 寫入，以及結尾摘要。**你的工作只有界定程序範圍並撰寫它的各個階段**。`STAGES` 標記以上的函式庫在每個 wizard 裡都完全相同；這種一致性正是重點：絕不手動修改它。

wizard 預設是用完即丟的：為一次執行而建，存到暫存路徑或 `scripts/` 路徑，工作完成後就刪除。只有在使用者想要一條應該留在 repo（程式碼儲存庫）裡、可重複使用的設定路徑時，才 commit（提交）它。

## 流程 (Process)

### 1. 界定程序範圍 (Scope the procedure)

找出人類必須做的每一個手動步驟，以及過程中要擷取的每一個值。先讀 repo，不要毫無準備就問：

- 設定類：`.env`、`.env.example`、`.env.*`、`README`、`docker-compose*`、框架設定，以及 `.github/workflows/*`（每個 `secrets.*` / `vars.*` 引用都是 wizard 必須產出的一個值）。
- 遷移或轉換類：目前狀態、目標狀態，以及兩者之間不可逆的動作。

接著把依序排列的階段清單，以及每個階段產出的值給使用者看，並請他確認：他可能會新增、刪除或重新排序。

**完成條件**：每個階段都依序命名，而且對每個擷取的值，你都知道 (a) 人類從哪裡取得它，(b) 它寫到哪裡（`.env`、一個 GitHub secret、兩者都寫，或哪裡都不寫；有些階段純粹是動作），以及 (c) 它是 secret（隱藏輸入）還是公開的。

### 2. 描繪每個階段的操作路徑 (Map each stage's journey)

對每個階段，寫出人類要走的精確路徑：打開哪個 URL、在那裡做什麼、值顯示在哪裡、它填入哪個變數：例如 "Dashboard → Developers → API keys → Reveal test key → copy"。如果你其實不清楚目前的 UI 或確切的指令，就直接說出來，然後問使用者或查文件：絕不捏造可能不存在的步驟。

**完成條件**：每個階段都對應到陌生人也能照做的具體指示。

### 3. 撰寫 wizard (Author the wizard)

把 `template.sh` 複製到目標路徑。把範例階段換成每個步驟一個 `stage`，依相依順序排列。使用函式庫的輔助函式：`stage`、`say`/`step`、`open_url`、`ask`/`ask_secret`、`write_env`、`set_secret`/`set_var`、`pause`/`confirm`。把 `TOTAL_STAGES` 設成你寫的階段數量。

維持 template 設下的標準：先打開 URL 再要求它的值，任何 secret 都用 `ask_secret`，每個要保存的值都 `write_env`，只對 CI 真正需要的值 `set_secret`，在任何不可逆動作之前都 `confirm`。每個 `stage` 都會清空畫面，只顯示目前的步驟：讓一個階段只做一件專注的事，這樣人類需要的內容就不會被捲走。不要碰標記以上的函式庫。

### 4. 驗證並交接 (Verify and hand off)

- `bash -n <script>`；如果有 `shellcheck` 就執行它。
- `chmod +x <script>`。
- 不要自己從頭到尾執行它：它會打開瀏覽器，並卡在等待人類輸入。改用靜態方式追查：第 1 步的每個值都有被擷取，並落在第 1 步說的地方，而且每個 `set_secret` 名稱都和 CI 裡的某個 `secrets.*` 引用完全一致。
- 告訴使用者如何執行它。如果它是一條可重複使用的設定路徑，就 commit 它並從 README 加上連結，讓下一個人執行這個腳本，而不是去問 AI。
