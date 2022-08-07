import 'package:get/get.dart';

import '../controller/forgotpassword_controller.dart';

class ForgotpasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotpasswordController());
  }
}
