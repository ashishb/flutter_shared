import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Some globals I may want to experiment with

class Utils {
  static final Random _random = Random();

  static bool get debugBuild {
    return kDebugMode;
  }

  static String uniqueFirestoreId() {
    const int idLength = 20;
    const String alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    final StringBuffer stringBuffer = StringBuffer();
    const int maxRandom = alphabet.length;

    for (int i = 0; i < idLength; ++i) {
      stringBuffer.write(alphabet[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }

  static Future<List<String>> jsonAssets(
      BuildContext context, String directoryName,
      [String filename]) async {
    final bundle = DefaultAssetBundle.of(context);
    String matchFilename = '';

    if (filename != null && filename.isNotEmpty) {
      matchFilename = filename;
    }

    final manifestContent = await bundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap =
        json.decode(manifestContent) as Map<String, dynamic>;

    final List<String> paths = manifestMap.keys
        .where((String key) => key.contains(directoryName))
        .where((String key) => key.contains(matchFilename))
        .where((String key) => key.contains('.json'))
        .toList();

    final List<String> result = <String>[];

    for (final String p in paths) {
      final contents = await bundle.loadString(p);

      // debugPrint(contents, wrapWidth: 555);

      result.add(contents);
    }

    return result;
  }

  static Future<void> printAssets(BuildContext context,
      {String directoryName, String ext}) async {
    String matchDir = '';
    String matchExt = '';

    if (directoryName != null && ext.isNotEmpty) {
      matchDir = directoryName;
    }

    if (ext != null && ext.isNotEmpty) {
      matchExt = ext;
    }

    final bundle = DefaultAssetBundle.of(context);

    final manifestContent = await bundle.loadString('AssetManifest.json');

    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    final List<String> paths = manifestMap.keys
        .where((String key) => key.contains(matchDir))
        .where((String key) => key.contains(matchExt))
        .toList();

    for (final String p in paths) {
      debugPrint('ASSET: $p', wrapWidth: 555);
    }
  }

  static String uniqueFileName(String name, String directoryPath) {
    int nameIndex = 1;
    final String fileName = name;
    String tryDirName = fileName;

    String destFile = p.join(directoryPath, tryDirName);
    while (File(destFile).existsSync() || Directory(destFile).existsSync()) {
      // test-1.xyz
      final String baseName = p.basenameWithoutExtension(fileName);
      final String extension = p.extension(fileName);

      tryDirName = '$baseName-$nameIndex$extension';
      destFile = p.join(directoryPath, tryDirName);

      nameIndex++;
    }

    return destFile;
  }

  static String uniqueDirName(String name, String directoryPath) {
    int nameIndex = 1;
    final String dirName = p.basenameWithoutExtension(name);
    String tryDirName = dirName;

    String destFolder = p.join(directoryPath, tryDirName);
    while (
        File(destFolder).existsSync() || Directory(destFolder).existsSync()) {
      tryDirName = '$dirName-$nameIndex';
      destFolder = p.join(directoryPath, tryDirName);

      nameIndex++;
    }

    return destFolder;
  }

  static String formatDateString(String iso) {
    final DateTime date = DateTime.parse(iso);

    return formatDateTime(date);
  }

  static String formatDateTime(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime yDay = now.subtract(const Duration(days: 1));
    final DateTime yyDay = yDay.subtract(const Duration(days: 1));

    final formatter = DateFormat.MMMd().add_jm();

    if (date.compareTo(yDay) != -1) {
      return 'Today ${formatter.format(date)}';
    } else if (date.compareTo(yyDay) != -1) {
      return 'Yesterday ${formatter.format(date)}';
    } else {
      return formatter.format(date);
    }
  }

  // if date is in UTC, use this to get local
  static String formatLocalDateTime({
    @required DateTime date,
    bool addDay = false,
  }) {
    if (date != null) {
      String day = '';

      if (addDay) {
        day = 'E, ';
      }

      final DateFormat formatter = DateFormat('${day}MMM dd, h:mm a');

      return formatter.format(date.toLocal());
    }

    // don't want to crash Text, return '' instead of null
    return '';
  }

  // sometimes you get a weird date format that crashes
  // not a perfect solution, but enough for now
  static String formatLocalDateString(String dateString) {
    String result;

    if (isNotEmpty(dateString)) {
      try {
        final DateTime theDate = parseDate(dateString);

        if (theDate != null) {
          result = formatLocalDateTime(date: theDate);
        }
      } catch (err) {
        print('Error: dateString: $dateString, err: $err');
      }
    }

    return result ?? '';
  }

  static DateTime parseDate(String dateString) {
    if (isNotEmpty(dateString)) {
      DateTime theDate;

      try {
        theDate = DateTime.parse(dateString);
      } catch (err) {
        print('Error: dateString: $dateString, err: $err');
      }

      if (theDate != null) {
        return theDate;
      }

      try {
        // try again with DateFormat.parse()
        theDate = DateFormat('MM/dd/yyy HH:mm:ss').parse(dateString);
      } catch (err) {
        print('Error-2: dateString: $dateString, err: $err');
      }

      if (theDate != null) {
        return theDate;
      }
    }

    return null;
  }

  // ===========================================
  // Package Info

  static bool get isAndroid {
    // Platform not available on web
    if (isWeb) {
      return false;
    }

    return Platform.isAndroid;
  }

  static bool get isIOS {
    // Platform not available on web
    if (isWeb) {
      return false;
    }
    return Platform.isIOS;
  }

  static bool get isMobile {
    return isAndroid || isIOS;
  }

  static bool get isWeb {
    // Platform not available on web
    // but this constant is the current work around
    if (kIsWeb) {
      return true;
    }

    // not sure why there isn't a web choice, this might be obsolete at some point
    return !(Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isLinux ||
        Platform.isWindows);
  }

  static Future<String> getAppVersion() async {
    if (isWeb) {
      return '0.0.0';
    }

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version + (debugBuild ? 'd' : '');
  }

  static Future<String> getAppID() async {
    if (isWeb) {
      return '0.0.0';
    }

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static Future<String> getAppName() async {
    if (isWeb) {
      return 'web';
    }

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.appName ?? 'CFBundleDisplayName null';
  }

  static void showSnackbar(BuildContext context, String message,
      {bool error = false, String action, void Function() onPressed}) {
    final snackBar = SnackBar(
      backgroundColor: error ? Colors.red : null,
      content: Text(message),
      action: action != null
          ? SnackBarAction(
              label: action,
              onPressed: onPressed,
            )
          : null,
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  static Future<void> showCopiedToast(BuildContext context) async {
    await Navigator.of(context).push<void>(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) => _Toast(),
    ));
  }

  // ===========================================
  // Misc

  static bool equalColors(Color color1, Color color2) {
    // colors don't compare well, one might be a material color, the other just has a Color(value)
    // both both might have the same value and should be considered equal
    return color1?.value == color2?.value;
  }

  static Size mediaSquareSize(BuildContext context,
      {double percent = 0.5, double maxDimension}) {
    double dimension = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    dimension = dimension * percent;
    if (maxDimension != null) {
      dimension = min(maxDimension, dimension);
    }

    return Size(dimension, dimension);
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0).toDouble());

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0).toDouble());

    return hslLight.toColor();
  }

