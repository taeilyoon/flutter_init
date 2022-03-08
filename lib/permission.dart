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
