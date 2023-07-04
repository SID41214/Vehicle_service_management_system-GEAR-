import 'package:flutter/material.dart';
import 'package:gear/Screens/Admin/staff_list.dart';
import 'package:gear/Screens/Customer/customer_list.dart';

import '../../Constants/my_functions.dart';
import '../../Constants/user_preferences.dart';
import '../../Models/home_adapter_model.dart';
import '../Customer/service_history.dart';
import 'admin_complaints.dart';
import 'complaint_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<HomeAdapterModel> list = [];
  @override
  initState(){
    getData();
    super.initState();
  }
  getData()async{
    list.add(HomeAdapterModel(name: 'Service History', icons: Icons.miscellaneous_services, screen:  ServicesHistory(customer: await getString(UserPreferences.USER_NUMBER))));
    list.add(HomeAdapterModel(name: 'Customer List', icons: Icons.directions_car, screen:const CustomerList()));
    list.add(HomeAdapterModel(name: 'Staff Management', icons: Icons.people, screen: const StaffList()));
    list.add(HomeAdapterModel(name: 'Services Complaints', icons: Icons.mail, screen:  const AdminComplaints()));
    setState(() {});
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(onPressed: ()async{
            showAlertDialog(context);

          }, icon: const Icon(Icons.logout))
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
