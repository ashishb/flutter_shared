import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_shared/flutter_shared.dart';

enum ServerFileType {
  unknown,
  image,
  json,
  text,
  pdf,
  archive,
  video,
  audio,
}

class ServerFile {
  ServerFile({
    @required this.path,
    @required this.isDirectory,
    this.directoryCount,
  });

  factory ServerFile.fromMap(Map<String, dynamic> map) {
    return ServerFile(
      path: map['path'] as String,
      isDirectory: map['isDirectory'] as bool,
    );
  }

  final String path;
  final bool isDirectory;
  final int directoryCount;
  String _name;
  String _directoryPath;
  String _directoryName;
  String _extension;
  String _lowerCaseName;
  ServerFileType _type;
  bool _hidden;
  DateTime _lastAccessed;
  DateTime _lastModified;
  int _length;

  bool get isFile => !isDirectory;
  bool get isImage => type == ServerFileType.image;
  bool get isAudio => type == ServerFileType.audio;
  bool get isVideo => type == ServerFileType.video;
  bool get isPdf => type == ServerFileType.pdf;
  bool get isText => type == ServerFileType.text;
  bool get isPng => extension == '.png';
  bool get isSvg => extension == '.svg';
  bool get isArchive => type == ServerFileType.archive;
  String get name => _name ??= p.basename(path);
  String get lowerCaseName => _lowerCaseName ??= name.toLowerCase();
  bool get hidden => _hidden ??= name.startsWith('.');
  String get extension => _extension ??= p.extension(path).toLowerCase();
  String get directoryPath => _directoryPath ??= p.dirname(path);
  String get directoryName => _directoryName ??= p.basename(directoryPath);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'path': path,
      'isDirectory': isDirectory,
    };
  }

  // mobile/desktop only
  DateTime get lastAccessed {
    if (_lastAccessed != null) {
      return _lastAccessed;
    }

    // uses dart:io, not for web
    if (!Utils.isWeb()) {
      _lastAccessed = File(path).lastAccessedSync();
    }

    return _lastAccessed;
  }

  // mobile/desktop only
  DateTime get lastModified {
    if (_lastModified != null) {
      return _lastModified;
    }

    // uses dart:io, not for web
    if (!Utils.isWeb()) {
      _lastModified = File(path).lastModifiedSync();
    }

    return _lastModified;
  }

  // mobile/desktop only
  int get length {
    if (_length != null) {
      return _length;
    }

    // uses dart:io, not for web
    if (!Utils.isWeb()) {
      _length = File(path).lengthSync();
    }

    return _length;
  }

  ServerFileType get type {
    if (_type == null) {
      final String mimeType = mime(name);

      if (mimeType != null) {
        switch (mimeType.split('/')[0]) {
          case 'image':
            return ServerFileType.image;
            break;
          case 'text':
            return ServerFileType.text;
            break;
          case 'audio':
            return ServerFileType.audio;
            break;
          case 'video':
            // .3gp crashes
            if (extension != '.3gp') {
              return ServerFileType.video;
            }
            break;
        }
      }

      switch (extension) {
        case '.raw':
          return ServerFileType.image;
          break;
        case '.xml':
          return ServerFileType.text;
          break;
        case '.pdf':
          return ServerFileType.pdf;
          break;
        case '.json':
          return ServerFileType.json;
          break;
        case '.zip':
        case '.tar':
        case '.gz':
          return ServerFileType.archive;
          break;
      }

      return ServerFileType.unknown;
    }

    return _type;
  }

  Icon icon({double size}) {
    IconData iconData;

    Color color = Colors.cyan;

    if (isDirectory) {
      iconData = FontAwesome5.folder;
      color = Colors.blue;
    } else if (isArchive) {
      iconData = FontAwesome5.file_archive;
    } else if (isPdf) {
      iconData = FontAwesome5.file_pdf;
      color = Colors.deepOrange;
    } else if (isImage) {
      iconData = FontAwesome5.file_image;
      color = Colors.green;
    } else if (type == ServerFileType.text) {
      iconData = FontAwesome5.file_code;
      color = Colors.pink;
    } else if (type == ServerFileType.video) {
      iconData = FontAwesome5.file_video;
      color = Colors.brown;
    } else if (type == ServerFileType.audio) {
      iconData = FontAwesome5.file_audio;
      color = Colors.brown;
    } else {
      iconData = FontAwesome5.file;
    }

    return Icon(iconData, size: size, color: color);
  }
}
