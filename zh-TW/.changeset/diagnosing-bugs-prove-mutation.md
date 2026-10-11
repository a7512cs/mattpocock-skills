---
"mattpocock-skills": patch
---

> 繁體中文翻譯。原文：[diagnosing-bugs-prove-mutation.md](../../.changeset/diagnosing-bugs-prove-mutation.md)

`diagnosing-bugs` 的 Phase 5 現在會要求 agent（代理）在相信 red（紅燈，測試失敗）之前，先用 `diff` 比對強制加入的 mutation（變異）和一份未經修改的原始副本，這樣一個默默什麼都沒改到的編輯，就無法被當成失敗的測試蒙混過關（#955）。
