import 'package:flutter/material.dart';
import 'package:msafi_mobi/themes/main.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(
      color: kTextMediumColor,
    ),
    colorScheme: const ColorScheme.light(
        primary: kPrimaryColor, secondary: kTextMediumColor, error: Colors.red),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kDarkBackgroundColor,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    colorScheme: const ColorScheme.light(
        primary: kPrimaryColor,
        secondary: kDarkTextMediumColor,
        error: Colors.yellow),
  );
}
