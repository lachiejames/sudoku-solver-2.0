#!/bin/sh

set -e
export PATH=$BUILD_SOURCESDIRECTORY/flutter/bin:$BUILD_SOURCESDIRECTORY/flutter/bin/cache/dart-sdk/bin:$PATH

# All scripts will be placed here
run_integration_tests() {
    echo "Running Integration Tests"
    flutter drive --target=test_driver/run_app.dart
}

"$@"
