import 'package:arapcaquiz/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;



  User? _firebaseUser;
  String? get user => _firebaseUser == null ? null: _firebaseUser!.uid;

  UserModel? _user;

  double get successRate => _user!.successRate!;
  int get wordsHave => _user!.wordsHave!;

  bool? isNewUser;

  AuthProvider(){
    getUserState().then((value) {
      isNewUser = value;
    });
    _auth.authStateChanges().listen((event) {
      _firebaseUser = event;
      if(event != null){
        Database(event.uid).userData.listen((user) {
          _user = user;
          notifyListeners();
        });
      }
    });
  }

  Future logInAnon () async{
    try{
      UserCredential _user = await _auth.signInAnonymously();
      Database(_user.user!.uid).setNewUserData();
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
}