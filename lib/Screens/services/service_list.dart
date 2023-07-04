import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gear/Screens/services/add_service.dart';

import '../../Constants/my_functions.dart';
import '../../Models/services_model.dart';

class ServicesList extends StatefulWidget {
  const ServicesList({Key? key}) : super(key: key);

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<ServicesModel> list = [];

  @override
  initState() {
    getService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Items")),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  callNext(AddServices(item: list[index],isEdit: true,), context);
                },
                leading: const CircleAvatar(child: Icon(Icons.settings_suggest)),
                title: Text(list[index].name),
                subtitle: Text(list[index].description),
                trailing: Text(list[index].rate),
              ),
            )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          callNext(AddServices(item: ServicesModel(id: '',name: '',rate: '',description: '',model: ''),), context);
        },
        label: const Text("Add Service Item"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  getService() async {
    mRootReference.child("ServicesItem").onValue.listen((event) {
      Map<dynamic, dynamic> customer = event.snapshot.value as Map;
      list.clear();
      customer.forEach((key, value) {
        list.add(ServicesModel(
          id: value['Id'],
          rate: value['Rate'],
          model: value['Model'],
          name: value['Name'],
          description: value['Description'],
        ));
      });
      setState(() {});
    });
  }
}
