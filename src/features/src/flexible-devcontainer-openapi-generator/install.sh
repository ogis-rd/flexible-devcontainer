#!/bin/bash

set -e

source common.sh

PACKAGE_NAME="OpenAPI Generator"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. major version: " $MAJOR_VERSION ", version: " $VERSION

PROXY_EXPORT_COMMAND=$(create_export_proxy_command_from_current_env)

# install.shではREMOTE_USERへ環境変数が引き継がれないため、コマンド実行時に直接指定する
if [ "$VERSION" ]; then
    su - $_REMOTE_USER -c ". ~/.nvm/nvm.sh && $PROXY_EXPORT_COMMAND export NODE_EXTRA_CA_CERTS=$NODE_EXTRA_CA_CERTS && npm install -g openapi-generator-plus@$VERSION"
else
    su - $_REMOTE_USER -c ". ~/.nvm/nvm.sh && $PROXY_EXPORT_COMMAND export NODE_EXTRA_CA_CERTS=$NODE_EXTRA_CA_CERTS && npm install -g openapi-generator-plus@$MAJOR_VERSION"
fi

echo "$PACKAGE_NAME install Done!"