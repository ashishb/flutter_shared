import 'package:dartx/dartx.dart';

extension StringUtils on String {
  bool get isAssetUrl {
    return startsWith('assets/');
  }

  String get firstChar => substring(0, 1);

  String fromCamelCase() {
    String displayName = '';
    bool lastUpper = false;
    for (final String r in characters) {
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
}
