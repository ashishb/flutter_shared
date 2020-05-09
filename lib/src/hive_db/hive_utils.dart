import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_shared/src/hive_db/hive_box.dart';
import 'package:flutter_shared/src/hive_db/hive_data.dart';

class HiveUtils {
  HiveUtils._();

  static Future<void> init() async {
    await Hive.initFlutter('hive');

    // register adapters
    Hive.registerAdapter<HiveData>(HiveDataAdapter());

    // open prefs box before app runs so it's ready
    await HiveBox.prefsBox.open();
  }
}

// return ValueListenableBuilder(
//   valueListenable: widget.hiveBox.listenable(),
//   builder: (BuildContext context, Box<ScanData> __, Widget _) {
//       return xx;
//   },
// ),

// not sure where I got this
// ValueListenableProvider.value(
//       value : widget.hiveBox.listenable(),
//       child:
