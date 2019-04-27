import 'package:firebase_database/firebase_database.dart';

class Comment {
  String _key;
  String _fullName;
  String _comment;
  String _personId;
  int _timestamp;

  Comment(this._key, this._fullName, this._comment, this._personId,
      this._timestamp);

  int get timestamp => _timestamp;

  String get personId => _personId;

  String get comment => _comment;

  String get fullName => _fullName;

  String get key => _key;

  Comment.fromSnapshot(DataSnapshot snapshot){
    _key=snapshot.key;
    _fullName=snapshot.value['fullName'];
    _comment=snapshot.value['comment'];
    _timestamp=snapshot.value['timestamp'];
  }
}
