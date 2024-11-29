import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.textBtn,
    required this.onPressed,
    this.width = 200,
    this.height = 50,
    this.backgroundColor = const Color(0xFF83C167),
    this.textColor = Colors.white,
  });

  final String textBtn;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          textBtn,
          style:
              TextStyle(color: textColor, fontSize: 18, fontFamily: 'Oswald'),
        ),
      ),
    );
  }
}
