import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:publicapi/common/Constants/UIConstants.dart';
import 'package:publicapi/pages/HomePage/pages/page1/Page1View.dart';
import 'package:publicapi/pages/HomePage/pages/page2/Page2View.dart';
import 'package:publicapi/pages/HomePage/pages/page3/Page3View.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> screens = [
    Page1View(),
    Page2View(),
    Page3View(),
  ];
  int currentSelectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: accetColor,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.api, size: 30),
          Icon(Icons.private_connectivity_outlined, size: 30),
          Icon(Icons.web, size: 30),
        ],
        onTap: (index) {
          setState(() {
            currentSelectedIndex = index;
          });
        },
      ),
      body: SafeArea(
        child: screens[currentSelectedIndex],
      ),
    );
  }
}
