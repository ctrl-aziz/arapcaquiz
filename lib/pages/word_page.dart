import 'package:arapcaquiz/providers/learning_provider.dart';
import 'package:arapcaquiz/widgets/custom_ar_text.dart';
import 'package:arapcaquiz/widgets/custom_tr_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordPage extends StatelessWidget {
  final LearningProvider _learningProvider;
  final String selectedWord;
  final int index;
  const WordPage(
      this._learningProvider, {
        Key? key,
        required this.selectedWord,
        required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ChangeNotifierProvider<LearningProvider>.value(
        value: _learningProvider,
        builder: (context, _){
          return Consumer<LearningProvider>(
            builder: (context, learning, _){
              return Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: PageView.builder(
                      itemCount: learning.arabicWords.length,
                      controller: learning.getPageController(index),
                      itemBuilder: (context, i){
                        return WordCard(
                          arabicWord: learning.arabicWords[i],
                          turkishWord: learning.turkishWords[learning.arabicWords[i]]!,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: TextButton(
                        onPressed: (){
                          learning.wordController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.bounceIn,
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              CustomTrText(text: "Sonra"),
                              Icon(Icons.arrow_forward_ios, color: Colors.black,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class WordCard extends StatelessWidget {
  final String arabicWord;
  final String turkishWord;
  const WordCard({
    Key? key,
    required this.arabicWord,
    required this.turkishWord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            top: 100,
            left: 50,
            child: Container(
              width: 250.0,
              height: 150.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 7,
                    ),
                  ]
              ),
              child: CustomTrText(
                text: turkishWord,
                fontSize: 21,
              ),
            ),
          ),
          Positioned(
            left: 140,
            top: 75,
            child: Container(
              width: 70.0,
              height: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 7,
                    ),
                  ]
              ),
              child: CustomArText(
                text: arabicWord,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
