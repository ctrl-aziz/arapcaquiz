import 'package:cloud_firestore/cloud_firestore.dart';

class WordModel {
  static const String ARABIC = "arabic", TURKISH = "turkish", LEVEL = "level", CREATED_AT = "created_at";
  static const String USERS = "users", ID = "id";

  String? id;
  String? arabic;
  String? turkish;
  String? level;
  Timestamp? createdAt;
  List<String>? users;

  WordModel({
    required this.id,
    required this.arabic,
    required this.turkish,
    required this.level,
    required this.users,
    required this.createdAt,
  });

  WordModel.updateUsers({
    required this.users,
  });

  WordModel.fromSnapshot(DocumentSnapshot snapshot){
    id = snapshot.id;
    arabic = snapshot.get(ARABIC);
    turkish = snapshot.get(TURKISH);
    level = snapshot.get(LEVEL);
    users = List.from(snapshot.get(USERS));
    createdAt = snapshot.get(CREATED_AT);
  }

  Map<String, dynamic> toJson(){
    return {
      ID: id,
      TURKISH: turkish,
      LEVEL: level,
      USERS: users,
      CREATED_AT: createdAt,
    };
  }

  Map<String, dynamic> userToJson(){
    return {
      USERS: FieldValue.arrayUnion(users!),
    };
  }
}