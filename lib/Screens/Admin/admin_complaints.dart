import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gear/Constants/my_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/complaint_model.dart';

class AdminComplaints extends StatefulWidget {
  const AdminComplaints({Key? key}) : super(key: key);

  @override
  State<AdminComplaints> createState() => _AdminComplaintsState();
}

class _AdminComplaintsState extends State<AdminComplaints> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<ComplaintsModel> list = [];

  @override
  initState() {
    getComplaints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services Complaints"),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const CircleAvatar(
                    child: Icon(Icons.directions_car_filled_outlined)),
                title: Text(list[index].title),
                subtitle: Text(list[index].customerName),
                trailing: IconButton(
                  icon: const Icon(Icons.call, color: myGrey),
                  onPressed: () => makePhoneCall(list[index].customer),
                ),
              ),
            )),
          );
        },
      ),
    );
  }
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  getComplaints() async {
    mRootReference.child("Complaints").onValue.listen((event) {
      print("dsflkj ${event.snapshot.value}");
      Map<dynamic, dynamic> complaints = event.snapshot.value as Map;
      list.clear();
      complaints.forEach((key, value) {
        list.add(ComplaintsModel(
            description: value["description"],
            title: value["Title"],
            customer: value["Customer"],
            id: value["id"],
            customerName: value["CustomerName"],
            dateMillisecondsSinceEpoch:
            value["DateMillisecondsSinceEpoch"],
            date: value["Date"]));
        setState((){});
      });
    });
  }
}
