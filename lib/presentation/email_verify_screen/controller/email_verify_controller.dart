import '../models/email_verify_model.dart';
import '/core/app_export.dart';

class EmailveryController extends GetxController with StateMixin<dynamic> {
  Rx<EmailveryModel> emailveryModelObj = EmailveryModel().obs;
  var isLoading=false.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
