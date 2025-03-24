FROM ubuntu:22.04

# ライセンス設定
COPY LICENSE /usr/share/doc/flexible-devcontainer/LICENSE

# ロケール/タイムゾーン設定
ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8

RUN apt-get update \
    && apt-get install -y \
    tzdata \
    language-pack-ja-base \
    language-pack-ja locales \
    && apt-get update \
    && apt-get install -y \
    curl \
    wget \
    unzip \
    tar \
    ca-certificates \
    vim \
    jq \
    git \
    # digのパッケージ
    dnsutils \ 
    # netstatのパッケージ
    net-tools \
    lsof \
    #pingのパッケージ
    iputils-ping \
    ssh \
    # systemdのインストール
    systemd \
    init \
    sudo \
    # Docker outside of docker 設定
    gnupg \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli docker-compose-plugin \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

    ENTRYPOINT ["/sbin/init"]