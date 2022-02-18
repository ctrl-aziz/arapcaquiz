import 'package:arapcaquiz/models/word_model.dart';
import 'package:arapcaquiz/providers/main_provider.dart';
import 'package:arapcaquiz/widgets/custom_ar_text.dart';
import 'package:arapcaquiz/widgets/custom_tr_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordPage extends StatelessWidget {
  final int index;
  const WordPage({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Consumer<MainProvider>(
        builder: (context, provider, _){
          return WillPopScope(
            onWillPop: () async{
              provider.clearPageController();
              return true;
            },
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: PageView.builder(
                    itemCount: provider.words.length,
                    controller: provider.getPageController(index),
                    itemBuilder: (context, i){
                      return WordCard(
                        words: provider.words[i],
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: TextButton(
                      onPressed: () => provider.nextWordPage(context),
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
                          children: [
                            CustomTrText(text: provider.isWordPageEnd ? "Sonlandır" : "Sonra"),
                            provider.isWordPageEnd
                                ?
                            const SizedBox()
                                :
                            const Icon(Icons.arrow_forward_ios, color: Colors.black,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class WordCard extends StatelessWidget {
  final WordModel words;
  const WordCard({
    Key? key,
    required this.words,
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
                text: words.turkish!,
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
                text: words.arabic!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
