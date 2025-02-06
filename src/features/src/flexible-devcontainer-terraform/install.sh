#!/bin/bash
#===============================================================================
#        CACERT: terraformはUbuntuへインストールした証明書が有効となるため個別対応は不要。
#=============================================================================== 

set -e

source common.sh

PACKAGE_NAME="terraform"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. major version: " $MAJOR_VERSION ", version: " $VERSION

apt-get update && apt-get install -y gnupg software-properties-common \
  && wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  && gpg --no-default-keyring --keyring /usr/share/keyrings/bashicorp-archive-keyring.gpg --fingerprint \
  && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
  && apt update 

if [ "$VERSION" ]; then
    INSTALL_TARGET_VERSION=$VERSION
else
    LATEST_VERSION=$(get_latest_version_from_apt "terraform" "$MAJOR_VERSION")
    if [ -z "$LATEST_VERSION" ]; then
        echo "E: Major version '$MAJOR_VERSION' for '$PACKAGE_NAME' was not found." >&2
        exit 1
    fi
    INSTALL_TARGET_VERSION=$LATEST_VERSION
fi

echo "$PACKAGE_NAME install version: " $INSTALL_TARGET_VERSION
apt-get install -y terraform=$INSTALL_TARGET_VERSION

apt-get clean && rm -rf /var/lib/apt/lists/*

echo "$PACKAGE_NAME install Done!"