import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mezamashi/BottomNavigationBar.dart';
import 'package:mezamashi/Intro.dart';
import 'package:mezamashi/sharedPref.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  binding.addPostFrameCallback((_) async {
    final BuildContext context = binding.rootElement as BuildContext;

    // 起動時に最初に表示される可能性のある画像群
    List images = [
      const AssetImage('assets/images/background_day.jpg'),
      const AssetImage('assets/images/background_night.jpg'),
      const AssetImage('assets/images/lv0.png')
    ];

    for (final image in images) {
      precacheImage(
        image,
        context,
      );
    }
  });

  // ライブラリ側のAlarmを初期化する
  Alarm.init();
  // admobの初期化
  MobileAds.instance.initialize();

  Widget homeWidget = const BottomNavigationBarScreen();

  // 過去に起動したことあるかを確認し、初回起動であればチュートリアル画面を表示する。
  List<String>? data = await sharedPref.load("isAccount");
  if(data == null){
    homeWidget = Intro();
  }

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeWidget,
  ));
}