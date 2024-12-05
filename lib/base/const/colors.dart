import 'package:flutter/material.dart';

class AppColors {
  static AppColors _singleton = AppColors._internal();

  factory AppColors() {
    return _singleton;
  }

  AppColors._internal();

  static const txtFormField = Color(0xFFF3E9B5);
  static const int _greenPrimaryValue = 0xFF83C167;
  static const MaterialColor green = MaterialColor(
    _greenPrimaryValue,
    <int, Color>{
      50: Color(0xFFE8F5E9), // Màu sáng nhất
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: Color(_greenPrimaryValue), // Màu chủ (màu 500)
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20), // Màu tối nhất
    },
  );
  static const lightGreen = Color.fromARGB(255, 185, 238, 161);
  static const darkGreen = Color.fromARGB(255, 133, 239, 84);
  static const backgroundColor = Color.fromARGB(255, 244, 244, 244);
  static const black = Colors.black;
}
