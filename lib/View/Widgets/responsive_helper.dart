import 'package:flutter/material.dart';

class ResponsiveHelper {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  static double width(double inputWidth) {
    return (inputWidth / 375.0) * screenWidth; // 375 is a base width (iPhone X)
  }

  static double height(double inputHeight) {
    return (inputHeight / 812.0) * screenHeight; // 812 is base height
  }

  static double font(double inputFontSize) {
    return width(inputFontSize);
  }
}
