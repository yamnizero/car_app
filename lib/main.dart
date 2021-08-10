import 'package:car_app/Screens/MainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'Screens/loginScreen.dart';
import 'Screens/registerationScreen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("user");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      initialRoute: MainScreen.idScreen,
      routes:
      {
        RegisterScreen.idScreen: (context) => RegisterScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        MainScreen.idScreen: (context) => MainScreen(),
      },
    );
  }
}

