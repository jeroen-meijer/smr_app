import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const fontFamilyProductSans = 'Product Sans';
  static const fontFamilyDefault = fontFamilyProductSans;

  static const fontWeightExtraLight = FontWeight.w200;
  static const fontWeightLight = FontWeight.w300;
  static const fontWeightNormal = FontWeight.w400;
  static const fontWeightMedium = FontWeight.w500;
  static const fontWeightSemiBold = FontWeight.w600;
  static const fontWeightBold = FontWeight.w700;

  static const colorTextPrimary = Colors.black;
  static const colorAccent = Colors.pink;
  static const colorBackground = Colors.white;

  static ThemeData theme() {
    return ThemeData(
      fontFamily: fontFamilyDefault,
      primarySwatch: colorAccent,
    );
  }
}
