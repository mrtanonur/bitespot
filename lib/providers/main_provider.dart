import 'package:bitespot/local_data_source/main_local_data_source.dart';
import 'package:flutter/material.dart';

enum Languages { tr, en }

class MainProvider extends ChangeNotifier {
  int navigationIndex = 0;
  Languages language = Languages.values.firstWhere(
    (language) =>
        language.name ==
        (MainLocalDataSource.read("language") ?? Languages.en.name),
  );

  ThemeMode theme = ThemeMode.values.firstWhere(
    (theme) =>
        theme.name ==
        (MainLocalDataSource.read("theme") ?? ThemeMode.system.name),
  );

  void changeNavigationIndex(int index) {
    navigationIndex = index;
    notifyListeners();
  }

  void changeTheme(ThemeMode themeMode) async {
    theme = themeMode;
    await MainLocalDataSource.add("theme", theme.name);

    notifyListeners();
  }

  void changeLanguage(Languages selectedLanguage) async {
    language = selectedLanguage;
    await MainLocalDataSource.add("language", language.name);

    notifyListeners();
  }

  void resetNavigationIndex() {
    navigationIndex = 0;
  }
}
