---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/implement/SKILL.md)
>
> **description 中譯：** 根據一份 spec（規格）或一組 ticket（工單）來實作一項工作。

實作使用者在 spec 或 ticket 裡描述的工作。

如果使用者傳入一個 ticket 參照，就從 issue tracker（議題追蹤系統）抓取它，並在開始之前說出它的標題。如果參照有歧義，就問。

在可能的地方，於事先約定好的 seam（接縫）上，用 "tdd" 呼叫 Skill 工具。

定期跑 typecheck（型別檢查）、定期跑單一測試檔，最後再跑一次完整的測試套件。

完成之後，用 "code-review" 呼叫 Skill 工具來審查這份工作。

把你的工作 commit（提交）到目前的 branch（分支）。
