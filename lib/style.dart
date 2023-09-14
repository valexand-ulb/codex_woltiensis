import 'package:flutter/material.dart';

class Styles {
  static const double _textSizeLarge = 20.0;
  static const double _textSizeDefault = 15.0;
  static const double _textSizeSmall = 12.0;

  static const horizontalPaddingDefault = 12.0;

  static const Color _textColorStrong = Color(0xFF000000);
  static const Color _textColorDefault = Color(0xFF000000);
  static const Color _textColorFaint = Color(0xFF999999);
  static const Color textColorBright = Color(0xFFFFFFFF);
  static const Color accentColor = Color(0xFFFF0000);
  static const String _fontNameDefault = 'Montserrat';

  static const navBarTitle = TextStyle(
    fontFamily: _fontNameDefault,
    fontWeight: FontWeight.w600,
    fontSize: _textSizeDefault,
    color: _textColorDefault,
  );

  static const headerLarge = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
    color: _textColorStrong,
  );

  static const textDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: _textColorDefault,
    height: 1.2,
  );

  static const locationTitleLight = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
    color: _textColorStrong,
  );

  static const locationTitleDark = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
    color: textColorBright,
  );

  static const locationTitleSubTitle = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: accentColor,
  );

  static const locationTitleCaption = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeSmall,
    color: _textColorFaint,
  );
}
