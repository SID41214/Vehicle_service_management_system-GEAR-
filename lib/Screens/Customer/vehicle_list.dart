import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gear/Constants/user_preferences.dart';
import 'package:gear/Screens/Customer/add_vehicle.dart';

import '../../Constants/my_functions.dart';
import '../../Models/customer_model.dart';
import '../../Models/vehicle_model.dart';
import '../service_counter_screen.dart';

class VehicleList extends StatefulWidget {

  CustomerModel customerModel;
   VehicleList({Key? key,required this.customerModel}) : super(key: key);

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<VehicleModel> list=[];
  bool isLoading=true;
  @override
  initState(){
    getVehicle();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vehicles"),) ,
      body:isLoading?const Center(child: CircularProgressIndicator(),):list.isNotEmpty? ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {

          return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: ()async{
                      if(await getString(UserPreferences.ACCESS_CODE)!="1") {
                        callNext(ServiceCounterScreen(vehicleModel: list[index],
                          customerModel: widget.customerModel,), context);
                      }
                    },
                    leading: const CircleAvatar(child: Icon(Icons.directions_car_filled_outlined)),
                    title: Text(list[index].vehicleType),
                    subtitle: Text(list[index].vehicleNo),
                    trailing: Text(list[index].vehicleModel),
                  ),
                )),
          );
        },
      ):const Center(child: Text("No Data"),),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          callNext( AddVehicle(customer:widget.customerModel.id,), context);
        },
        label: const Text("Add Vehicle"),
        icon: const Icon(Icons.add),
      ),
    );
  }
  getVehicle() async{
    isLoading=true;
    mRootReference.child("Customer").child(widget.customerModel.id).child("Vehicles").onValue.listen((event) {
    if(event.snapshot.exists) {
      Map<dynamic, dynamic> vehicleMap = event.snapshot.value as Map;
      list.clear();
      vehicleMap.forEach((key, value) {
        mRootReference.child("Vehicles").child(key).get().then((
            DataSnapshot che) {
          Map<dynamic, dynamic> vehicleData = che.value as Map;
          list.add(VehicleModel(
              vehicleNo: vehicleData["VehicleNumber"].toString(),
              vehicleType: vehicleData["VehicleType"]?.toString() ?? "",
              vehicleModel: vehicleData["VehicleModel"]?.toString() ?? "",
              owner: vehicleData["OwnerId"]?.toString() ?? ""));
          setState(() {
            isLoading = false;
          });
        });
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }
    });
  }
}
