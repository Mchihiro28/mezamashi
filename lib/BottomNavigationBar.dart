import 'package:flutter/material.dart';
import 'package:mezamashi/PlantScreen.dart';
import 'package:mezamashi/SettingScreen.dart';
import 'package:mezamashi/alarmListScreen.dart';

class BottomNavigationBarScreen extends StatefulWidget{
  //BottomNavigationBar
  const BottomNavigationBarScreen({super.key});

  @override
  BottomNavigationBarScreenState createState() => BottomNavigationBarScreenState();
}

class BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>{
  int _selectedIndex = 1; //bottom navigation barがタップされた場所を格納する変数
  final PageController _controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'alarm',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView(
          controller: _controller,
          children: const [
              PlantScreen(),
              alarmListScreen(),
              SettingScreen(),
            ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'ホーム',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm),
              label: 'アラーム',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '設定',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
            _selectedIndex = index; //変数の更新
            });
            _controller.jumpToPage(index); //PageViewのページの更新
          },
        ),
      ),
    );
  }

}