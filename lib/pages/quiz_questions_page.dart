import 'package:arapcaquiz/providers/main_provider.dart';
import 'package:arapcaquiz/widgets/custom_ar_text.dart';
import 'package:arapcaquiz/widgets/custom_button.dart';
import 'package:arapcaquiz/widgets/custom_tr_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizQuestionsPage extends StatelessWidget {
  final String title;
  const QuizQuestionsPage(this.title, {Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTrText(
          text: title,
          color: Colors.black,
        ),
      ),
      body: Consumer<MainProvider>(
        builder: (context, provider, _){
          return WillPopScope(
            onWillPop: ()=> provider.willPop(context),
            child: PageView.builder(
              itemCount: provider.quiz.length,
              physics: const NeverScrollableScrollPhysics(),
              controller: provider.pageController,
              itemBuilder: (context, pageIndex){
                if (kDebugMode) {
                  print("provider.quiz: ${provider.quiz.length}");
                }
                return Column(
                  children: [
                    const SizedBox(height: 20.0,),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomArText(
                                text: provider.quiz[pageIndex].arabic!,
                              ),
                              const SizedBox(width: 13.0,),
                              const CustomTrText(
                                text: "ne demektir?",
                                fontSize: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 12,
                      child: ListView.builder(
                        itemCount: provider.quiz[pageIndex].answers!.length,
                        itemBuilder: (context, listIndex){
                          return CustomButton(
                            onPressed: () => provider.chooseAnswer(context, pageIndex, listIndex),
                            text: provider.quiz[pageIndex].answers![listIndex],
                            icon: provider.optionsChar[listIndex],
                            selected: provider.isSelected(pageIndex, listIndex),
                            isRightAnswer: provider.isRightAnswer(pageIndex, listIndex),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}