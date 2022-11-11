import 'package:flutter/material.dart';
import 'package:publicapi/pages/HomePage/HomePage.dart';
import 'package:publicapi/pages/HomePage/pages/collectLatitude%20and%20Longitude.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

Color lightColor = Color(0xff89a2f0);
Color darkColor = Color(0xff2F2A8E);
late SharedPreferences prefs;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Public Api',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: prefs.containsKey("Data1") ? MyHomePage() : CollectLatAndLong(),
    );
  }
}
