#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "check installed version" bash -c "java --version | grep -F 'Temurin-21.'"

# $_REMOTE_USER_HOME is not defined in the test environment, so we need to use /root instead
check "check java home env" bash -c "cat /root/.bashrc | grep -F 'export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")'"

cacert_file="/usr/local/share/ca-certificates/cacert.crt"
JAVA_DIR=$(ls -d /usr/lib/jvm/temurin* 2>/dev/null | head -n 1)

if [ -s "$cacert_file" ]; then
    cacert_fingerprint=$(openssl x509 -in /usr/local/share/ca-certificates/cacert.crt -noout -fingerprint -sha256 | awk -F= '{print $2}')
    check "check cert content" bash -c "keytool -list -keystore $JAVA_DIR/lib/security/cacerts -storepass changeit | grep -F \"$cacert_fingerprint\""
fi

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
