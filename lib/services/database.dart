import 'package:arapcaquiz/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Database{
  final _userCollection = FirebaseFirestore.instance.collection("Users");

  String? id;

  Database(this.id);

  UserModel _userDataFromSnapshot(DocumentSnapshot snapshot){
    try{
      return UserModel.fromSnapshot(snapshot);
    }catch(e){
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }

  Stream<UserModel> get userData{
    assert(id != null, "User id must not be null");
    return _userCollection.doc(id).snapshots().map(_userDataFromSnapshot);
  }

  Future setNewUserData() async {
    try{
      bool _userExist = (await _userCollection.doc(id).get()).exists;
      if(_userExist){
        if (kDebugMode) {
          print("User is exist");
        }
        return;
      }else{
        return await _userCollection.doc(id).set(
          UserModel.data(successRate: 0, wordsHave: 0).toJson()
        );
      }
    }catch(e){
      if (kDebugMode) {
        print("setNewUserData Error: $e");
      }
      rethrow;
    }
  }
}