import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String clientImageTapTag = "";
  String orderSearchTag = "";

  // holds the current theme of app
  ThemeMode appThemeMode = ThemeMode.system;

  get clientTag => clientImageTapTag;
  get searchTag => orderSearchTag;

  void setTappedTag(String tag) {
    clientImageTapTag = tag;
    notifyListeners();
  }

  void toggleMode() {
    if (appThemeMode == ThemeMode.light) {
      appThemeMode = ThemeMode.dark;
    } else {
      appThemeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  void setOrderSearchTag(String tag) {
    orderSearchTag = tag;
    notifyListeners();
  }
}
