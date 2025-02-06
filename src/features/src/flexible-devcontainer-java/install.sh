#===============================================================================
#        CACERT:  adoptiumの公式からaptでインストールすると、ubuntuにインストールしたルート証明書をavaの証明書ストアに自動的に取り込んでくれる。
#                 SDKMANでインストールする場合は、cacertsファイルを指定して証明書を取り込む必要があるためaptでインストールする。
#=============================================================================== 
set -e

PACKAGE_NAME="Java"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. major version: " $MAJOR_VERSION ", version: " $VERSION

apt-get update && apt-get install -y apt-transport-https gnupg \
    && wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null \
    && echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list \
    && apt-get update

if [ "$VERSION" ]; then
    install_major_version=`echo $VERSION | awk -F'.' '{print $1}'`
    apt-get install -y temurin-${install_major_version}-jdk=${VERSION}
else
    apt-get install -y temurin-${MAJOR_VERSION}-jdk
fi

echo "export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" >> $_REMOTE_USER_HOME/.bashrc

echo "$PACKAGE_NAME install Done!"
