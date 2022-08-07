import 'package:get/get.dart';

import '../controller/join_controller.dart';

class joinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => joinController());
  }
}
