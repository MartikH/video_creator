import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static TextStyle _baseTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color = AppColors.textPrimary,
    TextOverflow? overflow,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      overflow: overflow,
    );
  }

  static final TextStyle pathname = _baseTextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    overflow: TextOverflow.ellipsis,
  );

  static final TextStyle bodyText = _baseTextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle button = _baseTextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.buttonText,
  );
}
