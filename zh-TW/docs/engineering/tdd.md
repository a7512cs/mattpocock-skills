> 繁體中文翻譯。原文：[tdd.md](../../../docs/engineering/tdd.md)

## 它做什麼 (What it does)

`tdd` 以 test 優先的方式開發功能或修 bug：先寫一個會失敗的 test，再寫剛好足以讓它通過的程式碼，然後處理下一個行為。它帶有讓這個迴圈產出值得保留的 test 的標準：什麼是好的 test、test 該放在哪裡、mock（模擬物件）是用來做什麼的，以及讓整套 test 變得毫無價值的三種反模式。

它不會在你還沒先同意的 seam（接縫：可以觀察行為的公開邊界）上寫任何 test。在任何 test 存在之前，它會說出它打算在哪些公開邊界上測試，並停下來等你確認。測試的精力是有限的，而這一步會把精力花在關鍵路徑上，而不是每一個邊界情況。`tdd` 也是一份**參考資料**，而不是驅動者。它包含迴圈的規則，而由別的東西（你，或 [implement](https://aihero.dev/skills-implement)）來執行套用這些規則的 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段）。

## 什麼時候用它 (When to reach for it)

輸入 `/tdd`，或者在任務適合時，[agent](https://www.aihero.dev/ai-coding-dictionary/agent)（代理）會自動使用它：以 test 優先的方式開發功能或修 bug，或當你說 "red-green-refactor"（紅燈、綠燈、重構）時。

當有一個具體的行為要做，它有輸入和可觀察的輸出，而且你想要能在 refactor（重構）之後存活的 test 時，就用它。

| 你的情況 | 該去哪裡 |
| --- | --- |
| 一個有明確輸入和輸出的行為（商業邏輯、request/response 契約、資料轉換、驗證） | `tdd` |
| 行為還沒確定下來 | [to-spec](https://aihero.dev/skills-to-spec)，它也會在寫任何程式碼之前先談定 test seam（測試接縫） |
| 問題其實是 interface（介面）的形狀，而不是 test | [codebase-design](https://aihero.dev/skills-codebase-design) |
| 你有一份 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格）或 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)（工單），想讓整個建置流程替你跑完 | [implement](https://aihero.dev/skills-implement)，它會為每張 ticket 驅動 `tdd` |
| 設定、接線、膠水程式碼、型別標註、單純的 CRUD 委派 | 這裡沒有很適合的；見下方的未解缺口 |

最後那一列是真實存在的缺口。這個 skill（技能）決定 seam 要放在*哪裡*，但裡面沒有任何東西決定某個變更到底*值不值得*走這個迴圈。如果你在一個沒有獨立事實來源可以拿來斷言的變更上執行它，你會得到一個只是在重述 implementation（實作）的 test。那就是這個 skill 警告的套套邏輯反模式，只是從另一個方向抵達。這是 [issue #746](https://github.com/mattpocock/skills/issues/746)（議題），目前仍未解決。在它關閉之前，你得自己做這個判斷，或把規則寫進你的 `CLAUDE.md`。

## 前置條件 (Prerequisites)

需要安裝 [codebase-design](https://aihero.dev/skills-codebase-design)。`tdd` 以前自帶 deep module（深模組）和 interface 設計的筆記；v1.0 刪掉了它們，改用共用的 skill，而 `tdd` 現在使用它的 interface 設計詞彙。除此之外不需要別的；這個 skill 是 [stateless](https://www.aihero.dev/ai-coding-dictionary/stateless)（無狀態）的，不會寫任何屬於自己的檔案。

## 迴圈，以及它執行時所在的 seam (The loop, and the seam it runs at)

這個 skill 建立在三個術語上。

**Red-green**（紅燈、綠燈）。先寫會失敗的 test，然後只寫足以讓它通過的程式碼。不要為下下個 test 寫程式碼。沒有 refactor 階段。這個 skill 在 2026 年 6 月拿掉了它，因為 agent 幾乎從不執行這一步，也因為審查和實作分成不同的 session 效果比較好。refactor 屬於 [code-review](https://aihero.dev/skills-code-review) 的工作。

**Vertical slice**（垂直切片）。在一個 seam 上寫一個 test，然後寫最小的實作，接著重複。第一輪是一個 **tracer bullet**（曳光彈），證明單一路徑可以從頭到尾走通。相反的做法是 horizontal slicing（水平切分）：先寫所有 test，再寫所有程式碼。大批寫出的 test 驗證的是*想像中*的行為。它們檢查的是東西的形狀，而不是使用者會做什麼，而且會在你理解實作之前，就把你綁死在某種 test 結構上。

**Pre-agreed seam**（事先談定的 seam）。seam 是你不必伸手進內部、就能觀察行為的公開邊界。這條規則沒有例外。任何 test 都不能放在未經確認的 seam 上。在完整的鏈中，seam 會更早談定，也就是在 [to-spec](https://aihero.dev/skills-to-spec) 期間：「`/tdd` 被告知只在事先談定的 test seam 上工作，`/code-review` 檢查是否只使用了談定的 test seam。」單獨呼叫時，`tdd` 會直接問你。

它要防止的三種反模式：

| 反模式 | 徵兆 |
| --- | --- |
| Implementation-coupled（與實作耦合） | 你重新命名一個內部函式時 test 就壞了，即使行為並沒有改變。mock 了內部協作者、斷言呼叫次數、用資料庫查詢來驗證而不是透過 interface。 |
| Tautological（套套邏輯） | 預期值的計算方式和程式碼的計算方式一樣，所以 test 從結構上就一定會通過。預期值必須來自別的地方：已知正確的字面值、實際算過的範例、spec。 |
| Horizontal slicing | 在任何實作之前就先落地了一批 test。 |

mock 只用在系統邊界：外部 API、時間、亂數，有時候是檔案系統或資料庫。絕對不要 mock 你自己的 module（模組）。

## 常見問題 (Common questions)

**為什麼它不做 refactor？description 上寫的是 "red-green-refactor"。**

因為 refactor 步驟被移除了，但 description（描述）沒有。移除是刻意的。agent 幾乎從不做這一步，而把實作和審查放在不同的 session 效果比較好。結果是否仍算是教科書上的 TDD（測試驅動開發），不如這個迴圈能否產出更好的程式碼來得重要。trigger（觸發）用語和內文之間的不一致已經回報為 [issue #589](https://github.com/mattpocock/skills/issues/589)，目前仍未解決，所以 "red-green-refactor" 仍然是能觸發這個 skill 的用語。你得到的是 red-green，而 refactor 交給 [code-review](https://aihero.dev/skills-code-review)。

**它要我選一個 test seam，但我完全不知道該選哪個。**

這是這個 skill 最常被回報的摩擦點（[issue #607](https://github.com/mattpocock/skills/issues/607)）。那個提問只按名稱列出候選 seam，完全沒說明每一個能抓到什麼、會漏掉什麼，所以你只是在幾個標籤之間做選擇。目前還沒有發布修正。實際的變通方法是在回答之前先問 agent 各選項的取捨：元件層級的 seam 會漏掉哪些整合層級的 seam 抓得到的東西，以及它會慢多少。這也是為什麼整條鏈會在 `to-spec` 階段就先談定 seam，因為那時你看得到整個功能，而不只是一個提問。

**即使 skill 說要先 red，它還是先寫了實作才寫 test。**

這種事會發生。有一位使用者就這件事追問 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型），得到一個異常誠實的回答：「我知道 skill 說『一次一個 test，看著它因為正確的原因失敗』。我讀過了。我只是預設回到了我平常的習慣。」這個 skill 接受這一點。沒有任何指示能讓 agent 100% 遵守，而更嚴格的措辭會限制 agent 的創造力，卻得不到多少好處。即使 agent 沒有嚴格遵守，這個迴圈仍然值得跑，因為整體結果還是比較好。如果某個切片特別需要嚴格遵守，就盯著執行過程，而不是信任 skill 會強制執行。

**它應該先寫瀏覽器 test 或端對端 test 嗎？**

通常不應該，而且 skill 不會阻止它。有使用者回報，agent 先寫了一個 Playwright test，然後花了很長的迴圈反覆重跑，最後得出結論說是 *test* 壞了，但那個功能根本還不存在。瀏覽器 test 慢到讓 red-green 回饋迴圈不再划算。在你 repo（儲存庫）的 `CLAUDE.md` 中寫明：瀏覽器 test 要等行為能運作之後才寫。

**`/tdd` 會取代 `/implement`，或課程裡的 `/do-work` 嗎？**

不會。`/tdd` 記錄的是方法論；`/implement` 是一個簡單的「工作→回饋→commit（提交）」迴圈，也是 `/do-work` 的直接替代品。課程中單一的 `/do-work` 步驟，現在拆分到 `/implement`、`/tdd` 和 `/code-review`。如果你問的是要對一張 ticket 執行哪一個，答案幾乎總是 `/implement`。

**deep module 和 interface 設計的指引去哪了？**

在 v1.0 移到了 [codebase-design](https://aihero.dev/skills-codebase-design)，並經過一般化，讓好幾個 skill 共用同一套詞彙。`refactoring.md` 也同時移除了；refactor 現在是 [code-review](https://aihero.dev/skills-code-review) 的工作，而那個 skill 帶有 Fowler 的 smell（程式碼異味）基準。

**它知道我的其他 ticket 嗎？**

不知道。針對一張 ticket 執行時，它可能會提出屬於另一張同層 ticket 的工作，因為它看不到 issue 關係圖的其他部分（[issue #129](https://github.com/mattpocock/skills/issues/129)）。這不是 `tdd` 的工作。把 spec 和 ticket 一起傳進去會有幫助；一開始就把 ticket 切成適當大小則更有幫助。

## 運作正常的跡象 (It's working if)

- 在任何 test 檔案存在之前，它會停下來說出打算在哪些 seam 上測試，然後等待。
- 一個 test 出現、變紅、得到剛好足以通過的程式碼，然後下一個 test 才出現，而不是一批 test 後面跟著一批程式碼。
- test 名稱讀起來是能力（"user can checkout with valid cart"），而不是內部細節（"checkout calls paymentService.process"）。
- 斷言中的預期值是可以追溯到 spec 的字面值，而不是用程式碼的計算方式重新算出來的值。
- 重新命名一個內部函式，不會讓整套 test 中任何東西壞掉。
- mock 只出現在外部邊界（付款 API、時鐘），從不出現在你自己的 module 周圍。

## 它在流程中的位置 (Where it fits)

`tdd` 在主鏈的建置步驟裡面執行；它本身不是一個獨立步驟：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

[to-spec](https://aihero.dev/skills-to-spec) 事先談定 test seam，[implement](https://aihero.dev/skills-implement) 為每張 ticket 驅動 `tdd`，而 [code-review](https://aihero.dev/skills-code-review) 事後檢查是否只使用了談定的 seam，並負責 `tdd` 不再做的 refactor。它的另一個鄰居是 [codebase-design](https://aihero.dev/skills-codebase-design)，也就是 `tdd` 所使用的 seam 和 deep module 詞彙的共用來源。只要有具體的行為要做、而且沒有完整的 spec，你也可以單獨使用它。當你不確定哪個 skill 適合你的情況時，[ask-matt](https://aihero.dev/skills-ask-matt) 會幫你指路。
