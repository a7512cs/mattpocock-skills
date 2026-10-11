---
name: tdd
description: Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests.
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/engineering/tdd/SKILL.md)
>
> **description 中譯：** 測試驅動開發。當使用者想用先寫測試的方式開發功能或修 bug、提到 "red-green-refactor"（紅燈、綠燈、重構），或想要整合測試時使用。

# 測試驅動開發 (Test-Driven Development)

TDD（測試驅動開發）就是 red → green（紅燈 → 綠燈：先寫一個會失敗的測試，再讓它通過）的循環。這個 skill（技能）是一份參考，讓這個循環產出值得保留的測試：什麼是好的測試、測試要放在哪裡、反模式，以及循環的規則。每一個區段在每一輪循環中都適用：在循環之前和進行中查閱它們，而不是之後。

在探索 codebase（程式碼庫）時，讀 `GLOSSARY.md`（如果存在），讓測試名稱和 interface（介面）用詞符合專案的領域語言，並尊重你正在修改的區域中的 ADR（架構決策紀錄）。

## 什麼是好的測試 (What a good test is)

測試透過公開的 interface 驗證行為，而不是 implementation（實作）細節。程式碼可以整個改掉；測試不應該跟著改。好的測試讀起來像一份規格："user can checkout with valid cart"（使用者可以用有效的購物車結帳）明確告訴你存在什麼能力，而且它能撐過 refactor（重構），因為它不在乎內部結構。

範例請見 [tests.md](tests.md)，mock（模擬物件）指引請見 [mocking.md](mocking.md)。

## Seams：測試放在哪裡 (Seams: where tests go)

**seam**（接縫）是你進行測試的那個公開邊界：你在這個 interface 上觀察行為，而不用伸進內部。測試放在 seam 上，絕不針對內部。

**只在事先同意的 seam 上測試。** 寫任何測試之前，先寫下要測試的 seam，並跟使用者確認。不在未經確認的 seam 上寫任何測試。你不可能測試所有東西，所以事先就 seam 達成共識，才能讓測試的心力落在關鍵路徑和複雜邏輯上，而不是每一個邊界情況上。

詢問：「公開的 interface 是什麼？我們應該測試哪些 seam？」為每個提議的 seam 附上一行說明，寫出它能抓到什麼、會漏掉什麼。

當那個 interface 的形狀本身就有疑問時（module（模組）有多深、seam 應該放在哪裡、interface 應該公開什麼），就用 "codebase-design" 呼叫 Skill 工具，取得相關詞彙。它是 module、interface、depth（深度）、seam、adapter（轉接層）、leverage（槓桿）和 locality（區域性）這些術語的共同來源，而且它是一份要查閱的參考，不是一個要執行的 session（工作階段）。

## 反模式 (Anti-patterns)

- **與 implementation 耦合 (Implementation-coupled)**：mock 內部的協作者、測試 private 方法，或透過旁路驗證（查詢資料庫，而不是使用 interface）。徵兆：你 refactor 時測試壞了，但行為並沒有改變。
- **套套邏輯 (Tautological)**：斷言用跟程式碼相同的方式重新計算預期值（`expect(add(a, b)).toBe(a + b)`、用同樣方式手動推導出來的 snapshot、一個被斷言等於它自己的常數），所以它在結構上必然通過，永遠不可能跟程式碼意見不同。預期值必須來自一個獨立的事實來源：一個已知正確的字面值、一個算過的例子、spec（規格）。
- **Horizontal slicing**（水平切片）：先寫完所有測試，再寫完所有 implementation。一次大量寫好的測試驗證的是*想像中*的行為：你測的是東西的*形狀*，而不是面向使用者的行為，測試會對真正的改變變得不敏感，而且你在理解 implementation 之前就把測試結構定死了。改用 **vertical slice**（垂直切片）的方式工作：一個測試 → 一段 implementation → 重複，每個測試都是一顆 **tracer bullet**（曳光彈：先打通整條路徑的最小實作），回應上一輪循環教給你的東西。

## 循環的規則 (Rules of the loop)

- **先 red 再 green。** 先寫會失敗的測試，然後只寫剛好足以讓它通過的程式碼。不要預想未來的測試，也不要加入推測性的功能。
- **一次一個切片。** 每一輪循環：一個 seam、一個測試、一段最小的 implementation。
- **Refactor 不是循環的一部分。** 它屬於 review 階段（見 `code-review` skill），不屬於 red → green 的 implementation 循環。
