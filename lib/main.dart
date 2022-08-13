import 'dart:async';
import 'dart:core';

import 'package:bbb_app/presentation/schedule_screen/controller/schedule_controller.dart';
import 'package:bbb_app/src/broadcast/app_state_notifier.dart';
import 'package:bbb_app/src/locale/app_localizations_delegate.dart';
import 'package:bbb_app/src/utils/log.dart';
import 'package:bbb_app/src/view/start/start_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:bbb_app/core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Entry point of the application.
Future main() async {
  /// Logging settings
  Log.allowVerbose = false;
  Log.allowDebug = true;
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BBBApp(),
    );
  }
}

/// Main widget of the BBB app.
class BBBApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppLocalization(),
        locale: Get.deviceLocale, //for setting localization strings
        fallbackLocale: Locale('en', 'US'),
        title: "sipsayura_live",
        initialBinding: InitialBindings(),
        initialRoute: AppRoutes.splashscreen,
        getPages: AppRoutes.pages,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(color: const Color(0xFF253341)),
          scaffoldBackgroundColor: const Color(0xFF15202B),
        ),
        themeMode: appState.darkModeEnabled ? ThemeMode.light : ThemeMode.dark,
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizationsDelegate.supportedLocales,
      ),
    );
  }
}

onTapgodashboard() {
  Get.toNamed(AppRoutes.dashboardScreen);
}
