import 'dart:async';

import 'package:Sungkawa/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  FirebaseUser currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser firebaseUser =
        await firebaseAuth.signInWithCredential(credential);
    if (firebaseUser != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection('admins')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      if (documents.length == 0) {
        Firestore.instance
            .collection('admins')
            .document(firebaseUser.uid)
            .setData({
          'nama': firebaseUser.displayName,
          'email': firebaseUser.email,
          'userId': firebaseUser.uid
        });
        currentUser = firebaseUser;

        prefs.setString('userId', currentUser.uid);
        prefs.setString('nama', currentUser.displayName);
        prefs.setString('email', currentUser.email);
      } else {
        prefs.setString('userId', currentUser.uid);
        prefs.setString('nama', currentUser.displayName);
        prefs.setString('email', currentUser.email);
      }
      print({
        prefs.getString('userId'),
        prefs.getString('nama'),
        prefs.getString('email'),
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    } else {
      SnackBar(
        content: Text('Login gagal'),
        duration: Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Text(
              'Sungkawa',
              style: TextStyle(fontSize: 40.0),
              textAlign: TextAlign.center,
            ),
            CupertinoButton(
                child: Text(
                  "Sign In with Google",
                  style: new TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () {
                  handleSignIn();
                }),
            new Padding(padding: const EdgeInsets.all(10.0)),
          ],
        ),
      ),
    );
  }
}
