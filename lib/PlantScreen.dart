import 'package:flutter/material.dart';

class PlantScreen extends StatefulWidget{
  //朝顔の画面　メイン画面の一つ
  //TODO bottom navigation barは別画面に切り出して、リストに入れたこの画面とalarmList画面と設定画面を切り替えて使用する(PageViewも併用)
  const PlantScreen({super.key});

  @override
  PlantScreenState createState() => PlantScreenState();
}

class PlantScreenState extends State<PlantScreen> with AutomaticKeepAliveClientMixin<PlantScreen>{

  @override //stateの保持
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'plant',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(

        ),
      ),
    );
  }

}