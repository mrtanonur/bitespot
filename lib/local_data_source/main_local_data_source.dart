import 'package:hive_flutter/hive_flutter.dart';

class MainLocalDataSource {
  static Box? box;

  static Future openBox() async {
    box = await Hive.openBox("main");
  }

  static Future add(String key, dynamic value) async {
    await box!.put(key, value);
  }

  static dynamic read(String key) {
    return box!.get(key);
  }

  static Future delete(String key) async {
    await box!.delete(key);
  }
}
