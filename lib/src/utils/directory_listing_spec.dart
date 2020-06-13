import 'package:flutter/foundation.dart';
import 'package:flutter_shared/flutter_shared.dart';

class DirectoryListingSpec {
  DirectoryListingSpec({
    @required this.serverFile,
    @required this.sortStyle,
    @required this.recursive,
    @required this.showHidden,
    @required this.searchHiddenDirs,
    @required this.directoryCounts,
  });

  final ServerFile serverFile;
  final bool recursive;
  final String sortStyle;
  final bool showHidden;
  final bool searchHiddenDirs;
  final bool directoryCounts;

  DirectoryListingSpec copyWith(ServerFile serverFile) {
    return DirectoryListingSpec(
      serverFile: serverFile,
      recursive: recursive,
      directoryCounts: directoryCounts,
      sortStyle: sortStyle,
      showHidden: showHidden,
      searchHiddenDirs: searchHiddenDirs,
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (other is DirectoryListingSpec) {
      if (other.recursive == recursive &&
          other.serverFile?.path == serverFile?.path &&
          other.sortStyle == sortStyle &&
          other.showHidden == showHidden &&
          other.searchHiddenDirs == searchHiddenDirs &&
          other.directoryCounts == directoryCounts) {
        return true;
      }
    }

    return false;
  }

  @override
  int get hashCode {
    int filehash = 1;

    if (serverFile != null) {
      filehash = serverFile.path.hashCode;
    }

    return filehash *
        recursive.hashCode *
        sortStyle.hashCode *
        directoryCounts.hashCode *
        showHidden.hashCode *
        searchHiddenDirs.hashCode;
  }

  bool shouldRebuildForNewSpec(DirectoryListingSpec otherSpec) {
    return sortStyle != otherSpec.sortStyle ||
        showHidden != otherSpec.showHidden ||
        searchHiddenDirs != otherSpec.searchHiddenDirs;
  }
}
