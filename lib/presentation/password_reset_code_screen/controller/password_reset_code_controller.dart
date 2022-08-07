import '../models/password_reset_code_model.dart';
import '/core/app_export.dart';

class ResetcodeController extends GetxController with StateMixin<dynamic> {
  Rx<ResetcodeModel> resetcodeModelObj = ResetcodeModel().obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
