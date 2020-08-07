import 'package:firebaseapp/GlobalComponent/GlobalAppColor.dart';
import 'package:firebaseapp/GlobalComponent/GlobalFlag.dart';
import 'package:firebaseapp/GlobalComponent/GlobalNavigationRoute.dart';
import 'package:firebaseapp/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';

//----------------------------------------------------------------------------//
class Signup extends StatefulWidget {
  static String tag = GlobalNavigationRoute.TagSignup.toString();
  @override
  _SignupState createState() => _SignupState();
}

//----------------------------------------------------------------------------//
class _SignupState extends State<Signup> {
  File _image;
  // ignore: non_constant_identifier_names
  TextEditingController SignupEmailController = new TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController SignupPasswordController = new TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController SignupConfirmPasswordController =
      new TextEditingController();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodePassword = FocusNode();
  GlobalKey<FormState> Key = new GlobalKey();
  var passKey = GlobalKey<FormFieldState>();
  bool _obscureTextConfirmLogin = true;
  bool _validate = false;
  String Email,
      // ignore: non_constant_identifier_names
      Password,
      // ignore: non_constant_identifier_names
      ConfirmPassword;
  bool _obscureTextLogin = true;
//--------------------------------------_toggleLogin--------------------------//
  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

//----------------------------------------------------------------------------//
  void _toggleLoginConfirm() {
    setState(() {
      _obscureTextConfirmLogin = !_obscureTextConfirmLogin;
    });
  }
//----------------------------------------------------------------------------//
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }
//----------------------------------------------------------------------------//
  Future uploadPic(BuildContext context) async{
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }
//----------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => Container(
          child: Form(
            key: Key,
            autovalidate: _validate,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Color(0xff476cfb),
                        child: ClipOval(
                          child: new SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image != null)
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.camera,
                          size: 30.0,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: new TextFormField(
                    focusNode: myFocusNodeEmail,
                    controller: SignupEmailController,
                    validator: validateEmail,
                    onSaved: (String val) {
                      Email = val;
                    },
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(),
                      hintText: GlobalFlag.EnterEmail.toString(),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: GlobalFlag.FontCode.toString(),
                      ),
                      labelText: GlobalFlag.EnterEmail.toString(),
                      labelStyle: new TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: GlobalFlag.FontCode.toString(),
                      ),
                      prefixIcon: const Icon(
                        Icons.email,
                      ),
                      errorStyle: TextStyle(
                          fontSize: 10.0,
                          color: GlobalAppColor.AppBarColorCode),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: new TextFormField(
                    obscureText: _obscureTextLogin,
                    focusNode: myFocusNodePassword,
                    controller: SignupPasswordController,
                    onSaved: (val) => Password = val,
                    key: passKey,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: GlobalAppColor.AppIcon),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: GlobalAppColor.AppIcon),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: GlobalAppColor.AppBarColorCode)),
                      hintText: GlobalFlag.EnterPassword,
                      hintStyle: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Raleway'),
                      labelText: GlobalFlag.EnterPassword,
                      labelStyle: new TextStyle(
                          color: GlobalAppColor.AppIcon,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Raleway'),
                      prefixIcon: Icon(
                        FontAwesomeIcons.lock,
                        color: GlobalAppColor.AppIcon,
                        size: 20,
                      ),
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
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: new TextFormField(
                    obscureText: _obscureTextConfirmLogin,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: GlobalAppColor.AppIcon),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: GlobalAppColor.AppIcon),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: GlobalAppColor.AppBarColorCode)),
                      hintText: GlobalFlag.RepeatPassword,
                      hintStyle: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Raleway'),
                      labelText: GlobalFlag.RepeatPassword,
                      labelStyle: new TextStyle(
                          color: GlobalAppColor.AppIcon,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Raleway'),
                      prefixIcon: Icon(
                        FontAwesomeIcons.key,
                        color: GlobalAppColor.AppIcon,
                        size: 20,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: _toggleLoginConfirm,
                        child: Icon(
                          _obscureTextConfirmLogin
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          size: 20.0,
                          color: GlobalAppColor.AppBarColorCode,
                        ),
                      ),
                    ),
                    validator: (confirmation) {
                      if (confirmation != passKey.currentState.value) {
                        return GlobalFlag.Passwordsnotmatch.toString();
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: Color(0xff476cfb),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    RaisedButton(
                      color: Color(0xff476cfb),
                      onPressed: () {
                        _sendToServer(context);
                      },
                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//-----------------_sendToServer----------------------------------------------//
  _sendToServer(BuildContext context) async {
    if (Key.currentState.validate()) {
      Key.currentState.save();
      if (_image != null) {
        uploadPic(context);
      } else {
        try{
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: SignupEmailController.text, password: SignupPasswordController.text);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          print(SignupEmailController.text);
          print(SignupPasswordController.text);
          print("Done");
          uploadPic(context);
        }catch(e){
          print(e.message);
        }
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
//--------------------------validateAdminEmployeEmail-------------------------//
  String validateEmail(String value) {
    String pattern = GlobalFlag.PattternEmail.toString();
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return GlobalFlag.EmailRequired.toString();
    } else if (!regExp.hasMatch(value)) {
      return GlobalFlag.InvalidEmail.toString();
    } else {
      return null;
    }
  }
}
//----------------------------------------------------------------------------//
