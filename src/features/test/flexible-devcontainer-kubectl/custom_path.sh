#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "check installed" bash -c "kubectl version --client=true"

# $_REMOTE_USER_HOME is not defined in the test environment, so we need to use /root instead
check "check config file path" bash -c "cat /root/.bashrc | grep -F 'export KUBECONFIG=/home/custom/workspace/.kube/config'"
check "check kubectl alias" bash -c "cat /root/.bashrc | grep -F 'alias k=\"kubectl\"'"
check "check kubectl describe alias" bash -c "cat /root/.bashrc | grep -F 'alias kd=\"kubectl describe\"'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
