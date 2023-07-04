import 'package:flutter/material.dart';
import 'package:gear/Constants/user_preferences.dart';

import '../Constants/my_functions.dart';
import 'Admin/admin_home_screen.dart';
import 'Customer/customer_home_screen.dart';
import 'Staff/staff_home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    checkLogin(context);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Gear",
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            SizedBox(height: 50,),
            CircularProgressIndicator(color: Colors.white,)
          ],
        ),
      ),
    );
  }
  checkLogin(BuildContext context)async{
    if(await getBool(UserPreferences.IS_LOGIN)??false){
      if(await getString(UserPreferences.ACCESS_CODE)=="1"){

        Future.delayed(const Duration(milliseconds: 3000), () {
          callTo(const CustomerHomeScreen(), context);
        });
      }
      else if(await getString(UserPreferences.ACCESS_CODE)=="2"){

        Future.delayed(const Duration(milliseconds: 3000), () {
          callTo(const StaffHomeScreen(), context);
        });
      }
      else if(await getString(UserPreferences.ACCESS_CODE)=="3"){

        Future.delayed(const Duration(milliseconds: 3000), () {
          callTo(const AdminHomeScreen(), context);
        });
      }else{
        print(await getString(UserPreferences.ACCESS_CODE));
      }
    }else{
      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }
}
