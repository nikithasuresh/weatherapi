import 'package:get/get.dart';

import '../services/fetchApi.dart';

class PublicEntriesController extends GetxController {
  var isLoading = false.obs;
  var entryDataList = <Map>[].obs;

  void fetchdata() async {
    isLoading(true);
    try {
      var dataReceived = await Dataservices.getEntries();
      if (dataReceived != null) {
        entryDataList.value = dataReceived.entries;
      }
    } catch (e) {
      isLoading(false);
      print("niki error $e");
    } finally {
      isLoading(false);
    }
  }
}
