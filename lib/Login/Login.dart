import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:firebaseapp/GlobalComponent/GlobalAppColor.dart';
import 'package:firebaseapp/GlobalComponent/GlobalFlag.dart';
import 'package:firebaseapp/GlobalComponent/GlobalImageAssets.dart';
import 'package:firebaseapp/GlobalComponent/GlobalNavigationRoute.dart';
import 'package:firebaseapp/Home/Home.dart';
import 'package:firebaseapp/Preferences/Preferences.dart';
import 'package:firebaseapp/Signup/Signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
//----------------------------------------Start-------------------------------//
class LoginScreen extends StatefulWidget {
  static String tag = GlobalNavigationRoute.TagLoginScreen.toString();
  @override
  LoginScreenState createState() => new LoginScreenState();
}

//-------------------UserLoginState-------------------------------------------//
class LoginScreenState extends State<LoginScreen> {
  ScrollController _scrollController = new ScrollController();
  // ignore: non_constant_identifier_names
  TextEditingController LoginEmailController = new TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController LoginPasswordController = new TextEditingController();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodePassword = FocusNode();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  // ignore: non_constant_identifier_names
  String Email, Password;
  var loading = true;
  String status = '';
  String errMessage = GlobalFlag.ErrorSendData.toString();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var passKey = GlobalKey<FormFieldState>();
  // ignore: non_constant_identifier_names
  var AppLoginReciveUserID;
  // ignore: non_constant_identifier_names
  var AppLoginReciveUserEmail;
  // ignore: non_constant_identifier_names
  var AppLoginReciveUserFullName;
  bool _obscureTextLogin = true;
  // ignore: non_constant_identifier_names
  var ReciveJsonData;
  // ignore: non_constant_identifier_names
  var ReciveJsonSTATUS;
  // ignore: non_constant_identifier_names
  var ReciveLoginUSERTYPE;
  // ignore: non_constant_identifier_names
  var ExtractJsaonData;
  // ignore: non_constant_identifier_names
  var ReciveJsonSTATUSMSG;
  // ignore: non_constant_identifier_names
  var RecivedPin;
//--------------------------------------_toggleLogin--------------------------//
  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

//--------------------------------------------initState-----------------------//
  @override
  void initState() {
    super.initState();
    this._checkInternetConnectivity();
  }

//-------------------------------------------------_onBackPressed-------------//
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
          GlobalFlag.Areyousure,
          style: TextStyle(
            fontSize: 13.0,
            color: GlobalAppColor.AppBarColorCode,
            fontWeight: FontWeight.bold,
            fontFamily: GlobalFlag.FontCode.toString(),
          ),
        ),
        content: new Text(
          GlobalFlag.exitanApp,
          style: TextStyle(
            fontSize: 13.0,
            color: GlobalAppColor.AppBarColorCode,
            fontWeight: FontWeight.bold,
            fontFamily: GlobalFlag.FontCode.toString(),
          ),
        ),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: roundedButton(
              GlobalFlag.No,
              const Color(0xFF386BC6),
              const Color(0xFFFFFFFF),
            ),
          ),
          new GestureDetector(
            onTap: () => exit(0),
            child: roundedButton(GlobalFlag.Yes, const Color(0xFF386BC6),
                const Color(0xFFFFFFFF)),
          ),
        ],
      ),
    ) ??
        false;
  }

//---------------------------------------roundedButton------------------------//
  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      padding: EdgeInsets.all(5.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFFFFFFFF),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }

