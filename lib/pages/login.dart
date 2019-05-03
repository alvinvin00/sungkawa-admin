import 'dart:async';

import 'package:Sungkawa/main.dart';
import 'package:Sungkawa/utilities/crud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  CRUD crud = new CRUD();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
//                  login();
                  handleSignIn();
                }),
            new Padding(padding: const EdgeInsets.all(10.0)),
          ],
        ),
      ),
    );
  }

  Future handleSignIn() async {
    prefs = await SharedPreferences.getInstance();
    googleSignIn.signIn().whenComplete(() {
      GoogleSignInAccount user = googleSignIn.currentUser;
      var adminRef = FirebaseDatabase.instance
          .reference()
          .child('admins')
          .orderByChild(user.id)
          .once();
      print('Admin Ref : ${adminRef.toString()}');
      if (adminRef == null) {
        crud.addAdmin(user.id, {'nama': user.displayName, 'email': user.email});
      }
      prefs.setString('userId', user.id);
      prefs.setString('nama', user.displayName);
      prefs.setString('email', user.email);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    });
  }
}
