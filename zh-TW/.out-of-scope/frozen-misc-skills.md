> 繁體中文翻譯。原文：[frozen-misc-skills.md](../../.out-of-scope/frozen-misc-skills.md)

# 對 `misc/` skill 的修改 (Changes to `misc/` skills)

`skills/misc/` 底下的 skill（技能包），包括 `git-guardrails-claude-code`、`migrate-to-shoehorn`、`scaffold-exercises`、`setup-pre-commit`，以及任何之後放進去的 skill，都已凍結。針對它們的 bug 回報、功能請求和 PR（合併請求）都會被關閉。

## 為什麼這不在範圍內 (Why this is out of scope)

`misc/` 是放那些我留著但很少用的 skill 的地方。它們不是 promoted（推廣）的：它們不會隨 Claude Code plugin（外掛）發布，沒有 docs 頁面，我也不是每天在跑它們，所以我無法判斷一個修正是否正確，也不會發現某個修正弄壞了其他東西。用和 promoted skill 一樣的標準來維護它們，成本和一個 promoted skill 一樣，使用量卻只有一小部分。

它們留在 repo（程式碼儲存庫）裡，不再維護，因為對某些人來說，它們照原樣仍然能用。如果某個 skill 對你不管用，就用 skills.sh 安裝它，然後修改你自己的那份副本：那些檔案是你的，可以隨意編輯。

如果某個 `misc/` skill 之後被重新 promoted 回 `engineering/` 或 `productivity/`，從那時起它就重新回到範圍內。

## 過去的請求 (Prior requests)

- #14: "Potential typo in setup-pre-commit/SKILL.md"（setup-pre-commit/SKILL.md 可能有錯字）
- #301: "`block-dangerous-git.sh` is bypassed by any git global option (e.g. `git -C <dir> push`)"（任何 git 全域選項都能繞過 `block-dangerous-git.sh`，例如 `git -C <dir> push`）
- #465: "git-guardrails-claude-code documentation is missing benefits over built in Claude code deny rules"（git-guardrails-claude-code 的文件沒有說明它比 Claude Code 內建的 deny 規則好在哪裡）
- #898: "git-guardrails-claude-code: hook fails open without jq and misses common git spellings"（git-guardrails-claude-code：沒有 jq 時 hook 會直接放行，而且漏掉常見的 git 寫法）
