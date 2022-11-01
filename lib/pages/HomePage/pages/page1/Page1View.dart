import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:publicapi/common/Constants/UIConstants.dart';
import 'package:publicapi/pages/HomePage/pages/page1/widgets/APIDisplayWidget.dart';

import 'controller/homepageController.dart';

class Page1View extends StatefulWidget {
  @override
  State<Page1View> createState() => _Page1ViewState();
}

class _Page1ViewState extends State<Page1View> {
  //initialize getx controller
  final PublicEntriesController entriesController =
      Get.put(PublicEntriesController());
  TextEditingController searchTextcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //add listener for textcontroller
    searchTextcontroller.addListener(() {
      _listener();
    });
  }

  _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          (searchTextcontroller.text.trim().split("").length > 0)
              ? Obx(() {
                  if (entriesController.isLoading.value) {
                    return Container(
                      height: 80,
                      width: 70,
                      child: Lottie.asset('assets/loading.json'),
                    );
                  } else {
                    print("nikku");
                    List<Map> list = entriesController.entryDataList.value;
                    if (list.length > 0) {
                      return ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            Map data = list[index];
                            if (searchTextcontroller.text.trim().length < 0) {
                              return ApiDisplayWidget(data: data);
                            } else {
                              String category = data['Category'];
                              if (category
                                  .substring(0, category.length)
                                  .contains(searchTextcontroller.text.trim())) {
                                return ApiDisplayWidget(data: data);
                              } else {
                                return SizedBox.shrink();
                              }
                            }
                          });
                    } else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0)),
                            elevation: 18.0,
                            color: accetColor,
                            clipBehavior: Clip.antiAlias, // Add This
                            child: MaterialButton(
                              minWidth: 120.0,
                              height: 35,
                              color: accetColor,
                              child: new Text('Fetch Data',
                                  style: new TextStyle(
                                      fontSize: 16.0, color: Colors.white)),
                              onPressed: () {
                                entriesController.fetchdata();
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  }
                })
              : Obx(() {
                  if (entriesController.isLoading.value) {
                    return Container(
                      height: 80,
                      width: 70,
                      child: Lottie.asset('assets/loading.json'),
                    );
                  } else {
                    List<Map> list = entriesController.entryDataList.value;
                    if (list.length > 0) {
                      return ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            Map data = list[index];

                            return ApiDisplayWidget(data: data);
                          });
                    } else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0)),
                            elevation: 18.0,
                            color: accetColor,
                            clipBehavior: Clip.antiAlias, // Add This
                            child: MaterialButton(
                              minWidth: 120.0,
                              height: 35,
                              color: accetColor,
                              child: new Text('Fetch Data',
                                  style: new TextStyle(
                                      fontSize: 16.0, color: Colors.white)),
                              onPressed: () {
                                entriesController.fetchdata();
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  }
                }),
          Align(
            alignment: Alignment.topRight,
            child: AnimSearchBar(
                autoFocus: true,
                rtl: true,
                closeSearchOnSuffixTap: true,
                width: MediaQuery.of(context).size.width * 0.95,
                textController: searchTextcontroller,
                onSuffixTap: () {
                  setState(() {
                    searchTextcontroller.clear();
                  });
                }),
          ),
        ],
      ),
    );
  }
}
