import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bbb_app/core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../nav_drawer_draweritem/controller/nav_drawer_controller.dart';
import '../nav_drawer_draweritem/nav_drawer_draweritem.dart';
import '../schedule_meeting_form_screen/controller/schedule_meeting_form_controller.dart';
import 'controller/dashboard_controller.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// ignore_for_file: must_be_immutable
class DashboardScreen extends GetWidget<DashboardController> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String token = "";
  var result;

  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.clear();

  @override
  void initState() {
    //super.initState();
  }
  void getCard() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("token")!;
    });
    //print (token);
  }

  getEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token")!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          AwesomeDialog dlg = AwesomeDialog(
              context: context,
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Exit',
              desc: 'Do You want to EXIT?????????',
              dismissOnBackKeyPress: false,
              useRootNavigator: true,
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                exit(0);
              },
              btnOkColor: Colors.lightBlueAccent,
              btnOkText: "Yes",
              btnCancelText: "No");

          await dlg.show();

          return result;
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: ColorConstant.whiteA700,
          appBar: new AppBar(
            backgroundColor: Colors.lightBlueAccent,
            title: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "lbl_sipsayura2".tr,
                      style: TextStyle(
                          color: ColorConstant.whiteA700,
                          fontSize: getFontSize(18),
                          fontFamily: 'Oldenburg',
                          fontWeight: FontWeight.w500)),
                ]),
                textAlign: TextAlign.left),
            centerTitle: true,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black54),
            actions: <Widget>[
              new IconButton(
                onPressed: () {
                  settingsScreen();
                  // handle the press
                },
                icon: new Icon(Icons.settings),
              ),
            ],
          ),

          drawer: NavDrawerDraweritem(NavDrawerController()),
          body: Column(children: [
            Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                                color: ColorConstant.whiteA700,
                                boxShadow: [
                                  BoxShadow(
                                      color: ColorConstant.black90028,
                                      spreadRadius: getHorizontalSize(2.00),
                                      blurRadius: getHorizontalSize(2.00),
                                      offset: Offset(1, 2))
                                ]),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: getVerticalSize(20.00)),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  6,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  6),
                                          child: Row(children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    4 /
                                                    6,
                                                child: Center(
                                                  child: TextFormField(
                                                      focusNode: FocusNode(),
                                                      controller: controller
                                                          .group7Controller,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  "msg_search_for_peop"
                                                                      .tr,
                                                              hintStyle: AppStyle
                                                                  .textstylenunitosemibold9
                                                                  .copyWith(
                                                                      fontSize:
                                                                          getFontSize(
                                                                              12),
                                                                      color: ColorConstant
                                                                          .gray500),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          getHorizontalSize(
                                                                              10.00)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color: Colors
                                                                              .transparent)),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(getHorizontalSize(10.00)),
                                                                  borderSide: BorderSide(color: Colors.transparent)),
                                                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(getHorizontalSize(10.00)), borderSide: BorderSide(color: Colors.transparent)),
                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(getHorizontalSize(10.00)), borderSide: BorderSide.none),
                                                              prefixIcon: Container(
                                                                  margin: EdgeInsets.only(left: getHorizontalSize(10.00), top: getVerticalSize(7.00), right: getHorizontalSize(8.51), bottom: getVerticalSize(6.51)),
                                                                  child: Container(
                                                                    height:
                                                                        getSize(
                                                                            10),
                                                                    width:
                                                                        getSize(
                                                                            10),
                                                                    child: Icon(
                                                                      Icons
                                                                          .search_outlined,
                                                                      color: Colors
                                                                          .black45,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                  )),
                                                              suffixIcon: Padding(padding: EdgeInsets.only(right: getHorizontalSize(15.00)), child: IconButton(onPressed: controller.group7Controller.clear, icon: Icon(Icons.clear, color: Colors.grey.shade600))),
                                                              filled: true,
                                                              fillColor: ColorConstant.gray300),
                                                      style: TextStyle(fontSize: getFontSize(11.0)),
                                                      onChanged: (value) {}),
                                                )),
                                          ]))),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              left: getHorizontalSize(20.00),
                                              top: getVerticalSize(19.00),
                                              right: getHorizontalSize(20.00)),
                                          decoration: BoxDecoration(
                                            color: ColorConstant.whiteA700,
                                          ),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              7,
                                                          top: getVerticalSize(
                                                              22.00),
                                                        ),
                                                        child: Text(
                                                            "lbl_contacts".tr,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .textstylemontserratregular11
                                                                .copyWith(
                                                                    fontSize:
                                                                        getFontSize(
                                                                            15))))),
                                                Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left:
                                                                getHorizontalSize(
                                                                    10.00),
                                                            top:
                                                                getVerticalSize(
                                                                    21.50),
                                                            right:
                                                                getHorizontalSize(
                                                                    10.00)),
                                                        child: Image.asset(
                                                            ImageConstant
                                                                .imgScreenshot2022,
                                                            height:
                                                                getVerticalSize(
                                                                    130.00),
                                                            width:
                                                                getHorizontalSize(
                                                                    151.00),
                                                            fit: BoxFit
                                                                .scaleDown))),
                                                Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: getHorizontalSize(
                                                                10.00),
                                                            top: getVerticalSize(
                                                                20.00),
                                                            right:
                                                                getHorizontalSize(
                                                                    10.00)),
                                                        child: Text(
                                                            "msg_no_contacts_add"
                                                                .tr,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .textstylemontserratregular111
                                                                .copyWith(
                                                                    fontSize:
                                                                        getFontSize(14))))),
                                                Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left:
                                                                getHorizontalSize(
                                                                    10.00),
                                                            top:
                                                                getVerticalSize(
                                                                    25.00),
                                                            right:
                                                                getHorizontalSize(
                                                                    10.00)),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  getHorizontalSize(
                                                                    10.00,
                                                                  ),
                                                                ), // <-- Radius
                                                              ),
                                                              primary: Colors
                                                                  .lightBlueAccent,
                                                            ),
                                                            onPressed: () {},
                                                            child: Text(
                                                                "lbl_add".tr),
                                                          ),
                                                        ))),
                                              ])))
                                ]))))),
          ]),
          bottomNavigationBar: BottomNavigationBar(
            // backgroundColor: Colors.black54,
            selectedItemColor: Colors.lightBlueAccent,
            currentIndex: 1,
            elevation: 2.0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time_filled_rounded),
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_sharp),
                label: 'Create',
              ),
            ],
            onTap: navRoute,
          ),
          // bottomNavigationBar: BottomBar(
          //   selectedIndex: 1,
          //   onTap: navRoute,
          //   items: <BottomBarItem>[
          //     BottomBarItem(
          //       icon: Icon(Icons.home),
          //       title: Text('Home'),
          //       activeColor: Colors.blue,
          //     ),
          //     BottomBarItem(
          //       icon: Icon(Icons.favorite),
          //       title: Text('Favorites'),
          //       activeColor: Colors.red,
          //     ),
          //     BottomBarItem(
          //       icon: Icon(Icons.person),
          //       title: Text('Account'),
          //       activeColor: Colors.greenAccent.shade700,
          //     ),
          //     BottomBarItem(
          //       icon: Icon(Icons.settings),
          //       title: Text('Settings'),
          //       activeColor: Colors.orange,
          //     ),
          //   ],
          // ),
        ));
  }

  navRoute(int tabIndex) {
    switch (tabIndex) {
      case 0:
        onTapImgMdischedule();
        break;
      case 1:
        onTapImgVector();
        break;
      case 2:
        onTapImgVector1();
        break;
    }
  }

  onTapImgVector() {
    Get.toNamed(AppRoutes.dashboardScreen);
  }

  onTapImgVector1() {
    loadDataForMeetings();
    Get.toNamed(AppRoutes.scheduleMeetingForm);
  }

  onTapImgMdischedule() {
    Get.toNamed(AppRoutes.scheduleScreen);
  }

  settingsScreen() {
    Get.toNamed(AppRoutes.settingsScreen);
  }

  onTapImgVector2() {
    Get.toNamed(AppRoutes.newMeetingScreen);
  }

  void setState(Null Function() param0) {}

  loadDataForMeetings() {
    final controller = Get.put(ScheduleMeetingFormController());
    controller.putUserMeeting();
  }
}
