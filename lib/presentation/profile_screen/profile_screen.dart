import 'dart:convert';
import 'package:bbb_app/core/app_export.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/color_constant.dart';
import '../../routes/app_routes.dart';
import 'controller/profile_controller.dart';

class ProfileScreen extends GetWidget<ProfileController> {
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool showErrorMessage = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController(); //Define email controller
  final passwordController = TextEditingController();
  late SharedPreferences prefs;
  late bool newuser;

  // bool isLoaded = true;

  // String email = '';
  // String id = '';
  // String firstName = '';
  // String lastName = '';
  // String phone = '';
  // String role = '';
  // String created = '';
  // String updated = '';
  // String jwtToken = '';
  // bool isVerified = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.lightBlueAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body:
            // controller.isLoaded
            //     ?
            Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(children: const <Widget>[
                    ListTile(
                      title: CircleAvatar(
                        //backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNhIHtc98HMPQQGu8kZTvh-AhaznS1s_nSHw&usqp=CAU'),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                const Divider(),
                Container(
                  child: Column(children: <Widget>[
                    ListTile(
                      leading: Text(
                        'Account',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            fontFamily: 'Neucha'),
                      ),
                      title: Obx(() {
                        return Text(
                          controller.profileModel.value.email,
                          style:
                              TextStyle(fontSize: 14.0, fontFamily: 'Neucha'),
                        );
                      }),
                      trailing: Icon(
                        Icons.arrow_right_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                const Divider(),
                // ignore: avoid_unnecessary_containers
                Container(
                  child: Column(children: <Widget>[
                    ListTile(
                      leading: Text(
                        'Display Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            fontFamily: 'Neucha'),
                      ),
                      title: Obx(() {
                        return Text(
                          controller.profileModel.value.firstName +
                              " " +
                              controller.profileModel.value.lastName,
                          style:
                              TextStyle(fontSize: 14.0, fontFamily: 'Neucha'),
                        );
                      }),
                      trailing: Icon(
                        Icons.arrow_right_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                const Divider(),
                Container(
                  child: Column(children: const <Widget>[
                    ListTile(
                      leading: Text(
                        'Personal Note',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            fontFamily: 'Neucha'),
                      ),
                      title: Text(
                        'Not Set',
                        style: TextStyle(fontSize: 14.0, fontFamily: 'Neucha'),
                      ),
                      trailing: Icon(
                        Icons.arrow_right_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                const Divider(),
                Container(
                  child: Column(children: const <Widget>[
                    ListTile(
                      leading: Text(
                        'Update Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            fontFamily: 'Neucha'),
                      ),
                      title: Text(
                        '',
                        style: TextStyle(fontSize: 14.0, fontFamily: 'Neucha'),
                      ),
                      trailing: Icon(
                        Icons.arrow_right_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                const Divider(),
                // Container(
                //   child: Column(
                //       children: const <Widget>[
                //         ListTile(
                //           leading: Text(
                //             'Department',
                //             style: TextStyle(fontWeight: FontWeight.bold,
                //                 fontSize: 16.0,
                //                 fontFamily: 'Neucha'),
                //           ),
                //
                //           title: Text(
                //             'Not Set',
                //             style: TextStyle(
                //                 fontSize: 14.0, fontFamily: 'Neucha'),
                //           ),
                //           trailing: Icon(
                //             Icons.arrow_right_sharp,
                //             color: Colors.black,
                //           ),
                //
                //         ),
                //       ]
                //   ),),
                // const Divider(),
                // Container(
                //   child: Column(
                //       children: const <Widget>[
                //         ListTile(
                //           leading: Text(
                //             'Job Title',
                //             style: TextStyle(fontWeight: FontWeight.bold,
                //                 fontSize: 16.0,
                //                 fontFamily: 'Neucha'),
                //           ),
                //
                //           title: Text(
                //             'Not Set',
                //             style: TextStyle(
                //                 fontSize: 14.0, fontFamily: 'Neucha'),
                //           ),
                //           trailing: Icon(
                //             Icons.arrow_right_sharp,
                //             color: Colors.black,
                //           ),
                //
                //         ),
                //       ]
                //   ),),
                // const Divider(),
                // Container(
                //   child: Column(
                //       children: const <Widget>[
                //         ListTile(
                //           leading: Text(
                //             'Location',
                //             style: TextStyle(fontWeight: FontWeight.bold,
                //                 fontSize: 16.0,
                //                 fontFamily: 'Neucha'),
                //           ),
                //
                //           title: Text(
                //             'Not Set',
                //             style: TextStyle(
                //                 fontSize: 14.0, fontFamily: 'Neucha'),
                //           ),
                //           trailing: Icon(
                //             Icons.arrow_right_sharp,
                //             color: Colors.black,
                //           ),
                //
                //         ),
                //       ]
                //   ),),
                // const Divider(),
                // Container(
                //   child: Column(
                //       children: const <Widget>[
                //         ListTile(
                //           leading: Text(
                //             'Personal Meeting ID (PMI)',
                //             style: TextStyle(fontWeight: FontWeight.bold,
                //                 fontSize: 16.0,
                //                 fontFamily: 'Neucha'),
                //           ),
                //
                //           title: Text(
                //             '0123456789',
                //             style: TextStyle(
                //                 fontSize: 14.0, fontFamily: 'Neucha'),
                //           ),
                //           trailing: Icon(
                //             Icons.arrow_right_sharp,
                //             color: Colors.black,
                //           ),
                //
                //         ),
                //       ]
                //   ),),
                // const Divider(),
              ],
            ),
          ),
        )
        // : Center(child: CircularProgressIndicator()),
        );
  }

  final url = "http://localhost:4000/accounts/authenticate";

  /**
   * This fuction use for login
   */

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
    Get.toNamed(AppRoutes.scheduleMeetingForm);
  }

  onTapImgMdischedule() {
    Get.toNamed(AppRoutes.scheduleScreen);
  }
}
