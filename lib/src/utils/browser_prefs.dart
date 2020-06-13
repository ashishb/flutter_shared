import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class BrowserPrefs {
  // show hidden
  static bool get showHidden =>
      HiveBox.prefsBox.get('showHidden', defaultValue: false) as bool;
  static set showHidden(bool flag) => HiveBox.prefsBox.put('showHidden', flag);

  // sort
  static String get sortStyle =>
      HiveBox.prefsBox.get('sortStyle', defaultValue: SortStyle.foldersFirst)
          as String;
  static set sortStyle(String style) =>
      HiveBox.prefsBox.put('sortStyle', style);

  // searchInsideHidden
  static bool get searchInsideHidden =>
      HiveBox.prefsBox.get('searchInsideHidden', defaultValue: false) as bool;
  static set searchInsideHidden(bool flag) =>
      HiveBox.prefsBox.put('searchInsideHidden', flag);

  // copy on drop
  static bool get copyOnDrop =>
      HiveBox.prefsBox.get('copyOnDrop', defaultValue: false) as bool;
  static set copyOnDrop(bool flag) => HiveBox.prefsBox.put('copyOnDrop', flag);
}

// sort constants

class SortStyle {
  SortStyle({
    @required this.id,
    @required this.name,
  });

  final String id;
  final String name;

  // constants
  static const String foldersFirst = 'foldersFirst';
  static const String foldersLast = 'foldersLast';
  static const String filesA2Z = 'filesA2Z';
  static const String filesZ2A = 'filesZ2A';
  static const String dateOldFirst = 'dateOldFirst';
  static const String dateNewFirst = 'dateNewFirst';
  static const String sizeLargeFirst = 'sizeLargeFirst';
  static const String sizeSmallFirst = 'sizeSmallFirst';

  static List<SortStyle> sortStyles = <SortStyle>[
    SortStyle(id: SortStyle.foldersFirst, name: 'Folders on top'),
    SortStyle(id: SortStyle.foldersLast, name: 'Folders on bottom'),
    SortStyle(id: SortStyle.filesA2Z, name: 'File name (A to Z)'),
    SortStyle(id: SortStyle.filesZ2A, name: 'File name (Z to A)'),
    SortStyle(id: SortStyle.dateOldFirst, name: 'Date (oldest first)'),
    SortStyle(id: SortStyle.dateNewFirst, name: 'Date (newest first)'),
    SortStyle(id: SortStyle.sizeLargeFirst, name: 'Size (largest first)'),
    SortStyle(id: SortStyle.sizeSmallFirst, name: 'Size (Smallest first)'),
  ];
}
