#!/bin/bash

# 檢查 jq 是否安裝
if ! command -v jq &> /dev/null; then
    echo "錯誤: 此腳本需要 jq，請先安裝 (pacman -S jq)"
    exit 1
fi

# 參數檢查
if [ "$#" -ne 2 ]; then
    echo "使用方式: $0 <輸入資料夾> <輸出 JSON 路徑>"
    exit 1
fi

SCAN_DIR="$1"
OUTPUT_FILE="$2"

mkdir -p "$(dirname "$OUTPUT_FILE")"

# 遞迴函數：只有當資料夾內含檔案時才回傳 JSON
scan_to_json() {
    local current_path="$1"
    local rel_base="$2"
    local items=()

    # 1. 遍歷當前目錄下的所有項目
    while IFS= read -r entry; do
        [ -z "$entry" ] && continue
        
        local name=$(basename "$entry")
        local rel_path="${rel_base}${name}"
        
        if [ -d "$entry" ]; then
            # --- 資料夾處理邏輯 ---
            # 遞迴取得子目錄內容
            local children_json=$(scan_to_json "$entry" "${rel_path}/")
            
            # 關鍵判斷：只有當 children_json 不是 "[]" 時，才新增此資料夾
            if [ "$children_json" != "[]" ]; then
                items+=("$(jq -n \
                    --arg name "$name" \
                    --argjson children "$children_json" \
                    '{name: $name, type: "directory", children: $children}')")
            fi
            
        elif [[ "$entry" == *.pdf ]]; then
            # --- 檔案處理邏輯 ---
            items+=("$(jq -n \
                --arg name "$name" \
                --arg url "$rel_path" \
                '{name: $name, type: "file", url: $url}')")
        fi
    done < <(find "$current_path" -maxdepth 1 -mindepth 1 | sort)

    # 2. 回傳結果
    if [ ${#items[@]} -eq 0 ]; then
        # 如果這層沒有任何檔案，也沒有任何「非空子資料夾」，回傳空陣列
        echo "[]"
    else
        printf '%s\n' "${items[@]}" | jq -s '.'
    fi
}

echo "--- 正在產生過濾後的索引 ---"

# 執行掃描
json_result=$(scan_to_json "$SCAN_DIR" "")

# 寫入檔案（如果連根目錄都是空的，就產出一個空陣列）
echo "$json_result" > "$OUTPUT_FILE"

echo "完成！已排除所有不含 PDF 的空路徑。"