#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "check installed" bash -c "az --version"
# $_REMOTE_USER_HOME is not defined in the test environment, so we need to use /root instead
check "check config file path" bash -c "cat /root/.bashrc | grep -F 'export AZURE_CONFIG_DIR=/root/workspace/.azure'"

cacert_file="/usr/local/share/ca-certificates/cacert.crt"
PYTHON_DIR=$(ls -d /opt/az/lib/python* 2>/dev/null | head -n 1)
check_file=$PYTHON_DIR/site-packages/certifi/cacert.pem

if [ -s "$cacert_file" ]; then
    cacert_fingerprint=$(openssl x509 -in $cacert_file -noout -fingerprint -sha256 | awk -F= '{print $2}')

    # 複数の証明書が含まれているとopenssl x509では最初の証明書のみを取得するため。
    # 最後の証明書を変数に格納
    last_cert=$(awk 'BEGIN {cert=""; capturing=0;} \
        /-----BEGIN CERTIFICATE-----/ {cert=""; capturing=1;} \
        {if (capturing) cert = cert $0 "\n";} \
        /-----END CERTIFICATE-----/ {capturing=0;} \
        END {print cert;}' < "$check_file")

    check "check cert content" bash -c "echo \"$last_cert\" | openssl x509 -noout -fingerprint -sha256 | grep -F \"$cacert_fingerprint\""
fi

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
