import 'package:flutter/material.dart';

class FontSizeProvider extends ChangeNotifier {
  double _fontSizeValue = 0.5; // Default value

  double get fontSizeValue => _fontSizeValue;

  void setFontSize(double value) {
    _fontSizeValue = value;
    notifyListeners();
  }
}