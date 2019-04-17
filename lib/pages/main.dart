import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Sungkawa/pages/about.dart';
import 'package:Sungkawa/pages/post_add.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Sungkawa/pages/admin_home.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

enum Pilihan { about, signOut }

final GoogleSignIn googleSignIn = GoogleSignIn();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sungkawa',
      theme: new ThemeData(
          primarySwatch: Colors.blueGrey,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          })),
      home: new SplashScreen(
        seconds: 1,
        title: Text('Sungkawa'),
        image: Image.asset(
          'assets/images/logo_mdp.png',
          fit: BoxFit.cover,
          width: 280,
        ),
        navigateAfterSeconds: DashboardScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

enum AuthStatus { signedIn, notSignedIn }

class _DashboardScreenState extends State<DashboardScreen> {
  AuthStatus _authStatus;
  var connectionStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
    getCurrentUser().then((userId) {
      setState(() {
        _authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  Future<String> getCurrentUser() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      return user.uid;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return new Login();
        break;
      case AuthStatus.signedIn:
        return buildHomeScreen(context);
        break;
    }
  }

  Scaffold buildHomeScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Sungkawa',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: selectedAction,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Pilihan>>[
                    const PopupMenuItem(
                      child: Text('Tentang Kami'),
                      value: Pilihan.about,
                    ),
                    const PopupMenuItem(
                      child: Text('SignOut'),
                      value: Pilihan.signOut,
                    )
                  ])
        ],
        backgroundColor: Colors.grey,
      ),
      body: HomePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostAdd()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[500],
      ),
    );
  }

  void selectedAction(Pilihan value) {
    print('You choose : $value');
    if (value == Pilihan.about) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => About()));
    }
    if (value == Pilihan.signOut) {
      signOut();
    }
  }

  void signOut() async {
    FirebaseAuth.instance.signOut();
    googleSignIn.signOut();
    _authStatus = AuthStatus.notSignedIn;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  void checkConnectivity() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        print('Connectivity Result: $connectivityResult');
        connectionStatus = true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        print('Connectivity Result: $connectivityResult');
        connectionStatus = true;
      } else {
        print('Connectivity Result: not connected');
        connectionStatus = false;
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
