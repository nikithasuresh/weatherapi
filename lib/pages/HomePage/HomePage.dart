import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:publicapi/main.dart';
import 'package:publicapi/pages/HomePage/model/currentWeatherModel.dart';
import 'package:publicapi/pages/HomePage/pages/collectLatitude%20and%20Longitude.dart';

class MyHomePage extends StatefulWidget {
  String? latLong;
  MyHomePage({this.latLong});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  String latLong = "";
  bool isLoading = false;
  Widget todayWeatherWidget(
      {required String value, required String name, required IconData icon}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: darkColor,
            ),
            Text(
              value,
              style: GoogleFonts.varela(
                  fontSize: 22, color: darkColor, fontWeight: FontWeight.bold),
            ),
            Text(
              name,
              style: GoogleFonts.varela(
                  fontSize: 12, color: lightColor, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  CurrentDataModel? currentDataModel;
  List<Map> hourlyData = [];
  List<Map> weeklyData = [];
  String location = "";
  List months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];

  ///Create data model variables
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.latLong != null) {
      latLong = widget.latLong!;
      fetchDataFromInternet();
    } else {
      getDataFromCache();
    }
  }

  void getDataFromCache() async {
    try {
      if (prefs.containsKey("Data1")) {
        var data = jsonDecode(prefs.getString("Data") ?? "");
        location = "${data['location']['name']} ${data['location']['region']}";
        Map current = data['current'];
        //Store data in cache

        //Decode the data and get the parts needed
        //get Current weather data
        currentDataModel = CurrentDataModel(
            condition: current['condition']['text'],
            feelLike: current['feelslike_c'].toString(),
            humidity: current['humidity'].toString(),
            temp: current['temp_c'].toString(),
            windspeed: current['wind_kph'].toString());
        //get hourly data
        hourlyData = List<Map>.from(data['forecast']['forecastday'][0]["hour"]);
        weeklyData = List<Map>.from(data['forecast']['forecastday']);
        weeklyData.removeAt(0);
        setState(() {});
        Fluttertoast.showToast(
          msg: "Data fetched from cache",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "No cacheData found !!! ",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "No Internet Connection!! and Cache Data",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void fetchDataFromInternet() async {
    latLong = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CollectLatAndLong()));
    setState(() {
      isLoading = true;
    });
    var response = await Dio().get(
        "http://api.weatherapi.com/v1/forecast.json?key=898b9dcccd9646dd95b172729221011&q=$latLong&days=8");
    if (response.statusCode == 200) {
      print("received data ${response}");
      var data = jsonDecode(response.toString());
      location = "${data['location']['name']} ${data['location']['region']}";
      Map current = data['current'];
      //Store data in cache
      prefs.setString("Data1", jsonEncode(data));
      //Decode the data and get the parts needed
      //get Current weather data
      currentDataModel = CurrentDataModel(
          condition: current['condition']['text'],
          feelLike: current['feelslike_c'].toString(),
          humidity: current['humidity'].toString(),
          temp: current['temp_c'].toString(),
          windspeed: current['wind_kph'].toString());
      //get hourly data
      hourlyData = List<Map>.from(data['forecast']['forecastday'][0]["hour"]);
      weeklyData = List<Map>.from(data['forecast']['forecastday']);
      weeklyData.removeAt(0);
      // ------------

      //------------------
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: Container(
                  height: 120,
                  width: 120,
                  child: Lottie.asset('assets/w.json'),
                ),
              )
            : ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  //greething with Internet Connection checker
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Good ${greeting()} 👋",
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: lightColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_sharp,
                                  color: darkColor,
                                ),
                                Text(
                                  "Location",
                                  style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    color: darkColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "$location",
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  color: darkColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          // latLong = "51.52,-0.11";
                          //load the data

                          fetchDataFromInternet();
                        },
                        child: Row(
                          children: [
                            Text(
                              "Sync ",
                              style: GoogleFonts.varela(
                                  fontSize: 16,
                                  color: darkColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.sync,
                                color: darkColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  if (weeklyData.length > 0) ...[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "${currentDataModel?.feelLike}°",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 120,
                          color: lightColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Weather - Overcast",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          color: lightColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            todayWeatherWidget(
                                value: "${currentDataModel?.temp}°C ",
                                name: "Temperature",
                                icon: Icons.local_fire_department_sharp),
                            todayWeatherWidget(
                                value: "${currentDataModel?.humidity}",
                                name: "Humidity",
                                icon: Icons.water_drop),
                            todayWeatherWidget(
                                value: "${currentDataModel?.windspeed} Km/H",
                                name: "Wind Speed",
                                icon: Icons.wind_power),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Hourly Forecast",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          color: lightColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      height: 134,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: hourlyData.length,
                        itemBuilder: (context, index) {
                          var elem = hourlyData[index];
                          return HourlyWeatherWidget(
                              temp: "${elem['temp_c']}",
                              humidity: "${elem['humidity']}",
                              windSpeed: "${elem['wind_kph']}",
                              time: "${elem['time'].toString().split(" ")[1]}");
                        },
                      ),
                    ),
                    Center(
                      child: Text(
                        "Weekly Forecast",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          color: lightColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      height: 134,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: weeklyData.length,
                        itemBuilder: (context, index) {
                          var elem = weeklyData[index];
                          Map data = elem['day'];
                          DateTime date = DateTime(
                              int.parse(elem['date'].toString().split("-")[0]),
                              int.parse(elem['date'].toString().split("-")[1]),
                              int.parse(elem['date'].toString().split("-")[2]));
                          return WeeklyWeatherWidget(
                              temp: "${data['avgtemp_c']}",
                              humidity: "${data['avghumidity']}",
                              condtion: "${data['condition']['text']}",
                              date: "${date.day} ${months[date.month - 1]}");
                        },
                      ),
                    )
                  ] else
                    Center(
                      child: Text(
                        "Please click on sync",
                        style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget WeeklyWeatherWidget({
    required String temp,
    required String humidity,
    required String condtion,
    required String date,
  }) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 100,
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "( $date )",
                      style: GoogleFonts.varela(
                          fontSize: 14,
                          color: lightColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.local_fire_department_sharp,
                          size: 22,
                          color: darkColor,
                        ),
                      ),
                      Text(
                        temp,
                        style: GoogleFonts.varela(
                            fontSize: 18,
                            color: darkColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.water_drop,
                          size: 22,
                          color: darkColor,
                        ),
                      ),
                      Text(
                        humidity,
                        style: GoogleFonts.varela(
                            fontSize: 18,
                            color: darkColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "$condtion",
                        style: GoogleFonts.varela(
                            fontSize: 12,
                            color: darkColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget HourlyWeatherWidget({
    required String temp,
    required String humidity,
    required String windSpeed,
    required String time,
  }) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 100,
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "( $time )",
                      style: GoogleFonts.varela(
                          fontSize: 14,
                          color: lightColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.local_fire_department_sharp,
                          size: 22,
                          color: darkColor,
                        ),
                      ),
                      Text(
                        temp,
                        style: GoogleFonts.varela(
                            fontSize: 18,
                            color: darkColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.water_drop,
                          size: 22,
                          color: darkColor,
                        ),
                      ),
                      Text(
                        humidity,
                        style: GoogleFonts.varela(
                            fontSize: 18,
                            color: darkColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.wind_power,
                          size: 22,
                          color: darkColor,
                        ),
                      ),
                      Text(
                        windSpeed,
                        style: GoogleFonts.varela(
                            fontSize: 18,
                            color: darkColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
