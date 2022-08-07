import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '/core/app_export.dart';
import 'package:bbb_app/presentation/nav_drawer_draweritem/models/nav_drawer_model.dart';

class NavDrawerController extends GetxController with StateMixin<dynamic> {
  Rx<NavDrawerModel> navDrawerModelObj = NavDrawerModel().obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
