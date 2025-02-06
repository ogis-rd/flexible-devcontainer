#!/bin/bash

set -e

source common.sh

PACKAGE_NAME="ArgoCD CLI"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. major version: " $MAJOR_VERSION ", version: " $VERSION

if [ "$VERSION" ]; then
    INSTALL_TARGET_VERSION=$VERSION
else
    LATEST_VERSION=$(get_latest_version_from_github "release" "https://api.github.com/repos/argoproj/argo-cd/releases" "$MAJOR_VERSION")
    if [ -z "$LATEST_VERSION" ]; then
        echo "E: Major version '$MAJOR_VERSION' for '$PACKAGE_NAME' was not found." >&2
        exit 1
    fi
    INSTALL_TARGET_VERSION=$LATEST_VERSION
fi

echo "$PACKAGE_NAME install version: " $INSTALL_TARGET_VERSION

curl -SL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/$INSTALL_TARGET_VERSION/argocd-linux-amd64 \
    && install -m 555 argocd-linux-amd64 /usr/local/bin/argocd \
    && rm argocd-linux-amd64

echo "$PACKAGE_NAME install Done!"