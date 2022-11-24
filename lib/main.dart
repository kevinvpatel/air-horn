import 'dart:io';

import 'package:air_horn/app/data/constants/analytics_controller.dart';
import 'package:air_horn/app/modules/splash_screen/bindings/splash_screen_binding.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app/routes/app_pages.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if(Platform.isAndroid) {
    MobileAds.instance.initialize();
  }

  AnalyticsController analyticsController = Get.put(AnalyticsController());

  ///In App Messaging
  FirebaseMessaging.instance.getInitialMessage();
  if(Platform.isAndroid) {
    FirebaseMessaging.instance.sendMessage();
  }
  var token = await FirebaseMessaging.instance.getToken();
  print("Print Instance Token ID: " + token!);


  runApp(
    GetMaterialApp(
      navigatorObservers: <NavigatorObserver>[analyticsController.observer],
      initialBinding: SplashScreenBinding(),
      builder: BotToastInit(),
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
