import 'package:flutter/material.dart';

class PlantScreen extends StatefulWidget{
  //朝顔の画面　メイン画面の一つ
  //TODO bottom navigation barは別画面に切り出して、リストに入れたこの画面とalarmList画面と設定画面を切り替えて使用する(PageViewも併用)
  const PlantScreen({super.key});

  @override
  PlantScreenState createState() => PlantScreenState();
}

class PlantScreenState extends State<PlantScreen>{
  int _selectedIndex = 0; //bottom navigation barがタップされた場所を格納する変数
  void _onItemTapped(int index) { //bottom navigation barがタップされた時の処理
    setState(() {
      _selectedIndex = index;
      //TODO something
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'alarm',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(

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
        onTap: _onItemTapped,
        ),
      ),
    );
  }

}