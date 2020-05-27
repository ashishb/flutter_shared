import 'package:dartx/dartx.dart';
import 'package:flutter_shared/flutter_shared.dart';

extension StringUtils on String {
  bool get isAssetUrl {
    return startsWith('assets/');
  }

  String get firstChar => substring(0, 1);

  String fromCamelCase() {
    String displayName = '';
    bool lastUpper = false;
    for (final String r in chars) {
      if (r.toUpperCase() == r) {
        displayName += lastUpper ? r : ' $r';

        lastUpper = true;
      } else {
        lastUpper = false;

        if (displayName.isEmpty) {
          displayName += r.toUpperCase();
        } else {
          displayName += r;
        }
      }
    }

    return displayName;
  }

  String truncate([int max = 20]) {
    String result = this;

    if (Utils.isNotEmpty(result)) {
      if (result.length > max) {
        result = '${result.substring(0, result.length - max)}...';
      }
    }

    return result;
  }

  String preTruncate([int max = 20]) {
    String result = this;

    if (Utils.isNotEmpty(result)) {
      if (result.length > max) {
        result = '...${result.substring(result.length - max, result.length)}';
      }
    }

    return result;
  }
}
