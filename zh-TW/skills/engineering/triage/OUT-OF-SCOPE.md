> 繁體中文翻譯。原文：[OUT-OF-SCOPE.md](../../../../skills/engineering/triage/OUT-OF-SCOPE.md)

# Out-of-Scope 知識庫 (Out-of-Scope Knowledge Base)

repo（程式碼倉庫）中的 `.out-of-scope/` 目錄存放被拒絕的功能請求的持久紀錄。它有兩個用途：

1. **組織記憶 (Institutional memory)**：一個功能為什麼被拒絕，這樣在 Issue（議題）關閉後，理由不會遺失
2. **去重 (Deduplication)**：當一個新進的 Issue 符合先前的某次拒絕時，skill（技能）可以提出先前的決定，而不是重新爭論一次

## 目錄結構 (Directory structure)

```
.out-of-scope/
├── dark-mode.md
├── plugin-system.md
└── graphql-api.md
```

每個 **concept**（概念）一個檔案，不是每個 Issue 一個。請求同一件事的多個 Issue 會歸在同一個檔案底下。

## 檔案格式 (File format)

檔案應該用輕鬆、易讀的風格來寫，比較像一份簡短的設計文件，而不是一筆資料庫紀錄。用段落、程式碼範例和實例，讓理由清楚，對第一次看到它的人也有用。

```markdown
# Dark Mode

這個專案不支援深色模式，也不支援面向使用者的主題設定。

## 為什麼這是 out of scope (Why this is out of scope)

渲染流程假設只有一個定義在 `ThemeConfig` 中的調色盤。
支援多個主題會需要：

- 一個包住整棵元件樹的 theme context provider
- 每個元件各自感知主題的樣式解析
- 一個儲存使用者主題偏好的持久層

這是一個重大的架構改變，跟專案專注於內容創作的方向不一致。
主題設定是下游使用者的事，也就是那些嵌入或重新散布輸出內容的人。

```ts
// The current ThemeConfig interface is not designed for runtime switching:
interface ThemeConfig {
  colors: ColorPalette; // single palette, resolved at build time
  fonts: FontStack;
}
```

## Prior requests

- #42: 「新增深色模式支援」
- #87: 「為了無障礙的夜間主題」
- #134: 「深色主題選項」
```

### 為檔案命名 (Naming the file)

為這個概念取一個簡短、具描述性的 kebab-case 名稱：`dark-mode.md`、`plugin-system.md`、`graphql-api.md`。名稱應該夠好辨認，讓瀏覽這個目錄的人不用打開檔案，就能了解被拒絕的是什麼。

### 撰寫理由 (Writing the reason)

理由應該有實質內容：不是「我們不想要這個」，而是為什麼。好的理由會參照：

- 專案範圍或理念（「這個專案專注於 X；主題設定是下游的事」）
- 技術限制（「支援這個會需要 Y，而這跟我們的 Z 架構衝突」）
- 策略性決定（「我們選擇用 A 而不是 B，因為……」）

理由應該經得起時間考驗。避免參照暫時性的狀況（「我們現在太忙了」）；那些不是真正的拒絕，而是延後。

## 什麼時候檢查 `.out-of-scope/` (When to check `.out-of-scope/`)

在 triage（分類處理）期間（第 1 步：蒐集 context（上下文）），讀取 `.out-of-scope/` 中的所有檔案。評估一個新 Issue 時：

- 檢查這個請求是否符合某個現有的 out-of-scope（範圍之外）概念
- 比對是依概念相似度，而不是關鍵字：「夜間主題」符合 `dark-mode.md`
- 如果有符合的，就提出來給維護者：「這跟 `.out-of-scope/dark-mode.md` 很相似。我們之前拒絕了這個，因為 [理由]。你現在的看法還是一樣嗎？」

維護者可能會：

- **確認 (Confirm)**：新的 Issue 被加進現有檔案的 "Prior requests" 清單，然後關閉
- **重新考慮 (Reconsider)**：刪除或更新那個 out-of-scope 檔案，而 Issue 照正常的 triage 流程繼續
- **不同意 (Disagree)**：這些 Issue 相關但不同，照正常的 triage 流程繼續

## 什麼時候寫入 `.out-of-scope/` (When to write to `.out-of-scope/`)

只有在一個 **enhancement**（不是 bug）以 `wontfix` 被*拒絕*時才寫入。這對 enhancement PR 的適用方式跟 Issue 完全一樣：被拒絕的 PR 會記錄在這裡，這樣同樣的請求就不會以全新程式碼的形式再回來。

當某個東西因為**已經實作**而以 `wontfix` 關閉時，**不要**寫在這裡。那是已經做好的功能，不是被拒絕的功能；記錄它會用錯誤的拒絕污染去重檢查。取而代之的是，關閉留言要指出這個功能已經在哪裡。

流程：

1. 維護者決定某個功能請求是 out of scope
2. 檢查是否已經存在符合的 `.out-of-scope/` 檔案
3. 如果有：把新的 Issue 附加到 "Prior requests" 清單
4. 如果沒有：建立一個新檔案，包含概念名稱、決定、理由和第一個先前的請求
5. 在 Issue 上發布一則留言，解釋這個決定，並提到那個 `.out-of-scope/` 檔案
6. 用 `wontfix` label 關閉 Issue

## 更新或移除 out-of-scope 檔案 (Updating or removing out-of-scope files)

如果維護者對某個先前被拒絕的概念改變了心意：

- 刪除那個 `.out-of-scope/` 檔案
- skill 不需要重新開啟舊的 Issue；它們是歷史紀錄
- 觸發這次重新考慮的新 Issue，照正常的 triage 流程繼續
