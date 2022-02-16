import 'package:arapcaquiz/pages/quiz_questions_page.dart';
import 'package:arapcaquiz/providers/main_provider.dart';
import 'package:arapcaquiz/widgets/custom_button.dart';
import 'package:arapcaquiz/widgets/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuizTab extends StatelessWidget {
  const QuizTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30.0,
        ),
        Expanded(
          flex: 1,
          child: Text(
            "İstediğin seviyeyi seçip egzersizler başla",
            style: GoogleFonts.oswald(
                fontSize: 17,
            ),
          ),
        ),
        Expanded(
          flex: 12,
          child: Consumer<MainProvider>(
            builder: (context, provider, _){
              return ListView.builder(
                itemCount: provider.levels.length,
                itemBuilder: (context, i){
                  return CustomButton(
                    onPressed: (){
                      provider.level = provider.levels[i];
                      provider.getQuiz();
                      CustomNavigator.push(context, QuizQuestionsPage("${provider.levels[i]} ${provider.levelsName[provider.levels[i]]}"));
                    },
                    text: provider.levelsName[provider.levels[i]]!,
                    icon: provider.levels[i],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}