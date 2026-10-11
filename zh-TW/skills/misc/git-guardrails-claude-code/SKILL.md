---
name: git-guardrails-claude-code
description: Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execute. Use when user wants to prevent destructive git operations, add git safety hooks, or block git push/reset in Claude Code.
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/misc/git-guardrails-claude-code/SKILL.md)
>
> **description 中譯：** 設定 Claude Code 的 hook（掛鉤），在危險的 git 指令（push、reset --hard、clean、branch -D 等）執行之前就把它們擋下來。當使用者想防止破壞性的 git 操作、加入 git 安全 hook，或在 Claude Code 中封鎖 git push/reset 時使用。

# 設定 Git 防護欄 (Setup Git Guardrails)

設定一個 PreToolUse hook，在 Claude 執行危險的 git 指令之前攔截並擋下它們。

## 會被擋下的指令 (What Gets Blocked)

- `git push`（所有變體，包括 `--force`）
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

被擋下時，Claude 會看到一則訊息，告訴它沒有權限使用這些指令。

## 步驟 (Steps)

### 1. 詢問範圍 (Ask scope)

問使用者：要安裝在**只有這個專案**（`.claude/settings.json`），還是**所有專案**（`~/.claude/settings.json`）？

### 2. 複製 hook script (Copy the hook script)

附帶的 script 位於：[scripts/block-dangerous-git.sh](../../../../skills/misc/git-guardrails-claude-code/scripts/block-dangerous-git.sh)

依照範圍把它複製到目標位置：

- **專案**：`.claude/hooks/block-dangerous-git.sh`
- **全域**：`~/.claude/hooks/block-dangerous-git.sh`

用 `chmod +x` 讓它可以執行。

### 3. 把 hook 加進設定 (Add hook to settings)

加到對應的設定檔：

**專案**（`.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**全域**（`~/.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

如果設定檔已經存在，把 hook 合併進既有的 `hooks.PreToolUse` 陣列。不要覆寫其他設定。

### 4. 詢問客製化需求 (Ask about customization)

問使用者是否要在封鎖清單中新增或移除任何 pattern。依此編輯複製過去的 script。

### 5. 驗證 (Verify)

跑一個快速測試：

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
```

應該以 exit code 2 結束，並在 stderr 印出一則 BLOCKED 訊息。
