//--------------------------Import-Library------------------------------------//
import 'package:firebaseapp/GlobalComponent/GlobalAppColor.dart';
import 'package:firebaseapp/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//---------------------------Create-mainMethod--------------------------------//
void main() => runApp(new MyApp());
Map<int, Color> color = {
  50: Color.fromRGBO(68, 114, 196, .1),
  100: Color.fromRGBO(68, 114, 196, .2),
  200: Color.fromRGBO(68, 114, 196, .3),
  300: Color.fromRGBO(68, 114, 196, .4),
  400: Color.fromRGBO(68, 114, 196, .5),
  500: Color.fromRGBO(68, 114, 196, .6),
  600: Color.fromRGBO(68, 114, 196, .7),
  700: Color.fromRGBO(68, 114, 196, .8),
  800: Color.fromRGBO(68, 114, 196, .9),
  900: Color.fromRGBO(68, 114, 196, 1),
};

//---------------------------------StatelessWidget----------------------------//
class MyApp extends StatelessWidget {
//----------------------------Genrated-Widget build---------------------------//
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: GlobalAppColor.Present));
    MaterialColor colorCustom = MaterialColor(0xFF4472C4, color);
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: colorCustom,
      ),
      debugShowCheckedModeBanner: false,
      routes: routes,
    );
  }
}
//---------------------------END-----------------------------------------------//
