import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Constants/my_colors.dart';
import '../../Constants/my_functions.dart';
import '../../Constants/user_preferences.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({Key? key}) : super(key: key);

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
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
            onPressed: () async{
              await addStaff().then((value) {
                ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                  backgroundColor: Colors.white,
                  content: Text(
                    "Successful",
                    style: TextStyle(color: Colors.black),
                  ),
                ));
                finish(context);
              });

            },child: const Text("Submit"),),
        ],
      ),
    );
  }
  Future<void> addStaff()async {
    HashMap<String,dynamic>data=HashMap<String,dynamic>();
    String id="+91${number.text}";
    data["Id"]=id;
    data["Name"]=name.text;
    data["Phone"]=id;
    data["CreatedBy"]=await getString(UserPreferences.USER_NUMBER);
    data["Date"]=DateTime.now().toString();
    data["AcessCode"]='2';
    data  ["AcessName"]='Staff';
    data["DateMillisecondsSinceEpoch"]=DateTime.now().millisecondsSinceEpoch.toString();

    HashMap<String,dynamic>access=HashMap<String,dynamic>();
    access["Name"]=name.text;
    access["Phone"]=id;
    access["AcessCode"]='2';
    access["AcessName"]='Customer';
    await mRootReference.child("Staff").child(id).child("Profile").update(data);
    await mRootReference.child("AccessControl").child(id).update(access);
  }
}
