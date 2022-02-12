import 'package:flutter/material.dart';

class LearningProvider extends ChangeNotifier{
  final Map<String, String> turkishWords = {
    "إذهب": "Git",
    "إفعل": "Yap",
    "إسئل": "Sor",
    "تناول": "Ye",
    "تعال": "Gel",
  };

  final List<String> arabicWords = [
    "إذهب",
    "إفعل",
    "إسئل",
    "تناول",
    "تعال",
  ];

  late PageController wordController;


  PageController getPageController(int currentIndex){
    wordController = PageController(initialPage: currentIndex);
    return wordController;

  }


}