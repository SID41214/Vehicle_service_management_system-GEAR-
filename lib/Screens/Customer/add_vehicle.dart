import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gear/Constants/my_functions.dart';
import '../../Constants/my_colors.dart';

class AddVehicle extends StatefulWidget {
  String customer;
   AddVehicle({Key? key,required this.customer}) : super(key: key);

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  TextEditingController vehicleNumber = TextEditingController();
  TextEditingController vehicleType = TextEditingController();
  TextEditingController vehicleModel = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add vehicle")),
      body: Form(
        key: formKey,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: vehicleNumber,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Vehicle Number',
                hintText: 'Enter Vehicle Number',
                filled: true,
                fillColor: myWhite,
              ),
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Vehicle Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: vehicleType,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Vehicle Type',
                hintText: 'eg: Dio',
                filled: true,
                fillColor: myWhite,
              ),
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Vehicle Type';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: vehicleModel,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Model Year',
                hintText: 'eg: 2019',
                filled: true,
                fillColor: myWhite,
              ),
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Model Year';
                }
                return null;
              },
            ),
          ),
          MaterialButton(onPressed: () async{
           await addVehicle().then((value) {
             ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
               backgroundColor: Colors.white,
               content: Text(
                 "Successfully Add Vehicle",
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
 Future<void> addVehicle()async {
    HashMap<String,dynamic>data=HashMap<String,dynamic>();
    data["VehicleNumber"]=vehicleNumber.text;
    data["VehicleType"]=vehicleType.text;
    data["VehicleModel"]=vehicleModel.text.toString();
    data["OwnerId"]=widget.customer.toString();
   await mRootReference.child("Vehicles").child(vehicleNumber.text).update(data);
   await mRootReference.child("Customer").child(widget.customer).child("Vehicles").child(vehicleNumber.text).set(vehicleNumber.text);
  }
}
