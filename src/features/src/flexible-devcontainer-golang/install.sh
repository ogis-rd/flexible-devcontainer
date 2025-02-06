#!/bin/bash
#===============================================================================
#        CACERT: golangはUbuntuへインストールした証明書が有効となるため個別対応は不要。
#=============================================================================== 

set -e

source common.sh

PACKAGE_NAME="Golang"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. major version: "$MAJOR_VERSION", version: " $VERSION

if [ "$VERSION" ]; then
    INSTALL_TARGET_VERSION=$VERSION
else
    LATEST_VERSION=$(get_latest_version_from_github "tag" "https://api.github.com/repos/golang/go/tags" "go$MAJOR_VERSION" "rc" "beta")
    if [ -z "$LATEST_VERSION" ]; then
        echo "E: Major version '$MAJOR_VERSION' for '$PACKAGE_NAME' was not found." >&2
        exit 1
    fi
    INSTALL_TARGET_VERSION=$LATEST_VERSION
fi

echo "$PACKAGE_NAME install version: " $INSTALL_TARGET_VERSION

curl -OL "https://go.dev/dl/$INSTALL_TARGET_VERSION.linux-amd64.tar.gz" \
    && tar -C /usr/local -xzf $INSTALL_TARGET_VERSION.linux-amd64.tar.gz

echo 'PATH=$PATH:/usr/local/go/bin' >> $_REMOTE_USER_HOME/.bashrc

echo "$PACKAGE_NAME install Done!"