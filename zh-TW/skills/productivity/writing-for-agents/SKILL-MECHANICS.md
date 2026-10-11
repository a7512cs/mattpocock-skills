> 繁體中文翻譯。原文：[SKILL-MECHANICS.md](../../../../skills/productivity/writing-for-agents/SKILL-MECHANICS.md)

# Skill 機制 (Skill mechanics)

[`writing-for-agents`](SKILL.md) 中專屬於 skill（技能包）的 branch（分支情況），說明當文件是一個 skill 時有什麼不同：frontmatter（檔頭中繼資料）、invocation（呼叫方式）的選擇，以及 router skill（路由型 skill）。關於撰寫它的其他一切，都是 `SKILL.md` 裡的通用參考。

## 呼叫方式 (Invocation)

兩種選擇，在兩種負擔之間取捨：

- **model-invoked**（由 model 呼叫）的 skill 保留一個 `description`，所以 agent（AI 代理）可以自主觸發它，其他 skill 也能取用它。你仍然可以輸入它的名稱：model-invocation 永遠*包含*使用者的取用；description 只會增加 agent 的發現能力，絕不會移除人類的。description 是 skill 頂層的 context pointer（脈絡指標），被迫隨時保持載入：用永久的 context load（context 負擔）換取可被發現性。一個內容全是 reference（參考）的 model-invoked skill，也是共享 reference 的一個歸宿：另一個 skill 可以呼叫它，所以好幾個 skill 都需要的 reference 可以放在同一個地方。機制：省略 `disable-model-invocation`，並寫一個面向 model、帶有 trigger（觸發）branch 的 description（`SKILL.md` 裡撰寫 pointer 的規則完全適用）。
- **user-invoked**（由使用者呼叫）的 skill 把 description 從 agent 能觸及的範圍中拿掉：只有輸入它名稱的人類能呼叫它，其他 skill 都不行。零 context load，但它花費 cognitive load（認知負擔）：你就是那份必須記得它存在的索引。機制：設定 `disable-model-invocation: true`；`description` 變成面向人類的：一行摘要，拿掉 trigger 清單。

只有在 agent 必須自己取用這個 skill，或另一個 skill 必須取用它時，才選 model-invocation。如果它永遠只會被手動觸發，就把它做成 user-invoked，不付任何 context load。

兩個 user-invoked skill 都需要的共享 reference，不能放在其中任何一個裡：沒有 description，兩者都無法觸發對方。把它推到 skill 系統之外的一個普通檔案：成為任何 skill 都能指向的外部 reference。

## 依 invocation 拆分 (Splitting by invocation)

這是拆分中依 invocation 切的那一刀（依順序切的那一刀在 `SKILL.md`）：當你有一個獨特的 leading word（引導詞）應該單獨觸發它（一個你在 prompt（提示詞）裡真的會用的 trigger 詞），或另一個 skill 必須取用它時，就拆出一個 model-invoked skill。你要為新的、永遠載入的 description 付出 context load，所以這種獨立的取用必須值得。

## Router skills

當 user-invoked skill 多到你記不住時，那堆積起來的 cognitive load 可以用一個 **router skill** 來解決：一個 user-invoked skill，列出其他 skill 的名稱以及何時該取用每一個，讓人類只需要記住一個 skill，而不是很多個。它只能提示，絕不能觸發它們：user-invoked skill 沒有 description，所以除了人類，沒有任何東西能取用它們。
