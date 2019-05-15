import 'package:firebase_database/firebase_database.dart';

class Comment {
  String _key;
  String _comment;
  String _userId;
  String _userName;
  int _timestamp;

  Comment(this._key, this._comment, this._userId, this._timestamp);

  String get userName => _userName;

  int get timestamp => _timestamp;

  String get userId => _userId;

  String get comment => _comment;

  String get key => _key;

  Comment.fromSnapshot(DataSnapshot snapshot) {
    _key = snapshot.key;
    _comment = snapshot.value['comment'];
    _timestamp = snapshot.value['timestamp'];
    _userId = snapshot.value['userId'];

    FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(userId)
        .once()
        .then((snapshot) {
      _userName = snapshot.value['userName'];
      if (snapshot == null) {
        FirebaseDatabase.instance
            .reference()
            .child('admins')
            .child(userId)
            .once()
            .then((snapshot) {
          _userName = snapshot.value['userName'];
        });
      }
    });
  }
}
