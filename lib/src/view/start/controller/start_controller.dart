import '../models/start_model.dart';
import '/core/app_export.dart';

class StartController extends GetxController with StateMixin<dynamic> {
  Rx<StartModel> onboardingModelObj = StartModel().obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
