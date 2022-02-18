import 'package:arapcaquiz/pages/word_page.dart';
import 'package:arapcaquiz/providers/main_provider.dart';
import 'package:arapcaquiz/widgets/custom_ar_text.dart';
import 'package:arapcaquiz/widgets/custom_navigator.dart';
import 'package:arapcaquiz/widgets/custom_tr_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearningPage extends StatelessWidget {
  final String title;
  const LearningPage(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTrText(
          text: title,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Consumer<MainProvider>(
          builder: (context, provider, _){
            return ListView.builder(
              itemCount: provider.words.length,
              itemBuilder: (context, i){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xff267DB2),
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: ListTile(
                      onTap: (){
                        CustomNavigator.push(context, WordPage(index: i,));
                      },
                      title: CustomArText(
                        text: provider.words[i].arabic!,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
