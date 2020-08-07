import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  // ignore: non_constant_identifier_names
  static var KEY_USER_ID = "USERID";
  // ignore: non_constant_identifier_names
  static var KEY_MobileNo = "MobileNo";
  // ignore: non_constant_identifier_names
  static var KEY_Name = "Name";
  // ignore: non_constant_identifier_names
  static var KEY_Photo = "Photo";
  // ignore: non_constant_identifier_names
  static var KEY_Email = "Email";
  // ignore: non_constant_identifier_names
  static var KEY_FCM_TOKEN = "FCM_TOKEN";
  // ignore: non_constant_identifier_names
  static var KEY_CREATEDDATE = "CREATEDDATE";

  storeDataAtLogin(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_USER_ID, data["data"][0]["USERID"].toString());
    prefs.setString(KEY_MobileNo, data["data"][0]["MobileNo"].toString());
    prefs.setString(KEY_Name, data["data"][0]["Name"].toString());
    prefs.setString(KEY_Photo, data["data"][0]["Photo"].toString());
    prefs.setString(KEY_Email, data["data"][0]["Email"].toString());
    prefs.setString(KEY_FCM_TOKEN, data["data"][0]["FCM_TOKEN"].toString());
    prefs.setString(KEY_CREATEDDATE, data["data"][0]["CREATEDDATE"].toString());

    print("KEY_USER_ID" + data["data"][0]["USERID"].toString());
    print("KEY_MobileNo" + data["data"][0]["MobileNo"].toString());
    print("KEY_Name" + data["data"][0]["Name"].toString());
    print("KEY_Photo" + data["data"][0]["Photo"].toString());
    print("KEY_Email" + data["data"][0]["Email"].toString());
    print("KEY_FCM_TOKEN" + data["data"][0]["FCM_TOKEN"].toString());
    print("KEY_CREATEDDATE" + data["data"][0]["CREATEDDATE"].toString());
  }
}
