import 'package:air_horn/app/data/constants/constants.dart';
import 'package:air_horn/app/data/constants/image_constant.dart';
import 'package:air_horn/app/modules/home/views/category_tiles.dart';
import 'package:air_horn/app/modules/home/views/drawer_view.dart';
import 'package:air_horn/app/modules/home/views/sound_tiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../controllers/home_controller.dart';


class HomeView extends GetView<HomeController> with WidgetsBindingObserver {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    HomeController controller = Get.put(HomeController());
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    controller.openGrid(context: context);

    return WillPopScope(
      onWillPop: () => controller.onWillPop(context: context),
      child: Scaffold(
        key: scaffoldKey,
        endDrawer: const DrawerView(),
        body: Container(
          height: height,
          width: width,
          color: themeColorRed,
          padding: const EdgeInsets.only(top: 40),
          child: Obx(() {
            print('controller.nativeAd ->  ${controller.nativeAd}');
            controller.gridviewHeight = controller.isAdLoaded.value ? 70.0.obs : 25.0.obs;
            return Stack(
              children: [
                ///Left Container
                Align(
                  alignment: const AlignmentDirectional(-1, 1),
                  child: Container(
                    width: width * 0.052,
                    height: height * 0.885,
                    decoration: BoxDecoration(
                        color: themeColorLightRed,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                        )
                    ),
                  ),
                ),
                ///Right Container
                Align(
                  alignment: const AlignmentDirectional(1, 1),
                  child: Container(
                    width: width * 0.052,
                    height: height * 0.885,
                    decoration: BoxDecoration(
                        color: themeColorLightRed,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                        )
                    ),
                  ),
                ),

                ///Bottom Container
                Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: Container(
                    height: height * 0.86,
                    color: themeColorLightRed,
                    // color: Colors.yellow,
                    child: Column(
                      children: [
                        ///bottom red patti
                        Expanded(
                          child: Container(
                            height: 10,
                            width: width * 0.895,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                              color: themeColorRed,
                            ),

                            ///bottom menu button
                            child: Stack(
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0,0.9),
                                  child: AnimatedOpacity(
                                    opacity: controller.animatedOpacity.value,
                                    duration: const Duration(milliseconds: 200),
                                    child: CupertinoButton(
                                      child: SvgPicture.asset(ConstantsImage.MENU_LOGO_2, height: 60, width: 60),
                                      onPressed: () async {
                                        if(controller.animatedGridHeight.value == controller.gridviewHeight.value) {
                                          controller.openGrid(context: context);
                                        }

                                        await controller.justAudioPlayer.stop();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        ///Bottom Grid View
                        AnimatedContainer(
                          height: controller.animatedGridHeight.value,
                          width: width * 0.897,
                          color: themeColorLightRed,
                          duration: const Duration(milliseconds: 400),
                          child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: controller.appBarTitle.value == 'Categories'
                                  ? categories.length
                                  : controller.selectedSoundMap.length,
                              padding: EdgeInsets.only(
                                  top: 45, bottom: controller.appBarTitle.value == 'Categories' ? 25 : 70,
                                  left: 4, right: 4
                              ),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: controller.appBarTitle.value == 'Categories' ? 3 : 2,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0,
                                  childAspectRatio: controller.appBarTitle.value == 'Categories' ? 0.72 : width * 0.0028
                              ),
                              itemBuilder: (context, index) {
                                if(controller.appBarTitle.value == 'Categories') {
                                  return CategoryTiles(index: index, controller: controller);
                                } else {
                                  return SoundTile(
                                    data: controller.selectedSoundMap.value,
                                    controller: controller,
                                    index: index,
                                  );
                                }
                              }
                          ),
                        )
                      ],
                    ),
                  ),
                ),


                ///Native Ad Used as Banner Ad
                controller.isAdLoaded.value ?
                Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: Container(
                    color: themeColorLightRed,
                    // color: Colors.green,
                    height: 60,
                    width: width * 0.89,
                    child: controller.nativeAd != null ? AdWidget(ad: controller.nativeAd!) : SizedBox.shrink(),
                  ),
                  // child: SizedBox(
                  //   height: controller.bannerAd.size.height.toDouble(),
                  //   width: controller.bannerAd.size.width.toDouble(),
                  //   child: AdWidget(ad: controller.bannerAd),
                  // ),
                ) : const SizedBox.shrink(),


                ///Patiyu red patti
                Align(
                  alignment: const AlignmentDirectional(0, -0.83),
                  child: Container(
                      width: width * 0.895,
                      height: 30,
                      decoration: BoxDecoration(
                          color: themeColorRed,
                          // color: Colors.green,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25)
                          )
                      ),
                      padding: const EdgeInsets.only(left: 35),
                      child: controller.animatedGridHeight.value != 25 ? Text(
                        '${controller.animatedOpacity.value == 0 && controller.appBarTitle.value != 'Categories'
                            ? controller.selectedCategoryTitle.value : controller.appBarTitle.value}'
                            ' - '
                            '${controller.appBarTitle.value == 'Categories' ? categories.length : controller.selectedSoundMap.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),) : const SizedBox.shrink()
                    // color: Colors.blue,
                  ),
                ),
                Column(
                  children: [
                    ///Appbar
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          controller.appBarTitle.value == 'Categories'
                              ? const SizedBox(height: 45, width: 45)
                          // ? SizedBox(
                          //   height: 45,
                          //   width: 45,
                          //   child: CupertinoButton(
                          //     padding: EdgeInsets.zero,
                          //     child: const Icon(Icons.menu, color: Colors.white, size: 27),
                          //     onPressed: () => controller.scaffoldKey.currentState?.openDrawer(),
                          //   ),
                          // )
                          ///Navigate to Back
                          : SizedBox(
                              height: 45,
                              width: 45,
                              child: TextButton(
                                child: SvgPicture.asset(ConstantsImage.BACK_ARROW_LOGO, height: 25, width: 25),
                                onPressed: (){
                                  print('controller.animatedGridHeight.value -> # ${controller.animatedGridHeight.value}');
                                  if(controller.animatedGridHeight.value == controller.gridviewHeight.value) {
                                    controller.openGrid(context: context);
                                  } else {
                                    controller.appBarTitle.value = 'Categories';
                                  }
                                },
                              ),
                          ),
                          const SizedBox(width: 5),
                          Text(controller.appBarTitle.value,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 22),),
                          const Spacer(),
                          ///Appbar Menu button
                          ///Drawer Open
                          SizedBox(
                            height: 55,
                            width: 55,
                            child: CupertinoButton(
                              child: SvgPicture.asset(ConstantsImage.MENU_LOGO, height: 24, width: 24),
                              onPressed: () async {
                                scaffoldKey.currentState?.openEndDrawer();
                                // if(controller.animatedGridHeight.value == 25) {
                                //   controller.openGrid(context: context);
                                // }
                                // await controller.justAudioPlayer.stop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///Body
                    Expanded(
                        child: IgnorePointer(
                          ignoring: controller.isIgnore.value,
                          child: AnimatedOpacity(
                            opacity: controller.animatedOpacity.value,
                            duration: const Duration(milliseconds: 200),
                            child: Center(
                              child: GestureDetector(
                                onTapDown: (val) async {
                                  print('ontap  1 sounds[controller.selectedIndex.value][sound] -> ${controller.selectedSoundMap[controller.selectedIndex.value]['sound']}');

                                  controller.isSelected.value = true;
                                  await controller.justAudioPlayer.play();
                                },
                                onTapUp: (val) async {
                                  print('ontap  2 sounds[controller.selectedIndex.value][sound] -> ${controller.selectedSoundMap[controller.selectedIndex.value]['sound']}');

                                  controller.isSelected.value = false;
                                  await controller.justAudioPlayer.stop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 60),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Material(
                                        shape: const CircleBorder(),
                                        color: controller.isSelected.value ? Colors.white12 : Colors.white24,
                                        elevation: controller.isSelected.value ? 0 : 2,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white24,
                                          radius: width * 0.34,
                                          child: CircleAvatar(
                                              backgroundColor: controller.isSelected.value ? Colors.redAccent.shade100 : Colors.white,
                                              radius: width * 0.25,
                                              child: controller.selectedSoundMap.isNotEmpty
                                                  ? Hero(
                                                      tag: 'sound image',
                                                      child: SvgPicture.asset(controller.selectedSoundMap[controller.selectedIndex.value]['icon'],
                                                          height: width * 0.22, width: width * 0.22, fit: BoxFit.fitHeight)
                                                  )
                                                  : const SizedBox.shrink()
                                          ),
                                        ),
                                      ),
                                      CircularPercentIndicator(
                                        radius: width * 0.3,
                                        animationDuration: 300,
                                        animation: true,
                                        backgroundColor: Colors.transparent,
                                        progressColor: controller.isSelected.value ? Colors.red.shade200 : Colors.white,
                                        fillColor: Colors.transparent,
                                        reverse: true,
                                        percent: controller.isSelected.value ? 1.0 : 0.6,
                                        circularStrokeCap: CircularStrokeCap.round,
                                        lineWidth: 7,
                                        startAngle: 315,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ],
            );
          }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(() =>
            controller.animatedOpacity.value == 0 && controller.appBarTitle.value != 'Categories'
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedOpacity(
                      opacity: controller.animatedOpacity.value == 0 && controller.appBarTitle.value != 'Categories' ? 1 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: CupertinoButton(
                        child: SvgPicture.asset(ConstantsImage.GRID_MENU, height: 60, width: 60),
                        onPressed: () async {
                          controller.appBarTitle.value = 'Categories';
                        },
                      ),
                    ),
                    const SizedBox(height: 40)
                  ],
                )
                : const SizedBox.shrink()
        ),
        // bottomNavigationBar: Obx(() =>
        //   controller.isAdLoaded.value ? Container(
        //     height: controller.bannerAd.size.height.toDouble(),
        //     width: controller.bannerAd.size.width.toDouble(),
        //     child: AdWidget(ad: controller.bannerAd),
        //   ) : const SizedBox.shrink()
        // ),
      ),
    );
  }
}



