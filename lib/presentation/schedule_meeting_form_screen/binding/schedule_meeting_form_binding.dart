import '../controller/schedule_meeting_form_controller.dart';
import 'package:get/get.dart';

class ScheduleMeetingFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScheduleMeetingFormController());
  }
}
