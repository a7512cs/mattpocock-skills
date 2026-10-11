---
name: prototype
description: Build a throwaway prototype to answer a design question. Use when the user wants to sanity-check whether a state model or logic feels right, or explore what a UI should look like.
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/prototype/SKILL.md)
>
> **description 中譯：** 建立一個用完即丟的 prototype（原型），來回答一個設計問題。當使用者想快速確認某個狀態模型或邏輯感覺對不對，或想探索某個 UI 應該長什麼樣子時使用。

# Prototype

prototype 是**用來回答一個問題的拋棄式程式碼**。問題決定它的形狀。

## 選一個分支 (Pick a branch)

根據使用者的 prompt（提示）、周圍的程式碼，或在使用者在場時直接詢問，找出要回答的是哪一個問題：

- **「這個邏輯 / 狀態模型感覺對嗎？」** → [LOGIC.md](LOGIC.md)。建立一個可以分享的單一 HTML 檔（自由操作的按鈕，加上分頁式的引導演練），把狀態機推過那些在紙上很難推理的情況，而且讓非開發者也能自己操作。
- **「這個應該長什麼樣子？」** → [UI.md](UI.md)。在單一路由 (route) 上產生幾個截然不同的 UI 變體，透過 URL search param（查詢參數）和一個浮動的底部列來切換。

這兩個分支產出的東西非常不同，所以選錯會浪費整個 prototype。如果問題真的模稜兩可，而且聯絡不到使用者，就預設選比較符合周圍程式碼的那個分支（後端 module（模組）→ 邏輯；頁面或元件 → UI），並在 prototype 的最上方寫明這個假設。

## 兩個分支都適用的規則 (Rules that apply to both)

1. **從第一天起就是拋棄式的，而且要清楚標示。** 把 prototype 程式碼放在接近它實際會被用到的地方（緊鄰它要原型化的那個 module 或頁面），讓脈絡一目了然，但命名要讓隨意翻看的讀者也看得出它是 prototype，不是正式產品程式碼。拋棄式的 UI 路由要遵守專案現有的路由慣例，不管是哪一種；不要發明新的頂層結構。
2. **執行起來毫不費力。** UI prototype 用專案 task runner 裡的一個指令就能啟動：`pnpm <name>`、`python <path>`、`bun <path>` 等等。邏輯示範是一個使用者雙擊就能開的單一 HTML 檔。不論哪一種，啟動時都不需要動腦。
3. **預設不做持久化。** 狀態放在記憶體裡。持久化是 prototype 要*檢查*的東西，不是它應該依賴的東西。如果問題明確牽涉到資料庫，就連到一個暫用的 DB，或一個名稱清楚寫著 "PROTOTYPE, wipe me"（PROTOTYPE，把我清掉）的本機檔案。
4. **跳過打磨。** 不寫測試，除了讓 prototype *能執行*所需的以外，不做錯誤處理，不做抽象化。重點是快速學到東西。
5. **把狀態攤開來。** 每次動作之後（邏輯），或每次切換變體時（UI），印出或渲染完整的相關狀態，讓使用者看得到什麼改變了。
6. **完成時把它保存下來。** 把任何已驗證的決定併入真正的程式碼，然後把 prototype 本身保存為 **primary source**（第一手資料）：commit（提交）到一個拋棄式的 branch（git 分支），不放進 main，並在負責實作的 Issue 上留一個指向那個 branch 的 context pointer（脈絡指標：指向相關資料位置的提示）。答案也要保存（結論，以及它解決的那個問題），寫在 Issue 或 commit 裡。main branch 只保留已驗證的決定。
