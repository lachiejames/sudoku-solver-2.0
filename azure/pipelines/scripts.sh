#!/bin/sh

set -e
export PATH=$BUILD_SOURCESDIRECTORY/flutter/bin:$BUILD_SOURCESDIRECTORY/flutter/bin/cache/dart-sdk/bin:$PATH

# All scripts will be placed here

install_flutter() {
  git clone -b stable https://github.com/flutter/flutter.git

  flutter precache
  yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
  flutter doctor
}

launch_avd() {
  echo "Installing SDK"
  $ANDROID_HOME/tools/bin/sdkmanager --install 'system-images;android-29;default;x86'

  echo "Creating emulator"
  $ANDROID_HOME/tools/bin/avdmanager create avd -n "pixel" --device "pixel" -k "system-images;android-29;default;x86"

  echo "Starting emulator"
  $ANDROID_HOME/emulator/emulator -avd "pixel" -no-snapshot &
  $ANDROID_HOME/platform-tools/adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed | tr -d '\r') ]]; do sleep 1; done; input keyevent 82'

  echo "Emulator started"
}

start_recording() {
  # Each video is 3 minutes max, so 5 videos will give us up to 15 minutes,
  # should be enough for test
  $ANDROID_HOME/platform-tools/adb shell mkdir /sdcard/video
  $ANDROID_HOME/platform-tools/adb shell screenrecord /sdcard/video/1.mp4
  $ANDROID_HOME/platform-tools/adb shell screenrecord /sdcard/video/2.mp4
  $ANDROID_HOME/platform-tools/adb shell screenrecord /sdcard/video/3.mp4
  $ANDROID_HOME/platform-tools/adb shell screenrecord /sdcard/video/4.mp4
  $ANDROID_HOME/platform-tools/adb shell screenrecord /sdcard/video/5.mp4
}

flutter_test() {
  flutter packages get
  
  flutter test

  launch_avd
  start_recording &
  flutter run --observatory-port 8888 --disable-service-auth-codes lib/main.dart
}

test_in_other_shell() {
  dart test_driver/single_test.dart
  pkill -f screenrecord || true
}



"$@"

