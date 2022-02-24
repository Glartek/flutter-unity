import 'dart:io';

import 'package:io/io.dart' as io;

void main() {
  try {
    String unityExportPath = '${Directory.current.path}/android/unityExport';

    if (!Directory(unityExportPath).existsSync()) {
      print('Directory not found: `$unityExportPath`');
      return;
    }

    String launcherPath = '$unityExportPath/launcher';
    String unityLibraryPath = '$unityExportPath/unityLibrary';
    String launcherResPath = '$launcherPath/src/main/res';
    String unityLibraryResPath = '$unityLibraryPath/src/main/res';

    if (!Directory(launcherResPath).existsSync()) {
      print('Directory not found: `$launcherResPath`');
      return;
    }

    if (!Directory(unityLibraryResPath).existsSync()) {
      print('Directory not found: `$unityLibraryResPath`');
      return;
    }
    
    File gradlePropertiesFile = File('$unityExportPath/gradle.properties');
    if (gradlePropertiesFile.existsSync()) {
      gradlePropertiesFile.copySync('$unityLibraryPath/gradle.properties');
    }

    io.copyPathSync(launcherResPath, unityLibraryResPath);

    Directory(launcherPath).deleteSync(recursive: true);

    for (FileSystemEntity entity in Directory(unityExportPath).listSync()) {
      try {
        entity.deleteSync();
      } catch (_) {}
    }

    io.copyPathSync(unityLibraryPath, unityExportPath);

    Directory(unityLibraryPath).deleteSync(recursive: true);

    File file = File('$unityExportPath/src/main/AndroidManifest.xml');
    String contents = file.readAsStringSync();
    contents = contents
        .replaceAll(RegExp(r'<application .*>'), '<application>')
        .replaceAll(RegExp(r'\s*<activity .*>(?:\s|\S)*<\/activity>'), '');
    file.writeAsStringSync(contents);

    /* build.gradle patch for Unity 2020.x+ */

    file = File('$unityExportPath/build.gradle');
    contents = file.readAsStringSync();
    contents = contents.replaceAll(RegExp(r'unityLibrary'), 'unityExport');
    file.writeAsStringSync(contents);
  } catch (e) {
    print(e);
  }
}
