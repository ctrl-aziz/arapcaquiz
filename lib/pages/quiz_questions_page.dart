import 'package:arapcaquiz/widgets/custom_ar_text.dart';
import 'package:arapcaquiz/widgets/custom_button.dart';
import 'package:arapcaquiz/widgets/custom_tr_text.dart';
import 'package:flutter/material.dart';

class QuizQuestionsPage extends StatefulWidget {
  final String title;
  const QuizQuestionsPage(this.title, {Key? key}) : super(key: key);

  @override
  State<QuizQuestionsPage> createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage> {
  final List<String> optionsChar = [
    "A",
    "B",
    "C",
    "D",
    "E",
  ];

  final Map<String, String> answers = {
    "A": "Gitti",
    "B": "Yapttı",
    "C": "Hoşlandı",
    "D": "Konuştu",
    "E": "Geldi",
  };

  final String _correctAnswer = "A";

  String? _selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          onPressed: (){
            Navigator.maybePop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Color(0xff267DB2), size: 27,),
        ),
        title: CustomTrText(
          text: widget.title,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          const SizedBox(height: 20.0,),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CustomArText(
                    text: "ذهب ",
                  ),
                  SizedBox(width: 13.0,),
                  CustomTrText(
                    text: "ne demektir?",
                    fontSize: 17,
                  ),
                ],
              ),
            ),
          ),
          ...List.generate(
            optionsChar.length,
                (index) => CustomButton(
                  onPressed: (){
                    setState(() {
                      _selectedAnswer = optionsChar[index];
                    });
                  },
                  text: answers[optionsChar[index]]!,
                  icon: optionsChar[index],
                  selected: _selectedAnswer == null ? null : optionsChar[index] == _selectedAnswer,
                  isRightAnswer: optionsChar[index] == _correctAnswer && _selectedAnswer==_correctAnswer,
                ),
          ),
        ],
      ),
    );
  }
}