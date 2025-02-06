#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "check installed version" bash -c "mvn --version | grep -F 'Apache Maven 3.8.8'"

# $_REMOTE_USER_HOME is not defined in the test environment, so we need to use /root instead
check "check maven path" bash -c "cat /root/.bashrc | grep -F 'export PATH=\$PATH:/usr/bin/apache-maven/bin'"
check "check maven settings.xml link" bash -c "readlink /root/.m2/settings.xml | grep -F '/root/workspace/.m2/settings.xml'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
