import 'package:get/get.dart';
import '../controller/email_verify_controller.dart';

class EmailveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmailveryController());
  }
}
