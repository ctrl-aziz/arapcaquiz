import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTrText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  const CustomTrText({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: GoogleFonts.oswald(
          fontSize: fontSize,
          color: color,
        ),
    );
  }
}
