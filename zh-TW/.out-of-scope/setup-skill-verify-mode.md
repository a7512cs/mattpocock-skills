> 繁體中文翻譯。原文：[setup-skill-verify-mode.md](../../.out-of-scope/setup-skill-verify-mode.md)

# `setup-matt-pocock-skills` 的驗證／檢查模式 (Verify/Check Mode for `setup-matt-pocock-skills`)

這個專案不會為 `setup-matt-pocock-skills` 加上專用的驗證／檢查模式（或另一個獨立的驗證 skill（技能包））。

## 為什麼這不在範圍內 (Why this is out of scope)

用第二個 skill（或一個 `--verify` 旗標）來檢查 `docs/agents/*.md` 這些產出物是否仍然符合種子範本的 schema，會和現有的 setup skill 在對話中已經處理的工作重複。

預期的工作流程是：**執行 `/setup-matt-pocock-skills`，然後叫它驗證你目前的設定。** 這個 skill 是由 prompt（提示詞）驅動的，所以維護者可以把它的範圍限定在一次驗證（「什麼都不要改寫，只要拿目前的種子範本檢查我現有的檔案，並回報差異」），不需要另一條獨立的程式碼路徑。加上一個旗標或一個並列的 skill，會把一個已經可以透過自然語言入口表達的功能，拆成兩塊介面。

把設定管理集中在單一 skill，也避免了種子範本演進時，兩個 skill 彼此漸漸不一致所帶來的維護成本。

## 過去的請求 (Prior requests)

- #106: Feature request: verify/check mode for setup-matt-pocock-skills（功能請求：setup-matt-pocock-skills 的驗證／檢查模式）
