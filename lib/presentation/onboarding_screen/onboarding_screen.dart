import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bbb_app/src/view/start/start_view.dart';
import 'package:flutter/material.dart';
import 'controller/onboarding_controller.dart';
import 'package:bbb_app/core/app_export.dart';

class OnboardingScreen extends GetWidget<OnboardingController> {
  var result;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AwesomeDialog dlg = AwesomeDialog(
            context: context,
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Exit',
            desc: 'Do You want to EXIT???????',
            dismissOnBackKeyPress: false,
            useRootNavigator: true,
            btnCancelOnPress: () {},
            btnOkColor: Colors.lightBlueAccent,
            btnOkOnPress: () {
              exit(0);
            },
            btnOkText: "Yes",
            btnCancelText: "No");

        await dlg.show();

        return result;
      },
      child: Scaffold(
          backgroundColor: ColorConstant.whiteA700,
          body: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: getHorizontalSize(10.00),
                        top: getVerticalSize(100.00),
                        right: getHorizontalSize(10.00)),
                    child: Text("lbl_start_a_meeting".tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.textstylenunitosemibold132
                            .copyWith(fontSize: getFontSize(25)))),
                Padding(
                    padding: EdgeInsets.only(
                        left: getHorizontalSize(10.00),
                        top: getVerticalSize(3.00),
                        right: getHorizontalSize(10.00)),
                    child: Text("msg_or_join_a_meeti".tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.textstylenunitolight10
                            .copyWith(fontSize: getFontSize(15)))),
                Padding(
                    padding: EdgeInsets.only(
                        left: getHorizontalSize(10.00),
                        top: getVerticalSize(35.00),
                        right: getHorizontalSize(10.00)),
                    child: Image.asset(ImageConstant.imgVector39,
                        height: getVerticalSize(130.00),
                        width: getHorizontalSize(131.00),
                        fit: BoxFit.scaleDown)),
                Padding(
                    padding: EdgeInsets.only(
                        left: getHorizontalSize(10.00),
                        top: getVerticalSize(60.00),
                        right: getHorizontalSize(10.00)),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StartView()),
                          );
                        },
                        child: Text("lbl_join_meeting".tr),
                      ),
                    )),
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: getVerticalSize(50.00),
                            bottom: getVerticalSize(25.00)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  // height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 2 / 8,
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
                                      onTapBtnSignup();
                                    },
                                    child: Text("lbl_sign_up".tr),
                                  ),
                                ),
                              ),
                              Container(
                                  height: getVerticalSize(0.50),
                                  width: MediaQuery.of(context).size.width / 12,
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: ColorConstant.black900)),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("lbl_or".tr,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.textstylemontserratbold6
                                          .copyWith(fontSize: getFontSize(8)))),
                              Container(
                                  height: getVerticalSize(0.50),
                                  width: MediaQuery.of(context).size.width / 12,
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: ColorConstant.black900)),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        2 /
                                        8,
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
                                        onTapBtnSignin();
                                      },
                                      child: Text("lbl_sign_in".tr),
                                    ),
                                  ))
                            ])))
              ]))),
    );
  }

  onTapBtnStartView() {
    Get.toNamed(AppRoutes.startScreen);
  }

  onTapBtnSignup() {
    Get.toNamed(AppRoutes.signupScreen);
  }

  onTapBtnSignin() {
    Get.toNamed(AppRoutes.signinScreen);
  }
}
