#!/bin/bash

set -e

source common.sh

PACKAGE_NAME="skaffold"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. major version: " $MAJOR_VERSION ", version: " $VERSION

if [ "$VERSION" ]; then
    INSTALL_TARGET_VERSION=$VERSION
else
    LATEST_VERSION=$(get_latest_version_from_github "release" "https://api.github.com/repos/GoogleContainerTools/skaffold/releases" "$MAJOR_VERSION")
    if [ -z "$LATEST_VERSION" ]; then
        echo "E: Major version '$MAJOR_VERSION' for '$PACKAGE_NAME' was not found." >&2
        exit 1
    fi
    INSTALL_TARGET_VERSION=$LATEST_VERSION
fi

echo "$PACKAGE_NAME install version: " $INSTALL_TARGET_VERSION

curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/$INSTALL_TARGET_VERSION/skaffold-linux-amd64 \
  && install skaffold /usr/local/bin/

echo "$PACKAGE_NAME install Done!"