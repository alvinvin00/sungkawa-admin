import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String _key;
  String _fullName;
  String _comment;
  String _postId;

  int _timestamp;

  Comment(
      this._key, this._fullName, this._comment, this._postId, this._timestamp);

  int get timestamp => _timestamp;

  String get postId => _postId;

  String get comment => _comment;

  String get fullName => _fullName;

  String get key => _key;

  Comment.fromSnapshot(DocumentSnapshot snapshot) {
    _key = snapshot.documentID;
    _fullName = snapshot.data['fullName'];
    _comment = snapshot.data['comment'];
    _timestamp = snapshot.data['timestamp'];
    _postId = snapshot.data['postId'];
  }
}
