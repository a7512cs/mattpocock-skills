---
"mattpocock-skills": patch
---

> 繁體中文翻譯。原文：[wizard-template-fixes-2.md](../../.changeset/wizard-template-fixes-2.md)

`wizard` 範本修正：`_existing` 會解碼用雙引號包住的 `.env` 值，所以「按 Enter 保留目前值」不會再把引號也存進去（#1220）；stage 在 `run_wizard` 內執行，所以在執行途中編輯腳本不會讓它中斷（#1142）；`tput clear` 失敗時，`_clear` 會退回使用 ANSI（#1081）；`write_env` 也會設定 shell 變數（#1041）；拿掉沒用到的 `RED`（#1003）。
