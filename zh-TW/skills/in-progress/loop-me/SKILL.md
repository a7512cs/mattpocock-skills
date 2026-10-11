---
name: loop-me
description: Grill me about specs for the workflows I want to build, within this workspace.
disable-model-invocation: true
argument-hint: "A workflow to design, or nothing to go find one"
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/in-progress/loop-me/SKILL.md)
>
> **description 中譯：** 在這個工作區裡，針對我想打造的 workflow（工作流程），拷問我它們的 spec（規格）。
>
> **argument-hint 中譯：** 一個要設計的 workflow，或留空讓你去找一個

執行一個有狀態（stateful）的 `/grilling` session（工作階段），它唯一的產出是 **workflow** spec。運用 grilling（拷問式提問）的紀律（毫不放鬆、一次一輪問題、每題都附上建議答案），瞄準下面的詞彙和目標。隨著 grilling 把事情釐清，建立、編輯和刪除 spec。

## loop 視角 (The loop lens)

**loop**（循環）是使用者生活中反覆出現的模式：他們的職涯、他們的一週、他們的早晨、某個重複進行的單一活動。把人生想像成一層套一層的 loop，就能看出其中的活動其實有多可預測，而這正是它們值得**委派**的原因。用這個視角找出值得寫成 spec 的 loop，並提出使用者還沒注意到的 loop。

**workflow** 是某一個 loop 的 spec，把它化為現實。你在一個 loop 上執行 workflow：loop 是 workflow 執行中的實例。Workflow 放在 `workflows/*.md`，而且是唯一可信的來源（source of truth）。

## 詞彙 (Vocabulary)

這是一套共享語言，只在 workflow 需要時才拿出來用：絕不是檢查清單。**不強制任何結構**：除非 grilling 顯示需要，否則 workflow 不需要 AI、不需要 checkpoint，也不需要排程。

- **Trigger**（觸發條件）：觸發每次執行的東西，可以是 **event**（事件：一封新 email、一個新 issue（議題））或 **schedule**（排程：每天早上）。用 event 觸發通常比較有效率。
- **Checkpoint**（檢查點）：human-in-the-loop（人在迴圈中）的節點，在這裡請使用者驗證或做決定。有些 workflow 沒有 checkpoint，完全自動執行；有些則完全不用 AI。
- **Push right**（往右推）：把 checkpoint 盡可能往後延。在找人介入之前先做完最多的工作，讓對方只被問一次、在很後面才被問，而且所有東西都已準備好。
- **Brief**（簡報摘要）：checkpoint 呈現的內容，一份精簡、可以直接拿來做決定的摘要（產出了什麼、為什麼，以及一個連到產出物本身的連結），絕不是原始輸出。使用者讀的是 brief，不是草稿。審閱速度至關重要。

## 完成的定義 (Definition of done)

當一個負責實作的 agent（AI 代理）不用問任何一個問題就能把 workflow spec 做出來時，這份 spec 才算完成。持續拷問直到那時；只要還剩一個問題，就什麼都不算完成。

## 工作區 (The workspace)

- `workflows/*.md`：每個 workflow 一份 spec。
- `NOTES.md`：關於使用者世界的原始筆記，包括他們使用的工具、他們處理的管道，以及他們自己對這兩者的用語。當它是空的或內容很少時，先訪談使用者關於他們的世界，再開始定義任何東西。模糊的用語一出現，就把它磨成標準用語，並記錄在這裡。
