import 'package:arapcaquiz/pages/home/home_page.dart';
import 'package:arapcaquiz/providers/main_provider.dart';
import 'package:arapcaquiz/widgets/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashProvider extends ChangeNotifier{
  final List<String> assets = [
    "assets/svg/01.svg",
    "assets/svg/02.svg",
    "assets/svg/03.svg",
  ];

  final List<String> titles = [
    "Arapça Dilini Geliştermek İçin Başla",
    "Egzersizler çöz",
    "Yeni kelimeler Öğren",
  ];

  final PageController pageController = PageController();

  bool isLastPage = false;

  SplashProvider(){
    pageController.addListener(() {
      isLastPage = pageController.page!.round() >= assets.length-1;
      notifyListeners();
    });
  }
  
  Future<void> nexPage(BuildContext context) async {
    if(pageController.page!.round() >= assets.length-1){
      await Provider.of<MainProvider>(context, listen: false).setUserState(false);
      await Provider.of<MainProvider>(context, listen: false).logInAnon();
      CustomNavigator.pushReplacement(context, const HomePage(),);
      // TODO: Activate this if need
      // ImageCache().clear();
    }else{
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.bounceOut);
    }
    notifyListeners();
  }
}