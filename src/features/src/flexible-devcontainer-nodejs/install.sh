#!/bin/bash
#===============================================================================
#        CACERT: DevContainerの定義によるVSCodeの拡張機能のインストール処理がnodeで実行されるため、
#                DockerfileでNODE_EXTRA_CA_CERTSの設定が必要となる。そのため、featureでの個別対応は不要。
#=============================================================================== 

set -e

source common.sh

PACKAGE_NAME="Node.js"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. major version: " $MAJOR_VERSION ", version: " $VERSION

if [ "$VERSION" ]; then
    INSTALL_TARGET_VERSION=$VERSION
else
    INSTALL_TARGET_VERSION=$MAJOR_VERSION
fi

PROXY_EXPORT_COMMAND=$(create_export_proxy_command_from_current_env)

# NonRootでnvmでnodeのインストール
su - $_REMOTE_USER -c "$PROXY_EXPORT_COMMAND curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash \
&& . ~/.nvm/nvm.sh && nvm install $INSTALL_TARGET_VERSION"

# install.shではREMOTE_USERへ環境変数が引き継がれないため、コマンド実行時に直接指定する
if [ "$NPM_VERSION" ]; then
    su - $_REMOTE_USER -c ". ~/.nvm/nvm.sh && $PROXY_EXPORT_COMMAND export NODE_EXTRA_CA_CERTS=$NODE_EXTRA_CA_CERTS && npm install -g npm@$NPM_VERSION"
else
    su - $_REMOTE_USER -c ". ~/.nvm/nvm.sh && $PROXY_EXPORT_COMMAND export NODE_EXTRA_CA_CERTS=$NODE_EXTRA_CA_CERTS && npm update -g npm"
fi

if [ "$COREPACK_VERSION" ]; then
    su - $_REMOTE_USER -c ". ~/.nvm/nvm.sh && $PROXY_EXPORT_COMMAND export NODE_EXTRA_CA_CERTS=$NODE_EXTRA_CA_CERTS && npm install -g corepack@$COREPACK_VERSION"
else
    su - $_REMOTE_USER -c ". ~/.nvm/nvm.sh && $PROXY_EXPORT_COMMAND export NODE_EXTRA_CA_CERTS=$NODE_EXTRA_CA_CERTS && npm update -g corepack"
fi

# プロジェクトレベルでのnpm、yarnのバージョン管理はcorepack+package.jsonで行うのでfeatureでは管理しない。

echo "$PACKAGE_NAME install Done!"