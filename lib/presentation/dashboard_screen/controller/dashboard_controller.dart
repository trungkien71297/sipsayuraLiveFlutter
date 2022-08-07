import '../models/dashboard_model.dart';
import '/core/app_export.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController with StateMixin<dynamic> {
  TextEditingController group7Controller = TextEditingController();

  Rx<DashboardModel> dashboardModelObj = DashboardModel().obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    group7Controller.dispose();
  }
}
