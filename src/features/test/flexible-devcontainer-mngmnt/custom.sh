#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.

# $_REMOTE_USER_HOME is not defined in the test environment, so we need to use /root instead
check "check no_proxy env" bash -c "cat /root/.bashrc | grep -F 'ADD_NO_PROXY=172.17.1.0/16'"
check "check no_proxy func" bash -c "cat /root/.bashrc | grep -F 'add_env_val_if_not_exist no_proxy "$ADD_NO_PROXY"'"
check "check NO_PROXY func" bash -c "cat /root/.bashrc | grep -F 'add_env_val_if_not_exist NO_PROXY "$ADD_NO_PROXY"'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
