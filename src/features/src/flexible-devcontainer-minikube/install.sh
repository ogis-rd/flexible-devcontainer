#!/bin/bash
#===============================================================================
#         NOTES:  minikube startではdocker daemonとminikubeのdocker コンテナインスタンスに同一IPでアクセスできる必要がある。
#                 そのため、DOCKER_HOSTにdocker.sockではなく、docker networkであるbridgeのgatewayのIPを指定することで、
#                 docker daemonとminikubeのdocker コンテナインスタンスに同一IPでアクセスできるようにする。
#        CACERT:  手動でminikubeのdockerコンテナ内のdocker daemonに証明書をインストール必要がある。手順は開発環境利用手順.mdを参照
#===============================================================================
set -e

source common.sh

PACKAGE_NAME="Minikube"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. major version: " $MAJOR_VERSION ", version: " $VERSION

add_env_val_if_not_exist_func "$_REMOTE_USER_HOME/.bashrc"

cat << EOF >> "$_REMOTE_USER_HOME/.bashrc"
ADD_NO_PROXY=$ADD_NO_PROXY
add_env_val_if_not_exist no_proxy "\$ADD_NO_PROXY"
add_env_val_if_not_exist NO_PROXY "\$ADD_NO_PROXY"
EOF

# NOTESの記載参照
echo "export DOCKER_HOST=tcp://$DOCKER_BRIDGE_NW_GW_IP" >> "$_REMOTE_USER_HOME/.bashrc"

if [ "$VERSION" ]; then
    INSTALL_TARGET_VERSION=$VERSION
else
    LATEST_VERSION=$(get_latest_version_from_github "release" "https://api.github.com/repos/kubernetes/minikube/releases" "$MAJOR_VERSION")
    if [ -z "$LATEST_VERSION" ]; then
        echo "E: Major version '$MAJOR_VERSION' for '$PACKAGE_NAME' was not found." >&2
        exit 1
    fi
    INSTALL_TARGET_VERSION=$LATEST_VERSION
fi

echo "$PACKAGE_NAME install version: " $INSTALL_TARGET_VERSION

curl -LO https://github.com/kubernetes/minikube/releases/download/$INSTALL_TARGET_VERSION/minikube-linux-amd64 \
    && install minikube-linux-amd64 /usr/local/bin/minikube

echo "$PACKAGE_NAME install Done!"