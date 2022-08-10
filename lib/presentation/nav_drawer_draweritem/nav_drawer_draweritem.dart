import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../schedule_meeting_form_screen/controller/schedule_meeting_form_controller.dart';
import '../schedule_screen/controller/schedule_controller.dart';
import 'controller/nav_drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bbb_app/core/app_export.dart';

// ignore_for_file: must_be_immutable
class NavDrawerDraweritem extends StatelessWidget {
  NavDrawerDraweritem(this.controller);
  NavDrawerController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "lbl_sipsayura2".tr,
                          style: TextStyle(
                              color: ColorConstant.lightBlue700,
                              fontSize: getFontSize(18),
                              fontFamily: 'Oldenburg',
                              fontWeight: FontWeight.w500)),
                    ]),
                  ),
                  // leading: new Icon(Icons.flight),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(),
                SizedBox(
                  height: 40,
                ),
                ListTile(
                  onTap: () {
                    goProfile();
                  },
                  //title: new Text("sidebar_4".tr),
                  title: new Text("My Profile"),
                  trailing: new Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {
                    scheduleMeetingForm();
                  },
                  title: new Text("Create Meeting"),
                  trailing: new Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {
                    scheduledMeetings();
                  },
                  title: new Text("Meeting List"),
                  trailing: new Icon(Icons.arrow_forward_ios),
                ),
                // ListTile(
                //   onTap: () {
                //     myMeetingScreen();
                //   },
                //   title: new Text("My Meeting ID"),
                //   trailing: new Icon(Icons.arrow_forward_ios),
                // ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  title: new Text("Recording List"),
                  trailing: new Icon(Icons.arrow_forward_ios),
                ),

                ListTile(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      headerAnimationLoop: false,
                      animType: AnimType.TOPSLIDE,
                      showCloseIcon: true,
                      title: 'Log Out',
                      desc: 'Are u sure??????????',
                      btnCancelOnPress: () {
                        Navigator.pop(context);
                      },
                      onDissmissCallback: (type) {
                        debugPrint('Dialog Dismiss from callback $type');
                      },
                      btnOkColor: Colors.lightBlueAccent,
                      btnOkOnPress: () async {
                        // Navigator.pop(context);
                        logout();
                      },
                    ).show();
                  },
                  title: new Text("Log Out"),
                  trailing: new Icon(Icons.arrow_forward_ios),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

goProfile() {
  Get.toNamed(AppRoutes.profileScreen);
}

scheduleMeetingForm() {
  loadDataForMeetings();
  Get.toNamed(AppRoutes.scheduleMeetingForm);
}

scheduledMeetings() {
  Get.toNamed(AppRoutes.scheduleScreen);
}

logout() async {
  SharedPreferences myPrefs = await SharedPreferences.getInstance();
  await myPrefs.clear();
  setEmptyForMeetingList();
  Get.toNamed(AppRoutes.onBoardingScreen);
}

setEmptyForMeetingList() {
  final controller = Get.put(ScheduleController());
  controller.data = [];
  controller.futureMeetings = [];
  controller.pastMeetings = [];
}

myMeetingScreen() {
  Get.toNamed(AppRoutes.newMeetingScreen);
}

loadDataForMeetings() {
  final controller = Get.put(ScheduleMeetingFormController());
  controller.putUserMeeting();
}
