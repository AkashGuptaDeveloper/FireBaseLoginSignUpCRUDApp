import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/GlobalComponent/GlobalAppColor.dart';
import 'package:firebaseapp/GlobalComponent/GlobalFlag.dart';
import 'package:firebaseapp/SplashScreen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  var Name;
  String id;
  final db = Firestore.instance;
  String name;
  String Description;
  // ignore: non_constant_identifier_names
  TextEditingController NameController = new TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController DescriptionController = new TextEditingController();
  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeDescription = FocusNode();
  GlobalKey<FormState> _key = new GlobalKey();
// ignore: non_constant_identifier_names
  bool _validate = false;

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListTile(
          /*leading:
          CachedNetworkImage(
            imageUrl: StoreImage
                .toString(),
            imageBuilder: (context,
                imageProvider) =>
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration:
                  BoxDecoration(
                    shape: BoxShape
                        .circle,
                    image: DecorationImage(
                        image:
                        imageProvider,
                        fit: BoxFit
                            .cover),
                  ),
                ),
            //placeholder: (context, url) => CircularProgressIndicator(),
            //errorWidget: (context, url, error) => Icon(Icons.error),
          ),*/
          title: Text(
            doc.data['name'],
            style: TextStyle(
              fontSize: 18.0,
              color:
              GlobalAppColor
                  .WhiteColorCode,
            ),
          ),
          subtitle: Text(
            doc.data['Description'],
            overflow: TextOverflow
                .ellipsis,
            style: TextStyle(
                fontFamily: GlobalFlag
                    .FontCode
                    .toString(),
                color:
                GlobalAppColor
                    .WhiteColorCode,
                fontSize: 12,
                fontWeight:
                FontWeight
                    .w300),
          ),
          trailing: Wrap(
            spacing:
            18, // space between two icons
            children: <Widget>[
//----------------------------------------Edit-Category-----------------------//
              new GestureDetector(
                onTap: () {
                  setState(() {
                    /*NameController.text = doc.data['name'];
                    DescriptionController.text = doc.data['Description'];*/
                    updateData(doc);
                  });

                },
                child: Icon(
                    FontAwesomeIcons.userEdit,
                    size: 20,
                    color: Color(0xFFFFFFFF)),
              ), // icon-1
//----------------------------------------Delete-Category---------------------//
              new GestureDetector(
                onTap: () {
                  deleteData(doc);
                },
                child: Icon(
                    FontAwesomeIcons.trashAlt,
                    size: 20,
                    color: Color(0xFFFFFFFF)),
              ), // icon-2
//-----------------------------------------------------------------------------//
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      /*focusNode: myFocusNodeName,*/
      controller: NameController,
      validator: validateName,
      onSaved: (String val) {
        Name = val;
      },
      decoration: new InputDecoration(
        border: new OutlineInputBorder(),
        hintText: GlobalFlag.EnterName.toString(),
        hintStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
          fontFamily: GlobalFlag.FontCode.toString(),
        ),
        labelText: GlobalFlag.EnterName.toString(),
        labelStyle: new TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
          fontFamily: GlobalFlag.FontCode.toString(),
        ),
        prefixIcon: const Icon(
          Icons.account_circle,
        ),
        errorStyle: TextStyle(
            fontSize: 10.0,
            color: GlobalAppColor.AppBarColorCode),
      ),
    );
  }

  TextFormField buildTextDescription() {
    return TextFormField(
      /*focusNode: myFocusNodeDescription,*/
      controller: DescriptionController,
      validator: validateDescription,
      onSaved: (String val) {
        Description = val;
      },
      decoration: new InputDecoration(
        border: new OutlineInputBorder(),
        hintText: GlobalFlag.EnterDescription.toString(),
        hintStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
          fontFamily: GlobalFlag.FontCode.toString(),
        ),
        labelText: GlobalFlag.EnterDescription.toString(),
        labelStyle: new TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
          fontFamily: GlobalFlag.FontCode.toString(),
        ),
        prefixIcon: const Icon(
          Icons.title,
        ),
        errorStyle: TextStyle(
            fontSize: 10.0,
            color: GlobalAppColor.AppBarColorCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                      (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          Form(
            key: _key,
            autovalidate: _validate,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10,),
                Container(
                  padding:EdgeInsets.only(left:15.0,right: 15),
                  child: buildTextFormField(),
                ),
                SizedBox(height: 20,),
                Container(
                  padding:EdgeInsets.only(left:15.0,right: 15),
                  child: buildTextDescription(),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: (){
                  _sendToServer(context);
                },
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
              RaisedButton(
                onPressed: id != null ? readData : null,
                child: Text('Read', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
            ],
          ),
          SizedBox(height:15,),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('CRUD').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.documents.map((doc) => buildItem(doc)).toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  void createData() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      DocumentReference ref = await db.collection('CRUD').add({'name': NameController.text, 'Description': DescriptionController.text});
      setState(() => id = ref.documentID);
      print(ref.documentID);
      NameController.clear();
      DescriptionController.clear();
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();
    print(snapshot.data['name']);
    print(snapshot.data['Description']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db.collection('CRUD').document(doc.documentID).updateData({'Description': DescriptionController.text,'name': NameController.text});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('CRUD').document(doc.documentID).delete();
    setState(() => id = null);
  }

  String randomTodo() {
    final randomNumber = Random().nextInt(4);
    String todo;
    switch (randomNumber) {
      case 1:
        todo = 'Like and subscribe 💩';
        break;
      case 2:
        todo = 'Twitter @robertbrunhage 🤣';
        break;
      case 3:
        todo = 'Patreon in the description 🤗';
        break;
      default:
        todo = 'Leave a comment 🤓';
        break;
    }
    return todo;
  }

//-------------------------------validateCategoryName--------------------------//
  String validateName(String value) {
    String patttern = r'';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Enter Name".toString();
    } else if (!regExp.hasMatch(value)) {
      return "Name Must be need".toString();
    }
    return null;
  }
//-------------------------------validateCategoryName--------------------------//
  String validateDescription(String value) {
    String patttern = r'';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Enter Description".toString();
    } else if (!regExp.hasMatch(value)) {
      return "Description Must be need".toString();
    }
    return null;
  }
//---------------------------------_AddCategorysendToServer-------------------//
  // ignore: non_constant_identifier_names
  _sendToServer(BuildContext context) {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      createData();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}