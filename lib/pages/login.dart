import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sung/pages/main.dart';
import 'dart:async';




class Login extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication gSA = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("Signed In " + user.displayName);
    return user;

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Text('Sungkawa', style: TextStyle(fontSize: 40.0), textAlign: TextAlign.center,),

            new RaisedButton(
              onPressed: () {
                _handleSignIn()
                    .then((FirebaseUser user) => print(user))
                    .catchError((e) => print('Error: $e'                                                                                                                                                                                                                                                                                                 ))
                    .whenComplete(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                });
              },
              child: new Text(
                "Sign In with Google",
                style: new TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),

            new Padding(padding: const EdgeInsets.all(10.0)),
          ],
        ),
      ),
    );
  }
}
