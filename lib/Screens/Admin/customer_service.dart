import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gear/Constants/user_preferences.dart';

import '../../Constants/my_functions.dart';
import '../../Models/cart_model.dart';
import '../../Models/service_history_model.dart';
import '../service_counter_edit.dart';

class CustomerServices extends StatefulWidget {
  const CustomerServices({Key? key}) : super(key: key);

  @override
  State<CustomerServices> createState() => _CustomerServicesState();
}

class _CustomerServicesState extends State<CustomerServices> {
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
    mRootReference.child("Customer").child(await getString(UserPreferences.USER_NUMBER)).child('Services').onValue.listen((event1) {
   if (event1.snapshot.exists) {
     Map<dynamic, dynamic> value = event1.snapshot.value as Map;
     value.forEach((key,val){
       mRootReference
           .child("Services")
           .child(val.toString())
           .onValue
           .listen((event) {
         if (event.snapshot.exists) {
           Map<dynamic, dynamic> value = event.snapshot.value as Map;
           list.clear();
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
               status: value['Status'] ?? "PENDING",
               cart: items));
           setState(() {
             isLoading = false;
           });
         }
         else {
           setState(() {
             isLoading = false;
           });
         }
       });
     });

    }else {
      setState(() {
        isLoading = false;
      });
    }
    });

  }
}
