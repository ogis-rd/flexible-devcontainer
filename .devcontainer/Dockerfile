ARG BASE_IMAGE_OS=ubuntu24.04
ARG BASE_IMAGE_TAG=latest
# Flexible DevContainerが提供するベースイメージ
# 基本的にlatestを利用してください。最新バージョンは最新の機能を提供し、バグ修正も最も早く行われます。
# もし最新バージョンで問題が発生する場合にのみ、旧バージョンに切り替えて使用してください。
FROM ghcr.io/ogis-rd/flexible-devcontainer/flexible-devcontainer:${BASE_IMAGE_OS}-${BASE_IMAGE_TAG} as base

ARG USERNAME

# cacert.crtが配置されない場合に以下のCOPYがエラーにならないようにするためdummy.crtは必要なファイル。
COPY cacert/*.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

ARG USER_UID=1000
ARG USER_GID=1000

# NODE_EXTRA_CA_CERTSの定義について
# [ルート証明書が必要なプロキシを利用する場合]
#  DevContainerの定義によるVSCodeの拡張機能のインストール処理はnodeで実行される、そのためNODE_EXTRA_CA_CERTSの定義が必要。
#  ＜補足＞
#  ・DevContainerの定義によるVSCodeの拡張機能のインストール処理はdocker execコマンドでコンテナ内のnodeのスクリプトを実行する事で実現している。
#    そのため、bashrcやその他の方法で環境変数を定義しても有効にならない。
#  ・npm config set cafileで証明書を指定するとnpm限定で有効となる。npm installコマンド実行時のスクリプトでnpm以外の方法でダウンロード処理を行うとエラーとなる。そのため、環境変数で指定する。
# [ルート証明書が不要の場合]
#  環境変数の定義は不要だが、DockerfileでENVの定義をする・しないの分岐処理ができないため環境変数は定義する。
#  また、定義したファイルが存在しないと、npmコマンドでワーニングが出るため空のファイルを作成する。
ARG CA_CERT_FILE_NAME="cacert.crt"
ENV CA_CERT_FILE=/usr/local/share/ca-certificates/$CA_CERT_FILE_NAME
ENV NODE_EXTRA_CA_CERTS=$CA_CERT_FILE
RUN if [ ! -f $NODE_EXTRA_CA_CERTS ]; then touch $NODE_EXTRA_CA_CERTS ;fi

# 24.04系固有処理
FROM base as ubuntu24.04-handler
ARG GROUP_ID=989

# 22.04系固有処理
FROM base as ubuntu22.04-handler
ARG GROUP_ID=999

FROM ${BASE_IMAGE_OS}-handler as final
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    # Dockerグループを追加
    && groupadd -g $GROUP_ID docker \
    # Dockerグループにユーザを追加
    && usermod -aG docker $USERNAME