//-----------------------------------------------Widget-----------------------//
  @override
  Widget build(BuildContext context) {
//-----------------------------------------Scaffold---------------------------//
    return new WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        key: _scaffoldKey,
        body: new Container(
          child: Center(
            child: new Form(
              key: _key,
              autovalidate: _validate,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  FormName(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.050,
                  ),
                  FormTextField(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  FormBtnLogin(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.020,
                  ),
                  FormBtnSignup(),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

//-----------------------------------------------------FormUI------------------//
  // ignore: non_constant_identifier_names
  Widget FormName() {
    return new Column(
      children: <Widget>[
        Container(
          child: new Container(
            child: Image.asset(GlobalImageAssets.Background,
                height: 120, fit: BoxFit.fill),
          ),
        ),
      ],
    );
  }

//------------------------------------------------FormTextField---------------//
  // ignore: non_constant_identifier_names
  Widget FormTextField() {
    return new Column(
      children: <Widget>[
        Container(
          child: new ListView(
            padding: EdgeInsets.only(left: 18.0, right: 18.0),
            controller: _scrollController,
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 1.0,
              ),
//-------------------------------------------------Email----------------------//
              Theme(
                data: Theme.of(context)
                    .copyWith(splashColor: Colors.transparent),
                child: TextFormField(
                  focusNode: myFocusNodeEmail,
                  controller: LoginEmailController,
                  validator: validateUserName,
                  onSaved: (String val) {
                    Email = val;
                  },
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  autofocus: false,
                  style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf)),
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(),
                    errorStyle: TextStyle(
                        fontSize: 10.0, color: GlobalAppColor.WhiteColorCode),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: GlobalFlag.Email.toString().toUpperCase(),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: GlobalFlag.FontCode.toString(),
                    ),
                    contentPadding: const EdgeInsets.only(
                        right: 42.0, bottom: 8.0, top: 8.0),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
//------------------------------------------------------Password--------------//
              Theme(
                data: Theme.of(context)
                    .copyWith(splashColor: Colors.transparent),
                child: TextFormField(
                  obscureText: _obscureTextLogin,
                  focusNode: myFocusNodePassword,
                  controller: LoginPasswordController,
                  onSaved: (val) => Password = val,
                  textAlign: TextAlign.center,
                  autofocus: false,
                  style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf)),
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(),
                    errorStyle: TextStyle(
                      fontSize: 10.0,
                      color: GlobalAppColor.WhiteColorCode,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText:
                    GlobalFlag.EnterPassword.toString().toUpperCase(),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: GlobalFlag.FontCode.toString(),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 0.0, bottom: 8.0, top: 8.0),
                    suffixIcon: GestureDetector(
                      onTap: _toggleLogin,
                      child: Icon(
                        _obscureTextLogin
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        size: 20.0,
                        color: GlobalAppColor.AppBarColorCode,
                      ),
                    ),
                  ),
                  validator: (password) {
                    var result = password.length < 1
                        ? GlobalFlag.Passwordempty.toString()
                        : null;
                    return result;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//------------------------------------FormBtnLogin----------------------------//
  // ignore: non_constant_identifier_names
  Widget FormBtnLogin() {
    return Container(
        padding: EdgeInsets.only(left: 80.0, right: 80.0),
        child: Row(children: <Widget>[
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          GlobalAppColor.AppbarTextColor,
                          GlobalAppColor.AppbarTextColor
                        ])),
                child: FlatButton(
                  padding: EdgeInsets.all(5.0),
                  splashColor: Colors.white,
                  onPressed: () {
                    _sendToServer();
                  },
                  child: Text(
                    GlobalFlag.Login.toString(),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: GlobalAppColor.WhiteColorCode,
                        fontWeight: FontWeight.bold,
                        fontFamily: GlobalFlag.FontCode.toString()),
                  ),
                )),
          ),
        ]));
  }

//------------------------------------FormBtnLogin----------------------------//
  // ignore: non_constant_identifier_names
  Widget FormBtnSignup() {
    return Container(
        padding: EdgeInsets.only(left: 80.0, right: 80.0),
        child: Row(children: <Widget>[
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          GlobalAppColor.GradiantColor1,
                          GlobalAppColor.GradiantColor2
                        ])),
                child: FlatButton(
                  padding: EdgeInsets.all(5.0),
                  splashColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (_) => new Signup()));
                  },
                  child: Text(
                    GlobalFlag.SIGNUP.toString(),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: GlobalAppColor.WhiteColorCode,
                        fontWeight: FontWeight.bold,
                        fontFamily: GlobalFlag.FontCode.toString()),
                  ),
                )),
          ),
        ]));
  }

//-----------------------------------validateTitle-----------------------------//
  String validateUserName(String value) {
    String patttern = r'';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return GlobalFlag.UserNameisRequired.toString();
    } else if (!regExp.hasMatch(value)) {
      return GlobalFlag.UserNamemustbeNeed.toString();
    }
    return null;
  }

//-------------------------------------------_checkInternetConnectivity-----//
  void _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showDialog(GlobalFlag.NoInternet, GlobalFlag.InternetNotConnected);
    }
  }

//-----------------------------------------AlertDialog------------------------//
  Future<void> _showDialog(title, text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            GlobalFlag.InternetWarning,
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontSize: 15.0,
                color: GlobalAppColor.AppBarColorCode,
                fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  title.toString(),
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: GlobalAppColor.AppBarColorCode,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _dismissDialog();
              },
              child: Text(
                GlobalFlag.Ok,
                style: new TextStyle(
                    fontSize: 15.0,
                    color: GlobalAppColor.AppBarColorCode,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

//---------------------------------------------_dismissDialog-----------------//
  _dismissDialog() {
    Navigator.pop(context);
  }

//----------------------------------------_sendToServer-----------------------//
  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      _checkInternetConnectivity();
      SubmitAccount(context);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  Future<void> SubmitAccount(BuildContext context) async {
    try{
      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: LoginEmailController.text, password: LoginPasswordController.text);
      new Preferences().storeDataAtLogin(user);
      print(user.email);
      print("Done");
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home(user: user)));
    }catch(e){
      print(e.message);
    }
  }
}
//----------------------------------------------------END---------------------//
