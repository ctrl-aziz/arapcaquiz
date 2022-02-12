import 'package:arapcaquiz/pages/quiz_questions_page.dart';
import 'package:arapcaquiz/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizTab extends StatelessWidget {
  QuizTab({Key? key}) : super(key: key);

  final List<String> levels = [
    "A1",
    "A2",
    "B1",
    "B2",
    "C1",
    "C2"
  ];

  final Map<String, String> levelsName = {
    "A1": "Başlangıç",
    "A2": "Temel",
    "B1": "Orta seviye öncesi",
    "B2": "Orta seviye",
    "C1": "Orta seviye üstü",
    "C2": "İleri",
  };


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40.0,
        ),
        Text(
          "İstediğin seviyeyi seçip egzersizler başla",
          style: GoogleFonts.oswald(
              fontSize: 17,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        ...List.generate(
          levels.length,
              (index) => CustomButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizQuestionsPage("${levels[index]} ${levelsName[levels[index]]}"),
                    ),
                  );
                },
                text: levelsName[levels[index]]!,
                icon: levels[index],
              ),
        ),
      ],
    );
  }
}