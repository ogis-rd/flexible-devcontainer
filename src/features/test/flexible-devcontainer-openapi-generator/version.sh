#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "check installed version" bash -c "openapi-generator-plus --version | grep -F '2.19.0'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
