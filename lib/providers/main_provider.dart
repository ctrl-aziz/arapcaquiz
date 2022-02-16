import 'dart:math';

import 'package:arapcaquiz/models/quiz_model.dart';
import 'package:arapcaquiz/services/database.dart';
import 'package:arapcaquiz/widgets/custom_tr_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/word_model.dart';

class MainProvider extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<WordModel> _words = [];
  List<QuizModel> _quiz = [];
  String? level;
  List<WordModel> get words => _words;
  List<QuizModel> get quiz => _quiz;

  final List<String> levels = [
    "A1", "A2", "B1", "B2", "C1", "C2"
  ];

  final Map<String, String> levelsName = {
    "A1": "Başlangıç", "A2": "Temel", "B1": "Orta seviye öncesi",
    "B2": "Orta seviye", "C1": "Orta seviye üstü", "C2": "İleri",
  };

  final List<String> optionsChar = [
    "A", "B", "C", "D", "E",
  ];

  String? _selectedAnswer;
  set selectedAnswer(String? val) {
    _selectedAnswer = val;
    notifyListeners();
  }

  final PageController pageController = PageController();

  User? _firebaseUser;
  String? get user => _firebaseUser == null ? null: _firebaseUser!.uid;

  UserModel? _user;

  double get successRate => _user!.successRate!;

  bool? isNewUser;

  late PageController _wordController;

  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  MainProvider(){
    getUserState().then((value) {
      isNewUser = value;
      notifyListeners();
    });
    _auth.authStateChanges().listen((event) {
      _firebaseUser = event;
      if(event != null){
        Database.id(event.uid).userData.listen((user) {
          _user = user;
          notifyListeners();
        });
      }else{
        notifyListeners();
      }
    });
  }


  /// ******** Auth functions start ********
  Future logInAnon () async{
    try{
      UserCredential _user = await _auth.signInAnonymously();
      await Database.id(_user.user!.uid).setNewUserData();
      return _user;
    }catch(e){
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    notifyListeners();
  }

  Future setUserState(bool state) async{
    final prefs = await SharedPreferences.getInstance();
    try{
      return prefs.setBool("isNewUser", state);
    }catch(e){
      if (kDebugMode) {
        print("Shared_preferences Error: $e");
      }
      rethrow;
    }
  }

  Future<bool?> getUserState() async{
    try{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool("isNewUser");
    }catch(e){
      if (kDebugMode) {
        print("Shared_preferences Error: $e");
      }
      rethrow;
    }
  }
  /// ******** Auth functions end ********

  /// ******** Learning functions start ********
  void getWords(){
    assert(level != null, "Level must not be null");
    Database.level(level).allWords.listen((words) {
      _words = words;
      notifyListeners();
    });
  }

  PageController getPageController(int currentIndex){
    _wordController = PageController(initialPage: currentIndex);
    return _wordController;
  }

  void nextWordPage()async{
    _wordController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
    String docID = _words[_wordController.page!.round()].id!;
    await Database.id(_firebaseUser!.uid).updateWordsUser(docID);
  }
  /// ******** Learning functions end ********

  List<QuizModel> _convertWordsToQuiz(List<WordModel> _words){
    List<QuizModel> result = [];
    List<String> answers = [];
    if(_words.isNotEmpty){
      Random _ran = Random(0);
      int _ranInt = _ran.nextInt(_words.length);
      for(int i = _ranInt; i < (_words.length<4?_words.length:4); i++){
        answers.add(_words[i].turkish!);
      }

      for (var word in _words) {
        if(!answers.contains(word.turkish)){
          answers.add(word.turkish!);
        }
        result.add(
          QuizModel(
            answers: answers,
            arabic: word.arabic,
            turkish: word.turkish,
            level: word.level,
            correctAnswer: word.turkish,
          ),
        );
      }
    }
    return result;
  }

  /// ******** Quiz functions start ********
  void getQuiz(){
    assert(level != null, "Level must not be null");
    Database.level(level).allWords.listen((words) {
      _quiz = _convertWordsToQuiz(words);
      _quiz.shuffle();
      notifyListeners();
    });
  }

  void chooseAnswer(BuildContext mainContext, int pageIndex, int listIndex) async{
    _selectedAnswer = _quiz[pageIndex].answers![listIndex];
    notifyListeners();
    if(isRightAnswer(pageIndex, listIndex)??false){
      _correctAnswers++;
    }else{
      _wrongAnswers++;
    }
    if(pageController.page!.round() < _quiz.length-1) {
      Future.delayed(
        const Duration(milliseconds: 250),
            () async{
              _selectedAnswer = null;
              notifyListeners();
              await pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInBack,
              ).then((value) {
                _quiz[pageIndex].answers!.shuffle();
                  notifyListeners();
              });
            },
      );
    }else{
      // End of quiz
      showDialog(
        context: mainContext,
        builder: (dialogContext){
          return WillPopScope(
            onWillPop: () async{
              return false;
            },
            child: dialog(mainContext, dialogContext),
          );
        },
      );
    }
  }

  AlertDialog dialog(BuildContext mainContext, dialogContext){
    double _score = _correctAnswers.toDouble() * 100.0;
    return AlertDialog(
      title: const Center(
        child: CustomTrText(
          text: "Sonuç",
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTrText(text: "Doğru cevap sayısı: $_correctAnswers"),
          CustomTrText(text: "Yanlış cevap sayısı: $_wrongAnswers"),
          CustomTrText(text: "Kazandığın puan: $_score"),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: (){
            Database.id(_firebaseUser!.uid).updateUserData(_user!.successRate! + _score);
            Navigator.of(dialogContext).pop();
            Navigator.of(mainContext).pop();
            _selectedAnswer = null;
            _correctAnswers = 0;
            _wrongAnswers = 0;
          },
          child: const CustomTrText(
            text: "Sonlandır",
          ),
        ),
      ],
    );
  }

  bool? isSelected(int pageIndex, int listIndex) {
    return _selectedAnswer == null ? null : _quiz[pageIndex].answers![listIndex] == _selectedAnswer;
  }

  bool? isRightAnswer(int pageIndex, int listIndex){
    return _quiz[pageIndex].answers![listIndex] == _quiz[pageIndex].turkish && _selectedAnswer==_quiz[pageIndex].turkish;
  }
/// ******** Quiz functions end ********

}