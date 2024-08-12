import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonbase_explore/app_constants/app_colors.dart';

class LightColorTheme {
  // Backgrounds
  static const primaryColor = Color(0xFFFBC386);
  static const primaryDarkColor = Color(0xFFF35307);
  static const secondaryColor = Color(0xFF20454E);
  static const buttonRedColor = Color(0xFFFB655F);

  // Pure Colors
  static const purpleColor = Color(0xFF5B1B72);
  static const darkWhite = Color(0xffC5CBCC);
  static const lightRed = Color(0xffFF9B85);
  static const yellow = Color(0xffDED9C4);
  static const white = Colors.white;
  static const lightBlack = Color(0xff001D21);
  static const greyColor = Color(0xff8B989A);
  static const greyShaded300 = Color(0xffC4C4C4);
  static const Color lightYellow = Color(0xffFFF2BD);
  static const Color lightGreyColor = Color(0xffEBEBEB);

  // Text Colors
  static Color darkTextColor = Colors.grey.shade900;
  static Color headingTextColor = darkTextColor;
  static Color normalTextColor = greyColor;

  // Other Colors
  static Color noDataDarkColor = primaryDarkColor.withOpacity(0.70);
  static const noDataYellowColor = Color(0xFFFFC847);
}

class DarkColorTheme {
  // Backgrounds
  static const primaryColor = Color(0xFFFBC386);
  static const primaryDarkColor = Color(0xFFF35307);
  static const secondaryColor = Color(0xFF20454E);
  static const buttonRedColor = Color(0xFFFB655F);

  // Pure Colors
  static const purpleColor = Color(0xFF5B1B72);
  static const darkWhite = Color(0xffC5CBCC);
  static const lightRed = Color(0xffFF9B85);
  static const yellow = Color(0xffDED9C4);
  static const lightBlack = Color(0xff001D21);
  static const greyColor = Color(0xff8B989A);
  static const greyShaded300 = Color(0xffC4C4C4);
  static const Color lightYellow = Color(0xffFFF2BD);
  static const Color lightGreyColor = Color(0xffEBEBEB);
  static Color darkTextColor = Colors.grey.shade900;

  // Other Colors
  static const noDataYellowColor = Color(0xFFFFC847);
  static Color noDataDarkColor = primaryDarkColor.withOpacity(0.70);
}

class MoonbaseAppColorTheme {
  MoonbaseAppColorTheme._();

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    primaryColorDark: LightColorTheme.darkTextColor,
    primaryColorLight: const Color(0xFFFBC386),
    disabledColor: const Color(0xffFF9B85),
    unselectedWidgetColor: const Color(0xFF20454E),
    shadowColor: const Color(0xffC4C4C4),
    indicatorColor: const Color(0xFF5B1B72),
    hintColor: Colors.white60,
    focusColor: const Color(0xFFFFC847),
    canvasColor: Colors.white,
    brightness: Brightness.light,
    textTheme: MoonbaseAppTextTheme.lightTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepOrange,
      titleTextStyle: TextStyle(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    primaryColorDark: DarkColorTheme.darkTextColor,
    primaryColorLight: const Color(0xFFFBC386),
    disabledColor: const Color(0xffFF9B85),
    unselectedWidgetColor: const Color(0xFF20454E),
    shadowColor: const Color(0xffC4C4C4),
    indicatorColor: const Color(0xFF5B1B72),
    hintColor: Colors.white60,
    focusColor: const Color(0xFFFFC847),
    brightness: Brightness.dark,
    textTheme: MoonbaseAppTextTheme.darkTextTheme,
    appBarTheme: const AppBarTheme(),
    canvasColor: Colors.grey.shade900,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(),
    ),
  );
}

class MoonbaseAppTextTheme {
  static TextTheme lightTextTheme = GoogleFonts.josefinSansTextTheme().copyWith(
    displayMedium: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    ),
    titleMedium: GoogleFonts.josefinSans(
      textStyle: TextStyle(
        color: Colors.grey.shade900,
        fontSize: 18,
      ),
    ),
  );

  static TextTheme darkTextTheme = GoogleFonts.josefinSansTextTheme().copyWith(
    displayMedium: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
        color: Color(0xffC4C4C4),
        fontSize: 14,
      ),
    ),
    titleMedium: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    ),
  );
}
