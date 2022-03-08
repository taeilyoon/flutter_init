import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'dart:developer';

const String fileOption = 'file';
const String helpFlag = 'help';
const String defaultConfigFile = 'flutter_init.yaml';

start(List<String> arguments) {
  final ArgParser parser = ArgParser(allowTrailingOptions: true);
  parser.addFlag(helpFlag, abbr: 'h', help: 'Usage help', negatable: false);
  // Make default null to differentiate when it is explicitly set
  parser.addOption(fileOption,
      abbr: 'f', help: 'Config file (default: $defaultConfigFile)');
  final ArgResults argResults = parser.parse(arguments);

  if (argResults[helpFlag]) {
    stdout.writeln('Generates icons for iOS and Android');
    stdout.writeln(parser.usage);
    exit(0);
  }

  final Map<String, dynamic>? yamlConfig =
      loadConfigFileFromArgResults(argResults, verbose: true);

  if (yamlConfig == null) {
    print("error");
    // throw const NoConfigFoundException();
  }
}

getConfig() {}

Map<String, dynamic>? loadConfigFileFromArgResults(ArgResults argResults,
    {bool verbose = false}) {
  print('createIconsFromArguments');
  inspect({argResults});
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
  print(yamlMap['flutter_init'].toString());

  final Map<String, dynamic> config = <String, dynamic>{};

  for (MapEntry<dynamic, dynamic> entry in yamlMap['flutter_init'].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}
