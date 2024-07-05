import 'package:flutter/material.dart';

const TextTheme textTheme = TextTheme(
  headlineLarge: TextStyle(fontSize: 40),
  headlineSmall: TextStyle(fontSize: 28),
  titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
  titleMedium: TextStyle(fontSize: 24),
  titleSmall: TextStyle(fontSize: 18),
  labelLarge: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  ),
  labelMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
);

ButtonStyle elevationButtonStyle(Color mainColor, Color textColor) =>
    ButtonStyle(
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(fontSize: 20),
      ),
      foregroundColor: WidgetStateProperty.all<Color>(textColor),
      backgroundColor: WidgetStateProperty.all<Color>(mainColor),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );

ButtonStyle textButtonStyle(Color mainColor) => TextButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );

InputDecorationTheme inputDecoration(Color? mainColor) => InputDecorationTheme(
      prefixIconColor: mainColor,
      suffixIconColor: mainColor,
      hintStyle: const TextStyle(fontSize: 20),
      labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: mainColor!),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: mainColor,
        ),
      ),
    );

ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.grey[300],
    centerTitle: true,
    titleTextStyle: const TextStyle(fontSize: 28, color: Colors.black),
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.blueAccent,
    cardColor: Colors.grey[50],
    backgroundColor: Colors.grey[300],
    brightness: Brightness.light,
  ),
  inputDecorationTheme: inputDecoration(Colors.black),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: elevationButtonStyle(Colors.blue, Colors.white),
  ),
  textButtonTheme: TextButtonThemeData(
    style: textButtonStyle(Colors.blue),
  ),
  textTheme: textTheme,
);

ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.grey[900],
    centerTitle: true,
    titleTextStyle: const TextStyle(fontSize: 28, color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.indigo,
    accentColor: Colors.indigoAccent,
    cardColor: Colors.grey[850],
    backgroundColor: Colors.grey[900],
    brightness: Brightness.dark,
  ),
  inputDecorationTheme: inputDecoration(Colors.grey[350]),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: elevationButtonStyle(Colors.indigo, Colors.white),
  ),
  textButtonTheme: TextButtonThemeData(
    style: textButtonStyle(Colors.indigo),
  ),
  textTheme: textTheme,
);
