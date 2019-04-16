import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Sungkawa/model/person.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:Sungkawa/pages/post_update.dart';
import 'package:Sungkawa/utilities/utilities.dart';
import 'package:Sungkawa/pages/detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final postref = FirebaseDatabase.instance.reference().child('posts');
Utilities util = new Utilities();
//FirebaseDatabaseUtil databaseUtil;

class _HomePageState extends State<HomePage> {
  var title;
  var nama, umur, lokasi, semayam, keluarga, post;

  List<Person> postList = new List();
  final GlobalKey<RefreshIndicatorState> _refreshPageKey =
      new GlobalKey<RefreshIndicatorState>();

  StreamSubscription<Event> onPostAddedSubscription;
  StreamSubscription<Event> onPostChangedSubscription;
  int timestamp;

  void _onPostAdded(Event event) {
    print('Berita ditampilkan');
    post = new Person.fromsnapShot(event.snapshot);
    print(post);
    setState(() {
      postList.add(post);
      postList.sort((i, j) => j.timestamp.compareTo(i.timestamp));
    });
  }

  void _onPostChanged(Event event) {
    print('Berita diupdate');
    post = new Person.fromsnapShot(event.snapshot);
    setState(() {
      postList.add(post);
      postList.sort((i, j) => j.timestamp.compareTo(i.timestamp));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postList.clear();
    onPostAddedSubscription = postref.onChildAdded.listen(_onPostAdded);
    onPostChangedSubscription = postref.onChildChanged.listen(_onPostChanged);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    onPostAddedSubscription.cancel();
    onPostChangedSubscription.cancel();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    postList.clear();
    onPostAddedSubscription = postref.onChildAdded.listen(_onPostAdded);
    onPostChangedSubscription = postref.onChildChanged.listen(_onPostChanged);
    postList.sort((i, j) => j.timestamp.compareTo(i.timestamp));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: postList == null
          ? const Center(
              child: const Text(
                "Data Masih Kosong",
                style: TextStyle(fontSize: 40),
              ),
            )
          : ListView.builder(
              itemBuilder: (buildContext, int index) {
                Person person = postList[index];

                return Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Detail(person)));
                    },
                    onLongPress: () {
                      print('Buka update');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdatePost(person)));
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
                                  postList[index].nama,
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
                                    postList[index].timestamp,
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
                              postList[index].usia + ' tahun',
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
                              imageUrl: postList[index].photo,
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
              itemCount: postList == null ? 0 : postList.length,
            ),
    );
  }
}
