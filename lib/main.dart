import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:mezamashi/BottomNavigationBar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Alarm.init();
  runApp(const MaterialApp(home: BottomNavigationBarScreen()));
}