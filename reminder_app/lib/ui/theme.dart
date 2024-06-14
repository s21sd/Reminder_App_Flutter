import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const Color primaryClr = bluishClr;
const Color darkClr = Color(0xFF121212);
Color darkHeaderClr = Colors.grey.shade300;

class Themes {
  // Light Mode
  static final light = ThemeData(
    
    useMaterial3: false,
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor:Colors.white ,
      primarySwatch: Colors.amber,
      accentColor: Colors.amber,
    ),
  );

  // Dark Mode
  static final dark = ThemeData(
    useMaterial3: false,
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: darkClr,
      primarySwatch: Colors.grey,
      accentColor: Colors.greenAccent,
    ),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: (const TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: (const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: (const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black)));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: (const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)));
}
