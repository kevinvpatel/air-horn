import 'package:air_horn/app/data/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

  drawerTile({required String title,IconData? icon, required String img, Function()? onTap}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 18)),
      // leading: Icon(icon, size: 25),
      leading: icon == null ? Image.network(img, height: 28, width: 28) : Icon(icon, color: Colors.black),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    double drawerWidth = width * 0.8;

    return Container(
      height: height,
      width: drawerWidth,
      color: themeColorLightRed,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            height: width * 0.6,
            width: drawerWidth,
            color: themeColorLightRed,
            padding: EdgeInsets.symmetric(vertical: width * 0.12, horizontal: width * 0.22),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 0), spreadRadius: 4, blurRadius: 7)],
                color: themeColorLightRed
              ),
              child: ClipOval(
                child: Image.asset('assets/logo.jpg', height: width * 0.32, width: width * 0.32),
              ),
            ),
          ),
          const Divider(),
          drawerTile(
              title: 'Home',
              icon: CupertinoIcons.home,
              img: 'https://img.icons8.com/material-outlined/96/000000/privacy-policy.png',
              onTap: () => Get.back()
          ),
          drawerTile(
              title: 'Privacy Policy',
              icon: CupertinoIcons.doc_text,
              img: 'https://img.icons8.com/material-outlined/96/000000/privacy-policy.png',
              onTap: () async => await launchUrl(Uri.parse('https://techmatessolutions.com/privacy-policy'))
          ),
          drawerTile(
              title: 'Rate Us',
              icon: Icons.star_rate,
              img: 'https://img.icons8.com/material-outlined/96/000000/rating.png',
              onTap: () => launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.airhorn.appglobal'),
                  mode: LaunchMode.externalApplication)
          ),
          drawerTile(
              title: 'About Us',
              icon: Icons.feedback_outlined,
              img: 'https://img.icons8.com/material-outlined/96/000000/about.png',
              onTap: () => Get.to(const AboutUsScreen())
          ),
          drawerTile(
              title: 'Share',
              icon: Icons.share,
              img: 'https://img.icons8.com/material-outlined/96/000000/about.png',
              onTap: () => Share.share('Download the app for FREE: \n ${Uri.parse('https://play.google.com/store/apps/details?id=com.airhorn.appglobal')}', subject: 'Look what I found!')
          ),
        ],
      ),
    );
  }
}


class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColorLightRed,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black)
                ),
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
            const Spacer(flex: 2,),
            const Text('Get everyone\'s attention, cheer at sports games, prank your friends or'
                ' wake up your family with this entertaining air horn for your Android device! Download it for free! \n\n',
                style: TextStyle(fontSize: 18)),
            const Text('INFINITE PLAYBACK! ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const Text('Play the air horn for an infinite period of time, push the button and the sound will keep playing for as long as you want.',
                style: TextStyle(fontSize: 18)),
            const Spacer(flex: 5)
          ],
        ),
      ),
    );
  }
}
