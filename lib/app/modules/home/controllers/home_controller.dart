import 'package:air_horn/app/data/constants/analytics_controller.dart';
import 'package:air_horn/app/data/constants/constants.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

class HomeController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement HomeController

  ///Google Ads
  NativeAd? nativeAd;
  AppOpenAd? openAppAd;
  InterstitialAd? interstitialAd;
  RxMap mapIds = {}.obs;

  // late BannerAd bannerAd;
  RxBool isAdLoaded = false.obs;


  ///animatedGridHeight = 25 means GridView is closed
  RxDouble animatedGridHeight = 25.0.obs;
  RxDouble animatedOpacity = 1.0.obs;
  RxBool isIgnore = false.obs;


  ///Center button selected
  RxBool isSelected = false.obs;


  ///Item selected index
  final selectedIndex = 0.obs;
  RxList selectedSoundMap = [].obs;


  ///Appbar Title
  RxString appBarTitle = 'Categories'.obs;
  RxString selectedCategoryTitle = 'Categories'.obs;


  ///just_audio
  final justAudioPlayer = AudioPlayer();

  ///backPress counts
  RxInt backPressCounter = 0.obs;
  RxInt backPressTotal = 2.obs;

  ///Handle Exit App
  Future<bool> onWillPop({required BuildContext context}) async {
    if(animatedGridHeight.value == gridviewHeight.value) {
      openGrid(context: context);
      return Future.value(false);
    } else if(animatedOpacity.value == 0 && appBarTitle.value != 'Categories') {
      appBarTitle.value = 'Categories';
      return Future.value(false);
    } else {
      if(backPressCounter < 2) {
        BotToast.showText(
          text: 'Press ${backPressTotal.value - backPressCounter.value} time to exit app',
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
          duration: const Duration(milliseconds: 2500),
          contentColor: Colors.grey.shade900.withOpacity(0.95),
          contentPadding: const EdgeInsets.all(10)
        );
        backPressCounter++;
        Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
          backPressCounter--;
        });
        return Future.value(false);
      } else {
        alertDialoge(context: context);
        return Future.value(false);
      }
    }
  }


  ///Dialoge box
  alertDialoge({required BuildContext context}) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Exit App', style: TextStyle(fontSize: 19),),
          content: const Text('Are you sure want to close app?', style: TextStyle(fontSize: 17),),
          actions: [
            CupertinoDialogAction(onPressed: (){
              if(Platform.isAndroid) {
                SystemNavigator.pop();
              } else {
                exit(0);
              }
            }, child: const Text('Yes')),
            CupertinoDialogAction(onPressed: ()=> Navigator.pop(context), child: const Text('NO'))
          ],
        )
    );
  }


  openGrid({required BuildContext context}) async {
    double height = MediaQuery.of(context).size.height;
    animatedGridHeight.value = height * 0.82;
    animatedOpacity.value = 0.0;
    isIgnore.value = true;

    ///un-select red button
    isSelected.value = false;
    ///stop audio
    await justAudioPlayer.stop();
  }

  RxDouble gridviewHeight = 25.0.obs;
  closeGrid() {
    animatedGridHeight.value = gridviewHeight.value;
    animatedOpacity.value = 1.0;
    isIgnore.value = false;
  }


  String bannerTestId = 'ca-app-pub-3940256099942544/6300978111';
  String nativeTestId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/2247696110' : 'ca-app-pub-3940256099942544/3986624511';
  String appOpenTestId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/3419835294' : 'ca-app-pub-3940256099942544/3419835294';
  String interstitialTestId = 'ca-app-pub-3940256099942544/1033173712';


  ///Launch When User Open Premium Sounds
  Future initInterstitialAd({
    required List<dynamic> lstInterstitialAdID,
    required List<dynamic> data,
    required int index
  }) async {
    if(adShow.value == true) {
      // await InterstitialAd.load(
      //     adUnitId: Platform.isAndroid ? lstInterstitialAdID[0]['id'] : lstInterstitialAdID[0]['id'],
      //     request: const AdRequest(),
      //     adLoadCallback: InterstitialAdLoadCallback(
      //         onAdLoaded: (ad) {
      //           interstitialAd = ad;
      //           setFullScreenContentCallBack(ad);
      //           update();
      //         },
      //         onAdFailedToLoad: (error) {
      //           interstitialAdFunc(
      //               adUnitId: Platform.isAndroid ? lstInterstitialAdID[2]['id'] : lstInterstitialAdID[2]['id'],
      //               interstitialAd: interstitialAd,
      //               onAdFailedToLoad: (error) {
      //                 print('InterstitialAd -> $error');
      //               }
      //           );
      //           print('InterstitialAd -> $error');
      //         }
      //     )
      // );
      // interstitialAd?.show();

      return interstitialAdFunc(
        adUnitId: Platform.isAndroid ? lstInterstitialAdID[0]['id'] : lstInterstitialAdID[0]['id'],
        interstitialAd: interstitialAd,
        data: data,
        index: index,
        onAdFailedToLoad: (error) {
          interstitialAdFunc(
              adUnitId: Platform.isAndroid ? lstInterstitialAdID[1]['id'] : lstInterstitialAdID[1]['id'],
              interstitialAd: interstitialAd,
              data: data,
              index: index,
              onAdFailedToLoad: (error) {
                interstitialAdFunc(
                    adUnitId: Platform.isAndroid ? lstInterstitialAdID[2]['id'] : lstInterstitialAdID[2]['id'],
                    interstitialAd: interstitialAd,
                    data: data,
                    index: index,
                    onAdFailedToLoad: (error) {
                      print('InterstitialAd -> $error');
                    }
                );
                print('InterstitialAd -> $error');
              }
          );
          print('InterstitialAd -> $error');
        }
      );
    }
  }

  interstitialAdFunc({
    required String adUnitId,
    required InterstitialAd? interstitialAd,
    required void Function(LoadAdError) onAdFailedToLoad,
    required List<dynamic> data,
    required int index,
  }) async {
    await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) async {
              interstitialAd = ad;
              setFullScreenContentCallBack(ad);
              interstitialAd?.show();

              await justAudioPlayer.setAsset(data[index]['sound']);
              await justAudioPlayer.setLoopMode(LoopMode.one);

              appBarTitle.value = data[index]['name'];
              selectedIndex.value = index;
              closeGrid();

              update();
            },
            onAdFailedToLoad: onAdFailedToLoad
        )
    );
  }

  void setFullScreenContentCallBack(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) => print('$ad  #  onAdShowedFullScreenContent'),
        onAdDismissedFullScreenContent: (ad) {
          print('$ad  #  onAdDismissedFullScreenContent');
          // interstitialAd?.dispose();
        },
        onAdFailedToShowFullScreenContent: (ad, error) => print('$ad  #  onAdFailedToShowFullScreenContent  #  $error'),
        onAdImpression: (ad) => print('$ad  #  onAdImpression')
    );
  }



  ///Native Ad Used as Banner Ad
  initNativeAd() {
    if(adShow.value == true) {
      ever(mapIds, (value) {
        List nativeAdId = mapIds['Native'];
        nativeAd = nativeAdFunc(
          adUnitId: Platform.isAndroid ? nativeAdId[0]['id'] : nativeAdId[0]['id'],
          nativeAd: nativeAd,
          onAdFailedToLoad: (ad, error) {
            nativeAd = nativeAdFunc(
                adUnitId: Platform.isAndroid ? nativeAdId[1]['id'] : nativeAdId[1]['id'],
                nativeAd: nativeAd,
                onAdFailedToLoad: (ad, error) {
                  nativeAd = nativeAdFunc(
                      adUnitId: Platform.isAndroid ? nativeAdId[2]['id'] : nativeAdId[2]['id'],
                      nativeAd: nativeAd,
                      onAdFailedToLoad: (ad, error) {
                        isAdLoaded.value = false;
                        print('Native Ad Failed -> $error');
                      }
                  );
                  isAdLoaded.value = false;
                  print('Native Ad Failed -> $error');
                }
            );
            isAdLoaded.value = false;
            print('Native Ad Failed -> $error');
          }
        );
        nativeAd?.load();
      });
    }
  }

  nativeAdFunc({
    required String adUnitId,
    required NativeAd? nativeAd,
    required Function(Ad, LoadAdError)? onAdFailedToLoad,
  }) {
    return NativeAd(
      adUnitId: adUnitId,
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
          onAdLoaded: (ad) {
            print('Native Ad Loaded Successfully @@@@@@');
            isAdLoaded.value = true;
            update();
          },
          onAdFailedToLoad: onAdFailedToLoad
      ),
    );
  }



  ///Launch When App Open
  initAppOpenAd({required List<dynamic> lstAppOpenAdID}) async {
    if(adShow.value == true) {
      openAppAdFunc(
          adUnitId: Platform.isAndroid ? lstAppOpenAdID[0]['id'] : lstAppOpenAdID[0]['id'],
          openAppAd: openAppAd,
          onAdFailedToLoad: (error) {
            openAppAdFunc(
                adUnitId: Platform.isAndroid ? lstAppOpenAdID[1]['id'] : lstAppOpenAdID[1]['id'],
                openAppAd: openAppAd,
                onAdFailedToLoad: (error) {
                  openAppAdFunc(
                      adUnitId: Platform.isAndroid ? lstAppOpenAdID[2]['id'] : lstAppOpenAdID[2]['id'],
                      openAppAd: openAppAd,
                      onAdFailedToLoad: (error) {
                        print('OpenApp Ad Failed -> $error');
                      }
                  );
                  print('OpenApp Ad Failed -> $error');
                }
            );
            print('OpenApp Ad Failed -> $error');
          }
      );
    }
  }

  openAppAdFunc({
    required String adUnitId,
    required AppOpenAd? openAppAd,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) async {
    await AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            print('OpenApp Ad Loaded @@@@@');
            openAppAd = ad;
            openAppAd?.show();
            update();
          },
          onAdFailedToLoad: onAdFailedToLoad
      ),
    );
  }


  // initBannerAd() {
  //   bannerAd = BannerAd(
  //       size: AdSize.banner,
  //       adUnitId: Platform.isAndroid ? 'ca-app-pub-6225325015993154/5164366303' : 'ca-app-pub-6225325015993154/5549748809',
  //       listener: BannerAdListener(
  //         onAdLoaded: (ad) {
  //           print('Banner Loaded Successfully @@@@@@');
  //           isAdLoaded.value = true;
  //         },
  //         onAdFailedToLoad: (ad, error) {
  //           print('Banner -> ${ad.responseInfo?.adapterResponses}  &  Failed -> $error');
  //           ad.dispose();
  //         }
  //       ),
  //     request: AdRequest()
  //   );
  //
  //   bannerAd.load();
  // }


  AnalyticsController analyticsController = Get.put(AnalyticsController());


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    isAdLoaded.value = false;
    analyticsController.screenTrack(
        screenClass: Platform.isAndroid ? 'HomeScreenActivity' : 'HomeScreenVC',
        screenName: Platform.isAndroid ? 'HomeScreen_Android' : 'HomeScreen_iOS'
    );
    analyticsController.eventTrack();
    if(Platform.isAndroid) {
      initNativeAd();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.addObserver(this);
  }

  late bool startAd;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('state@@@@ -> $state');
    if(state == AppLifecycleState.inactive) {
      startAd = false;
    } else if(state == AppLifecycleState.paused) {
      startAd = true;
    } else if(state == AppLifecycleState.resumed){
      print('@@@@ -> $state');
      if(startAd == true) {
        print('state 111111 -> $state');
        if(Platform.isAndroid) {
          initAppOpenAd(lstAppOpenAdID: mapIds['App Open']);
        }
      }
    } else {

    }
  }


}
