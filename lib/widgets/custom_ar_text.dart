import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomArText extends StatelessWidget {
  final String text;
  final Color? color;
  const CustomArText({Key? key, required this.text, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.lemonada(
        color: color,
      ),
    );
  }
}
