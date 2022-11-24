import 'package:air_horn/app/data/city_data.dart';
import 'package:air_horn/app/data/film_effect_data.dart';
import 'package:air_horn/app/data/constants/image_constant.dart';
import 'package:air_horn/app/data/horror_data.dart';
import 'package:air_horn/app/data/house_hold.dart';
import 'package:air_horn/app/data/musical_data.dart';
import 'package:air_horn/app/data/nature.dart';
import 'package:air_horn/app/data/people_data.dart';
import 'package:air_horn/app/data/technology_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Color themeColorRed = Color.fromRGBO(221, 21, 18, 1);
Color themeColorRed = Colors.red.shade800;

Color themeColorLightRed = const Color.fromRGBO(253, 235, 235, 1);

RxList premiumCategories = [].obs;

List<Map<String, dynamic>> categories = [
  {
    'title' : 'Film Effects',
    'image' : ConstantsImage.FILM_EFFECTS_ICON,
    'sounds' : filmEffectMap
  },
  {
    'title' : 'People',
    'image' : ConstantsImage.PEOPLE_ICON,
    'sounds' : peopleMap
  },
  {
    'title' : 'Nature',
    'image' : ConstantsImage.NATURE_ICON,
    'sounds' : natureMap
  },
  {
    'title' : 'House Hold',
    'image' : ConstantsImage.HOUSE_HOLD_ICON,
    'sounds' : houseHoldMap
  },
  {
    'title' : 'City',
    'image' : ConstantsImage.CITY_ICON,
    'sounds' : cityMap
  },
  {
    'title' : 'Musical',
    'image' : ConstantsImage.MUSICAL_ICON,
    'sounds' : musicalMap
  },
  {
    'title' : 'Technology',
    'image' : ConstantsImage.TECHNOLOGY_ICON,
    'sounds' : technologyMap
  },
  {
    'title' : 'Horror',
    'image' : ConstantsImage.HORROR_ICON,
    'sounds' : horrorMap
  },
];


RxBool adShow = true.obs;