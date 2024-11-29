import 'package:flutter/material.dart';

abstract class AppTextStyle {
  const AppTextStyle._();

  static TextStyle get _defaultFont {
    return const TextStyle(
      fontWeight: FontWeight.w400,
      overflow: TextOverflow.ellipsis,
      color: Colors.black,
      fontFamily: 'Oswald',
    );
  }

  static TextStyle get _font10 => _defaultFont.copyWith(fontSize: 10);
  static TextStyle get _font12 => _defaultFont.copyWith(fontSize: 12);
  static TextStyle get _font14 => _defaultFont.copyWith(fontSize: 14);
  static TextStyle get _font16 => _defaultFont.copyWith(fontSize: 16);
  static TextStyle get _font18 => _defaultFont.copyWith(fontSize: 18);
  static TextStyle get _font20 => _defaultFont.copyWith(fontSize: 20);
  static TextStyle get _font24 => _defaultFont.copyWith(fontSize: 24);
  static TextStyle get _font32 => _defaultFont.copyWith(fontSize: 32);
  static TextStyle get _font36 => _defaultFont.copyWith(fontSize: 36);

  // 10
  static TextStyle get font10Be => _font10.copyWith(
        fontWeight: FontWeight.w300,
      );
  static TextStyle get font10Re => _font10.copyWith(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get font10Semi => _font10.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get font10Bo => _font10.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get font10Ex => _font10.copyWith(
        fontWeight: FontWeight.w800,
      );

  // Des
  static TextStyle get font12Be => _font12.copyWith(
        fontWeight: FontWeight.w300,
      );
  static TextStyle get font12Re => _font12.copyWith(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get font12Semi => _font12.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get font12Bo => _font12.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get font12Ex => _font12.copyWith(
        fontWeight: FontWeight.w800,
      );

  // Det
  static TextStyle get font14Be => _font14.copyWith(
        fontWeight: FontWeight.w300,
      );
  static TextStyle get font14Re => _font14.copyWith(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get font14Semi => _font14.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get font14Bo => _font14.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get font14Ex => _font14.copyWith(
        fontWeight: FontWeight.w800,
      );

  // Body
  static TextStyle get font16Be => _font16.copyWith(
        fontWeight: FontWeight.w300,
      );
  static TextStyle get font16Re => _font16.copyWith(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get font16Semi => _font16.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get font16Bo => _font16.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get font16Ex => _font16.copyWith(
        fontWeight: FontWeight.w800,
      );

  // Sub
  static TextStyle get font18Be => _font18.copyWith(
        fontWeight: FontWeight.w300,
      );
  static TextStyle get font18Re => _font18.copyWith(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get font18Semi => _font18.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get font18Bo => _font18.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get font18Ex => _font18.copyWith(
        fontWeight: FontWeight.w800,
      );

  // Heading0
  static TextStyle get font20Be => _font20.copyWith(
        fontWeight: FontWeight.w300,
      );
  static TextStyle get font20Re => _font20.copyWith(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get font20Semi => _font20.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get font20Bo => _font20.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get font20Ex => _font20.copyWith(
        fontWeight: FontWeight.w800,
      );

  // Heading1
  static TextStyle get font24Re => _font24.copyWith(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get font24Semi => _font24.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get font24Bo => _font24.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get font24Ex => _font24.copyWith(
        fontWeight: FontWeight.w800,
      );

  // Heading2
  static TextStyle get font32Re => _font32.copyWith(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get font32Semi => _font32.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get font32Bo => _font32.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get font32Ex => _font32.copyWith(
        fontWeight: FontWeight.w800,
      );

  // Heading3
  static TextStyle get font36Re => _font36.copyWith(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get font36Semi => _font36.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get font36Bo => _font36.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get font36Ex => _font36.copyWith(
        fontWeight: FontWeight.w800,
      );
}
