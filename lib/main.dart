import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mezamashi/Intro.dart';

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  binding.addPostFrameCallback((_) async {
    final BuildContext context = binding.rootElement as BuildContext;

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

  Alarm.init();
  MobileAds.instance.initialize();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Intro()
  ));
}