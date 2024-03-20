import 'package:flutter/material.dart';
import 'package:mezamashi/ManagePoint.dart';
import 'package:mezamashi/MyWeather.dart';
import 'dart:math' as math;

import 'package:mezamashi/sharedPref.dart';

class PlantScreen extends StatefulWidget{
  //朝顔の画面　メイン画面の一つ
  const PlantScreen({super.key});

  @override
  PlantScreenState createState() => PlantScreenState();
}

class PlantScreenState extends State<PlantScreen> with AutomaticKeepAliveClientMixin<PlantScreen>{

  @override //stateの保持
  bool get wantKeepAlive => true;

  late ManagePoint mp;
  late MyWeather mw;
  String flowerImage = "lv0"; //花の画像を表示するパス
  String backImage = "background_day"; //背景の画像を表示するパス
  String weatherText = ""; //天気のテキスト
  String isSnackBar = "false"; //snackbarを表示するフラグ

  @override
  initState(){
    super.initState();
    _reBuildImage();
  }

  Future<void> _reBuildImage() async{ //画像関係のロード
    mp = await ManagePoint.getInstance();
    mp.point = 0;//FIXME
    int randomNum = math.Random().nextInt(5) + 1;
    List<String>? preName = await sharedPref.load("random");
    preName ??= [""];

    if(mp.isNight()){
      backImage = "background_night";
    }else{
      backImage = "background_day";
    }
    flowerImage = mp.applyPoint();

    //画像名の最後が0以上か（朝顔の咲いた画像か）判定
    if(flowerImage.substring(flowerImage.length-1, flowerImage.length) == 'o'){
    //以前の画像名と今の画像名が同じなら保存していたrandomNumを適用
    if(preName[0] == flowerImage){
        randomNum = int.parse(preName[1]);
      }
      sharedPref.save("random", [flowerImage, randomNum.toString()]);
      flowerImage = flowerImage + randomNum.toString();
    }

    

    setState((){ });

    _reBuildWeather();
  }

  Future<void> _reBuildWeather() async{ //天気のロード
    mw  = MyWeather();
    await mw.init();
    weatherText = await _getWeather();

    setState((){ });
  }

  Future<String> _getWeather() async{
    List<String> s = await mw.getWeather();
    if(s.first == 'ws is f'){
      return mp.point.toString() + s.last;
    }else if((s.first == 'per err') || (s.first == 'loc err')){
      isSnackBar = s[1];
    }
    return '${s[1]}  気温:${double.parse(s[2]).toStringAsFixed(1)}℃  湿度:${double.parse(s[3]).toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var ss = MediaQuery.of(context).size;
    if(isSnackBar != "false"){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isSnackBar),
        ),
      );
      isSnackBar = "false";
    }
    return Scaffold(
      body: Center(
        child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/$backImage.jpg'),
                      fit: BoxFit.cover,
                    )),
                child:SizedBox(
                  height: ss.height*0.9,
                  width: ss.width,
                  child: Image.asset('assets/images/$flowerImage.png'),),
              ),
              Align(
                  alignment: const Alignment(-0.5, -0.9),
                  child: Container(
                    alignment: Alignment.center,
                    width: ss.width* 0.4,
                    height: ss.height*0.06,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(weatherText,
                        style: const TextStyle(fontSize: 16)),
                  )
              ),
            ]
        ),
      ),
    );
  }

}