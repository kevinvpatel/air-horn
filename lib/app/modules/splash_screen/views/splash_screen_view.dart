import 'package:air_horn/app/data/constants/constants.dart';
import 'package:air_horn/app/data/constants/image_constant.dart';
import 'package:air_horn/app/modules/home/controllers/home_controller.dart';
import 'package:air_horn/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    HomeController homeController = Get.put(HomeController());

    controller.getAdId();

    Future.delayed(const Duration(milliseconds: 1800), () {
      Get.to(const HomeView());
    });

    return Scaffold(
      backgroundColor: themeColorLightRed,
      body: Center(
        child: Container(
          height: width * 0.48,
          width: width * 0.48,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(42),
            boxShadow: const [
              BoxShadow(color: Colors.black12, offset: Offset(0, 0), blurRadius: 10, spreadRadius: 7)
            ],
            image: const DecorationImage(image: AssetImage(ConstantsImage.APP_LOGO))
          ),
        ),
      ),
    );
  }
}
