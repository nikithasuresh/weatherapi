import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:publicapi/common/Constants/UIConstants.dart';

class Page2View extends StatefulWidget {
  const Page2View({Key? key}) : super(key: key);

  @override
  State<Page2View> createState() => _Page2ViewState();
}

class _Page2ViewState extends State<Page2View> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Good ${greeting()} 👋",
                style: GoogleFonts.openSans(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Expanded(
          child: StreamBuilder<InternetConnectionStatus>(
              stream: InternetConnectionChecker().onStatusChange,
              builder: (context, snapshot) {
                if (snapshot.data == InternetConnectionStatus.connected) {
                  return Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.wifi,
                          color: accetColor,
                          size: 40,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Internet connection available",
                          style: GoogleFonts.varela(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ));
                } else if (snapshot.data ==
                    InternetConnectionStatus.disconnected) {
                  return Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.wifi_off_sharp,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "No Internet connection available",
                          style: GoogleFonts.varela(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ));
                } else {
                  return Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.wifi_find_outlined,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Scanning ...",
                          style: GoogleFonts.varela(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ));
                }
              }),
        )
        // InternetConnectionChecker().onStatusChange.listen((status) {
        //   switch (status) {
        //     case InternetConnectionStatus.connected:
        //       print('Data connection is available.');
        //       break;
        //     case InternetConnectionStatus.disconnected:
        //       print('You are disconnected from the internet.');
        //       break;
        //   }
        // })
      ],
    );
  }
}
