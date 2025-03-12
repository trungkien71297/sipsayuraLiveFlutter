import '../models/signin_model.dart';
import '/core/app_export.dart';
import 'package:flutter/material.dart';

class Signup02Controller extends GetxController with StateMixin<dynamic> {
  TextEditingController dDMMYController = TextEditingController();

  Rx<Signin02Model> signup02ModelObj = Signin02Model().obs;

  var isPasswordVisibilityHidden = true.obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    dDMMYController.dispose();
  }
}
