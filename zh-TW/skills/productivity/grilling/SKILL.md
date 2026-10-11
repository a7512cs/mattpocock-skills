---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/productivity/grilling/SKILL.md)
>
> **description 中譯：** 針對一個計畫、決定或想法，毫不留情地追問使用者。當使用者想對自己的想法做壓力測試，或使用任何 'grill' trigger（觸發）用語時使用。

毫不留情地訪談使用者，直到你們達成共同的理解。把這個過程畫成一棵 **design tree**（設計樹）：每個決定都會分支出依附在它之下的其他決定。

以 **rounds**（輪次）來處理這棵樹。**frontier**（前沿）是所有前提條件都已確定的決定：也就是你*現在*就能問、不必去猜還沒聽到的答案的問題。在一個 round 裡問完整個 frontier：為每個問題編號，並給出你建議的答案。然後等使用者回答，再進入下一個 round。

一個 round 的格式如下：

```
❓ **Q1** - **<問題標題>**: <問題內文，可能有多個段落，包含多個選項>

➡️ <你建議的答案>

---

❓ **Q2** - **<問題標題>**: <問題內文，可能有多個段落，包含多個選項>

➡️ <你建議的答案>
```

每個問題的措辭，都要讓回答 "yes" 就等於接受你建議的答案。

使用者每回答一個 round，樹就會重新成形：已確定的決定把 frontier 往外推，並解除依賴它們的問題的阻擋。重新計算 frontier，然後問下一個 round。如果一個問題的答案取決於本 round 中另一個仍未回答的問題，它就屬於*之後*的 round，而不是這一個。

找出*事實*是你的工作，絕不是使用者的。當某個 frontier 問題需要來自環境的事實（檔案系統、工具等），就派一個 sub-agent（子代理）去找；不要問使用者任何你自己就能查到的東西。不要因此卡住：一個正在進行的探索是一個尚未確定的前提條件，所以只有它下游的問題要等 sub-agent 回報；frontier 上其餘的問題現在就問。*決定*屬於使用者：把每個決定交給他們，然後等待。

當 frontier 清空時，這個 session（工作階段）就結束了：design tree 的每個分支都走過，沒有任何東西被默默假設。在使用者確認你們已達成共同理解之前，不要據此採取行動。
