import 'package:bbb_app/core/app_export.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../core/utils/color_constant.dart';
import '../../core/utils/math_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'controller/password_reset_code_controller.dart';

class PasswordResetcodeScreen extends GetWidget<ResetcodeController> {
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool showErrorMessage = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var emailController = TextEditingController(); //Define email controller

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.whiteA700,
          appBar: new AppBar(
            backgroundColor: Colors.lightBlueAccent,
            title: RichText(
                text: TextSpan(
                    children: [
                    ]),
                textAlign:
                TextAlign.left),
            centerTitle: true,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 80.0, bottom: 100.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0), color: Colors.white),
                child: Center(
                  child: SafeArea(
                    left: false,
                    top: false,
                    right: false,
                    bottom: false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 50.0,
                        horizontal: 10.0,
                      ),
                      child: Form(
                        // key: _formkey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 40.0,
                                child: Center(
                                  child: Text(
                                    'Enter Code Here',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0,
                                      color: Colors.lightBlueAccent,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              const Text(
                                "Enter the verification code we just sent you on your email address",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black54),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 16.0, bottom: 20.0),
                                child: TextFormField(

                                  autovalidateMode: null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'code cannot be a empty';
                                    } else if (value.isEmpty) {
                                      return null;
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black45,
                                        fontStyle: FontStyle.italic),
                                    icon: Icon(Icons.mail, color: Colors.lightBlueAccent),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    RcvpasswordScreen();
                                  },
                                  child: const Text(
                                    'Submit Code',
                                  ),
                                  style: ButtonStyle(
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.lightBlueAccent),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                              side: const BorderSide(
                                                  color: Colors.lightBlueAccent)))),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("If you didn't receive a code? "),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text('Resend'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }

  RcvpasswordScreen() {
    Get.toNamed(AppRoutes.recoveryPasswordScreen);
  }

}
