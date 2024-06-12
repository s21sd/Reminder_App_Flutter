import 'package:flutter/material.dart';

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
      primarySwatch: Colors.amber,
      accentColor: Colors.amber,
    ),
  );

  // Dark Mode
  static final dark = ThemeData(
    useMaterial3: false,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.grey,
      accentColor: Colors.greenAccent,
    ),
  );
}
