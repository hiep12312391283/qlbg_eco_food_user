import 'package:flutter/material.dart';

class AppColors {
  static AppColors _singleton = AppColors._internal();

  factory AppColors() {
    return _singleton;
  }

  AppColors._internal();
  static const Color primaryColor = Color(0xFF6200EE); 
  static const txtFormField = Color(0xFFF3E9B5);
  static const green = Color(0xFF83C167);
  static const lightGreen = Color.fromARGB(255, 185, 238, 161);
  static const darkGreen = Color.fromARGB(255, 133, 239, 84);
  static const backgroundColor = Color.fromARGB(255, 244, 244, 244);
  static const black = Colors.black;
}
