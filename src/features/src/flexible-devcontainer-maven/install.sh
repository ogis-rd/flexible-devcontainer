#!/bin/bash
#===============================================================================
#        CACERT: mavenはjavaを使用するため、javaのcacertを使用する
#=============================================================================== 

set -e

PACKAGE_NAME="Maven"

echo "$PACKAGE_NAME install Start!"

echo "Parameters. version: " $VERSION

curl -OL https://archive.apache.org/dist/maven/maven-3/${VERSION}/binaries/apache-maven-${VERSION}-bin.tar.gz \
  && tar -xzvf apache-maven-${VERSION}-bin.tar.gz \
  && mv apache-maven-${VERSION} /usr/bin \
  && cd /usr/bin \
  && ln -s /usr/bin/apache-maven-${VERSION} apache-maven

if [ "$MAVEN_SETTINGS_DIR" = "/home/${USER}/workspace/.m2" ]; then
  MAVEN_SETTINGS_DIR=$_REMOTE_USER_HOME/workspace/.m2
fi

sudo -u $_REMOTE_USER mkdir $_REMOTE_USER_HOME/.m2
sudo -u $_REMOTE_USER ln -s $MAVEN_SETTINGS_DIR/settings.xml $_REMOTE_USER_HOME/.m2/settings.xml

echo 'export PATH=$PATH:/usr/bin/apache-maven/bin' >> $_REMOTE_USER_HOME/.bashrc


echo "$PACKAGE_NAME install Done!"