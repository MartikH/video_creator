import 'package:flutter/material.dart';
import 'colors.dart';

class AppButtonStyles {
  static final ButtonStyle _baseButtonStyle = ButtonStyle(
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static final ButtonStyle elevatedButtonStyle = _baseButtonStyle.copyWith(
    backgroundColor: WidgetStateProperty.all(AppColors.primary),
  );

  static final ButtonStyle textButtonStyle = _baseButtonStyle.copyWith(
    foregroundColor: WidgetStateProperty.all(AppColors.primary),
    textStyle: WidgetStateProperty.all(
      const TextStyle(
        color: Colors.white10,
      ),
    ),
  );

  static final ButtonStyle outlinedButtonStyle = _baseButtonStyle.copyWith(
    foregroundColor: WidgetStateProperty.all(AppColors.primary),
    side: WidgetStateProperty.all(
      const BorderSide(color: AppColors.primary),
    ),
  );
}
