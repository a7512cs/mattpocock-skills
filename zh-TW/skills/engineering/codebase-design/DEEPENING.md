> 繁體中文翻譯。原文：[DEEPENING.md](../../../../skills/engineering/codebase-design/DEEPENING.md)

# 深化 (Deepening)

在考慮依賴關係的前提下，如何安全地深化一群 shallow module（淺模組）。假設你已經熟悉 [SKILL.md](SKILL.md) 裡的詞彙：**module**（模組）、**interface**（介面）、**seam**（接縫）、**adapter**（轉接器）。

## 依賴類別 (Dependency categories)

評估一個深化候選時，先把它的依賴分類。類別決定了深化後的 module 要如何跨過它的 seam 來測試。

### 1. 同一程序內 (In-process)

純計算、記憶體內的狀態、沒有 I/O。永遠可以深化：把這些 module 合併，直接透過新的 interface 測試。不需要 adapter。

### 2. 可在本地替代 (Local-substitutable)

有本地測試替身的依賴（Postgres 用 PGLite、記憶體內的檔案系統）。如果替身存在，就可以深化。深化後的 module 在測試套件中搭配執行中的替身來測試。seam 是內部的；module 的外部 interface 上沒有 port（埠）。

### 3. 遠端但屬於自己（Ports & Adapters） (Remote but owned)

你自己的服務，但隔著網路邊界（microservices、內部 API）。在 seam 上定義一個 **port**（interface）。deep module（深模組）擁有邏輯；傳輸層以 **adapter** 的形式注入。測試使用記憶體內的 adapter。正式環境使用 HTTP/gRPC/queue adapter。

建議的說法格式：*「在 seam 上定義一個 port，為正式環境實作一個 HTTP adapter，為測試實作一個記憶體內的 adapter，這樣即使它是跨網路部署的，邏輯也集中在一個 deep module 裡。」*

### 4. 真正的外部依賴（Mock） (True external)

你無法控制的第三方服務（Stripe、Twilio 等等）。深化後的 module 把外部依賴當成注入的 port 來接收；測試提供一個 mock（模擬）adapter。

## Seam 紀律 (Seam discipline)

- **一個 adapter 代表假想的 seam。兩個 adapter 代表真的 seam**。除非至少有兩個 adapter 是有理由存在的（通常是正式環境 + 測試），否則不要引入 port。只有單一 adapter 的 seam 只是多一層間接。
- **內部 seam vs 外部 seam**。一個 deep module 可以有內部 seam（只屬於它的 implementation（實作），供它自己的測試使用），也可以有位於 interface 的外部 seam。不要只因為測試用到內部 seam，就透過 interface 把它們暴露出去。

## 測試策略：取代，不要疊加 (Testing strategy: replace, don't layer)

- 一旦在深化後 module 的 interface 上有了測試，shallow module 上的舊單元測試就變成浪費；刪掉它們。
- 在深化後 module 的 interface 上寫新的測試。**interface 就是測試面**。
- 測試透過 interface 對可觀察的結果做斷言，而不是對內部狀態。
- 測試應該能撐過內部的 refactor（重構），因為它們描述的是行為，不是 implementation。如果 implementation 改變時測試也得跟著改，那它就是在越過 interface 測試。
