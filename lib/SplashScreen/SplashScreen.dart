import 'dart:async';
import 'package:firebaseapp/GlobalComponent/GlobalAppColor.dart';
import 'package:firebaseapp/GlobalComponent/GlobalImageAssets.dart';
import 'package:firebaseapp/GlobalComponent/GlobalNavigationRoute.dart';
import 'package:firebaseapp/Home/Home.dart';
import 'package:firebaseapp/Login/Login.dart';
import 'package:firebaseapp/Signup/Signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//------------------------------------START-----------------------------------//
class SplashScreen extends StatefulWidget {
  static String tag = GlobalNavigationRoute.TagSplashScreen.toString();
  const SplashScreen({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  SplashScreenState createState() => new SplashScreenState();
}
//-----------------------------------SplashScreenState------------------------//
class SplashScreenState extends State<SplashScreen> {
//-----------------------------------handleTimeout----------------------------//
  Future<FirebaseUser> _handleSignIn() async {
    FirebaseAuth.instance.currentUser().then((currentUser) {
      if (currentUser == null) {
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (_) => new LoginScreen()));
      } else {
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (_) => new Home()));
      }
    });
  }
//-----------------------------------startTimeout-----------------------------//
  startTimeout() async {
    var duration = const Duration(seconds: 4);
    return new Timer(duration, _handleSignIn);
  }
//-----------------------------------initState--------------------------------//
  @override
  void initState() {
    super.initState();
    startTimeout();
  }
//-----------------------------------------dispose()---------------------------//
  @override
  void dispose() {
    super.dispose();
    startTimeout();
  }
//------------------------------------Widget build----------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: new Form(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                FormLogo(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.060,
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: GlobalAppColor.WhiteColorCode,
    );
  }
//-----------------------------------------------------FormLogo---------------//
  // ignore: non_constant_identifier_names
  Widget FormLogo() {
    return new Column(
      children: <Widget>[
        new Container(
          child: new Container(
            child: Image.asset(GlobalImageAssets.Background,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.fill),
          ),
        ),
      ],
    );
  }
}
//---------------------------------------END----------------------------------//
