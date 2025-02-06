#!/bin/bash
#===============================================================================
#        CACERT: azure cliはpythonを内包するため、pythonの証明書ストアに証明書を取り込む。
#=============================================================================== 

set -e

PACKAGE_NAME="Azure cli"

echo "$PACKAGE_NAME install Start!"

if [ "$AZURE_CONFIG_DIR" = "/home/＄｛USER｝/workspace/.azure" ]; then
  AZURE_CONFIG_DIR=$_REMOTE_USER_HOME/workspace/.azure
fi

echo "export AZURE_CONFIG_DIR=$AZURE_CONFIG_DIR" >> $_REMOTE_USER_HOME/.bashrc

AZ_DIST=$(lsb_release -cs)

apt-get update \
  && apt-get install -y ca-certificates apt-transport-https lsb-release gnupg \
  && mkdir -p /etc/apt/keyrings \
  && curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null \
  && chmod go+r /etc/apt/keyrings/microsoft.gpg  \
  && echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | tee /etc/apt/sources.list.d/azure-cli.sources \
  && apt-get update && apt-get install -y azure-cli && apt-get clean && rm -rf /var/lib/apt/lists/*

# 証明書のインストール
if [ ! -s "$CA_CERT_FILE" ]; then
    echo "$PACKAGE_NAME install Done!"
    exit 0
fi

if [ "$AZ_CLI_CACERT_FILE" ]; then
    cat $CA_CERT_FILE >> $AZ_CLI_CACERT_FILE
else
  PYTHON_DIR=$(ls -d /opt/az/lib/python* 2>/dev/null | head -n 1)
  if [ -n "$PYTHON_DIR" ]; then
      cat $CA_CERT_FILE >> $PYTHON_DIR/site-packages/certifi/cacert.pem
  else
      echo "No Python directory found in /opt/az/lib"
      exit 1
  fi
fi

echo "$PACKAGE_NAME install Done!"