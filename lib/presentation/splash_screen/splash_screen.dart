import 'package:bbb_app/core/app_export.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'controller/splash_controller.dart';

class Splashscreen extends GetWidget<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colo
          // ),
          color: Colors.lightBlueAccent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/images/letmo.png",
                  height: 180.0,
                  width: 180.0,
                ),
                Text(
                  "Let\'s Meet Online",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SpinKitThreeBounce(
                  color: Colors.white,
                  size: 30.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
