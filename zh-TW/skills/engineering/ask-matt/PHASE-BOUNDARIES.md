> 繁體中文翻譯。原文：[PHASE-BOUNDARIES.md](../../../../skills/engineering/ask-matt/PHASE-BOUNDARIES.md)

# 階段邊界 (Phase boundaries)

**phase**（階段）是 session（工作階段）裡的一段工作：grilling（拷問式訪談）、實作、QA。這個定義是刻意模糊的：當你覺得「*好，那個做完了*」時，一個 phase 就結束了。

**phase boundary**（階段邊界）是兩個 phase 之間的空隙，也是這個決定唯一該出現的地方。在 phase 進行中沒有決定要做：繼續，或把剩下的工作拆給 subagent（子代理）。在 phase 中途 compact 會讓 agent（代理）跟丟思路。

## 五個選項 (The five options)

| 選項 | 它做什麼 |
| ------------ | --------------------------------------------------------------- |
| **Continue**（繼續） | 留在這個 session。完全沒有 context（上下文）切換。 |
| **`/clear`** | 清空 context window（上下文視窗），從零開始。 |
| **`/handoff`** | 寫一個可攜帶的 markdown 檔，用它在任何地方啟動一個 session。 |
| **Subagent** | 把任務送到它自己的 context window，然後拿回一份報告。 |
| **`/compact`** | 壓縮這個 context，用摘要啟動一個新的 session。 |

## 決策樹 (The tree)

在 boundary 上從上往下走。第一個 **yes** 勝出。

**1. 你能在這個 session 裡繼續嗎？** 有兩件事會讓答案是 yes：下一個 phase 需要把這個 phase 當成 **primary source**（第一手來源），或者你還剩下足夠的 [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)（聰明區）空間（約 150k token），足以裝下下一個 phase。Grilling → 實作就是標準的 yes：實作需要的是原封不動的推理過程，而不是它的摘要。Continue 不花成本也不損失任何東西，所以在考慮其他任何選項之前，先把它排除。

**2. 這些 context 跟接下來的事無關嗎？** 這個 session 裡的一切（探索、決定、死路）都可以丟掉嗎？如果是，就 **`/clear`**。這是棋盤上最便宜的一步：它不花時間，還把整個視窗還給你。`/clear` 也不是終局：舊的 session 仍然可以恢復。

搞錯這件事的代價是單向的。把*相關的* context 清掉，你就失去了你所建造的東西背後的**為什麼**，而且再怎麼回頭讀 diff（差異）也拿不回來。

**3. 你需要 handoff（交接）嗎？** `/handoff` 的用途很窄。只有在你要做以下這些事時才需要它：

- 換到**新的 harness**（代理執行環境），例如 Claude → Codex，
- 搬到**新的目錄**或 repo（儲存庫），
- 把工作交給**同事**，
- 或者在 **phase 進行中**分出你發現的支線任務，又不打亂你正在做的事。

這份清單就是這一條的全部內容。`/handoff` 換來的是**可攜性**：一個能帶著走的檔案。如果沒有東西要帶走，你就不需要它。

**4. 這個任務可以 AFK（不在鍵盤前）完成嗎？** 它的範圍是否限定得夠嚴格，能在你離開鍵盤、不需要引導的情況下執行？那就把它送給一個 **subagent**，讓這個 session 保持原樣。自動化審查就是標準案例：agent 讀 diff 然後回報，它在做的時候不需要你。

**5. 否則，`/compact`。** 相關的 context、同一個 harness、同一個目錄，而且你需要持續參與其中：這就是決策樹的落點，而且經常落在這裡。給它一個指示（`/compact we're going to QA this area`），讓摘要保留下一個 phase 需要的東西。

`/compact` 是**預設選項，不是第一個伸手去拿的**。它排在最底部，是因為它上面的四個問題都更便宜或更精確。人們一開始就選它時的失敗模式，是得到一個新的 session，對某個被摘要壓扁的決定自信滿滿地搞錯。

## 第一手與第二手來源 (Primary and secondary sources)

除了 **Continue** 之外，每一步都會把 **primary source** 變成 **secondary source**（第二手來源）：原本實際發生的 session，被它的摘要取代。這個交換的形狀永遠一樣：

| 來源 | 資訊 | 雜訊 | 活動空間 |
| --------------------------------- | ----------- | ----- | ------------ |
| Primary（Continue） | 完整 | 很多 | 很少 |
| Secondary（`/compact`、`/handoff`） | 有損失 | 較少 | 很多 |

這就是為什麼問題 1 排第一。只有在留下來的成本高於它省下的東西時，你才付出這份損失。

## 這些都是判斷題 (These are judgement calls)

這些問題不是客觀的：每一題都帶有個人品味，同一個 boundary 在兩個不同的日子可能走向兩種結果。價值在於**依序**問這些問題，而且是在 boundary 上問，而不是在工作進行到一半時問。
