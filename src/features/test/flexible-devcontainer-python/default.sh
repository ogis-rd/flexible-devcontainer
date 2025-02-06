#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "check installed version" bash -c "python3 --version | grep -F 'Python 3.'"

cacert_file="/usr/local/share/ca-certificates/cacert.crt"

if [ -s "$cacert_file" ]; then
    check "check cert dev" bash -c "python3 -m pip config list | grep -F \"global.cert='$cacert_file'\""
fi

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
