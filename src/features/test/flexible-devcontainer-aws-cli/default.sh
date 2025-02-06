#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "check installed" bash -c "aws --version"

# $_REMOTE_USER_HOME is not defined in the test environment, so we need to use /root instead
check "check config file path" bash -c "cat /root/.bashrc | grep -F 'export AWS_CONFIG_FILE=/root/workspace/.aws/config'"
check "check shared credencial file path" bash -c "cat /root/.bashrc | grep -F 'export AWS_SHARED_CREDENTIALS_FILE=/root/workspace/.aws/credentials'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
