#!/bin/bash

# featuresのinstall.shで共通的に利用する関数を定義する
# 各feature毎に独立したinstallerになるので、common.shを共有することはできない。
# 必要な場合のみcommon.shをコピーして利用すること。
# 将来的にはgithub actionでfeaturesをghcrでリリースする時に、common.shを取り込むように修正する

# 仕様:
#   指定されたパッケージ、メジャーバージョンに該当する最新のバージョンを取得する。rc、betaバージョンは除く。
# パラメーター:
#   $1 - パッケージ名 (例: "bash", "nginx")
#   $2 - メジャーバージョン（バージョン接頭辞） (例: "1", "2")
# 処理結果:
#   指定された条件に一致する最新のバージョン番号を標準出力に設定する。
get_latest_version_from_apt() {
     echo $(apt-cache madison "$1" | cut -d'|' -f2 | tr -d ' ' | grep -v -- '-rc' | grep -v -- '-beta' | grep "^$2\." | sort -Vr | head -n1)
}

# 仕様:
#   指定されたプレフィックス（メジャーバージョン）に該当する最新のバージョンを取得する。-rc、-betaは除く。
# パラメーター:
#   $1 - release or tag
#   $2 - github url (例: "https://api.github.com/repos/GoogleContainerTools/skaffold/releases", "https://api.github.com/repos/golang/go/tags")
#   $3 - プレフィックス（メジャーバージョン） (例: "go1")
#   $3以降 - 除外パターン (例: "rc", "beta")
# 処理結果:
#   指定された条件に一致する最新のバージョン番号を標準出力に設定する。
get_latest_version_from_github() {
    local TARGET_FIELD_NAME
    if [ "$1" == "tag" ]; then
        TARGET_FIELD_NAME=name
    else
        TARGET_FIELD_NAME=tag_name
    fi
    local url=$2
    local prefix=$3
    shift
    shift
    shift
  
    local exclude_patterns=("$@")
    # defualt exclude patterns
    exclude_patterns+=("\-rc")
    exclude_patterns+=("\-beta")
    exclude_patterns+=("\-alpha")

    local page=1
    local all_tags=()
    while :; do
        local tags
        tags=$(curl --silent "$url?per_page=100&page=$page" | grep "$TARGET_FIELD_NAME" | sed -E 's/.*"([^"]+)".*/\1/')
        [[ -z $tags ]] && break
        all_tags+=($tags)
        ((page++))
    done
    local IFS=$'\n'
    local exclude_pattern
    local filtered_tags=()

    if [ ${#exclude_patterns[@]} -ne 0 ]; then
        exclude_pattern=$(printf "|%s" "${exclude_patterns[@]}")
        exclude_pattern=${exclude_pattern:1}  # 先頭のパイプを削除
        filtered_tags=($(echo "${all_tags[*]}" | grep -v -E "$exclude_pattern"))
    else
        filtered_tags=("${all_tags[*]}")
    fi

    echo $(echo "${filtered_tags[*]}" | grep "^$prefix" | sort -Vr | head -n1)
}


# 仕様:
#   実行の環境のプロキシ設定を取得し、標準出力に設定する。他ユーザーにsuしてコマンドを実行する場合に利用する。
# パラメーター:
#   $1 - &&で区切るかどうか (例: "true", "false")。デフォルトはtrue。
# 関数の仕様:
#   実行の環境のプロキシ設定を取得し、exportコマンドを生成して標準出力に設定する。
#   HTTPS_PROXY, HTTP_PROXY, NO_PROXYの環境変数が設定されている場合のみ、exportコマンドを生成する。
create_export_proxy_command_from_current_env() {
    local delimiter_condition=${1:-true}
    local PROXY_LIST=("HTTPS_PROXY" "HTTP_PROXY" "NO_PROXY")
    local DELIMITER="&&"
    local PROXY_EXPORT_COMMAND=()
    if [ $delimiter_condition = false ]; then
        DELIMITER=""
    fi

    for var in "${PROXY_LIST[@]}"; do
        value="${!var}"
        if [[ -n "$value" ]]; then
            # exportコマンドは&&区切り無しでも連続して実行可能
            PROXY_EXPORT_COMMAND+=("export $var=$value $DELIMITER")
        fi
    done
    echo "${PROXY_EXPORT_COMMAND[*]}"
}

# 仕様:
#   指定されたファイルに、add_env_val_if_not_exist関数が存在しない場合は、追記する。
# パラメーター:
#   $1 - ファイルパス (例: "/home/abc/.bashrc")
# add_env_val_if_not_exist関数の仕様:
#   第一引数の環境変数に第二引数の値が存在しない場合は、第二引数の値を追加する。
# パラメーター:
#   $1 - 環境変数名 (例: "no_proxy", "NO_PROXY")
#   $2 - 値 (例: "0.0.0.0/32,1.1.1.1/32")
add_env_val_if_not_exist_func() {
    if ! grep -qF "add_env_val_if_not_exist" "$1"; then
        cat << EOF >> "$1"

add_env_val_if_not_exist() {
local current_value=\$(eval echo \\$\${1})
local new_value=\$current_value
local value_added=false

if [ -z "\$current_value" ]; then
    export \$1=\$2
    return
fi
local IFS=','
read -r -a ips <<< "\$2"
for ip in "\${ips[@]}"; do
    if ! echo "\$current_value" | grep -q "\$ip"; then
    new_value="\${new_value:+\$new_value,}\$ip"
    value_added=true
    fi
done
if [ "\$value_added" = true ]; then
    export \$1="\$new_value"
fi
}
EOF
    fi
}
