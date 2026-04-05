#!/bin/bash

# 檢查 jq 是否安裝
if ! command -v jq &> /dev/null; then
    echo "錯誤: 此腳本需要 jq，請先安裝 (pacman -S jq)"
    exit 1
fi

# --- 參數設定 (若未提供則使用預設值) ---
# $1: 輸出路徑
# $2: 網頁標題 (Page Title)
# $3: 側邊欄標題 (Sidebar Header)
# $4: 預覽區標題 (Placeholder Title)
# $5: 預覽區副標題 (Placeholder Subtitle)

OUTPUT_FILE="${1:-./settings.json}"
PAGE_TITLE="${2:-yfhd 的技術文檔庫}"
SIDEBAR_HEADER="${3:-專案文件存檔}"
PLACEHOLDER_TITLE="${4:-請由左側選擇文件}"
PLACEHOLDER_SUBTITLE="${5:-點擊目錄即可即時預覽 PDF 內容}"

echo "--- 正在產生設定檔 ---"
echo "輸出路徑: $OUTPUT_FILE"
echo "網頁標題: $PAGE_TITLE"

# 使用 jq 安全地產生 JSON
jq -n \
  --arg pt "$PAGE_TITLE" \
  --arg sh "$SIDEBAR_HEADER" \
  --arg pht "$PLACEHOLDER_TITLE" \
  --arg phs "$PLACEHOLDER_SUBTITLE" \
  '{
    pageTitle: $pt,
    sidebarHeader: $sh,
    placeholder: {
      title: $pht,
      subtitle: $phs
    }
  }' > "$OUTPUT_FILE"

echo "--- 設定檔產生完成 ---"