  static Future<void> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  static SystemUiOverlayStyle systemUiStyle(BuildContext context) {
    if (Utils.isDarkMode(context)) {
      return SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      );
    }

    return SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    );
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static void scrollToEndAnimated(ScrollController scrollController,
      {bool reversed = false}) {
    scrollController.animateTo(
      reversed
          ? scrollController.position.minScrollExtent
          : scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  static void scrollToEnd(ScrollController scrollController,
      {bool reversed = false}) {
    scrollController.jumpTo(
      reversed
          ? scrollController.position.minScrollExtent
          : scrollController.position.maxScrollExtent,
    );
  }

  // 4 -> 04,
  static String twoDigits(num n) {
    if (n >= 10 || n <= -10) {
      return '$n';
    }

    if (n < 0) {
      return '-0${n.abs()}';
    }
    return '0$n';
  }

  static List<MatchText> matchArray(
      {bool email = true, bool phone = true, bool url = true}) {
    final result = <MatchText>[];

    if (email) {
      result.add(MatchText(
        type: ParsedType.EMAIL,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 24,
        ),
        onTap: (String r) => Utils.matchCallback('email', r),
      ));
    }

    if (phone) {
      result.add(MatchText(
        type: ParsedType.PHONE,
        style: const TextStyle(
          color: Colors.blue,
        ),
        onTap: (String r) => Utils.matchCallback('phone', r),
      ));
    }

    if (url) {
      result.add(MatchText(
        type: ParsedType.URL,
        style: const TextStyle(
          color: Colors.blue,
        ),
        onTap: (String r) => Utils.matchCallback('url', r),
      ));
    }

    return result;
  }

  static void matchCallback(String type, String payload) {
    switch (type) {
      case 'email':
        Utils.launchUrl('mailto:$payload');
        break;
      case 'phone':
        Utils.launchUrl('tel:$payload');
        break;
      case 'url':
        Utils.launchUrl(payload);
        break;
    }
  }

  static bool isNotEmpty(dynamic input) {
    if (input == null) {
      return false;
    }

    if (input is String) {
      return input.isNotEmpty;
    }

    if (input is List) {
      return input.isNotEmpty;
    }

    print('### isNotEmpty called on ${input.runtimeType}');

    return false;
  }

  static bool isEmpty(dynamic input) {
    return !isNotEmpty(input);
  }

  static void showToast(String value) {
    Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor:
          Colors.cyan, // no context Theme.of(context).primaryColor,
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
    );
  }
}

class NothingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // could also try this
    // return SizedBox(width: 0, height: 0);

    // error message says this takes up as little space as possible
    return Container(width: 0, height: 0);
  }
}

// if you want the contents scrollable when the keyboard comes up to avoid clipping
class ScrollWrapper extends StatelessWidget {
  const ScrollWrapper(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: constraint.maxHeight, maxWidth: constraint.maxWidth),
            child: child),
      );
    });
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    String hc = hexColor.toUpperCase().replaceAll('#', '');
    if (hc.length == 6) {
      hc = 'FF$hc';
    }
    return int.parse(hc, radix: 16);
  }
}

class _Toast extends StatefulWidget {
  @override
  __ToastState createState() => __ToastState();
}

class __ToastState extends State<_Toast> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: const Text('Copied',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
