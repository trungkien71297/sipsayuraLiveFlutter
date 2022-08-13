import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '/core/app_export.dart';
import 'package:bbb_app/presentation/profile_screen/models/profile_model.dart';

class SplashController extends GetxController with StateMixin<dynamic> {
  bool isLoaded = false;
  ProfileModel? profile;
  late SharedPreferences prefs;
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    autoLogIn();
  }

  Future autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? currentemail = prefs.getString('user_email');

    Timer(Duration(seconds: 5), () => checkPreferences(currentemail));
    //Get.to((currentemail == null ? login() : dashboard())));

    //   if (currentemail != null) {
    //     dashboard();
    //   } else {
    //     login();
    // }
  }
}

checkPreferences(currentemail) {
  if (currentemail != null) {
    dashboard();
  } else {
    login();
  }
}

dashboard() {
  Get.toNamed(AppRoutes.dashboardScreen);
}

login() {
  Get.toNamed(AppRoutes.initialRoute);
}
