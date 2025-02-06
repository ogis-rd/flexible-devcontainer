#!/bin/bash
set -e

#
# Dockerfileで制御できない実装を行う
#

source common.sh

PACKAGE_NAME="mngmnt"

echo "$PACKAGE_NAME install Start!"

add_env_val_if_not_exist_func "$_REMOTE_USER_HOME/.bashrc"

cat << EOF >> "$_REMOTE_USER_HOME/.bashrc"
ADD_NO_PROXY=$ADD_NO_PROXY
add_env_val_if_not_exist no_proxy "\$ADD_NO_PROXY"
add_env_val_if_not_exist NO_PROXY "\$ADD_NO_PROXY"
EOF

echo "$PACKAGE_NAME install Done!"