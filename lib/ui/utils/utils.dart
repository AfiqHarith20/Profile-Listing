import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color theme_black = HexColor.fromHex('#1C1C1B');

const FontWeight sb = FontWeight.w600;

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

TextStyle myTextStyle(double fontSize, color, fontWeight,
    {double letterSpacing = 0,
    font_style = FontStyle.normal,
    decoration: TextDecoration.none}) {
  return GoogleFonts.openSans(
      textStyle: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          decoration: decoration,
          fontStyle: font_style));
}
