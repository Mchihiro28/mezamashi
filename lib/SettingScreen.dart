import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget{
  //設定画面　メイン画面の一つ
  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> with AutomaticKeepAliveClientMixin<SettingScreen>{

  @override //stateの保持
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'setting',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: const Text(
          'IT IS TEST ABOUT SETTINGSCREEN.',
        ),
      ),
    );
  }

}