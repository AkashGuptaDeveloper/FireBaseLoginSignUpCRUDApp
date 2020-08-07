//--------------------------Import-Library------------------------------------//
import 'package:firebaseapp/Login/Login.dart';
import 'package:firebaseapp/SplashScreen/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
final routes = {
  '/Splash': (BuildContext context) => new SplashScreen(),
  '/': (BuildContext context) => new SplashScreen(),
  '/': (BuildContext context) => new SplashScreen(),
  LoginScreen.tag: (context) => LoginScreen(),
};
//-------------------------------END------------------------------------------//
