#!/bin/bash
#===============================================================================
#        CACERT: aws cliはUbuntuへインストールした証明書が有効となるため個別対応は不要。
#=============================================================================== 

set -e

PACKAGE_NAME="AWS cli"

echo "$PACKAGE_NAME install Start!"

if [ "$AWS_CONFIG_FILE" = "/home/＄｛USER｝/workspace/.aws/config" ]; then
  AWS_CONFIG_FILE=$_REMOTE_USER_HOME/workspace/.aws/config
fi

if [ "$AWS_SHARED_CREDENTIALS_FILE" = "/home/＄｛USER｝/workspace/.aws/credentials" ]; then
  AWS_SHARED_CREDENTIALS_FILE=$_REMOTE_USER_HOME/workspace/.aws/credentials
fi

echo "export AWS_CONFIG_FILE=$AWS_CONFIG_FILE" >> $_REMOTE_USER_HOME/.bashrc
echo "export AWS_SHARED_CREDENTIALS_FILE=$AWS_SHARED_CREDENTIALS_FILE" >> $_REMOTE_USER_HOME/.bashrc

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"  -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install

echo "$PACKAGE_NAME install Done!"