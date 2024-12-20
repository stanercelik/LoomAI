import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    primaryColor: HexColor('#6A994E'),
    scaffoldBackgroundColor: HexColor('#F7F7F7'),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: HexColor('#333333'),
        fontFamily: 'Poppins',
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: HexColor('#333333'),
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: HexColor('#333333'),
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: HexColor('#333333'),
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: HexColor('#333333'),
        fontFamily: 'Poppins',
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: HexColor('#333333'),
        fontFamily: 'Poppins',
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: HexColor('#333333'),
        fontFamily: 'Poppins',
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: HexColor('#333333'),
        fontFamily: 'Poppins',
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: HexColor('#333333'),
        fontFamily: 'Poppins',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: HexColor('#8FCB81'),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: HexColor('#333333'),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: HexColor('#6A994E'),
      secondary: HexColor('#A5D6A7'),
      surface: HexColor('#F7F7F7'),
      onSurface: HexColor('#333333'),
      onPrimary: HexColor('#333333'),
      onSecondary: HexColor('#333333'),
      error: HexColor('#FF0000'),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    primaryColor: HexColor('#2D6A4F'),
    scaffoldBackgroundColor: HexColor('#121212'),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: HexColor('#E1E1E1'),
        fontFamily: 'Poppins',
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: HexColor('#E1E1E1'),
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: HexColor('#E1E1E1'),
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: HexColor('#E1E1E1'),
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: HexColor('#E1E1E1'),
        fontFamily: 'Poppins',
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: HexColor('#E1E1E1'),
        fontFamily: 'Poppins',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: HexColor('#527A67'),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: HexColor('#E1E1E1'),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: HexColor('#2D6A4F'),
      secondary: HexColor('#81C784'),
      surface: HexColor('#121212'),
      onSurface: HexColor('#E1E1E1'),
      onPrimary: HexColor('#E1E1E1'),
      onSecondary: HexColor('#E1E1E1'),
      error: HexColor('#FF0000'),
    ),
  );
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    } else if (hexColor.length == 3) {
      hexColor = hexColor.split('').map((char) => '$char$char').join();
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
