> 繁體中文翻譯。原文：[README.md](../../../skills/in-progress/README.md)

# In Progress

Beta 版。這些 skill（技能包）是刻意公開的：試用看看，然後告訴我哪裡壞了。在它們升級到穩定的 bucket（分類資料夾）之前，它們不會被放進 plugin（外掛）和最上層的 README，也沒有 docs 頁面，而且可能在沒有預警的情況下改變或消失。

plugin 不會提供這些 skill。請直接安裝其中一個：

```bash
npx skills@latest add mattpocock/skills --skill=<name>
```

- **[loop-me](./loop-me/SKILL.md)**：在多個 session（工作階段）中拷問自己，直到產出可以實作的工作流程 spec（規格），並把目前的目錄當成有狀態的工作區。User-invoked（使用者呼叫）。
- **[writing-beats](./writing-beats/SKILL.md)**：把一篇文章塑造成一段由 beat（節拍：文章裡的一個小段落單位）組成的旅程，用「選擇你自己的冒險」的風格。選一個起始 beat，只寫那個 beat，然後轉向下一個，直到文章自然結束。
- **[writing-fragments](./writing-fragments/SKILL.md)**：一個 grilling session（拷問式對談），從你身上挖出 fragment（片段：五花八門的零碎寫作素材），並把它們附加到單一文件裡，作為未來文章的原始素材。
- **[writing-shape](./writing-shape/SKILL.md)**：拿一份裝著原始素材的 markdown 檔，一段一段把它塑造成文章，並在每一步討論格式的選擇。
- **[claude-handoff](./claude-handoff/SKILL.md)**：把目前的對話交給一個全新的 background agent（背景 agent），它會立刻接手工作，並透過 `claude --bg` 以一份 handoff（交接）摘要作為起點。User-invoked。
- **[setup-ts-deep-modules](./setup-ts-deep-modules/SKILL.md)**：把 dependency-cruiser 接進一個 TypeScript repo（程式碼儲存庫），讓每個 package 都是一個 deep module（深模組）：implementation（實作）藏在子資料夾裡，只能透過它的進入點檔案存取，測試也透過那些檔案來測它。User-invoked。
