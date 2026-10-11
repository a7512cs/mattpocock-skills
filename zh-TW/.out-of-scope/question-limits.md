> 繁體中文翻譯。原文：[question-limits.md](../../.out-of-scope/question-limits.md)

# grilling 期間問題數量的硬性上限 (Hard limits on the number of questions during grilling)

`/grill-me` skill（技能包），以及其他 skill 裡的 grilling session（拷問式對談），不會強制問題數量的上限。要求加上可設定上限或硬性上限的請求，都是 out of scope（不在範圍內）。

## 為什麼這不在範圍內 (Why this is out of scope)

grilling 刻意設計成沒有固定終點。重點是一直挖下去，直到決策樹的每個分支都有結論：有些計畫只需要三個問題，有些需要五十個。固定的上限要嘛會在困難的問題上切斷有用的探索，要嘛在簡單的問題上顯得很武斷。

如果一個 session（工作階段）感覺太長，正確的出口已經存在：

- 使用者可以隨時停止 session，接受計畫目前的狀態。
- 使用者可以叫 model（模型）收尾、做摘要，然後往下走，因為設計上的控制方式就是用自然語言引導，而不是數字上限。

加上硬性上限，也會把兩種不同的失敗模式混為一談：一種是 model 因為計畫真的不夠明確而問了很多問題（這是正常運作），另一種是 model 問了重複或低價值的問題（這是 prompt（提示詞）品質的問題，不是數量的問題）。後者的修正應該放在 skill 的 prompt 裡，而不是放一個計數器。

## 過去的請求 (Prior requests)

- #44: "Codex just asked me 200 questions"（Codex 剛剛問了我 200 個問題）
