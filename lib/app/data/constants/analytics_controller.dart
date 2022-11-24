import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  screenTrack({required String screenName, required String screenClass}) async {
    await analytics.logScreenView(screenClass: screenClass, screenName: screenName);
  }

  eventTrack() async {
    Platform.isAndroid ? await analytics.logEvent(
        name: 'Home_Screen_Android',
        parameters: {
          'Navigate_To_Android_HomeScreen' : 'open_Android_HomeScreen'
        }
    ) : await analytics.logEvent(
        name: 'Home_Screen_iOS',
        parameters: {
          'Navigate_To_iOS_HomeScreen' : 'open_iOS_HomeScreen'
        }
    );
    print('homescreen Track detected...');
  }

}