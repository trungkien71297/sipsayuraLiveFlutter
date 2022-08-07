import '../models/signup_model.dart';
import '/core/app_export.dart';

class Signup04Controller extends GetxController with StateMixin<dynamic> {
  Rx<Signup04Model> signup04ModelObj = Signup04Model().obs;

  var isPasswordVisibilityHidden = true.obs;
  var isConfirmPasswordVisibilityHidden = true.obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
