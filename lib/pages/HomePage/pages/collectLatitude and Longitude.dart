import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:publicapi/main.dart';

import '../HomePage.dart';

class CollectLatAndLong extends StatefulWidget {
  const CollectLatAndLong({Key? key}) : super(key: key);

  @override
  State<CollectLatAndLong> createState() => _CollectLatAndLongState();
}

class _CollectLatAndLongState extends State<CollectLatAndLong> {
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  FocusScopeNode fc = FocusScopeNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff89a2f0),
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            fc.unfocus();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please enter the Latitude and longitude",
                style: GoogleFonts.varela(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          offset: Offset(-6.0, -6.0),
                          blurRadius: 16.0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(6.0, 6.0),
                          blurRadius: 16.0,
                        ),
                      ]),
                  child: TextField(
                    controller: latitudeController,
                    decoration: InputDecoration(labelText: " Latitude"),
                    style: GoogleFonts.varela(fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          offset: Offset(-6.0, -6.0),
                          blurRadius: 16.0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(6.0, 6.0),
                          blurRadius: 16.0,
                        ),
                      ]),
                  child: TextField(
                    controller: longitudeController,
                    decoration: InputDecoration(labelText: " Longitude"),
                    style: GoogleFonts.varela(fontSize: 20),
                  ),
                ),
              ),
              // Color(0xff89a2f0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return Color(0xff89a2f0);
                    }
                    return Color(0xff89a2f0);
                  })),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Submit',
                            style: GoogleFonts.openSans(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(
                          Icons.cloud_sync,
                          size: 30,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  onPressed: () async {
                    if (prefs.containsKey("Data1")) {
                      Navigator.pop(context,
                          "${latitudeController.text.trim()},${longitudeController.text.trim()}");
                    } else {
                      var response = await Dio().get(
                          "http://api.weatherapi.com/v1/forecast.json?key=898b9dcccd9646dd95b172729221011&q=${"${latitudeController.text.trim()},${longitudeController.text.trim()}"}&days=8");
                      if (response.statusCode == 200) {
                        print("received data ${response}");
                        var data = jsonDecode(response.toString());

                        //Store data in cache
                        prefs.setString("Data1", jsonEncode(data));
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
