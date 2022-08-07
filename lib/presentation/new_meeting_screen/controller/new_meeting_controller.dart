import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../schedule_screen/controller/schedule_controller.dart';
import '/core/app_export.dart';
import 'package:bbb_app/presentation/new_meeting_screen/models/new_meeting_model.dart';

class NewMeetingController extends GetxController with StateMixin<dynamic> {
  Rx<NewMeetingModel> newMeetingModelObj = NewMeetingModel().obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
