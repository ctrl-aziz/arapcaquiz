import 'package:arapcaquiz/models/user_model.dart';
import 'package:arapcaquiz/models/word_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Database{
  final _userCollection = FirebaseFirestore.instance.collection("Users");
  final _wordCollection = FirebaseFirestore.instance.collection("Words");

  String? id;

  String? level;

  Database.id(this.id);

  Database.level(this.level);

  Database();

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
          UserModel.data(successRate: 0).toJson()
        );
      }
    }catch(e){
      if (kDebugMode) {
        print("setNewUserData Error: $e");
      }
      rethrow;
    }
  }

  Future updateUserData(double score) async {
    assert(id != null, "User id must not be null");
    try{
      return await _userCollection.doc(id).update(
          UserModel.data(successRate: score).toJson()
      );
    }catch(e){
      if (kDebugMode) {
        print("updateUserData Error: $e");
      }
      rethrow;
    }
  }


  List<WordModel> _wordsFromSnapshot(QuerySnapshot snapshot){
    try{
      return snapshot.docs.map((doc) {
        return WordModel.fromSnapshot(doc);
      }).toList();
    }catch(e){
      if (kDebugMode) {
        print("WordsFromSnapshot Error: $e");
      }
      rethrow;
    }
  }

  Stream<List<WordModel>> get allWords{
    assert(level != null, "Level must not be null user Database.level() constructor");
    return _wordCollection.where(WordModel.LEVEL, isEqualTo: level).snapshots().map(_wordsFromSnapshot);
  }

  Future<int> get userWords async {
    assert(id != null, "id must not be null try use Database.id() constructor");
    try{
      int len = (await _wordCollection.where(WordModel.USERS, arrayContains: id).get()).size;
      return len;
    }catch(e){
      if (kDebugMode) {
        print("userWords Error: $e");
      }
      rethrow;
    }
  }

  Future updateWordsUser(String docID) async {
    assert(id != null, "User id must not be null");
    try{
      return await _wordCollection.doc(docID).update(
          WordModel.updateUsers(users: [id!]).userToJson()
      );
    }catch(e){
      if (kDebugMode) {
        print("updateUserData Error: $e");
      }
      rethrow;
    }
  }

}