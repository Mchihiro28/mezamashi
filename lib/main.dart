import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:mezamashi/BottomNavigationBar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Alarm.init();
  MobileAds.instance.initialize();
  runApp(const MaterialApp(home: BottomNavigationBarScreen()));
}