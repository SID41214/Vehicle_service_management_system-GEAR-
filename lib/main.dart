import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gear/Screens/splash_screen.dart';
import 'Constants/my_colors.dart';
import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase database = FirebaseDatabase.instance;
  database.setPersistenceEnabled(true);
  database.setPersistenceCacheSizeBytes(10000000);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor:Colors.transparent));
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.grey,
              body: Center(child: Text("Error")),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Gear',
            theme: ThemeData(
                primaryColor: primaryColor,
                fontFamily: 'NunitoSans',
            ),
          home: const SplashScreen(),
          );
        }
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            // backgroundColor: Colors.white,
            body: Center(
                child: Text(
                  "Loading",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        );
      },
    );
  }
}