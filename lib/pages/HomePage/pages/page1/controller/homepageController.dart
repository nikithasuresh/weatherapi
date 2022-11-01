import 'package:get/get.dart';

import '../services/fetchApi.dart';

class PublicEntriesController extends GetxController {
  var isLoading = false.obs;
  var entryDataList = <Map>[].obs;

  @override
  void onInit() {
    // fetchdata();
    super.onInit();
  }

  void fetchdata() async {
    isLoading(true);
    try {
      var todos = await Dataservices.getEntries();
      if (todos != null) {
        entryDataList.value = todos.entries;
      }
    } catch (e) {
      isLoading(false);
      print("niki error $e");
    } finally {
      isLoading(false);
    }
  }
}
