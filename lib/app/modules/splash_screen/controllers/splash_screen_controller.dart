import 'dart:convert';
import 'package:air_horn/app/data/constants/constants.dart';
import 'package:air_horn/app/modules/home/controllers/home_controller.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class SplashScreenController extends GetxController {


  HomeController homeController = Get.put(HomeController());

  Future getAdId() async {
    http.Response request = await http.get(Uri.parse('https://rubicodes.com/ManageApp/com_airhorn_appglobal'));
    Map<String, dynamic> mapIds = json.decode(request.body);

    if (request.statusCode == 200) {
      homeController.mapIds.value = mapIds['AdMob'];
      adShow.value = mapIds['AdShow'];
      print('mapIds[AdShow] --> ${mapIds['AdShow']}');
      print('mapIds --> ${mapIds}');
      print('homeController.mapIds.value --> ${adShow.value}');
    }
    // homeController.initAppOpenAd(appOpenAdID: mapIds['AdMob']['App Open'][0]['id']);
  }


  Future setPremiumSounds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> premiumTemp = [
      ///Film Effects
      'Bone Crack', 'Shotgun', 'Finger snap', 'Glass Breaking', 'Bubbles',
      ///People
      'Wow', 'Hmms various', 'Drinking Water', 'Girl Chuckle', 'Concrete Footsteps',
      ///Nature
      'Horse and Chariot', 'Waterfall', 'Rustling Leaves',
      ///House Hold
      'Squeaky Door Open', 'Bottle Open', 'Car Door Close', 'Clock Alarm', 'Knocking on Door',
      ///City
      'Passing Motorcycle', 'Old Church Bell', 'Train - Railroad', 'Jet Plane Flyby', 'Helicopter',
      ///Musical
      'Industrial Drone', 'Fearverb', 'Mountain Voices', 'Icecubes', 'Start Computer',
      ///Technology
      'Telephone', 'Mechanical Keyboard', 'Mouse Click', 'CPU working', 'Turbine', 'Minitractor',
      ///Horror
      'Monster Screech', 'Scary', 'Ghost', 'Demon Laugh', 'Witch', 'Horror Movie Cue',
    ];

    if(prefs.getStringList('premiumCategories') == null) {
      await prefs.setStringList('premiumCategories', premiumTemp).then((value) async {
        List<String> lstCtgs = prefs.getStringList('premiumCategories')!;
        premiumCategories.value.addAll(lstCtgs);
        return value;
      });
    } else {
      List<String> lstCtgs = prefs.getStringList('premiumCategories')!;
      premiumCategories.value.addAll(lstCtgs);
    }

  }


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    ///In App Messaging
    FirebaseInAppMessaging.instance.triggerEvent("");
    if(Platform.isAndroid) {
      FirebaseMessaging.instance.sendMessage();
    }
    FirebaseMessaging.instance.getInitialMessage();

    setPremiumSounds();
    print('App Open Ad ++++++');
    getAdId().then((value) {
      print('App Open Ad -> ${homeController.mapIds['App Open'][0]['id']}');
      if(Platform.isAndroid) {
        homeController.initAppOpenAd(lstAppOpenAdID: homeController.mapIds['App Open']);
      }
      // homeController.initInterstitialAd(lstInterstitialAdID: homeController.mapIds['Interstitial']);
    });
  }

  @override
  void onClose() {
    super.onClose();
  }


}
