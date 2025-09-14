import 'package:bitespot/utils/constants/constants.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: ColorConstants.grey900,
  textTheme: const TextTheme(
    labelMedium: TextStyle(color: ColorConstants.white),
    bodyLarge: TextStyle(color: ColorConstants.white),
    bodyMedium: TextStyle(color: ColorConstants.white),
    bodySmall: TextStyle(color: ColorConstants.white),
    titleLarge: TextStyle(color: ColorConstants.white),
    titleMedium: TextStyle(color: ColorConstants.white),
    titleSmall: TextStyle(color: ColorConstants.white),
  ),
  colorScheme: const ColorScheme.dark(
    surface: ColorConstants.grey800,
    surfaceBright: ColorConstants.black,
    primary: ColorConstants.accent,
    secondary: ColorConstants.white,
    tertiary: ColorConstants.white,
    inversePrimary: ColorConstants.grey500,
    error: ColorConstants.red,
    outline: ColorConstants.green,
  ),
);
