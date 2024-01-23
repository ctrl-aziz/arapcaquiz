import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const String successRateFieldName = "success_rate";
  String? uid;

  UserModel.uid(this.uid);

  double? successRate;

  UserModel.data({
    required this.successRate,
  });

  UserModel.fromSnapshot(DocumentSnapshot data){
    successRate = double.tryParse(data.get(successRateFieldName).toString());
  }

  Map<String, dynamic> toJson(){
    return {
      successRateFieldName: successRate,
    };
  }
}