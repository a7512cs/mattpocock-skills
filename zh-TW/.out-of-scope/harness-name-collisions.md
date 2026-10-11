> 繁體中文翻譯。原文：[harness-name-collisions.md](../../.out-of-scope/harness-name-collisions.md)

# 為了避開 harness 內建指令而重新命名 skill (Renaming skills to dodge harness built-in commands)

skill（技能包）名稱不會因為某個 harness（執行環境）內建了同名的指令或 skill 而更改（`/prototype`、`/research`、`/code-review` 等等）。為了避免名稱衝突而要求重新命名 skill 或加上別名的請求，都是 out of scope（不在範圍內）。

## 為什麼這不在範圍內 (Why this is out of scope)

harness 隨時都在新增內建功能，而且每個 harness 自己決定名稱。每當其中一個用到我們已經在用的名稱就重新命名，意味著要在 Claude Code、Copilot、Devin 和其他工具之間追逐一個不斷移動的目標，而且每次都會破壞每位使用者的肌肉記憶，以及 skill 之間的每一個交叉引用。

harness 怎麼處理兩個同名的東西，是 harness 的行為，不是 skill 的行為。不管怎樣，skill 的文字都是正確的。

解決方法是用帶命名空間的呼叫方式。Claude Code plugin（外掛）會把每個 skill 放在它的 plugin 名稱底下，所以你永遠都可以明確地呼叫到我們的 skill：

```
/mattpocock-skills:research
/mattpocock-skills:code-review
```

如果你是用 skills.sh 安裝的，檔案就是你的：在你的副本裡重新命名資料夾和 `name:` 欄位。

如果某個 harness 完全沒辦法讓你呼叫帶命名空間或重新命名過的 skill，請向那個 harness 回報。

## 過去的請求 (Prior requests)

- #423: "/code-review shadows Claude Code own review skill"（/code-review 蓋掉了 Claude Code 自己的 review skill）
- #483: "/code-review name clash with Claude Code built-in"（/code-review 和 Claude Code 的內建功能名稱衝突）
- #857: "Rename the research skill to avoid conflict with Copilot's built-in /research command"（重新命名 research skill，以避免和 Copilot 內建的 /research 指令衝突）
- #1019: "Shorthand `/prototype` conflicts with hidden new Claude Code built-in skill `/prototype`"（簡寫 `/prototype` 和 Claude Code 隱藏的新內建 skill `/prototype` 衝突）
- #1037: "Skill name overlap with devin cli inbuilt commands"（skill 名稱和 devin cli 的內建指令重疊）
