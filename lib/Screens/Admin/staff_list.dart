import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../Constants/my_functions.dart';
import '../../Models/customer_model.dart';
import 'add_staff.dart';

class StaffList extends StatefulWidget {
  const StaffList({Key? key}) : super(key: key);

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<CustomerModel> list = [];
  @override
  initState(){
    getCustomer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Staff List")),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: (){
                    },
                    leading: const CircleAvatar(child: Icon(Icons.perm_identity)),
                    title: Text(list[index].name),
                    subtitle: Text(list[index].number),

                  ),
                )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          callNext(const AddStaff(), context);
        },
        label: const Text("Add Staff"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  getCustomer() async {
    mRootReference.child("Staff").onValue.listen((event) {
      Map<dynamic, dynamic> customer = event.snapshot.value as Map;
      list.clear();
      customer.forEach((key, value) {
        print(value);
        list.add(CustomerModel(
            id: value["Profile"]['Id'],
            name: value["Profile"]['Name'],
            number: value["Profile"]['Phone'],
            createdBy: value["Profile"]['CreatedBy'],
            vehicleCount:'0',
            joinDate: value["Profile"]['Date']));
      });
      setState((){});
    });
  }
}
