import 'package:arapcaquiz/data.dart';
import 'package:arapcaquiz/pages/word_page.dart';
import 'package:arapcaquiz/providers/learning_provider.dart';
import 'package:arapcaquiz/widgets/custom_ar_text.dart';
import 'package:arapcaquiz/widgets/custom_tr_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearningPage extends StatelessWidget {
  final String title;
  LearningPage(this.title, {Key? key}) : super(key: key);

  final LearningProvider _learningProvider = LearningProvider();

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
          text: title,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ChangeNotifierProvider<LearningProvider>(
          create: (_) => _learningProvider,
          builder: (context, _){
            return Consumer<LearningProvider>(
              builder: (context, learning, _){
                return ListView.builder(
                  itemCount: words.length,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WordPage(
                                  _learningProvider,
                                  selectedWord: words[i]["arabic"]!,
                                  index: i,
                                ),
                              ),
                            );
                          },
                          title: CustomArText(
                            text: words[i]["arabic"]!,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/*
FlipCard(
              controller: _cardController,
              front: Card(
                color: const Color(0xff267DB2),
                child: Center(
                  child: Text(
                    arabicWords[i],
                    style: GoogleFonts.lemonada(color: Colors.white),
                  ),
                ),
              ),
              back: Card(
                color: const Color(0xff267DB2),
                child: Center(
                  child: Text(
                    turkishWords[arabicWords[i]]!,
                    style: GoogleFonts.lemonada(color: Colors.white),
                  ),
                ),
              ),
            )
*/
