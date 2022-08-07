import 'package:shared_preferences/shared_preferences.dart';
import '/core/app_export.dart';
import 'package:bbb_app/presentation/profile_screen/models/profile_model.dart';

class ProfileController extends GetxController with StateMixin<dynamic> {

   Rx<ProfileModel> profileModel =  ProfileModel(
     "first_name",
      "last_name",
      "user_email",
      "phone_no",
      "user_role",
      true,
      "Token"
  ).obs;

  bool isLoaded = false;
  ProfileModel? profile ;
  late SharedPreferences prefs;
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setProfile();
    print("Model get value in init"+ profileModel.value.firstName);
  }
  void initView() {

  }
  Future<void> setProfile() async {

    prefs = await SharedPreferences.getInstance();
    profileModel.value.firstName = prefs.getString("first_name")!;
    profileModel.value.lastName = prefs.getString("last_name")!;
    profileModel.value.email = prefs.getString("user_email")!;
    profileModel.value.phone = prefs.getString("phone_no")!;
    profileModel.value.role = prefs.getString("user_role")!;
    profileModel.value.isVerified = prefs.getBool("isVerified")!;
    profileModel.value.jwtToken = prefs.getString("Token")!;

    // profile = ProfileModel(
    //   prefs.getString("first_name")!,
    //   prefs.getString("last_name")!,
    //   prefs.getString("user_email")!,
    //     prefs.getString("phone_no")!,
    //     prefs.getString("user_role")!,
    //     prefs.getBool('isVerified')!,
    //     prefs.getString("Token")!
    // );
    // print("Shared preference:"+ prefs.getString("first_name")!);
     print("Model get value in set profile"+ profileModel.value.firstName);
    profileModel.update((firstName) {prefs.getString("first_name"); });
    print("Model get value in set profile"+ profileModel.value.firstName);
    // this.profileModel=profileModel;
    isLoaded = true;
  }

}