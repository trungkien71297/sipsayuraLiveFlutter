import '../controller/join_meeting_controller.dart';
import 'package:get/get.dart';

class JoinMeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JoinMeetingController());
  }
}
