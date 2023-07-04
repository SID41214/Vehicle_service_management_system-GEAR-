
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

   static const String IS_LOGIN = "IS_LOGIN";
   static const String ACCESS_CODE = "ACCESS_CODE";
   static const String USER_NUMBER = "USER_NUMBER";
   static const String USER_Name = "USER_Name";
   static const String USER_TYPE = "USER_TYPE";
   static const String NAME = "NAME";
   static const String CODE = "CODE";

}
setString(String key,String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}
setInt(String key,int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}
setDouble(String key,double value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(key, value);
}setBool(String key,bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

getString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString(key);
  return stringValue;
}
getInt(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? stringValue = prefs.getInt(key);
  return stringValue;
}
getBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? stringValue = prefs.getBool(key);
  return stringValue??false;
}
getDouble(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double? stringValue = prefs.getDouble(key);
  return stringValue;
}

clearUserData(){
  // setString(UserPreferences.USER_NAME, "");
  // setBool(UserPreferences.IS_IP_SET, false);
  // setBool(UserPreferences.IS_LOGIN, false);
}