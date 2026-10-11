> 繁體中文翻譯。原文：[subagent-recursion.md](../../.out-of-scope/subagent-recursion.md)

# 防止 sub-agent 遞迴呼叫 skill 的保護機制 (Guards against sub-agents recursing into skills)

skill（技能包）不會加上保護機制，來防止 sub-agent（子 agent）遞迴呼叫 skill 或產生巢狀的 agent（AI 代理），例如 `/code-review` 的 sub-agent 又呼叫 `/code-review`、`/research` agent 又產生另一個 agent。要求加上 leaf-agent（末端 agent）指示、深度限制，或 "do not invoke this skill"（不要呼叫這個 skill）這類句子的請求，都是 out of scope（不在範圍內）。

## 為什麼這不在範圍內 (Why this is out of scope)

應該由 harness（執行環境）負責阻止無限的 subagent 迴圈，而不是 skill。harness 決定 sub-agent 能使用哪些工具和 skill、巢狀可以多深，所以在那裡設定的限制，會一次適用於所有 skill。寫在某個 skill 文字裡的保護機制，只涵蓋那一個 skill，每次執行都要花 token（詞元），而且仍然取決於 model（模型）是否選擇遵守。

如果某個 sub-agent 無限制地遞迴或擴散出去，請向 harness 回報。

## 過去的請求 (Prior requests)

- #530: "research skill: spawned background agent can recursively re-spawn another agent (uncontrolled nesting)"（research skill：產生出來的 background agent 可以遞迴地再產生另一個 agent，造成失控的巢狀）
- #573: "code-review sub-agents recursively invoke /code-review and fan out"（code-review 的 sub-agent 遞迴呼叫 /code-review 並擴散出去）（PR #1186，"code-review: make the Standards and Spec sub-agents leaf reviewers"（code-review：讓 Standards 和 Spec 這兩個 sub-agent 成為末端審查者），已關閉）
