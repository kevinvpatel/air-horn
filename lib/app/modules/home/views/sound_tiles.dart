import 'dart:io';

import 'package:air_horn/app/data/constants/constants.dart';
import 'package:air_horn/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundTile extends StatelessWidget {

  final List<dynamic> data;
  final HomeController controller;
  final int index;

  const SoundTile({Key? key,
    required this.controller,
    required this.index,
    required this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('selecteddddd');

        if(premiumCategories.contains(data[index]['name'])) {
          if(Platform.isAndroid) {
            controller.initInterstitialAd(
                lstInterstitialAdID: controller.mapIds['Interstitial'],
                data: data,
                index: index
            );
          }
          premiumCategories.remove(data[index]['name']);
          prefs.setStringList('premiumCategories', premiumCategories.map((e) => e.toString()).toList());
        } else {
          await controller.justAudioPlayer.setAsset(data[index]['sound']);
          await controller.justAudioPlayer.setLoopMode(LoopMode.one);

          controller.appBarTitle.value = data[index]['name'];
          controller.selectedIndex.value = index;
          controller.closeGrid();
        }

      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
            padding: const EdgeInsets.only(left: 8, right: 8),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3, spreadRadius: 1, offset: const Offset(0, 1))
                ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 1),
                Hero(
                    tag: 'sound image',
                    child: SvgPicture.asset(data[index]['icon'], height: width * 0.18, width: width * 0.18)
                ),

                Text(data[index]['name'],
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16.5),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1)
              ],
            ),
          ),
          premiumCategories.contains(data[index]['name']) ? Positioned(
            top: 0,
            left: 5,
            child: Container(
              padding: EdgeInsets.all(width * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3, spreadRadius: 1, offset: const Offset(0, 1))]
              ),
              child: Icon(Icons.lock, size: 28, color: themeColorRed),
            ),
          )  : SizedBox.shrink()
        ],
      ),
    );
  }
}