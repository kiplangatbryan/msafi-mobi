import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/themes/main.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kTextLight,
    iconTheme: const IconThemeData(
      color: kTextColor,
    ),
    textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
    colorScheme: const ColorScheme.light(
      primary: kTextColor,
      secondary: kTextMediumColor,
      secondaryContainer: kSecondaryColor,
      error: Colors.red,
      tertiary: kAccentColor,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kTextColor,
    scaffoldBackgroundColor: kTextColor,
    textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
    iconTheme: const IconThemeData(
      color: kTextLight,
    ),
    colorScheme: const ColorScheme.dark(
        primary: kTextColor, secondary: kSecondaryColor, error: Colors.yellow),
  );
}
