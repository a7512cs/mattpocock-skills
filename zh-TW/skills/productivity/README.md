> 繁體中文翻譯。原文：[README.md](../../../skills/productivity/README.md)

# Productivity

通用的工作流程工具，不限於程式碼。

## User-invoked

只有在你輸入它們時才能觸發（Claude Code：`disable-model-invocation: true`；Codex：`agents/openai.yaml` 裡的 `policy.allow_implicit_invocation: false`）。

- **[grill-me](./grill-me/SKILL.md)**：針對一個計畫或設計被毫不留情地訪談，直到 design tree（設計樹）的每個分支都有結論。
- **[handoff](./handoff/SKILL.md)**：把目前的對話壓縮成一份 handoff（交接）文件，讓另一個 agent（AI 代理）能接手繼續工作。
- **[teach](./teach/SKILL.md)**：在多個 session（工作階段）中教使用者一項新技能或新概念，把目前的目錄當成有狀態的教學工作區。
- **[to-questionnaire](./to-questionnaire/SKILL.md)**：把一個你無法獨自回答的決策，變成一份 Markdown 問卷，交給那個能回答的人（可以非同步填寫，或在會議中一起填）。
- **[wait-what](./wait-what/SKILL.md)**：在某則訊息你沒看懂的那一刻，就觸發它。agent 會補上你缺少的 context（脈絡），用淺白的英文和你 `GLOSSARY.md` 裡的詞彙，重新說一次。

## Model-invoked

model（模型）或使用者都能觸發（使用豐富的 trigger（觸發條件）用語，讓 model 能自動取用它們）。

- **[grilling](./grilling/SKILL.md)**：針對一個計畫、決策或想法毫不留情地訪談使用者，直到 design tree 的每個分支都有結論。
- **[writing-for-agents](./writing-for-agents/SKILL.md)**：替 agent 撰寫文件：skill（技能包）、AGENTS.md/CLAUDE.md，以及任何 agent 透過指標連過去的文件。
