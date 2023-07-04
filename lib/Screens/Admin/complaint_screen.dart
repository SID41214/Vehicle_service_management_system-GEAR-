import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../Constants/my_functions.dart';
import '../../Models/complaint_model.dart';
import '../Customer/add_complaints.dart';

class ComplaintScreen extends StatefulWidget {
  String customer;
   ComplaintScreen({Key? key,required this.customer}) : super(key: key);

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<ComplaintsModel> list=[];
  @override
  initState(){
    getComplaints();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Services Complaints"),),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.directions_car_filled_outlined)),
                    title: Text(list[index].title),
                    subtitle: Text(list[index].title),
                    trailing: Text(list[index].date.substring(0,10)),
                  ),
                )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          callNext( AddComplaints(customer:widget.customer,), context);
        },
        label: const Text("Add Complaint"),
        icon: const Icon(Icons.add),
      ),
    );
  }
  getComplaints() async{
print("dsflkj ${widget.customer}");
    mRootReference.child("Customer").child(widget.customer).child("Complaint").onValue.listen((event) {
      print("dsflkj ${event.snapshot.value}");
      Map<dynamic, dynamic> vehicleMap =event.snapshot.value as Map;
      list.clear();
      vehicleMap.forEach((key, value) {
        mRootReference.child("Complaints").child(key).get().then((DataSnapshot che) {
          Map<dynamic, dynamic> complaintsData= che.value as Map;
          list.add(ComplaintsModel(description: complaintsData["description"], title: complaintsData["Title"], customer:  complaintsData["Customer"], id:  complaintsData["id"], customerName: complaintsData["CustomerName"], dateMillisecondsSinceEpoch: complaintsData["DateMillisecondsSinceEpoch"], date: complaintsData["Date"]));
          setState((){});
        });
      });
    });
  }
}
