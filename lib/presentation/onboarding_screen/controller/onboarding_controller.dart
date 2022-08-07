import '../models/onboarding_model.dart';
import '/core/app_export.dart';

class OnboardingController extends GetxController with StateMixin<dynamic> {
  Rx<OnboardingModel> onboardingModelObj = OnboardingModel().obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
