import 'package:flutter/material.dart';
import 'package:flutter_platter/core/constants.dart';
import 'package:flutter_platter/theme/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: kPrimary,
  scaffoldBackgroundColor: kPrimary,
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimary,
    iconTheme: IconThemeData(color: kPrimaryText),
    titleTextStyle: TextStyle(color: kPrimaryText, fontSize: 20.sp),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: kPrimary,
    secondary: kPrimaryText,
    error: kAccentColor,
    tertiary: kSecondary,
  ),
  textTheme: TextTheme(
    titleLarge: kTitleTextStyle,
    bodyLarge: kRegularTextStyle,
    bodySmall: kParagraphTextStyle,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kPrimary,
    labelStyle: kRegularTextStyle,
    hintStyle: kRegularTextStyle.copyWith(color: kPrimaryText.withAlpha(100)),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 6.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kPrimaryText),
      borderRadius: BorderRadius.circular(10.0),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: kPrimaryText),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kPrimaryText),
      borderRadius: BorderRadius.circular(10.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kAccentColor),
      borderRadius: BorderRadius.circular(10.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  primaryColor: kPrimaryDark,
  scaffoldBackgroundColor: kPrimaryDark,
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimaryDark,
    iconTheme: IconThemeData(color: kPrimaryTextDark),
    titleTextStyle: TextStyle(color: kPrimaryTextDark, fontSize: 20.sp),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: kPrimaryDark,
    secondary: kPrimaryTextDark,
    error: kAccentColor,
    tertiary: kSecondaryDark,
  ),
  iconTheme: IconThemeData(color: kPrimaryTextDark),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: kPrimaryTextDark,
      textStyle: kRegularTextStyle.copyWith(color: kPrimaryTextDark),
    ),
  ),
  textTheme: TextTheme(
    titleLarge: kTitleTextStyle.copyWith(color: kPrimaryTextDark),
    bodyLarge: kRegularTextStyle.copyWith(color: kPrimaryTextDark),
    bodySmall: kParagraphTextStyle.copyWith(color: kPrimaryTextDark),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kPrimaryDark,
    labelStyle: kRegularTextStyle.copyWith(color: kPrimaryTextDark),
    hintStyle: kRegularTextStyle.copyWith(
      color: kPrimaryTextDark.withAlpha(100),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 6.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kPrimaryTextDark),
      borderRadius: BorderRadius.circular(10.0),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: kPrimaryTextDark),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kPrimaryTextDark),
      borderRadius: BorderRadius.circular(10.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kAccentColor),
      borderRadius: BorderRadius.circular(10.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
);
