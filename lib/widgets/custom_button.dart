import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final String text, icon;
  final bool? selected;
  final bool? isRightAnswer;
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.selected,
    this.isRightAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          selected: selected??false,
          selectedTileColor: isRightAnswer == null || !isRightAnswer! ? Colors.grey[200] : Colors.green,
          tileColor: isRightAnswer == null || !isRightAnswer! ? Colors.grey[100] : Colors.green,
          selectedColor: isRightAnswer == null || !isRightAnswer! ? Colors.red : Colors.black,
          title: Text(
            text,
            style: GoogleFonts.oswald(),
          ),
          leading: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                icon,
                style: GoogleFonts.oswald(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
