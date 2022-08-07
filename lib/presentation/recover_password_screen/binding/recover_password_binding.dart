import 'package:get/get.dart';
import '../controller/recover_password_controller.dart';

class RcvpasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RcvpasswordController());
  }
}
