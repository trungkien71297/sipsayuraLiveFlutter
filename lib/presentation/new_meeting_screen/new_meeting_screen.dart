import 'controller/new_meeting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bbb_app/core/app_export.dart';

class NewMeetingScreen extends GetWidget<NewMeetingController> {
  int currentTabIndex=0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              title: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text:
                            "lbl_sipsayura2"
                                .tr,
                            style: TextStyle(
                                color: ColorConstant
                                    .lightBlue700,
                                fontSize:
                                getFontSize(
                                    18),
                                fontFamily:
                                'Oldenburg',
                                fontWeight:
                                FontWeight.w500)),
                      ]),
                  textAlign:
                  TextAlign.left),
              centerTitle: true,
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.black54),
              actions: <Widget>[
                new IconButton(onPressed: () {
                  // onTapImgVector1();
                  // handle the press
                }, icon: new Icon(Icons.settings),
                ),
              ],

            ),
            body: Column(children: [
              Expanded(
                  child: Container(
                      width: MediaQuery.of(context).size.width ,
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
                              width: MediaQuery.of(context).size.width ,
                              child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              getHorizontalSize(
                                                                  44.75),
                                                          top: getVerticalSize(
                                                              32.50),
                                                          right:
                                                              getHorizontalSize(
                                                                  38.75)),
                                                      child: Text(
                                                          "my_meetinga_id".tr,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppStyle
                                                              .textstylemontserratlight11
                                                              .copyWith(
                                                                  fontSize:
                                                                      getFontSize(
                                                                          15)))),
                                                  Align(
                                                    alignment:
                                                    Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: MediaQuery.of(context).size.width/6,
                                                        right: MediaQuery.of(context).size.width/6,
                                                        top: 20,
                                                      ),
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Row(
                                                          // mainAxisAlignment:
                                                          //     MainAxisAlignment
                                                          //         .end,
                                                          // crossAxisAlignment:
                                                          //     CrossAxisAlignment
                                                          //         .start,
                                                          // mainAxisSize:
                                                          //     MainAxisSize.max,
                                                            children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                    left: MediaQuery.of(context).size.width/10,
                                                                    // right: MediaQuery.of(context).size.width/12,
                                                                    top: 20,
                                                                  ),
                                                                  child: Text(
                                                                      "lbl_937_964_8755"
                                                                          .tr,
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                      textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                      style: AppStyle
                                                                          .textstylenunitosemibold18
                                                                          .copyWith(
                                                                          fontSize:
                                                                          getFontSize(20))),
                                                                ),
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      right: MediaQuery.of(context).size.width/10,
                                                                      top: getVerticalSize(
                                                                          1.75),
                                                                      bottom:
                                                                      getVerticalSize(
                                                                          6.75)),
                                                                  child: Container(
                                                                    height:
                                                                    getVerticalSize(
                                                                        16.50),
                                                                    width: getHorizontalSize(
                                                                        5.25),
                                                                    child: Icon(
                                                                      Icons.copy_outlined,
                                                                      color: Colors.black45,
                                                                      size: 24.0,
                                                                    ),))
                                                            ]),
                                                      ),
                                                    ),
                                                  ),
                                              Align(
                                                  alignment:
                                                      Alignment.center,
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: MediaQuery.of(context).size.width/6,
                                                          top: MediaQuery.of(context).size.width/6,
                                                          right:
                                                              getHorizontalSize(
                                                                  33.75)),
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: getVerticalSize(
                                                              23.00),
                                                          width: MediaQuery.of(context).size.width/3,
                                                          decoration: AppDecoration
                                                              .textstylenunitosemibold92,
                                                          child: Text("lbl_invite_people".tr,
                                                              textAlign: TextAlign
                                                                  .left,
                                                              style: AppStyle
                                                                  .textstylenunitosemibold92
                                                                  .copyWith(fontSize: getFontSize(15))))))
                                            ])),
                                  ))),
            ]),
        )
    );
  }


  onTapImgVector() {
    Get.toNamed(AppRoutes.dashboardScreen);
  }

  onTapImgVector1() {
    Get.toNamed(AppRoutes.settingsScreen);
  }

  onTapImgMdischedule() {
    Get.toNamed(AppRoutes.scheduleScreen);
  }
}
