import 'dart:convert';

import 'package:dio/dio.dart';

import '../model/Public entries model.dart';

class Dataservices {
  static Future<PublicApiEntriesOutlineModel?> getEntries() async {
    var response = await Dio().get("https://api.publicapis.org/entries");

    if (response.statusCode == 200) {
      print("received data ${response}");
      var data = jsonDecode(response.toString());
      return PublicApiEntriesOutlineModel.fromJson(data);
    } else {
      return null;
    }
  }
}
