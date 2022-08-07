import 'package:get/get.dart';
import '../controller/password_reset_code_controller.dart';

class PasswordResetcodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetcodeController());
  }
}
