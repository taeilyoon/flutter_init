import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

const String fileOption = 'file';
const String helpFlag = 'help';
const String defaultConfigFile = 'flutter_launcher_icons.yaml';

start() {
  const loadConfigFileFromArgResults();
}

getConfig() {}

Map<String, dynamic>? loadConfigFileFromArgResults(ArgResults argResults,
    {bool verbose = false}) {
  print('createIconsFromArguments');
  print(argResults);
  final String? configFile = argResults[fileOption];
  final String? fileOptionResult = argResults[fileOption];

  // if icon is given, try to load icon
  if (configFile != null && configFile != defaultConfigFile) {
    try {
      return loadConfigFile(configFile, fileOptionResult);
    } catch (e) {
      if (verbose) {
        stderr.writeln(e);
      }

      return null;
    }
  }

  // If none set try flutter_launcher_icons.yaml first then pubspec.yaml
  // for compatibility
  try {
    return loadConfigFile(defaultConfigFile, fileOptionResult);
  } catch (e) {
    // Try pubspec.yaml for compatibility
    if (configFile == null) {
      try {
        return loadConfigFile('pubspec.yaml', fileOptionResult);
      } catch (_) {}
    }

    // if nothing got returned, print error
    if (verbose) {
      stderr.writeln(e);
    }
  }

  return null;
}

Map<String, dynamic> loadConfigFile(String path, String? fileOptionResult) {
  final File file = File(path);
  final String yamlString = file.readAsStringSync();
  // ignore: always_specify_types
  final Map yamlMap = loadYaml(yamlString);

  if (!(yamlMap['flutter_init'] is Map)) {
    stderr.writeln("");
    exit(1);
  }
  //
  //
  //
  //
  //
  final Map<String, dynamic> config = <String, dynamic>{};
  
  for (MapEntry<dynamic, dynamic> entry in yamlMap['flutter_init'].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}
