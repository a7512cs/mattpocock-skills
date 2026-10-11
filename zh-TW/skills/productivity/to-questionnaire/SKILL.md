---
name: to-questionnaire
description: Turn a decision you can't fully answer into a questionnaire for someone else to fill in.
disable-model-invocation: true
---

> 繁體中文翻譯。原文：[SKILL.md](../../../../skills/productivity/to-questionnaire/SKILL.md)
>
> **description 中譯：** 把一個你無法完全回答的決定，變成一份讓別人填寫的問卷。

把使用者無法獨自回答的事，變成一份 **questionnaire**（問卷）：一份 Markdown 文件，使用者把它交給某一個人非同步填寫，或在會議中一起填完。接收者擁有使用者缺少的知識；questionnaire 就是把這些知識從他們身上引出來。

**要 grill（追問）的是「發送」，不是主題**。只針對*發送*這件事訪談使用者，這部分他們一定答得出來：要發給誰，以及他們需要拿回什麼。接著，文件裡的問題就瞄準接收者所知與使用者所需之間的 **gap**（落差）。


1. **要發給誰**？在一次交流中問清楚接收者的角色、專長，以及和使用者的關係。這決定了 questionnaire 的語氣，以及它必須附帶多少 context（脈絡）。當你知道接收者是誰、以及他們知道哪些使用者不知道的事時，就算完成。

2. **你需要拿回什麼**？在一次交流中問清楚使用者無法獨自解決、需要從這個人那裡得到的具體決定或事實。當你有一份具體清單，列出使用者最後必須能夠做到或決定的事時，就算完成。

3. **撰寫 questionnaire**。依照下方的文件結構（Document structure），草擬針對第 1 到 2 步那個 gap 的問題。寫到目前目錄下的 `to-questionnaire-<slug>.md`（slug 取自主題），並回報路徑。當檔案存在，而且使用者在第 2 步列出的每一項都有對應的問題時，就算完成。

## 文件結構 (Document structure)

把文件定位成一份 **discovery questionnaire**（探索式問卷）：使用者缺少 context，接收者擁有它。問題依最重要的優先排序，因為非同步代表你可能只有一次機會；一旦問題超過少數幾個，就依主題分組放在 `##` 標題下。用下方的範本撰寫。

<questionnaire-template>

# <問卷標題>

**Purpose:** 這份問卷為什麼存在，以及取決於它的那個決定。

**From:** <使用者>, **To:** <接收者>, **How your answers will be used:** <答案會用在哪裡>

## Context

一段話，幫一個不在使用者腦中的接收者掌握方向。足以讓他好好回答，而不是一整頁。

## How to answer

截止日期和大約需要的工作量。部分答案和 "I don't know"（我不知道）都有用：有任何不確定的地方，標註出來，而不是跳過。

## <主題標題>

每個主題一個 `##` 區段。每個區段底下放它的問題，最重要的優先。每個問題只有一個概念，絕不合併多個，正下方直接附上作答區；只有在問題可能被誤讀、或可能招來敷衍回答時，才加一行 *why this matters*（為什麼這很重要）。

<question-example>
### 系統上線時預期要承受多少負載？

_Why this matters: 它決定我們要現在就為突發流量佈建資源，還是延後處理。_

>
</question-example>

## Anything else?

結尾的總括問題：有沒有我們沒問到、但應該知道的事？

</questionnaire-template>
