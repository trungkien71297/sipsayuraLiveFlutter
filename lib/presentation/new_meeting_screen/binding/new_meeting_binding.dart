import '../controller/new_meeting_controller.dart';
import 'package:get/get.dart';

class NewMeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewMeetingController());
  }
}
