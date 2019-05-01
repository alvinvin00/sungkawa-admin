import 'package:Sungkawa/model/post.dart';
import 'package:Sungkawa/pages/detail.dart';
import 'package:Sungkawa/pages/post_update.dart';
import 'package:Sungkawa/utilities/crud.dart';
import 'package:Sungkawa/utilities/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Utilities util = new Utilities();
  CRUD crud = new CRUD();

  @override
  void initState() {
    // TODO: implement initState

    crud.getPost().then((results) {
      print(results);
      setState(() {
        _stream = results;
      });
    });

    super.initState();
  }

  var _stream;

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: _stream != null
            ? StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  return snapshot.data != null
                      ? ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            Post post = Post.fromSnapshot(
                                snapshot.data.documents[index]);
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Detail(post)));
                                },
                                onLongPress: () {
                                  print('Buka update');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdatePost(post)));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          top: 10.0,
                                          bottom: 10.0,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              snapshot.data.documents[index]
                                                  .data['nama'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(),
                                            ),
                                            Text(
                                              util.convertTimestamp(snapshot
                                                  .data
                                                  .documents[index]
                                                  .data['timestamp']),
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          bottom: 10.0,
                                        ),
                                        child: Text(
                                          snapshot.data.documents[index]
                                                  .data['umur'].toString() +
                                              ' tahun',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          imageUrl: snapshot.data
                                              .documents[index].data['photo'],
                                          height: 240.0,
                                          width: double.infinity,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Text('No Data');
                },
              )
            : Center(child: CircularProgressIndicator()));
  }
}
