#!/bin/bash

set -e

source common.sh

PACKAGE_NAME="Kubectl"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. major and minor version: " $MAJOR_MINOR_VERSION ", version: " $VERSION

if [ "$VERSION" ]; then
    MAJOR_MINOR_VERSION=$(echo "$VERSION" | awk -F'.' '{print $1"."$2}')
fi

apt-get update && apt-get install -y apt-transport-https gnupg \
  && curl -fsSL https://pkgs.k8s.io/core:/stable:/v$MAJOR_MINOR_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
  && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v'$MAJOR_MINOR_VERSION'/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
  && apt-get update

if [ "$VERSION" ]; then
    INSTALL_TARGET_VERSION=$VERSION
else
    LATEST_VERSION=$(get_latest_version_from_apt "kubectl" "$MAJOR_MINOR_VERSION")
    if [ -z "$LATEST_VERSION" ]; then
        echo "E: Major version '$MAJOR_MINOR_VERSION' for '$PACKAGE_NAME' was not found." >&2
        exit 1
    fi
    INSTALL_TARGET_VERSION=$LATEST_VERSION
fi

echo "$PACKAGE_NAME install version: " $INSTALL_TARGET_VERSION
apt-get install -y kubectl=$INSTALL_TARGET_VERSION

apt-get clean && rm -rf /var/lib/apt/lists/*

if [ "$KUBECONFIG" = "/home/＄｛USER｝/workspace/.kube/config" ]; then
  KUBECONFIG=$_REMOTE_USER_HOME/workspace/.kube/config
fi

echo "export KUBECONFIG=$KUBECONFIG" >> $_REMOTE_USER_HOME/.bashrc \
  && echo 'alias k="kubectl"' >> $_REMOTE_USER_HOME/.bashrc \
  && echo 'alias kd="kubectl describe"' >> $_REMOTE_USER_HOME/.bashrc

echo "$PACKAGE_NAME install Done!"