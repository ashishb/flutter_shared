import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_shared/flutter_shared.dart';

class SystemDirectories {
  static Future<String> get documentsPath async {
    String result;

    if (Utils.isIOS) {
      // on Android this give us a data directory for some odd reason
      final Directory dir = await getApplicationDocumentsDirectory();

      result = dir.path;
    } else {
      final Directory dir = await getExternalStorageDirectory();
      result = dir.path;
    }

    return result;
  }

  static Future<String> get tmpDirectoryPath async {
    final Directory directory = await getTemporaryDirectory();
    return directory.path;
  }

  static Future<String> get appSupportDirectoryPath async {
    final Directory directory = await getApplicationSupportDirectory();

    return directory.path;
  }

  // iOS only
  static Future<String> get libraryDirectoryPath async {
    if (Utils.isIOS) {
      final Directory directory = await getLibraryDirectory();

      return directory.path;
    }

    return null;
  }

  // Android only
  static Future<List<String>> get externalCacheDirectoryPaths async {
    if (Utils.isAndroid) {
      final List<Directory> directories = await getExternalCacheDirectories();

      return directories.map((dir) => dir.path).toList();
    }

    return null;
  }

  // Desktop only
  static Future<String> get downloadsDirectoryPath async {
    if (!Utils.isMobile) {
      final Directory directory = await getDownloadsDirectory();

      return directory.path;
    }

    return null;
  }

  static Future<Directory> recordingDirectory() async {
    final documents = await documentsPath;
    return Directory('$documents/recordings');
  }

  static Future<Directory> booksDirectory() async {
    final documents = await documentsPath;
    final Directory dir = Directory('$documents/books');

    if (!dir.existsSync()) {
      dir.createSync();
    }

    return dir;
  }

  // iOS won't work with full paths
  // we only save the file name, and get the path fresh each time.
  static Future<String> bookPath(String filename) async {
    final Directory dir = await booksDirectory();
    final String path = '${dir.path}/$filename';

    return path;
  }

  static Future<List<String>> recordingPaths() async {
    final Directory dir = await recordingDirectory();

    if (!dir.existsSync()) {
      dir.createSync();
    }

    return dir.listSync().map((f) {
      return f.path;
    }).toList();
  }
}
