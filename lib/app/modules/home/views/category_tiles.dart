import 'package:air_horn/app/data/constants/constants.dart';
import 'package:air_horn/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryTiles extends StatelessWidget {

  final HomeController controller;
  final int index;
  const CategoryTiles({Key? key, required this.index, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        controller.appBarTitle.value = categories[index]['title'];
        controller.selectedCategoryTitle.value = categories[index]['title'];
        controller.selectedIndex.value = 0;

        controller.selectedSoundMap.clear();
        controller.selectedSoundMap.addAll(categories[index]['sounds']);
      },
      child: Column(
        children: [
          Container(
              height: width * 0.24,
              width: width * 0.24,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(200),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        spreadRadius: 6,
                        blurRadius: 8,
                        offset: const Offset(0, 0)
                    )
                  ]
              ),
              child: SvgPicture.asset(categories[index]['image'])
          ),
          const SizedBox(height: 12),
          Text(categories[index]['title'],
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16.5),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
