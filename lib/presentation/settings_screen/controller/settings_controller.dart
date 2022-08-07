import '/core/app_export.dart';
import 'package:bbb_app/presentation/settings_screen/models/settings_model.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController with StateMixin<dynamic> {
  TextEditingController accountController = TextEditingController();

  TextEditingController pushNotificatiController = TextEditingController();

  TextEditingController noiseCancellatController = TextEditingController();

  TextEditingController bandwidthUsageController = TextEditingController();

  TextEditingController metadataController = TextEditingController();

  Rx<SettingsModel> settingsModelObj = SettingsModel().obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    accountController.dispose();
    pushNotificatiController.dispose();
    noiseCancellatController.dispose();
    bandwidthUsageController.dispose();
    metadataController.dispose();
  }
}
