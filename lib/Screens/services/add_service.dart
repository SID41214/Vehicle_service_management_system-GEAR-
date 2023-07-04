import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../Constants/my_colors.dart';
import '../../Constants/my_functions.dart';
import '../../Models/services_model.dart';

class AddServices extends StatefulWidget {
  bool isEdit;
  ServicesModel item;
   AddServices({Key? key,this.isEdit=false,required this.item}) : super(key: key);

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController desc = TextEditingController();
  @override
  initState() {
   if(widget.isEdit){
      name = TextEditingController(text: widget.item.name);
      price = TextEditingController(text: widget.item.rate);
      desc = TextEditingController(text: widget.item.description);
   }else{

   }
    super.initState();
  }


  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Services Item"),
      ),
      body: Form(
        key: formKey,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: name,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Service Name',
                hintText: 'Enter Service Name',
                filled: true,
                fillColor: myWhite,
              ),
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Service Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: price,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Service Price',
                hintText: '20',
                filled: true,
                fillColor: myWhite,
              ),
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Service Price';
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
                labelText: 'Description',
                hintText: 'Description',
                filled: true,
                fillColor: myWhite,
              ),
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Description';
                }
                return null;
              },
            ),
          ),
          MaterialButton(onPressed: () async{
            await addService(widget.isEdit?widget.item.id:DateTime.now().millisecondsSinceEpoch.toString()).then((value) {
              ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  "Successfully Add Services Item",
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
  Future<void> addService(String id)async {
    HashMap<String,dynamic>data=HashMap<String,dynamic>();
    // String id=DateTime.now().millisecondsSinceEpoch.toString();
    data["Id"]=id;
    data["Name"]=name.text;
    data["Rate"]=price.text.toString();
    data["Model"]=price.text.toString();
    data["Description"]=desc.text.toString();
    await mRootReference.child("ServicesItem").child(id).update(data);
  }
}
