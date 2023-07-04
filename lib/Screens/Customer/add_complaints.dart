import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gear/Constants/user_preferences.dart';

import '../../Constants/my_colors.dart';
import '../../Constants/my_functions.dart';

class AddComplaints extends StatefulWidget {
  String customer;
   AddComplaints({Key? key,required this.customer}) : super(key: key);

  @override
  State<AddComplaints> createState() => _AddComplaintsState();
}

class _AddComplaintsState extends State<AddComplaints> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Complaint")),
      body: Form(
        key: formKey,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: title,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Complaint Title',
                hintText: 'Enter Complaint Title',
                filled: true,
                fillColor: myWhite,
              ),
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Complaint Title';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: desc,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Details',
                hintText: 'Details',
                filled: true,
                fillColor: myWhite,
              ),
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Details';
                }
                return null;
              },
            ),
          ),

          MaterialButton(onPressed: () async{
            await addComplaint().then((value) {
              ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  "Successful",
                  style: TextStyle(color: Colors.black),
                ),
              ));
              finish(context);
            });
          },child: const Text("Submit"),  color: primaryColor,
            minWidth: double.infinity,),
        ],),
      ),
    );
  }
  Future<void> addComplaint()async {
    HashMap<String,dynamic>data=HashMap<String,dynamic>();
    String id="COM${DateTime.now().millisecondsSinceEpoch.toString()}";
    data["id"]=id;
    data["Title"]=title.text;
    data["description"]=desc.text;
    data["Customer"]=widget.customer.toString();
    data["Date"]=DateTime.now().toString();
    data["CustomerName"]=await getString(UserPreferences.USER_Name);
    data["DateMillisecondsSinceEpoch"]=DateTime.now().millisecondsSinceEpoch.toString();
    await mRootReference.child("Complaints").child(id).update(data);
    await mRootReference.child("Customer").child(widget.customer).child("Complaint").child(id).set(id);
  }
}
