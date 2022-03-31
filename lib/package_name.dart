import 'dart:io';

import 'package:flutter_init/util.dart';
import 'package:xml/xml.dart';

class AndroidRenameSteps {
  final String newPackageName;
  final String newAppName;
  String? oldAppName;
  String? oldPackageName;

  AndroidRenameSteps(this.newPackageName, this.newAppName);

  Future<void> process() async {
    if (!await File(PATH_BUILD_GRADLE).exists()) {
      print(
          'ERROR:: build.gradle file not found, Check if you have a correct android directory present in your project'
          '\n\nrun " flutter create . " to regenerate missing files.');
      return;
    }
    String? contents = await readFileAsString(PATH_BUILD_GRADLE);

    var pacakgeReg =
        RegExp('applicationId "(.*)"', caseSensitive: true, multiLine: false);

    var packageName = pacakgeReg.firstMatch(contents!)!.group(1);
    oldPackageName = packageName;

    print("Old Package Name: $oldPackageName");

    print('Updating build.gradle File');
    await _replace(PATH_BUILD_GRADLE);

    print('Updating Main Manifest file');
    await _replace(PATH_MANIFEST);

    print('Updating Debug Manifest file');
    await _replace(PATH_MANIFEST_DEBUG);

    print('Updating Profile Manifest file');
    await _replace(PATH_MANIFEST_PROFILE);

    await updateMainActivity();
  }

  Future<void> appNameCahnge(String newName) async {
    if (!await File(PATH_MANIFEST).exists()) {
      print(
          'ERROR:: build.gradle file not found, Check if you have a correct android directory present in your project'
          '\n\nrun " flutter create . " to regenerate missing files.');
      return;
    }
    String? contents = await readFileAsString(PATH_MANIFEST);
    final parsed = XmlDocument.parse(contents!);

    final application = parsed.findAllElements("application").toList()[0];
    final List<String> label = application.attributes
        .where((attrib) => attrib.toString().contains("android:label"))
        .map((i) => i.toString())
        .toList();
    if (label.isEmpty) {
      throw Exception("Could not find android:label in $PATH_MANIFEST");
    }
    var neweContents =
        contents!.replaceAll(label[0], 'android:label="$newName"');
    print(neweContents);

    await writeFileFromString(PATH_MANIFEST, neweContents);
    print("CHANGE APP NAME");
  }

  Future<void> updateMainActivity() async {
    String oldPackagePath = oldPackageName!.replaceAll('.', '/');
    String javaPath = PATH_ACTIVITY + 'java/$oldPackagePath/MainActivity.java';
    String kotlinPath =
        PATH_ACTIVITY + 'kotlin/$oldPackagePath/MainActivity.kt';

    String newPackagePath = newPackageName.replaceAll('.', '/');
    String newJavaPath =
        PATH_ACTIVITY + 'java/$newPackagePath/MainActivity.java';
    String newKotlinPath =
        PATH_ACTIVITY + 'kotlin/$newPackagePath/MainActivity.kt';

    if (await File(javaPath).exists()) {
      print('Project is using Java');
      print('Updating MainActivity.java');
      await _replace(javaPath);

      print('Creating New Directory Structure');
      await Directory(PATH_ACTIVITY + 'java/$newPackagePath')
          .create(recursive: true);
      await File(javaPath).rename(newJavaPath);

      print('Deleting old directories');
      await deleteOldDirectories('java', oldPackageName!, PATH_ACTIVITY);
    } else if (await File(kotlinPath).exists()) {
      print('Project is using kotlin');
      print('Updating MainActivity.kt');
      await _replace(kotlinPath);

      print('Creating New Directory Structure');
      await Directory(PATH_ACTIVITY + 'kotlin/$newPackagePath')
          .create(recursive: true);
      await File(kotlinPath).rename(newKotlinPath);

      print('Deleting old directories');
      await deleteOldDirectories('kotlin', oldPackageName!, PATH_ACTIVITY);
    } else {
      print(
          'ERROR:: Unknown Directory structure, both java & kotlin files not found.');
    }
  }

  Future<void> _replace(String path) async {
    await replaceInFile(path, oldPackageName, newPackageName);
  }
}
