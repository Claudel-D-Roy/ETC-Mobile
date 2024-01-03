import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool _isDarkMode, BuildContext context){
    return ThemeData(
      scaffoldBackgroundColor: _isDarkMode ? const Color(0xFF30001a) : const Color(0xFFFFFFFF),
      primaryColor: Colors.grey,
      colorScheme: ThemeData().colorScheme.copyWith(
        secondary: 
        _isDarkMode ? const Color(0xFF1a1f3c) : const Color(0xFFE8FDFD),
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,

        ),
        cardColor: 
        _isDarkMode ? const Color(0xFF3a0d2c) : const Color(0xFFF2FDFD),
        canvasColor: _isDarkMode ? Colors.black : Colors.grey[50],
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: _isDarkMode ? const ColorScheme.dark() : const ColorScheme.light()
        ),
      );
  }
}