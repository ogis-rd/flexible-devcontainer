#!/bin/bash
#===============================================================================
#        CACERT: helmはUbuntuへインストールした証明書が有効となるため個別対応は不要。
#=============================================================================== 

set -e

source common.sh

PACKAGE_NAME="Helm"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. major version: " $MAJOR_VERSION ", version: " $VERSION

# add gnupg
apt-get update && apt-get install apt-transport-https gnupg --yes \
  && curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
  && apt-get update

if [ "$VERSION" ]; then
    INSTALL_TARGET_VERSION=$VERSION
else
    LATEST_VERSION=$(get_latest_version_from_apt "helm" "$MAJOR_VERSION")
    if [ -z "$LATEST_VERSION" ]; then
        echo "E: Major version '$MAJOR_VERSION' for '$PACKAGE_NAME' was not found." >&2
        exit 1
    fi
    INSTALL_TARGET_VERSION=$LATEST_VERSION
fi

echo "$PACKAGE_NAME install version: " $INSTALL_TARGET_VERSION
apt-get install -y helm=$INSTALL_TARGET_VERSION

apt-get clean && rm -rf /var/lib/apt/lists/*

echo "$PACKAGE_NAME install Done!"