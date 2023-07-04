import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gear/Constants/user_preferences.dart';
import 'package:gear/Screens/splash_screen.dart';
import 'package:intl/intl.dart';
import '/RoutingAnimations/slide_right_route.dart';
final List<TextInputFormatter> decimalValidation = [
  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
  TextInputFormatter.withFunction((oldValue, newValue) {
    try {
      final text = newValue.text;
      if (text.isNotEmpty) {
        double.parse(text);
      }
      return newValue;
    } catch (e) {}
    return oldValue;
  })];

onLoading(var context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: const Center(child: SizedBox(height: 50,width: 50,child: CircularProgressIndicator()),));
      });
}
showAlertDialog(BuildContext context) {

  AlertDialog alert = AlertDialog(
    title: const Text("Logout"),
    content: const Text("Are you sure to logout"),
    actions: [
      TextButton(
        child: const Text("No"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: const Text("Yes"),
        onPressed: () {
          setBool(UserPreferences.IS_LOGIN,false);
          setString(UserPreferences.ACCESS_CODE,"");
          setString(UserPreferences.USER_NUMBER,"");
          setString(UserPreferences.USER_Name,"");
          setString(UserPreferences.USER_TYPE,"");
          finishAccountCreation(const SplashScreen(), context);
        },
      ),

    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
callNext(var className, var context) {
  Navigator.push(context, SlideRightRoute(page: className));
}
callTo(var className, var context) {
  Navigator.pushReplacement(context, SlideRightRoute(page: className));
}
void finishAccountCreation(var className, var context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (BuildContext context) => className),
    ModalRoute.withName('/'),
  );
}
Widget space15 = const SizedBox(
  height: 15,
);
Widget space10 = const SizedBox(
  height: 15,
);
Widget space5 = const SizedBox(
  height: 10,
);

back(var context) {
  Navigator.pop(context);
}

void finish(context) {
  Navigator.pop(context);
}

void hideKeyboard(context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

callNextReplacement(var className, var context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => className),
  );
}

Color hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff' + hex : hex;
  int val = int.parse(hex, radix: 16);
  return Color(val);
}

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

String getDateOnly(String date) {
  var input = DateFormat('MM/dd/yyyy hh:mm:ss aaa').parse(date);
  String output = DateFormat('dd/MM/yyyy').format(input);
  return output;
}

Stream<String> getTime() async* {
  String time;

  time = DateTime.parse("1969-07-20 20:18:04Z") as String;
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    yield time;
  }
}
void showLoaderDialog(BuildContext context){

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => Center(
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child:  const Padding(
          padding: EdgeInsets.all(12.0),

          child: CupertinoActivityIndicator(),
        ),
      ),
    ),
  );

}

