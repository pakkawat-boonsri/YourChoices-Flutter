import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle googleFont(
          Color color, double fontSize, FontWeight fontWeight) =>
      GoogleFonts.ibmPlexSansThai(
          color: color, fontSize: fontSize, fontWeight: fontWeight);
}
