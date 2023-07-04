import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gear/Constants/my_functions.dart';
import 'package:gear/Screens/Customer/add_customer.dart';
import 'package:gear/Screens/Customer/vehicle_list.dart';

import '../../Models/customer_model.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
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
      appBar: AppBar(title: const Text("Customer List")),
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
                  callNext(VehicleList( customerModel:  list[index],), context);
                },
                leading: const CircleAvatar(child: Icon(Icons.perm_identity)),
                title: Text(list[index].name),
                subtitle: Text(list[index].number),
                trailing: Text(list[index].vehicleCount),
              ),
            )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          callNext(const AddCustomer(), context);
        },
        label: const Text("Add Customer"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  getCustomer() async {
    mRootReference.child("Customer").onValue.listen((event) {
      Map<dynamic, dynamic> customer = event.snapshot.value as Map;

      list.clear();
      customer.forEach((key, value) {
        print(value);
        print( value["Vehicles"].toString());
        list.add(CustomerModel(
            id: value["Profile"]['Id'],
            name: value["Profile"]['Name'],
            number: value["Profile"]['Phone'],
            createdBy: value["Profile"]['CreatedBy'],
            vehicleCount: value["Vehicles"].toString()=='null'?"0": value["Vehicles"].length.toString(),
            joinDate: value["Profile"]['Date']));
      });
      setState((){});
    });
  }
}
