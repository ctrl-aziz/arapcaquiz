import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const String SUCCESS_RATE = "success_rate", WORD_HAVE = "word_have";
  String? uid;

  UserModel.uid(this.uid);

  double? successRate;
  int? wordsHave;

  UserModel.data({
    required this.successRate,
    required this.wordsHave,
  });

  UserModel.fromSnapshot(DocumentSnapshot data){
    successRate = double.tryParse(data.get(SUCCESS_RATE).toString());
    wordsHave = int.tryParse(data.get(WORD_HAVE).toString());
  }

  Map<String, dynamic> toJson(){
    return {
      SUCCESS_RATE: successRate,
      WORD_HAVE: wordsHave,
    };
  }
}