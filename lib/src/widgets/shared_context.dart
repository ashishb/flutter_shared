import 'package:flutter/material.dart';

class SharedContext {
  factory SharedContext() {
    return _instance ??= SharedContext._();
  }
  SharedContext._();

  static SharedContext _instance;

  // must set this and get this
  BuildContext context;
}
