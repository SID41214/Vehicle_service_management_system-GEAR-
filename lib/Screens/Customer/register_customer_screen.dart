import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Constants/my_colors.dart';
import '../../Constants/my_functions.dart';
import '../../Constants/user_preferences.dart';
import '../Admin/admin_home_screen.dart';
import '../Staff/staff_home_screen.dart';
import 'customer_home_screen.dart';

class RegisterCustomerScreen extends StatefulWidget {
  String number;

  RegisterCustomerScreen({Key? key, required this.number}) : super(key: key);

  @override
  State<RegisterCustomerScreen> createState() => _RegisterCustomerScreenState();
}

class _RegisterCustomerScreenState extends State<RegisterCustomerScreen> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  @override
  initState() {
    number = TextEditingController(text: widget.number);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Customer")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: name,
              inputFormatters: [
                // FilteringTextInputFormatter.allow(RegExp('[0-9]'))
              ],
              // controller: value.contactPerson,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                hintText: 'Name',
                filled: true,
                fillColor: myWhite,
              ),
              autofocus: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              enabled: false,
              controller: number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]'))
              ],
              // controller: value.contactPerson,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contact Number',
                hintText: 'Enter Contact Number',
                filled: true,
                fillColor: myWhite,
              ),
              autofocus: false,
            ),
          ),
          MaterialButton(
            color: primaryColor,
            minWidth: double.infinity,
            onPressed: () async {
              await addCustomer().then((value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.white,
                  content: Text(
                    "Successful",
                    style: TextStyle(color: Colors.black),
                  ),
                ));
                finish(context);
              });
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  Future<void> addCustomer() async {
    HashMap<String, dynamic> data = HashMap<String, dynamic>();
    String id = widget.number;
    data["Id"] = id;
    data["Name"] = name.text;
    data["Phone"] = id;
    data["CreatedBy"] = widget.number;
    data["Date"] = DateTime.now().toString();
    data["AcessCode"] = '1';
    data["AcessName"] = 'Customer';
    data["DateMillisecondsSinceEpoch"] =
        DateTime.now().millisecondsSinceEpoch.toString();

    HashMap<String, dynamic> access = HashMap<String, dynamic>();
    access["Name"] = name.text;
    access["Phone"] = id;
    access["AcessCode"] = '1';
    access["AcessName"] = 'Customer';
    await mRootReference
        .child("Customer")
        .child(id)
        .child("Profile")
        .update(data);
    await mRootReference.child("AccessControl").child(id).update(access);
    checkAuth(widget.number);
  }

  checkAuth(String loginPh) {
    mRootReference
        .child('AccessControl')
        .child(loginPh)
        .once()
        .then((dataSnapshot) {
      if (dataSnapshot.snapshot.exists) {
        Map<dynamic, dynamic> loginData = dataSnapshot.snapshot.value as Map;
        if (loginData["AcessCode"].toString() == "1") {
          setBool(UserPreferences.IS_LOGIN, true);
          setString(
              UserPreferences.ACCESS_CODE, loginData["AcessCode"].toString());
          setString(UserPreferences.USER_NUMBER,
              dataSnapshot.snapshot.key.toString());
          setString(UserPreferences.USER_Name, loginData["Name"].toString());
          setString(
              UserPreferences.USER_TYPE, loginData["AcessName"].toString());
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              "Login Successfully",
              style: TextStyle(color: Colors.black),
            ),
          ));
          Future.delayed(const Duration(milliseconds: 1000), () {
            finishAccountCreation(const CustomerHomeScreen(), context);
          });
        } else if (loginData["AcessCode"].toString() == "2") {
          setBool(UserPreferences.IS_LOGIN, true);
          setString(
              UserPreferences.ACCESS_CODE, loginData["AcessCode"].toString());
          setString(UserPreferences.USER_NUMBER,
              dataSnapshot.snapshot.key.toString());
          setString(UserPreferences.USER_Name, loginData["Name"].toString());
          setString(
              UserPreferences.USER_TYPE, loginData["AcessName"].toString());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              "Welcome back ${loginData["Name"].toString()}",
              style: const TextStyle(color: Colors.black),
            ),
          ));
          Future.delayed(const Duration(milliseconds: 1000), () {
            finishAccountCreation(const StaffHomeScreen(), context);
          });
        } else if (loginData["AcessCode"].toString() == "3") {
          setBool(UserPreferences.IS_LOGIN, true);
          setString(
              UserPreferences.ACCESS_CODE, loginData["AcessCode"].toString());
          setString(UserPreferences.USER_NUMBER,
              dataSnapshot.snapshot.key.toString());
          setString(UserPreferences.USER_Name, loginData["Name"].toString());
          setString(
              UserPreferences.USER_TYPE, loginData["AcessName"].toString());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              "Welcome back ${loginData["Name"].toString()}",
              style: const TextStyle(color: Colors.black),
            ),
          ));
          Future.delayed(const Duration(milliseconds: 1000), () {
            finishAccountCreation(const AdminHomeScreen(), context);
          });
        }
      } else {}
    });
  }
}
