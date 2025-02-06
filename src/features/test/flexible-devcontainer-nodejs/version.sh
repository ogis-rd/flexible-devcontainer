#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "check node installed version" bash -c "node --version | grep -F 'v22.10.0'"
check "check nvm installed version" bash -c ". ~/.nvm/nvm.sh && nvm --version | grep -F '0.39.0'"
check "check npm installed version" bash -c "npm --version | grep -F '10.9.0'"
check "check corepack installed version" bash -c "corepack --version | grep -F '0.29.2'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
