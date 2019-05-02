import 'package:Sungkawa/model/post.dart';
import 'package:Sungkawa/utilities/crud.dart';
import 'package:Sungkawa/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentPage extends StatefulWidget {
  CommentPage(this.post);

  final Post post;

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var _stream;
  String comment, fullName, userId;
  CRUD crud = new CRUD();
  Utilities util = new Utilities();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Komentar'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: Container(child: buildCommentPage())),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              title: TextField(
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
    print(widget.post.key);
    if (_stream != null) {
      return StreamBuilder<QuerySnapshot>(
          stream: crud.getComment(widget.post.key).snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemBuilder: (context, index) {
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Text(snapshot.data.documents[index].data['fullName']),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text(util.convertTimestamp(
                          snapshot.data.documents[index].data['timestamp']))
                    ],
                  ),
                  subtitle:
                      Text(snapshot.data.documents[index].data['comment']),
                );
              },
              itemCount: snapshot.data.documents.length,
            );
          });
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  void sendComment() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('koment' + comment);
//    prefs = await SharedPreferences.getInstance();
    crud.addComment({
      'fullName': fullName,
      'comment': comment,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': userId,
      'postId': widget.post.key
    });
  }

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString('nama');
    userId = prefs.getString('userId');
  }
}
