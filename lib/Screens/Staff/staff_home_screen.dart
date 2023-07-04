import 'package:flutter/material.dart';
import 'package:gear/Screens/Customer/customer_list.dart';
import 'package:gear/Screens/Customer/service_history.dart';
import 'package:gear/Screens/services/service_list.dart';

import '../../Constants/my_functions.dart';
import '../../Constants/user_preferences.dart';
import '../../Models/home_adapter_model.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({Key? key}) : super(key: key);

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  List<HomeAdapterModel> list = [];

  @override
  initState() {
    getData();
    super.initState();
  }

  getData() async {
    list.add(HomeAdapterModel(
        name: 'Customer',
        icons: Icons.directions_car,
        screen: const CustomerList()));
    // list.add(HomeAdapterModel(name: 'Add Service', icons: Icons.outgoing_mail, screen: const AddServices()));
    list.add(HomeAdapterModel(
        name: 'Service History',
        icons: Icons.miscellaneous_services,
        screen: ServicesHistory(
            customer: await getString(UserPreferences.USER_NUMBER))));
    list.add(HomeAdapterModel(
        name: 'Service Items',
        icons: Icons.add_circle,
        screen: const ServicesList()));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Dashboard"),
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
            onTap: () {
              callNext(list[index].screen, context);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(list[index].icons),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  title: Text(list[index].name),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
