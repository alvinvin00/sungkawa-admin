import 'dart:async';

import 'package:Sungkawa/model/comment.dart';
import 'package:Sungkawa/model/post.dart';
import 'package:Sungkawa/utilities/crud.dart';
import 'package:Sungkawa/utilities/utilities.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentPage extends StatefulWidget {
  CommentPage(this.post);

  final Post post;

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String comment, fullName, userId;
  CRUD crud = new CRUD();
  Utilities util = new Utilities();
  var _commentRef;
  final commentController = new TextEditingController();
  SharedPreferences prefs;
  List<Comment> _commentList = new List();
  StreamSubscription<Event> _onCommentAddedSubscription;
  StreamSubscription<Event> _onCommentChangedSubscription;

  _onCommentAdded(Event event) {
    setState(() {
      _commentList.add(Comment.fromSnapshot(event.snapshot));
    });
  }

  _onCommentChanged(Event event) {
    var oldEntry = _commentList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _commentList[_commentList.indexOf(oldEntry)] =
          Comment.fromSnapshot(event.snapshot);
    });
  }

  @override
  void initState() {
    super.initState();
    _commentRef = FirebaseDatabase.instance
        .reference()
        .child('comments')
        .child(widget.post.key)
        .orderByChild('timestamp');
    readLocal();
    _commentList.clear();
    _onCommentAddedSubscription =
        _commentRef.onChildAdded.listen(_onCommentAdded);
    _onCommentChangedSubscription =
        _commentRef.onChildChanged.listen(_onCommentChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _commentList.clear();
    _onCommentAddedSubscription.cancel();
    _onCommentChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Komentar'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Container(child: buildCommentPage())),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              title: TextField(
                controller: commentController,
                onChanged: (value) => comment = value,
                decoration:
                    InputDecoration(hintText: 'Tuliskan Komentarmu disini'),
              ),
              trailing:
                  IconButton(icon: Icon(Icons.send), onPressed: sendComment),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCommentPage() {
    if (_commentList.length != 0) {
      return ListView.builder(
          itemCount: _commentList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                _commentList[index].fullName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing:
                  Text(util.convertTimestamp(_commentList[index].timestamp)),
              subtitle: Text(_commentList[index].comment),
            );
          });
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  void sendComment() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('koment' + comment);
    prefs = await SharedPreferences.getInstance();
    crud.addComment(widget.post.key, {
      'fullName': fullName,
      'comment': comment,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': userId,
    });
  }

  void readLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString('nama');
    userId = prefs.getString('userId');
  }
}
