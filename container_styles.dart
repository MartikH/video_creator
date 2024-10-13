import 'package:flutter/material.dart';

class AppContainerStyles {
  static BoxDecoration boxStyle = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 4,
        offset: Offset(2, 2),
      ),
    ],
  );
}
