import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bbb_app/core/app_export.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:http/http.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/math_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'controller/email_verify_controller.dart';

class EmailveryScreen extends GetWidget<EmailveryController> {
  final TextEditingController _Sendotp = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  ConnectivityResult result = ConnectivityResult.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
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
              left: 0, right: 0, top: 0, bottom: 0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0), color: Colors.white),
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
                    key: _formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 40.0,
                            child: Center(
                              child: Text(
                                'Enter Verification Code',
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
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black54),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 16.0, bottom: 20.0),
                            child: TextFormField(
                              controller: _Sendotp,
                              autovalidateMode: null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'code cannot be a empty';
                                } else if (value.isEmpty) {
                                  return null;

                                }

                                return null;
                                //const LoginTosign();
                              },
                              decoration: const InputDecoration(
                                labelText: "Enter the verification code",
                                labelStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontStyle: FontStyle.italic),
                                icon: Icon(Icons.key, color: Colors.lightBlueAccent),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.lightBlueAccent),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: Obx(()=>ElevatedButton(
                              onPressed: () {
                                postVerifyData(context);
                              },
                              child: controller.isLoading.value
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 12.0,
                                    width: 12.0,
                                    child:  CircularProgressIndicator(
                                      color: Colors.white,

                                    ),
                                  ),

                                  Text("Please waite", style:
                                  TextStyle(fontSize: 16,color: Colors.white))
                                ],

                              ): Text(
                                'Verify Email',
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
                            ),),
                          ),
                      SizedBox(
                        height: 10,),
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
    );
  }

  final url = "http://192.168.8.175/accounts/verify-email";

  /**
   * verify email function
   */
  void postVerifyData(context) async {
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
    controller.isLoading.value=true;
    await Future.delayed(const Duration(seconds: 2), (){});
    try {
      final response = await post(Uri.parse(url), body: {
        "token":_Sendotp.text
      });
      print(response.body);
      controller.isLoading.value=false;
      toastsuccessful();
      onTapBtnSignin();
    } catch (err) {}}
  }

  void toastsuccessful() => Fluttertoast.showToast(
      msg: "Email Verified Successful",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);

  onTapBtnSignin() {
    Get.toNamed(AppRoutes.signinScreen);
  }

}
