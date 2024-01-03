import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:etc_claudel/Providers/dark_theme_provider.dart';

class Utilis {
  BuildContext context;
  Utilis(this.context);
  bool get getTheme => Provider.of<DarkThemeProvider>(context).getDarkTheme;
  Color get color => getTheme ? Colors.white : Colors.black;
  Size get getScreenSize => MediaQuery.of(context).size;
}