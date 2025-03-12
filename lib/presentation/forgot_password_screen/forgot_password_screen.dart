import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:bbb_app/core/app_export.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../core/utils/color_constant.dart';
import 'controller/forgotpassword_controller.dart';

class ForgotpasswordScreen extends GetWidget<ForgotpasswordController> {
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
        title:
            RichText(text: TextSpan(children: []), textAlign: TextAlign.left),
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
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
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            child: Center(
                              child: Text(
                                'Forgot Password', //Heading
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
                          const Text(
                            "Don't worry. Resetting your password is easy, just tell us the email address you registered.",
                            textAlign: TextAlign.center, //Description1
                            style: TextStyle(
                                fontSize: 15.0, color: Colors.black54),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, bottom: 8.0),
                            child: TextFormField(
                              controller: emailController,
                              //calling Defined email controllor

                              keyboardType: TextInputType.text,

                              //validation of email
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email can not be empty';
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return "Please enter a valid email.";
                                }
                                return null;
                              },

                              decoration: const InputDecoration(
                                labelText: "Enter your Email Address",
                                labelStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontStyle: FontStyle.italic),
                                icon: Icon(Icons.mail,
                                    color: Colors.lightBlueAccent),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 40,
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ResetCodeScreen();

                                    // getresetcode();

                                    if (_formKey.currentState!.validate()) {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) =>
                                      //       const ResetCodeScreen(),
                                      //     ));
                                    }
                                    //_formkey.currentState?.validate();
                                  },
                                  child: const Text(
                                    'Send Code',
                                    style: TextStyle(fontSize: 18),
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
                                                  color:
                                                      Colors.lightBlueAccent)))),
                                ),
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
    ));
  }

  /**
   * send email and get code
   */
  Future<void> getresetcode() async {
    if (emailController.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse("http://localhost:4000/accounts/forgot-password"),
          body: ({'email': emailController.text}));
      if (response.statusCode == 200) {
        ResetCodeScreen();
      } else {
        toastInvalid();
      }
    } else {
      toastlank();
    }
  }

  /**
   * toast message for Invalid
   */
  void toastInvalid() => Fluttertoast.showToast(
      msg: "Invalid",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);

  /**
   * toast message for Field
   */
  void toastlank() => Fluttertoast.showToast(
      msg: "Please Enter Email",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

ResetCodeScreen() {
  Get.toNamed(AppRoutes.passwordResetCodeScreen);
}
