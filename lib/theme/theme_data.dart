import 'package:flutter/material.dart';

ThemeData lightThemeData = themeData(lightColorScheme);
ThemeData darkThemeData = themeData(darkColorScheme);

ThemeData themeData(ColorScheme colorScheme) {
  return ThemeData(
    colorScheme: colorScheme,
    accentColor: colorScheme.primary,
    primaryColor: colorScheme.primary,
    scaffoldBackgroundColor: colorScheme.background,
    dialogTheme: DialogTheme(
      backgroundColor: colorScheme.surface,
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.onSurface.withAlpha(96),
      endIndent: 8,
      indent: 8,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: colorScheme.surface,
    ),
    disabledColor: colorScheme.onSurface.withAlpha(128),
    textTheme: TextTheme(
      bodyText2: TextStyle(
        color: colorScheme.onSurface,
      ),
      subtitle1: TextStyle(
        color: colorScheme.onSurface,
      ),
      headline6: TextStyle(
        color: colorScheme.onSurface,
      ),
    ),
    iconTheme: IconThemeData(
      color: colorScheme.onBackground,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: colorScheme.surface,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: TextStyle(
          fontSize: 16,
        ),
      ),
    ),
    toggleableActiveColor: colorScheme.primary,
  );
}

const ColorScheme lightColorScheme = ColorScheme.light(
  primary: Colors.blueGrey,
  surface: Color(0xffe0e0e0), // grey[300]
  onSurface: Color(0xff212121), // grey[900]
  background: Colors.white,
  onBackground: Color(0xff454545),
);

const ColorScheme darkColorScheme = ColorScheme.dark(
  primary: Colors.blueGrey,
  surface: Color(0xff212121), // grey[900]
  onSurface: Color(0xffbdbdbd), // grey[400]
  background: Colors.black,
  onBackground: Color(0xff757575),
);
