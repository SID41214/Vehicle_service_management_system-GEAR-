import 'package:flutter/material.dart';
import 'package:gear/Models/customer_model.dart';
import 'package:gear/Screens/Admin/complaint_screen.dart';
import 'package:gear/Screens/Customer/service_history.dart';
import 'package:gear/Screens/Customer/vehicle_list.dart';

import '../../Constants/my_functions.dart';
import '../../Constants/user_preferences.dart';
import '../../Models/home_adapter_model.dart';
import '../Admin/customer_service.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<HomeAdapterModel> list = [];
  @override
  initState(){
    getData();
    super.initState();
  }
  getData()async{
  list.add(HomeAdapterModel(name: 'My Vehicles', icons: Icons.directions_car, screen:  VehicleList(customerModel: CustomerModel(id: await getString(UserPreferences.USER_NUMBER),name: '',createdBy: '',joinDate: '',number: '',vehicleCount: ''),)));
  list.add(HomeAdapterModel(name: 'Service History', icons: Icons.miscellaneous_services, screen: CustomerServices()));
  list.add(HomeAdapterModel(name: 'Report Complaints', icons: Icons.comment, screen:  ComplaintScreen(customer: await getString(UserPreferences.USER_NUMBER))));
  setState(() {});
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Customer Dashboard"),
          actions: [
            IconButton(
                onPressed: () async {
                  showAlertDialog(context);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                callNext(list[index].screen, context);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ListTile(

                    leading: CircleAvatar(

                      child: Icon(list[index].icons), ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    title: Text(list[index].name),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
