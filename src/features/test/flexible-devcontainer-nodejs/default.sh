#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "check node installed version" bash -c "node --version | grep -F 'v22.'"
check "check nvm installed version" bash -c ". ~/.nvm/nvm.sh && nvm --version | grep -F '0.40.0'"
check "check npm installed" bash -c "npm --version"
check "check corepack installed" bash -c "corepack --version"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
