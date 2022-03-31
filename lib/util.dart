import 'dart:io';

const String PATH_BUILD_GRADLE = 'android/app/build.gradle';
const String PATH_MANIFEST = 'android/app/src/main/AndroidManifest.xml';
const String PATH_MANIFEST_DEBUG = 'android/app/src/debug/AndroidManifest.xml';
const String PATH_MANIFEST_PROFILE =
    'android/app/src/profile/AndroidManifest.xml';

const String PATH_ACTIVITY = 'android/app/src/main/';

Future<void> replaceInFile(String path, oldPackage, newPackage) async {
  String? contents = await readFileAsString(path);
  if (contents == null) {
    print('ERROR:: file at $path not found');
    return;
  }
  contents = contents.replaceAll(oldPackage, newPackage);
  await writeFileFromString(path, contents);
}

Future<String?> readFileAsString(String path) async {
  var file = File(path);
  String? contents;

  if (await file.exists()) {
    contents = await file.readAsString();
  }
  return contents;
}

Future<void> writeFileFromString(String path, String contents) async {
  var file = File(path);
  await file.writeAsString(contents);
}

Future<void> deleteOldDirectories(
    String lang, String oldPackage, String basePath) async {
  var dirList = oldPackage.split('.');
  var reversed = dirList.reversed.toList();

  for (int i = 0; i < reversed.length; i++) {
    String path = '$basePath$lang/' + dirList.join('/');

    if (Directory(path).listSync().toList().isEmpty) {
      Directory(path).deleteSync();
    }
    dirList.removeLast();
  }
}
