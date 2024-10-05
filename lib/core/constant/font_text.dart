import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  // Primary font for titles and headers
  static final TextStyle titleFont = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Font for body text
  static final TextStyle bodyFont = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  // Font for smaller body text
  static final TextStyle smallBodyFont = GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );

  // Font for buttons
  static final TextStyle buttonFont = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Font for captions or labels
  static final TextStyle captionFont = GoogleFonts.lato(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );
}
