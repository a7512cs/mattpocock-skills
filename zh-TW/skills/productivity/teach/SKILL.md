---
name: teach
description: Teach the user a new skill or concept, within this workspace.
disable-model-invocation: true
argument-hint: "What would you like to learn about?"
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/productivity/teach/SKILL.md)
>
> **description 中譯：** 在這個工作區內，教使用者一項新技能或新概念。
>
> **argument-hint 中譯：** 你想學什麼？

使用者請你教他們某樣東西。這是一個有狀態的請求：他們打算在多個 session（工作階段）中學習這個主題。

## 教學工作區 (Teaching Workspace)

把目前的目錄當成一個教學工作區。工作區路徑（`./lessons/` 和其他路徑）從執行 `/teach` 的目錄解析；只有 `*-FORMAT.md` 連結是從這個 skill（技能包）的資料夾解析。他們的學習狀態記錄在這個目錄的幾個檔案裡：

- `MISSION.md`：一份記錄使用者對這個主題感興趣的*原因*的文件。所有教學都應該以它為基礎。使用 [MISSION-FORMAT.md](./MISSION-FORMAT.md) 裡的格式。
- `./reference/*.html`：一個存放參考資料的目錄。這些是從 lesson（課程單元）壓縮出來的學習成果：小抄、參考演算法、語法、瑜伽姿勢、glossary（詞彙表）。它們是學習的原始單位。它們應該是印出來也很好看的美觀文件，而且是為了快速查閱而設計。
- `RESOURCES.md`：一份資源清單，可以拿來探索，讓你的教學建立在脈絡知識上，或用來獲取知識與智慧。使用 [RESOURCES-FORMAT.md](./RESOURCES-FORMAT.md) 裡的格式。
- `./learning-records/*.md`：一個存放學習紀錄的目錄，記錄使用者學到了什麼。它們大致相當於軟體開發裡的架構決策紀錄：記錄不明顯的教訓和關鍵洞見，這些可能之後需要修訂，或會引導未來的 session。應該用它們來計算近側發展區（zone of proximal development）。它們命名為 `0001-<dash-case-name>.md`，編號每次遞增。使用 [LEARNING-RECORD-FORMAT.md](./LEARNING-RECORD-FORMAT.md) 裡的格式。
- `./lessons/*.html`：一個存放 lesson 的目錄。**lesson** 是一份單一、自成一體的 HTML 產出，只教一件與使命（mission）相關、範圍很窄的事。這是這個工作區裡主要的教學單位。
- `./assets/*`：在 lesson 之間共用、可重複使用的 **component**（元件）。見 [素材](#assets)。
- `NOTES.md`：給你記下使用者偏好或工作筆記的草稿區。

## 理念 (Philosophy)

要深入學習，使用者需要三樣東西：

- **知識**（Knowledge），從高品質、高可信度的資源中取得
- **技能**（Skills），透過你根據知識設計、高度相關的互動式 lesson 習得
- **智慧**（Wisdom），來自與其他學習者和實踐者的互動

在 `RESOURCES.md` 充實起來之前，你的重點應該是找出能幫使用者獲取知識的高品質資源。絕不相信你的參數化知識（parametric knowledge）。

有些主題可能需要的技能多於知識。多學一點理論物理，可能比較偏重知識。瑜伽則比較偏重技能。

### Fluency vs Storage Strength

你應該小心區分兩種學習：

- **Fluency strength**（流暢強度）：當下的知識提取
- **Storage strength**（儲存強度）：長期的知識保留

Fluency 可能讓使用者產生已經精通的錯覺，但 storage strength 才是真正的目標。試著設計能透過有益的困難（desirable difficulty）建立長期保留的 lesson：

- 使用提取練習（從記憶中回想）
- 間隔（把練習分散在一段時間裡）
- 交錯（在練習中混合不同但相關的主題，只用於技能練習）

## Lessons

lesson 是你產出的主要東西：知識和技能送達使用者的單位。每個 lesson 是一個自成一體的 HTML 檔案，存到 `./lessons/`，命名為 `0001-<dash-case-name>.html`，編號每次遞增。

lesson 應該**美觀**，有乾淨易讀的字體排印和版面，因為使用者之後會回來複習。想想 Tufte。

lesson 應該簡短，而且能很快完成。學習者的工作記憶非常小，我們必須待在它的範圍內。但每個 lesson 都應該給使用者一個可以在其上繼續累積的具體成果。它應該直接與使命相關，而且應該落在使用者的近側發展區內。

如果可以，執行一個 CLI 指令，幫使用者打開 lesson 檔案。

每個 lesson 都應該透過 HTML 錨點，連結到其他 lesson 和參考文件。

每個 lesson 都應該推薦一份 primary source（一手資料）給使用者閱讀或觀看。這應該是你在這個主題上找到的品質最高、可信度最高的資源。

每個 lesson 都應該包含一句提醒，請使用者向 agent（AI 代理）提出後續問題。agent 是他們的老師，可以協助任何不清楚的地方。

<a id="assets"></a>
## 素材 (Assets)

lesson 由可重複使用的 **component** 組成，存放在 `./assets/`：樣式表、測驗小工具、模擬器、圖表輔助工具，以及任何第二個 lesson 可以重複使用的東西。

重複使用是預設，不是例外。撰寫 lesson 之前，先讀 `./assets/`，用已經有的 component 來建構。當一個 lesson 需要新的、可重複使用的東西時，把它寫成 `./assets/` 裡的 component 並連結它；絕不內嵌未來的 lesson 會重複的程式碼。

共用樣式表是每個工作區第一個該有的 component：每個 lesson 都連結它，所以這些 lesson 看起來像一門一致的課程，而不是一堆各自為政的單品。隨著工作區成長，component 庫也應該跟著成長。

## 使命 (The Mission)

每個 lesson 都應該和使命相連：使用者想學這個主題的原因。

如果使用者對使命不清楚，或 `MISSION.md` 還沒有內容，你的第一件工作應該是詢問使用者為什麼想學這個。

不了解使命，就代表知識的獲取沒有建立在真實世界的目標上。lesson 會感覺太抽象。你會沒辦法判斷使用者下一步該做什麼。

隨著使用者發展出更多技能和知識，使命可能會改變。這很正常：務必更新 `MISSION.md`，並新增一筆學習紀錄來記錄這個改變。改變使命之前，先和使用者確認。

## 近側發展區 (Zone Of Proximal Development)

每一個 lesson，使用者都應該一直覺得自己受到「剛剛好」的挑戰。

使用者可能會指定一個他們想學的確切東西。如果沒有，就這樣找出他們的近側發展區：

- 閱讀他們的 `learning-records`
- 根據他們的使命，找出該教他們的正確內容
- 教最相關、而且落在他們近側發展區內的東西

## 知識 (Knowledge)

lesson 應該圍繞使用者要學的一項技能來設計。lesson 裡的知識，應該只包含習得那項技能所需的部分。你先教知識，再讓使用者透過互動式 feedback loop（回饋迴圈）練習技能。

知識應該先從可信的資源收集。用 `RESOURCES.md` 追蹤這些資源。lesson 裡應該到處都是引用來源：連到外部資源的連結，用來支持每一個主張。這會提高 lesson 的可信度。

對於獲取知識來說，困難是敵人。它會吃掉你理解時需要的工作記憶。

## 技能 (Skills)

如果說知識的重點是獲取，技能的重點就是持久與靈活。讓知識記得牢。

對於技能的習得來說，困難是工具。費力的提取，正是建立 storage strength 的方式。技能應該透過互動式 lesson 來教。你手上有幾種工具：

- 互動式 lesson，使用測驗和輕量的瀏覽器內任務
- 引導使用者完成一連串真實世界步驟的 lesson（例如瑜伽姿勢）

這些都應該以一個 **feedback loop** 為基礎，讓使用者收到關於自己表現的回饋。這個 feedback loop 應該越緊密越好，立即給予回饋，最好還是自動的。

對於測驗，每個答案應該剛好是相同的字數（可以的話，字元數也相同）。在不同題目間變換正確答案所在的位置。不要透過格式或順序，給使用者任何關於答案的線索。

## 獲取智慧 (Acquiring Wisdom)

智慧來自真正的真實世界互動：在學習環境之外測試你的技能。

當使用者問了一個似乎需要智慧的問題時，你的預設姿態應該是嘗試回答，但最終要交給一個 **community**（社群）。

community 是一個地方（線上或線下），使用者可以在那裡於真實世界中測試自己的技能。這可能是論壇、subreddit、真實世界的課程（預算允許的話）或在地的同好團體。

你應該嘗試找出使用者可以加入的高聲譽 community。如果使用者表示不想加入 community，就尊重這個偏好。

## 參考文件 (Reference Documents)

在建立 lesson 的同時，你也應該建立參考文件。lesson 可以引用這些文件：它們有助於追蹤在多個 lesson 之間都有用的知識原始單位。

lesson 之後很少會被重看；參考文件則會。它們應該是 lesson 壓縮後的精華，採用為快速查閱而設計的格式。

有些學習主題很適合做成參考資料：

- 程式設計用的語法和程式碼片段
- 流程用的演算法和流程圖
- 瑜伽用的瑜伽姿勢和序列
- 健身用的動作和訓練組合
- 任何有自己專有名詞的主題都適用的 glossary

尤其 glossary 是一種不可或缺的參考資料。一旦建立了，每個 lesson 都應該遵守它。

## `NOTES.md`

使用者有時會表達他們想被怎麼教的偏好，或是你應該記住的事。這裡就是記錄這些偏好的地方，讓你在設計 lesson 或和使用者合作時可以回頭參考。
