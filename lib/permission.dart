import 'dart:io';

import 'package:xml/xml.dart';

const androidManifestPath = "android/app/src/main/AndroidManifest.xml";
const androidDebugManifestPath = "android/app/src/debug/AndroidManifest.xml";
const androidProfileGradlePath = "android/app/src/profile/AndroidManifest.xml";
const iosPlistPath = "ios/Runner/Info.plist";

class Permission {
  XmlDocument getAndroidGradle({String path = androidManifestPath}) {
    final File file = File(path);
    var xml = XmlDocument.parse(file.readAsBytesSync().toString());
    return xml;
  }

  applyAndroidPermission() {
    var xml = getAndroidGradle();
    // xml.findElements('manifest').first.children.add()
  }

  applyIosPermission() {}
}

const permissionAOS = {
  'camera': '<uses-permission android:name="android.permission.CAMERA" />',
  'flashlight':
      '<uses-permission android:name="android.permission.FLASHLIGHT" />',
  'internet': '<uses-permission android:name="android.permission.INTERNET" />',
  'location':
      '<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />\n<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />',
  'backgrounde_location':
      '<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />',
  'wakeup': '<uses-permission android:name="android.permission.WAKE_LOCK" />',
  'bluetooth': '<uses-permission android:name="android.permission.BLUETOOTH" />'
};

const permissionIOS = {
  'camera': '<uses-permission android:name="android.permission.CAMERA" />',
  'flashlight':
      '<uses-permission android:name="android.permission.FLASHLIGHT" />',
  'internet': '<uses-permission android:name="android.permission.INTERNET" />',
  'location':
      '<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />\n<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />',
  'backgrounde_location':
      '<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />',
  'wakeup': '<uses-permission android:name="android.permission.WAKE_LOCK" />',
  'bluetooth': '<uses-permission android:name="android.permission.BLUETOOTH" />'
};
