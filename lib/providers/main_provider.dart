import 'dart:math';

import 'package:arapcaquiz/models/quiz_model.dart';
import 'package:arapcaquiz/services/database.dart';
import 'package:arapcaquiz/widgets/custom_navigator.dart';
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

  bool _isWordPageEnd = false;
  bool get isWordPageEnd => _isWordPageEnd;

  MainProvider(){
    getUserState().then((value) {
      isNewUser = value;
      if(!(value??true)){
        notifyListeners();
      }
    });
    _auth.authStateChanges().listen((event) {
      _firebaseUser = event;
      if(event != null){
        Database.id(event.uid).userData.listen((user) {
          _user = user;
        });
      }
    });


  }

  @override
  dispose(){
    pageController.dispose();
    _wordController.dispose();
    super.dispose();
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
    _wordController.addListener(() {
      if(_wordController.page!.round() < _words.length -1){
        _isWordPageEnd = false;
        notifyListeners();
      }else{
        _isWordPageEnd = true;
        notifyListeners();
      }
    });
    return _wordController;
  }

  void clearPageController(){
    _wordController.dispose();
    _isWordPageEnd = false;
  }

  void nextWordPage(BuildContext context)async{
    String docID = _words[_wordController.page!.round()].id!;
    await Database.id(_firebaseUser!.uid).updateWordsUser(docID);
    if(!_isWordPageEnd){
      _wordController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    }else{
      Navigator.of(context).pop();
      _isWordPageEnd = false;
    }
  }
  /// ******** Learning functions end ********

  List<QuizModel> _convertWordsToQuiz(List<WordModel> _words){
    List<QuizModel> result = [];
    if(_words.isNotEmpty){
      _words.shuffle();
      Random _ran = Random(0);
      for (var word in _words) {
        List<String> answers = [];
        int _ranInt = _ran.nextInt(_words.length - 4);
        for(int i = _ranInt; i < _words.length; i++){
          answers.add(_words[i].turkish!);
          if(answers.length >= 5){
            break;
          }
        }
        if(!answers.contains(word.turkish)){
          answers.remove(answers.last);
          answers.add(word.turkish!);
        }
        answers.shuffle();
        result.add(
          QuizModel(
            answers: answers,
            arabic: word.arabic,
            turkish: word.turkish,
            level: word.level,
            correctAnswer: word.turkish,
          ),
        );
        if(result.length >= 10){
          break;
        }
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

  Future<bool> willPop(BuildContext context) async{
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CustomTrText(
            text: "Testi Sonlandır",
          ),
          content: const CustomTrText(
            text: "Testi bitmeden sonlandırsan puan eklenmeyecek.\nçıkmak istiyor musun?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _selectedAnswer = null;
                _correctAnswers = 0;
                _wrongAnswers = 0;
              },
              child: const CustomTrText(text: "Evet",),
            ),
            TextButton(
              onPressed: ()=> Navigator.of(context).pop(false),
              child: const CustomTrText(text: "Hayır",),
            ),
          ],
        );
      },
    ) ?? false;
  }
/// ******** Quiz functions end ********

}