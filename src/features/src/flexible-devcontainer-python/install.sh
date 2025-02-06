#!/bin/bash
#===============================================================================
#         NOTES:  インストール方法について - deadsnakesはサポートしているバージョンが少ないので利用しない。
#                 pyenvからインストールする場合は、ソースコードからのコンパイルが必要で、ビルドに必要なライブラリをインストールする必要がある。
#                 DevContainerの利用方法では手動でソースコードからコンパイルする場合と比べて、
#                 pyenvでインストールしてもメリットは少ないが利用可能な機能が増えるのでpyenvを利用する。
#        CACERT:  pipのglobal.certに証明書を設定する事で、依存ライブラリインストール時に証明書のエラーを回避する。
#                 requestsモジュールなどはREQUESTS_CA_BUNDLEに証明書を設定する必要があるが、設定するとaws cliがSSLエラーになる。
#                 そのため、必要な場合に個別に設定する事が望ましい、環境全体に影響を与えるREQUESTS_CA_BUNDLEを設定する機能は提供しない。
#          LINK:  pyenv: https://github.com/pyenv/pyenv
#===============================================================================  
set -e

source common.sh

PACKAGE_NAME="Python"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. version: " $VERSION

# ビルドに必要なパッケージをインストール  
apt update && apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

PROXY_EXPORT_COMMAND=$(create_export_proxy_command_from_current_env)

# install.shではREMOTE_USERへ環境変数が引き継がれないため、コマンド実行時に指定する
# pyenvのインストール
curl https://pyenv.run | su - $_REMOTE_USER -c "$PROXY_EXPORT_COMMAND bash"

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $_REMOTE_USER_HOME/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> $_REMOTE_USER_HOME/.bashrc
echo 'eval "$(pyenv init -)"' >> $_REMOTE_USER_HOME/.bashrc

# pythonのインストールと証明書の設定
su - $_REMOTE_USER -c "
  export PYENV_ROOT=$_REMOTE_USER_HOME/.pyenv && \
  export PATH=\$PYENV_ROOT/shims:\$PYENV_ROOT/bin:$PATH && \
  $PROXY_EXPORT_COMMAND \
  pyenv init - && \
  pyenv install $VERSION && \
  pyenv global $VERSION && \
  if [ -s \"$CA_CERT_FILE\" ]; then pip config set global.cert $CA_CERT_FILE; fi && \
  pip install --upgrade pip
"

# 不要なビルドツールやライブラリをアンインストール  
apt remove -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev &&
apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

echo "$PACKAGE_NAME install Done!"