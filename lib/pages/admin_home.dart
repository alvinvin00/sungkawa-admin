import 'package:Sungkawa/model/person.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:Sungkawa/pages/post_update.dart';
import 'package:Sungkawa/utilities/utilities.dart';
import 'package:Sungkawa/pages/detail.dart';
//import 'package:sung/utilities/firebase_database_util.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final postref = FirebaseDatabase.instance.reference().child('posts');
Utilities util = new Utilities();
//FirebaseDatabaseUtil databaseUtil;

class _HomePageState extends State<HomePage> {
  var nama, umur, lokasi, semayam, keluarga, post;

  List<Person> postlist = new List();

  StreamSubscription<Event> onPostAddedSubscription;
  StreamSubscription<Event> onPostChangedSubscription;
  int timestamp;

  void _onPostAdded(Event event) {
    print('Berita ditampilkan');
    post = new Person.fromsnapShot(event.snapshot);
    setState(() {
      postlist.add(post);
    });
  }

  void _onPostChanged(Event event) {
    print('Berita diupdate');
    post = new Person.fromsnapShot(event.snapshot);
    setState(() {
      postlist.add(post);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postlist.clear();
    onPostAddedSubscription = postref.onChildAdded.listen(_onPostAdded);
    onPostChangedSubscription = postref.onChildChanged.listen(_onPostChanged);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    databaseUtil.dispose();
    onPostAddedSubscription.cancel();
    onPostChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: postlist == null
          ? const Center(
              child: const Text(
                "Data Masih Kosong",
                style: TextStyle(fontSize: 40),
              ),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      Person siperson = postlist[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Detail(siperson)));
                    },
                    onLongPress: () {
                      print('Buka update');
                      Person siperson = postlist[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdatePost(siperson)));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  postlist[index].nama,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Text(
                                  util.convertTimestamp(
                                    postlist[index].timestamp,
                                  ),
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey),
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
                              postlist[index].umur + ' tahun',
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
                              imageUrl: postlist[index].photo,
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
              itemCount: postlist == null ? 0 : postlist.length,
            ),
    );
  }
}
