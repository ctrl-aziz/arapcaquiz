import 'package:arapcaquiz/pages/settings_page.dart';
import 'package:arapcaquiz/providers/main_provider.dart';
import 'package:arapcaquiz/widgets/custom_navigator.dart';
import 'package:arapcaquiz/widgets/custom_tr_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tabs/learn_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/quiz_tab.dart';

/*
  * #267DB2
  * #FF6A6B
  * #50BCFF
  * #CCCA2C
  * #B2B02F
  * */
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> titles = [
    "Öğren",
    "Egzersiz",
    "Profil",
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    login();
    super.initState();
    _tabController = TabController(vsync: this, length: titles.length)..addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  login() async {
    if(Provider.of<MainProvider>(context, listen: false).user == null) {
      await Provider.of<MainProvider>(context, listen: false).logInAnon();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTrText(
          text: titles[_currentIndex],
            color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: (){
              CustomNavigator.push(context, const SettingsPage());
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 10.0,),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LearnTab(),
          QuizTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xff267DB2),
        child: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xffFF6A6B),
          labelColor: const Color(0xffFF6A6B),
          overlayColor: MaterialStateProperty.all(Colors.black),
          unselectedLabelColor: Colors.white,
          tabs: List.generate(
            titles.length,
                (index) => Tab(
            child: CustomTrText(
              text: titles[index],
            ),
          ),
          ),
        ),
      ),
    );
  }
}
