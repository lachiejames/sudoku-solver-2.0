#!/bin/sh

set -e
export PATH=$BUILD_SOURCESDIRECTORY/flutter/bin:$BUILD_SOURCESDIRECTORY/flutter/bin/cache/dart-sdk/bin:$PATH

# All scripts will be placed here
install_flutter() {
    echo "Installing Flutter SDK"
    git clone -b stable https://github.com/flutter/flutter.git

    echo "Verifying Flutter Installation"
    flutter precache
    yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
    flutter doctor

    echo "Downloading Packages"
    flutter packages get
}

setup_emulator() {
    echo "Installing Emulator SDK"
    $ANDROID_HOME/tools/bin/sdkmanager --install 'system-images;android-29;default;x86'

    echo "Creating Emulator"
    $ANDROID_HOME/tools/bin/avdmanager create avd -n "pixel" --device "pixel" -k "system-images;android-29;default;x86"

    echo "Starting Emulator"
    $ANDROID_HOME/emulator/emulator -avd "pixel" -no-snapshot &
    $ANDROID_HOME/platform-tools/adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed | tr -d '\r') ]]; do sleep 1; done; input keyevent 82'
    echo "Emulator started"
}

run_integration_tests() {
    echo "Running Integration Tests"
    flutter drive --target=test_driver/run_app.dart
}

"$@"