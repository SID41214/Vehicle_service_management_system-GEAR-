import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gear/Constants/my_functions.dart';

import '../../Models/cart_model.dart';
import '../../Models/service_history_model.dart';
import '../service_counter_edit.dart';

class ServicesHistory extends StatefulWidget {
  String customer;

  ServicesHistory({Key? key, required this.customer}) : super(key: key);

  @override
  State<ServicesHistory> createState() => _ServicesHistoryState();
}

class _ServicesHistoryState extends State<ServicesHistory> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<ServicesHistoryModel> list = [];
  bool isLoading = true;

  @override
  initState() {
    getServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services History"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : list.isNotEmpty
              ? ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            callNext(
                                ServiceCounterEdit(
                                  id: list[index].id,
                                ),
                                context);
                          },
                          leading: const CircleAvatar(
                              child:
                                  Icon(Icons.directions_car_filled_outlined)),
                          title: Text(list[index].status),
                          subtitle: Text(list[index].vehicleId),
                          trailing: Text(list[index].grandTotal),
                        ),
                      )),
                    );
                  },
                )
              : const Center(
                  child: Text("No Data"),
                ),
    );
  }

  getServices() async {
    isLoading = true;
    mRootReference.child("Services").onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> services = event.snapshot.value as Map;
        list.clear();
        services.forEach((key, value) {
          List<CartModel> items = [];

          list.add(ServicesHistoryModel(
              id: value['Id'],
              createdBy: value['createdBy'],
              createdTime: value['createdBy'],
              total: value['createdTime'],
              discount: value['Discount'],
              grandTotal: value['GrandTotal'],
              vehicleId: value['vehicleId'],
              customerId: value['CustomerId'],
              customerName: value['CustomerName'],
              status: value['Status'] != null ? value['Status'] : "PENDING",
              cart: items));
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }
}
