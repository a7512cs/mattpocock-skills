---
"mattpocock-skills": patch
---

> 繁體中文翻譯。原文：[wizard-template-fixes.md](../../.changeset/wizard-template-fixes.md)

`wizard` 範本修正：`ask` 改用 Readline，讓方向鍵可以移動游標（#741）；`write_env` 用單引號包住值，讓空格、`#`、`$` 和引號在經過 `source` 與 dotenv 處理後都能保留（#770）；沒有可用的瀏覽器開啟程式時，`open_url` 會印出請你自行開啟的警告（#774）；`write_env` 會穿過 symlink 寫入 `.env`，並保留既有檔案的權限模式（#811）；`ask` 和 `ask_secret` 在遇到 EOF 時會失敗，而不是一直迴圈（#852）。
