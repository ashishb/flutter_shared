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
    @required String path,
    @required this.isDirectory,
    this.directoryCount,
  }) {
    // remove trailing slash Directory.path and File.path return / at end
    this.path = path.removeTrailing('/');
  }

  factory ServerFile.fromMap(Map<String, dynamic> map) {
    final result = ServerFile(
      path: map['path'] as String,
      isDirectory: map['isDirectory'] as bool,
      directoryCount: map['directoryCount'] as int,
    );

    result._length = map['length'] as int;

    final mod = map['lastModified'] as String;
    if (mod != null) {
      result._lastModified = DateTime.parse(mod);
    }

    return result;
  }

  String path;
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
  String get directoryPath => _directoryPath ??= p.dirname(path);
  String get directoryName => _directoryName ??= p.basename(directoryPath);

  // String get extension => _extension ??= p.extension(path).toLowerCase();
  // Wondering if this is faster than above
  String get extension {
    if (_extension == null) {
      final int lastDot = name.lastIndexOf('.', name.length - 1);
      if (lastDot != -1) {
        _extension = name.substring(lastDot).toLowerCase();
      }
    }

    return _extension;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'path': path,
      'isDirectory': isDirectory,
      'directoryCount': directoryCount,
      'lastModified': _lastModified?.toString(),
      'length': _length,
    };
  }

  // mobile/desktop only
  DateTime get lastAccessed {
    if (_lastAccessed != null) {
      return _lastAccessed;
    }

    _lastAccessed = DateTime.now();

    // uses dart:io, not for web
    if (!Utils.isWeb()) {
      if (isFile) {
        _lastAccessed = File(path).lastAccessedSync();
      }
    }

    return _lastAccessed;
  }

  // this is used when detecting modified directories
  // we need a fresh mod date, call this before lastModified
  void clearLastModified() {
    _lastModified = null;
  }

  // mobile/desktop only
  DateTime get lastModified {
    if (_lastModified != null) {
      return _lastModified;
    }

    // set to some a date in the past just to signal it's clearly not workin
    // but setting _lastModified prevents futher calls
    _lastModified = DateTime.utc(1969);

    // uses dart:io, not for web
    if (!Utils.isWeb()) {
      if (isFile) {
        _lastModified = File(path).lastModifiedSync();
      } else {
        _lastModified = Directory(path).statSync().modified;
      }
    }

    return _lastModified;
  }

  // mobile/desktop only
  int get length {
    if (_length != null) {
      return _length;
    }

    _length = 0;

    if (isFile) {
      // uses dart:io, not for web
      if (!Utils.isWeb()) {
        _length = File(path).lengthSync();
      }
    }
    return _length;
  }

  ServerFileType get type {
    if (_type == null) {
      if (Utils.isNotEmpty(extension)) {
        String noDot = extension;

        if (noDot.length > 1) {
          noDot = extension.substring(1);
        }

        final String mimeType = mimeFromExtension(noDot);

        if (mimeType != null) {
          switch (mimeType.split('/')[0]) {
            case 'image':
              // might want to set the type as an image, but filter when being drawn
              // psd for example crashes
              if (extension != '.psd') {
                _type = ServerFileType.image;
              }
              break;
            case 'text':
              _type = ServerFileType.text;
              break;
            case 'audio':
              _type = ServerFileType.audio;
              break;
            case 'video':
              // .3gp crashes, .wmv doesn't work
              if (extension != '.3gp' && extension != '.wmv') {
                _type = ServerFileType.video;
              }
              break;
          }
        }

        if (_type == null) {
          switch (extension) {
            case '.raw':
              _type = ServerFileType.image;
              break;
            case '.xml':
              _type = ServerFileType.text;
              break;
            case '.pdf':
              _type = ServerFileType.pdf;
              break;
            case '.json':
              _type = ServerFileType.json;
              break;
            case '.zip':
            case '.tar':
            case '.gz':
              _type = ServerFileType.archive;
              break;
          }
        }
      }

      _type ??= ServerFileType.unknown;
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

  @override
  String toString() {
    return path;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is ServerFile) {
      if (other.path == path && other.isDirectory == isDirectory) {
        return true;
      }
    }

    return false;
  }

  @override
  int get hashCode => hashValues(
        path,
        isDirectory,
      );
}
