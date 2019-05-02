import 'dart:async';

import 'package:Sungkawa/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sung_user/pages/profil.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  bool isLoading = false;
  bool triedSilentLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    isSignedIn();
  }

//  void isSignedIn() async {
//    this.setState(() {
//      isLoading = true;
//    });
//    prefs = await SharedPreferences.getInstance();
//
//    isLoggedin = await googleSignIn.isSignedIn();
//    if (isLoggedin) {
//      Navigator.pushReplacement(
//          context, MaterialPageRoute(builder: (context) => Profil()));
//    }
//    this.setState(() {
//      isLoading = false;
//    });
//  }

//  Future<Null> handleSignIn() async {
//    prefs = await SharedPreferences.getInstance();
//    this.setState(() {
//      isLoading = true;
//    });
//    GoogleSignInAccount googleUser = await googleSignIn.signIn();
//    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//    FirebaseUser firebaseUser =
//        await firebaseAuth.signInWithCredential(credential);
//    if (firebaseUser != null) {
//      final QuerySnapshot result = await Firestore.instance
//          .collection('users')
//          .where('id', isEqualTo: firebaseUser.uid)
//          .getDocuments();
//      final List<DocumentSnapshot> documents = result.documents;
//
//      if (documents.length == 0) {
//        Firestore.instance
//            .collection('users')
//            .document(firebaseUser.uid)
//            .setData({
//          'nama': firebaseUser.displayName,
//          'email': firebaseUser.email,
//          'userId': firebaseUser.uid
//        });
//        currentUser = firebaseUser;
//
//        await prefs.setString('userId', currentUser.uid);
//        await prefs.setString('nama', currentUser.displayName);
//        await prefs.setString('email', currentUser.email);
//      } else {
//        await prefs.setString('userId', currentUser.uid);
//        await prefs.setString('nama', currentUser.displayName);
//        await prefs.setString('email', currentUser.email);
//      }
//      SnackBar(
//        content: Text('Login berhasil'),
//        duration: Duration(seconds: 2),
//      );
//      this.setState(() {
//        isLoading = false;
//      });
//      Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//              builder: (context) => Profil(currentUserId: firebaseUser.uid)));
//    } else {
//      SnackBar(
//        content: Text('Login gagal'),
//        duration: Duration(seconds: 2),
//      );
//      this.setState(() {
//        isLoading = false;
//      });
//    }
//  }
  void login() async {
    await ensureLoggedIn(context);
    setState(() {
      triedSilentLogin = true;
    });
  }

  void silentLogin(BuildContext context) async {
    await _silentLogin(context);
    setState(() {});
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
                  login();
                }),
            new Padding(padding: const EdgeInsets.all(10.0)),
          ],
        ),
      ),
    );
  }

  Future<Null> ensureLoggedIn(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) {
      user = await googleSignIn.signInSilently();
    }
    if (user == null) {
      await googleSignIn.signIn().then((_) {
        tryCreateUserRecord(context);
      });
    }
    if (await firebaseAuth.currentUser() == null) {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);
    }
  }

  Future<Null> _silentLogin(BuildContext context) async {
    GoogleSignInAccount user = googleSignIn.currentUser;

    if (user == null) {
      user = await googleSignIn.signInSilently().then((_) {
        tryCreateUserRecord(context);
      });
    }

    if (await firebaseAuth.currentUser() == null && user != null) {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);
    }
  }

  tryCreateUserRecord(BuildContext context) async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) {
      return null;
    }
    DocumentSnapshot userRecord =
        await Firestore.instance.collection('users').document(user.id).get();
    if (userRecord.data == null) {
      Firestore.instance.collection('users').document(user.id).setData({
        'userid': user.id,
        'username': user.displayName,
        'email': user.email
      });
      await prefs.setString('userId', user.id);
      await prefs.setString('nama', user.displayName);
      await prefs.setString('email', user.email);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    } else {
      await prefs.setString('userId', user.id);
      await prefs.setString('nama', user.displayName);
      await prefs.setString('email', user.email);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    }
  }
}
