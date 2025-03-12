import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/math_utils.dart';
import '../../theme/app_style.dart';
import '../schedule_screen/controller/schedule_controller.dart';
import 'controller/join_meeting_controller.dart';
import 'package:flutter/material.dart';
import 'package:bbb_app/core/app_export.dart';

class JoinMeetingScreen extends GetWidget<JoinMeetingController> {
  ConnectivityResult result = ConnectivityResult.none;
  String meetingLink = 'http://localhost:4000/join/u';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body:
            GetBuilder<JoinMeetingController>(builder: (JoinMeetingController) {
          return Obx(() => Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: controller.isLoading.value
                      ? Container(
                          alignment: Alignment.center,
                          child: Center(
                              child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator())),
                        )
                      : Container(
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    9.00,
                                  ),
                                  top: getVerticalSize(
                                    21.00,
                                  ),
                                  right: getHorizontalSize(
                                    9.00,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: getHorizontalSize(
                                          12.00,
                                        ),
                                        top: getVerticalSize(
                                          7.00,
                                        ),
                                        bottom: getVerticalSize(
                                          8.00,
                                        ),
                                      ),
                                      child: Text(
                                        "lbl_topic".tr,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black,
                                          // AppStyle.textstylenunitosemibold10
                                          //     .copyWith(
                                          //   fontSize: getFontSize(
                                          //     10,
                                          //   ),
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: getVerticalSize(
                                          9.00,
                                        ),
                                        left: getHorizontalSize(
                                          60.00,
                                        ),
                                        bottom: getVerticalSize(
                                          6.00,
                                        ),
                                      ),
                                      child: Text(
                                        controller.apiResponse["name"]
                                            .toString()
                                            .replaceAll('%20', ' ')
                                            .replaceAll('%27', '\''),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: Colors.blueGrey
                                            // AppStyle.textstylenunitosemibold10
                                            //     .copyWith(
                                            //   fontSize: getFontSize(
                                            //     10,
                                            //   ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    9.00,
                                  ),
                                  top: getVerticalSize(
                                    5.00,
                                  ),
                                  right: getHorizontalSize(
                                    9.00,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: getHorizontalSize(
                                          12.00,
                                        ),
                                        top: getVerticalSize(
                                          7.00,
                                        ),
                                        bottom: getVerticalSize(
                                          8.00,
                                        ),
                                      ),
                                      child: Text(
                                        "lbl_when".tr,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          // style: AppStyle.textstylenunitosemibold10
                                          //     .copyWith(
                                          //   fontSize: getFontSize(
                                          //     10,
                                          //   ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: getVerticalSize(
                                          8.00,
                                        ),
                                        left: getHorizontalSize(
                                          60.00,
                                        ),
                                        bottom: getVerticalSize(
                                          7.00,
                                        ),
                                      ),
                                      child: Text(
                                        DateFormat.yMd()
                                            .add_jm()
                                            .format(DateFormat(
                                                    "yyyy-MM-dd HH:mm")
                                                .parse(
                                                    '${controller.apiResponse["scheduled_at_Date"].toString()} ${controller.apiResponse["scheduled_at_Time"].toString()}'))
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: Colors.blueGrey
                                            // style: AppStyle.textstylenunitosemibold10
                                            //     .copyWith(
                                            //   fontSize: getFontSize(
                                            //     10,
                                            //   ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    9.00,
                                  ),
                                  top: getVerticalSize(
                                    5.00,
                                  ),
                                  right: getHorizontalSize(
                                    9.00,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: getHorizontalSize(
                                          12.00,
                                        ),
                                        top: getVerticalSize(
                                          7.00,
                                        ),
                                        bottom: getVerticalSize(
                                          8.00,
                                        ),
                                      ),
                                      child: Text(
                                        "lbl_meeting_id".tr,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          // style: AppStyle.textstylenunitosemibold10
                                          //     .copyWith(
                                          //   fontSize: getFontSize(
                                          //     10,
                                          //   ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: getVerticalSize(
                                          7.00,
                                        ),
                                        left: getHorizontalSize(
                                          40.00,
                                        ),
                                        bottom: getVerticalSize(
                                          8.00,
                                        ),
                                      ),
                                      child: Text(
                                        controller.apiResponse["meeting_id"]
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: Colors.blueGrey
                                            // style: AppStyle.textstylenunitosemibold10
                                            //     .copyWith(
                                            //   fontSize: getFontSize(
                                            //     10,
                                            //   ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    9.00,
                                  ),
                                  top: getVerticalSize(
                                    5.00,
                                  ),
                                  right: getHorizontalSize(
                                    9.00,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: getHorizontalSize(
                                          11.50,
                                        ),
                                        top: getVerticalSize(
                                          7.00,
                                        ),
                                        bottom: getVerticalSize(
                                          8.00,
                                        ),
                                      ),
                                      child: Text(
                                        "lbl_duration".tr,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          // style: AppStyle.textstylenunitosemibold10
                                          //     .copyWith(
                                          //   fontSize: getFontSize(
                                          //     10,
                                          //   ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: getVerticalSize(
                                          7.00,
                                        ),
                                        left: getHorizontalSize(
                                          50.00,
                                        ),
                                        bottom: getVerticalSize(
                                          8.00,
                                        ),
                                      ),
                                      child: Text(
                                        controller.apiResponse["max_duration"]
                                                .toString() +
                                            " mins",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: Colors.blueGrey
                                            // style: AppStyle.textstylenunitosemibold10
                                            //     .copyWith(
                                            //   fontSize: getFontSize(
                                            //     10,
                                            //   ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    9.00,
                                  ),
                                  top: getVerticalSize(
                                    5.00,
                                  ),
                                  right: getHorizontalSize(
                                    9.00,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: getHorizontalSize(
                                          11.50,
                                        ),
                                        top: getVerticalSize(
                                          7.00,
                                        ),
                                        bottom: getVerticalSize(
                                          8.00,
                                        ),
                                      ),
                                      child: Text(
                                        "lbl_passcode_1".tr,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          // style: AppStyle.textstylenunitosemibold10
                                          //     .copyWith(
                                          //   fontSize: getFontSize(
                                          //     10,
                                          //   ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: getVerticalSize(
                                          8.00,
                                        ),
                                        left: getHorizontalSize(
                                          45.00,
                                        ),
                                        bottom: getVerticalSize(
                                          7.00,
                                        ),
                                      ),
                                      child: Text(
                                        controller.apiResponse["password"]
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: Colors.blueGrey
                                            // style: AppStyle.textstylenunitosemibold10
                                            //     .copyWith(
                                            //   fontSize: getFontSize(
                                            //     10,
                                            //   ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    10.00,
                                  ),
                                  top: getVerticalSize(
                                    22.00,
                                  ),
                                  right: getHorizontalSize(
                                    10.00,
                                  ),
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          getHorizontalSize(
                                            10.00,
                                          ),
                                        ), // <-- Radius
                                      ),
                                      primary: Colors.lightBlueAccent,
                                    ),
                                    onPressed: () {
                                      onTapBtnStart(context);
                                    },
                                    child: controller.isLoading1.value
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                height: 10.0,
                                                width: 10.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "Please wait",
                                                style: AppStyle
                                                    .textstylenunitosemibold101
                                                    .copyWith(
                                                  fontSize: getFontSize(
                                                    10,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : Text("lbl_start_now".tr),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    10.00,
                                  ),
                                  top: getVerticalSize(
                                    13.00,
                                  ),
                                  right: getHorizontalSize(
                                    10.00,
                                  ),
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          getHorizontalSize(
                                            10.00,
                                          ),
                                        ), // <-- Radius
                                      ),
                                      primary: Colors.lightBlueAccent,
                                    ),
                                    onPressed: () {
                                      onTapBtnShare();
                                    },
                                    child: Text(
                                      "lbl_invite".tr,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    10.00,
                                  ),
                                  top: getVerticalSize(
                                    12.00,
                                  ),
                                  right: getHorizontalSize(
                                    10.00,
                                  ),
                                  bottom: getVerticalSize(
                                    22.00,
                                  ),
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          getHorizontalSize(
                                            10.00,
                                          ),
                                        ), // <-- Radius
                                      ),
                                      primary: Colors.red,
                                    ),
                                    onPressed: () {
                                      onTapBtnDelete(context);
                                    },
                                    child: controller.isLoading2.value
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                height: 10.0,
                                                width: 10.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "Please wait",
                                                style: AppStyle
                                                    .textstylenunitosemibold101
                                                    .copyWith(
                                                  fontSize: getFontSize(
                                                    10,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : Text(
                                            "lbl_delete".tr,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ));
        }),
      ),
    );
  }

  onTapBtnStart(context) async {
    result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.ERROR,
        showCloseIcon: false,
        title: "Oops!",
        desc: 'No Internet Connection found Check your connection',
        btnOkOnPress: () {
          // Navigator.pop(context);
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        },
      ).show();
    } else {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Start Meeting',
              desc: 'Do you want to start the meeting?',
              dismissOnBackKeyPress: false,
              useRootNavigator: true,
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                controller.joinMeeting();
              },
              btnOkColor: Colors.lightBlueAccent,
              btnOkText: "Yes",
              btnCancelText: "No")
          .show();
    }
  }

  onTapBtnShare() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var name = prefs.getString("last_name");
    await Share.share(
        "${name} is inviting you to a scheduled LetMO meeting.\n\nTopic: ${controller.apiResponse["name"].toString().replaceAll('%20', ' ').replaceAll('%27', '\'')}\nTime: ${controller.apiResponse["scheduled_at_Date"].toString()}  ${controller.apiResponse["scheduled_at_Time"].toString()}\n\nJoin LetMO Meeting\n${meetingLink}\n\n Meeting ID: ${controller.apiResponse["meeting_id"].toString()}\nPasscode: ${controller.apiResponse["password"].toString()}");
  }

  onTapBtnDelete(context) async {
    result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.ERROR,
        showCloseIcon: false,
        title: "Oops!",
        desc: 'No Internet Connection found Check your connection',
        btnOkOnPress: () {
          // Navigator.pop(context);
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        },
      ).show();
    } else {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Delete Meeting?',
              desc: 'Are you really wanted to delete the meeting?',
              dismissOnBackKeyPress: false,
              useRootNavigator: true,
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                controller.deleteMeeting();
                getRefreshMeetings();
                Navigator.pop(context);
              },
              btnOkColor: Colors.lightBlueAccent,
              btnOkText: "Yes",
              btnCancelText: "No")
          .show();
    }
  }

  getRefreshMeetings() {
    final controller = Get.put(ScheduleController());
    // controller.futureMeetings = [];
    // controller.pastMeetings = [];
    controller.getJsonData();
  }

  settingsScreen() {
    Get.toNamed(AppRoutes.settingsScreen);
  }
}
