import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:mezamashi/alarmListScreen.dart';

void main() {
  runApp(const MaterialApp(home: alarmListScreen()));
  Alarm.init();
}