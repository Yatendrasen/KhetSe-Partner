import 'package:admin/src/models/themes/flex_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlockThemes {
  BlockThemes({
    required this.light,
    required this.dark,
    required this.themeMode,
    required this.googleFontsTextTheme
  });

  ThemeData light;
  ThemeData dark;
  ThemeMode themeMode;
  TextTheme Function([TextTheme]) googleFontsTextTheme;

  factory BlockThemes.fromJson(Map<String, dynamic> json) {
    return BlockThemes(
      light: flexThemeFromJson(json['flexLight'], 'light'),
      dark: flexThemeFromJson(json['flexDark'], 'dark'),
      themeMode: json['themeMode'] == 'ThemeMode.dark' ? ThemeMode.dark : json['themeMode'] == 'ThemeMode.light' ? ThemeMode.light : ThemeMode.system,
      googleFontsTextTheme: GoogleFonts.robotoTextTheme,
    );
  }
}
