import 'package:bbb_app/presentation/signup_screen/signup_screen.dart';
import 'package:bbb_app/presentation/dashboard_screen/dashboard_screen.dart';
import 'package:bbb_app/presentation/onboarding_screen/onboarding_screen.dart';
import 'package:get/get.dart';

import '../presentation/dashboard_screen/binding/dashboard_binding.dart';
import '../presentation/email_verify_screen/binding/email_verify_binding.dart';
import '../presentation/email_verify_screen/email_verify_screen.dart';
import '../presentation/forgot_password_screen/binding/forgotpassword_binding.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/join_screen/binding/join_meeting_binding.dart';
import '../presentation/join_screen/join_meeting_screen.dart';
import '../presentation/new_meeting_screen/binding/new_meeting_binding.dart';
import '../presentation/new_meeting_screen/new_meeting_screen.dart';
import '../presentation/onboarding_screen/binding/onboarding_binding.dart';
import '../presentation/profile_screen/binding/profile_binding.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/recover_password_screen/binding/recover_password_binding.dart';
import '../presentation/recover_password_screen/recover_password_screen.dart';
import '../presentation/password_reset_code_screen/binding/password_reset_code_binding.dart';
import '../presentation/password_reset_code_screen/password_reset_code_screen.dart';
import '../presentation/schedule_meeting_form_screen/binding/schedule_meeting_form_binding.dart';
import '../presentation/schedule_meeting_form_screen/schedule_meeting_form_screen.dart';
import '../presentation/schedule_screen/binding/schedule_binding.dart';
import '../presentation/schedule_screen/schedule_screen.dart';
import '../presentation/settings_screen/binding/settings_binding.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/signin_screen/binding/signin_binding.dart';
import '../presentation/signin_screen/signin_screen.dart';
import '../presentation/signup_screen/binding/signup_binding.dart';
import '../presentation/splash_screen/binding/splash_binding.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../src/view/join/binding/join_binding.dart';
import '../src/view/join/join_view.dart';
import '../src/view/start/binding/start_binding.dart';
import '../src/view/start/start_view.dart';

class AppRoutes {
  // static String joinMeetingScreen = '/join_meeting_screen';

  static String signinScreen = '/signin_screen';

  static String profileScreen = '/profile_screen';

  static String signupScreen = '/signup_screen';

  static String scheduleScreen = '/schedule_screen';

  static String passwordResetCodeScreen = '/password_reset_code_screen';

  static String emailVerifyScreen = '/email_verify_Screen';

  static String dashboardScreen = '/dashboard_screen';

  static String newMeetingScreen = '/new_meeting_screen';

  static String joinScreen = '/join_screen';

  static String joinMeetingScreen = '/join_meeting_screen';
  static String settingsScreen = '/settings_screen';

  static String scheduleMeetingForm = '/schedule_meeting_form_screen';

  static String onBoardingScreen = '/on_boarding_screen';

  static String recoveryPasswordScreen = '/recovery_password_screen';

  static String startScreen = '/start_screen';

  static String forgotPasswordScreen = '/forgot_password_screen';

  static String initialRoute = '/initialRoute';

  static String splashscreen = '/splashscreen';

  static List<GetPage> pages = [
    // GetPage(
    //   name: joinMeetingScreen,
    //   page: () => JoinMeetingScreen(),
    //   bindings: [
    //     JoinMeetingBinding(),
    //   ],
    // ),
    GetPage(
      name: signinScreen,
      page: () => SignInScreen(),
      bindings: [
        SignInBinding(),
      ],
    ),
    GetPage(
      name: signupScreen,
      page: () => SignUpScreen(),
      bindings: [
        SignUpBinding(),
      ],
    ),

    GetPage(
      name: passwordResetCodeScreen,
      page: () => PasswordResetcodeScreen(),
      bindings: [
        PasswordResetcodeBinding(),
      ],
    ),

    GetPage(
      name: scheduleMeetingForm,
      page: () => ScheduleMeetingFormScreen(),
      bindings: [
        ScheduleMeetingFormBinding(),
      ],
    ),

    GetPage(
      name: scheduleScreen,
      page: () => ScheduleScreen(),
      bindings: [
        ScheduleBinding(),
      ],
    ),

    GetPage(
      name: emailVerifyScreen,
      page: () => EmailveryScreen(),
      bindings: [
        EmailveryBinding(),
      ],
    ),

    GetPage(
      name: recoveryPasswordScreen,
      page: () => RcvpasswordScreen(),
      bindings: [
        RcvpasswordBinding(),
      ],
    ),

    GetPage(
      name: dashboardScreen,
      page: () => DashboardScreen(),
      bindings: [
        DashboardBinding(),
      ],
    ),

    GetPage(
      name: forgotPasswordScreen,
      page: () => ForgotpasswordScreen(),
      bindings: [
        ForgotpasswordBinding(),
      ],
    ),

    GetPage(
      name: settingsScreen,
      page: () => SettingsScreen(),
      bindings: [
        SettingsBinding(),
      ],
    ),

    GetPage(
      name: onBoardingScreen,
      page: () => OnboardingScreen(),
      bindings: [
        OnboardingBinding(),
      ],
    ),

    GetPage(
      name: startScreen,
      page: () => StartView(),
      bindings: [
        StartBinding(),
      ],
    ),

    GetPage(
      name: joinScreen,
      page: () => joinView(),
      bindings: [
        joinBinding(),
      ],
    ),

    GetPage(
      name: joinMeetingScreen,
      page: () => JoinMeetingScreen(),
      bindings: [
        JoinMeetingBinding(),
      ],
    ),

    GetPage(
      name: profileScreen,
      page: () => ProfileScreen(),
      bindings: [
        ProfileBinding(),
      ],
    ),

    GetPage(
      name: initialRoute,
      page: () => OnboardingScreen(),
      bindings: [
        OnboardingBinding(),
      ],
    ),

    GetPage(
      name: splashscreen,
      page: () => Splashscreen(),
      bindings: [
        splashBinding(),
      ],
    ),

    GetPage(
      name: newMeetingScreen,
      page: () => NewMeetingScreen(),
      bindings: [
        NewMeetingBinding(),
      ],
    ),
  ];
}
