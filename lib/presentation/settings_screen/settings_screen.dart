import 'controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:bbb_app/core/app_export.dart';

class SettingsScreen extends GetWidget<SettingsController> {
  int currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        appBar: new AppBar(
          backgroundColor: Colors.lightBlueAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "lbl_settings".tr,
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
        ),
        body: Container(
          width: size.width,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: ColorConstant.whiteA700,
                boxShadow: [
                  BoxShadow(
                    color: ColorConstant.black90028,
                    spreadRadius: getHorizontalSize(
                      2.00,
                    ),
                    blurRadius: getHorizontalSize(
                      2.00,
                    ),
                    offset: Offset(
                      1,
                      2,
                    ),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: getHorizontalSize(
                          23.00,
                        ),
                        top: getVerticalSize(
                          60.00,
                        ),
                        right: getHorizontalSize(
                          23.00,
                        ),
                      ),
                      child: Text(
                        "lbl_general".tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.textstylemontserratregular11.copyWith(
                          fontSize: getFontSize(
                            15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: getVerticalSize(
                      0.50,
                    ),
                    width: getHorizontalSize(
                      47.00,
                    ),
                    margin: EdgeInsets.only(
                      left: getHorizontalSize(
                        22.00,
                      ),
                      top: getVerticalSize(
                        2.00,
                      ),
                      right: getHorizontalSize(
                        22.00,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ColorConstant.bluegray900,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: getHorizontalSize(
                        10.00,
                      ),
                      top: getVerticalSize(
                        14.50,
                      ),
                      right: getHorizontalSize(
                        10.00,
                      ),
                    ),
                    child: Container(
                      height: getVerticalSize(
                        29.00,
                      ),
                      width: getHorizontalSize(
                        175.00,
                      ),
                      child: TextFormField(
                        focusNode: FocusNode(),
                        controller: controller.accountController,
                        decoration: InputDecoration(
                          hintText: "lbl_account".tr,
                          hintStyle:
                              AppStyle.textstylemontserratregular9.copyWith(
                            fontSize: getFontSize(
                              15,
                            ),
                            color: ColorConstant.black900,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: ColorConstant.whiteA700,
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            left: getHorizontalSize(
                              8.00,
                            ),
                            top: getVerticalSize(
                              9.00,
                            ),
                            right: getHorizontalSize(
                              30.00,
                            ),
                            bottom: getVerticalSize(
                              9.00,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            9.0,
                          ),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
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
                        15.00,
                      ),
                      right: getHorizontalSize(
                        10.00,
                      ),
                    ),
                    child: Container(
                      height: getVerticalSize(
                        29.00,
                      ),
                      width: getHorizontalSize(
                        175.00,
                      ),
                      child: TextFormField(
                        focusNode: FocusNode(),
                        controller: controller.pushNotificatiController,
                        decoration: InputDecoration(
                          hintText: "msg_push_notificati".tr,
                          hintStyle:
                              AppStyle.textstylemontserratregular9.copyWith(
                            fontSize: getFontSize(
                              15,
                            ),
                            color: ColorConstant.black900,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: ColorConstant.whiteA700,
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            left: getHorizontalSize(
                              8.00,
                            ),
                            top: getVerticalSize(
                              9.00,
                            ),
                            right: getHorizontalSize(
                              30.00,
                            ),
                            bottom: getVerticalSize(
                              9.00,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            15,
                          ),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
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
                        15.00,
                      ),
                      right: getHorizontalSize(
                        10.00,
                      ),
                    ),
                    child: Container(
                      height: getVerticalSize(
                        29.00,
                      ),
                      width: getHorizontalSize(
                        175.00,
                      ),
                      child: TextFormField(
                        focusNode: FocusNode(),
                        controller: controller.noiseCancellatController,
                        decoration: InputDecoration(
                          hintText: "msg_noise_cancellat".tr,
                          hintStyle:
                              AppStyle.textstylemontserratregular9.copyWith(
                            fontSize: getFontSize(
                              15,
                            ),
                            color: ColorConstant.black900,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: ColorConstant.whiteA700,
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            left: getHorizontalSize(
                              8.00,
                            ),
                            top: getVerticalSize(
                              9.00,
                            ),
                            right: getHorizontalSize(
                              30.00,
                            ),
                            bottom: getVerticalSize(
                              9.00,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            9.0,
                          ),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: getHorizontalSize(
                          24.00,
                        ),
                        top: getVerticalSize(
                          15.00,
                        ),
                        right: getHorizontalSize(
                          24.00,
                        ),
                      ),
                      child: Text(
                        "lbl_advanced".tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.textstylemontserratregular11.copyWith(
                          fontSize: getFontSize(
                            15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: getVerticalSize(
                      0.50,
                    ),
                    width: getHorizontalSize(
                      58.00,
                    ),
                    margin: EdgeInsets.only(
                      left: getHorizontalSize(
                        23.00,
                      ),
                      top: getVerticalSize(
                        2.00,
                      ),
                      right: getHorizontalSize(
                        23.00,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ColorConstant.bluegray900,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: getHorizontalSize(
                        10.00,
                      ),
                      top: getVerticalSize(
                        12.50,
                      ),
                      right: getHorizontalSize(
                        10.00,
                      ),
                    ),
                    child: Container(
                      height: getVerticalSize(
                        29.00,
                      ),
                      width: getHorizontalSize(
                        175.00,
                      ),
                      child: TextFormField(
                        focusNode: FocusNode(),
                        controller: controller.bandwidthUsageController,
                        decoration: InputDecoration(
                          hintText: "lbl_bandwidth_usage".tr,
                          hintStyle:
                              AppStyle.textstylemontserratregular9.copyWith(
                            fontSize: getFontSize(
                              15,
                            ),
                            color: ColorConstant.black900,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: ColorConstant.whiteA700,
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            left: getHorizontalSize(
                              8.00,
                            ),
                            top: getVerticalSize(
                              9.00,
                            ),
                            right: getHorizontalSize(
                              30.00,
                            ),
                            bottom: getVerticalSize(
                              9.00,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            9.0,
                          ),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
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
                        15.00,
                      ),
                      right: getHorizontalSize(
                        10.00,
                      ),
                      bottom: getVerticalSize(
                        20.00,
                      ),
                    ),
                    child: Container(
                      height: getVerticalSize(
                        29.00,
                      ),
                      width: getHorizontalSize(
                        175.00,
                      ),
                      child: TextFormField(
                        focusNode: FocusNode(),
                        controller: controller.metadataController,
                        decoration: InputDecoration(
                          hintText: "lbl_metadata".tr,
                          hintStyle:
                              AppStyle.textstylemontserratregular9.copyWith(
                            fontSize: getFontSize(
                              15,
                            ),
                            color: ColorConstant.black900,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                6.00,
                              ),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: ColorConstant.whiteA700,
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            left: getHorizontalSize(
                              8.00,
                            ),
                            top: getVerticalSize(
                              9.00,
                            ),
                            right: getHorizontalSize(
                              30.00,
                            ),
                            bottom: getVerticalSize(
                              9.00,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            9.0,
                          ),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  settingsScreen() {
    Get.toNamed(AppRoutes.settingsScreen);
  }
}
