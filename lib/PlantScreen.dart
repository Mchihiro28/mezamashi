import 'package:flutter/material.dart';
import 'package:mezamashi/ManagePoint.dart';
import 'package:mezamashi/MyWeather.dart';
import 'dart:math' as math;

import 'package:mezamashi/sharedPref.dart';

/// 朝顔を表示する画面
///
/// メイン画面の一つであり、朝顔の画像と天気が表示される。
class PlantScreen extends StatefulWidget{

  const PlantScreen({super.key});

  @override
  PlantScreenState createState() => PlantScreenState();
}

class PlantScreenState extends State<PlantScreen> with AutomaticKeepAliveClientMixin<PlantScreen>{

  @override //stateの保持
  bool get wantKeepAlive => true;

  static final PlantScreenState _instance = PlantScreenState._internal();
  factory PlantScreenState() {
    return _instance;
  }
  PlantScreenState._internal();

  late ManagePoint mp;
  late MyWeather mw;

  ///花の画像を表示するパス
  String flowerImage = "lv0";
  ///背景の画像を表示するパス
  String backImage = "background_day";
  ///天気のテキスト
  String weatherText = "";
  ///snackbarを表示するフラグ兼文章
  String isSnackBar = "false";

  @override
  initState(){
    super.initState();
    _reBuildImage();
  }

  /// 画像関係のロードを行う。
  ///
  /// 朝顔の画像、空の画像についてファイル名を決定して読み込む。
  Future<void> _reBuildImage() async{
    mp = await ManagePoint.getInstance();
    // 朝顔の画像の差分
    int randomNum = math.Random().nextInt(5) + 1;
    List<String>? preName = await sharedPref.load("random");
    preName ??= [""];

    // 現在時刻に応じて空の画像を切替
    if(mp.isNight()){
      backImage = "background_night";
    }else{
      backImage = "background_day";
    }

    // ポイントに応じて朝顔の画像を決定
    flowerImage = mp.applyPoint();

    // 画像名の最後が0以上か（朝顔の咲いた画像か）判定
    if(flowerImage.substring(flowerImage.length-1, flowerImage.length) == 'o'){
    // 以前の画像名と今の画像名が同じなら保存していたrandomNumを適用
    if(preName[0] == flowerImage){
        randomNum = int.parse(preName[1]);
      }
      sharedPref.save("random", [flowerImage, randomNum.toString()]);
      flowerImage = flowerImage + randomNum.toString();
    }

    setState((){ });

    reBuildWeather();
  }

  /// 天気を表示して画面の更新を行う。
  Future<void> reBuildWeather() async{ //天気のロード
    mw  = MyWeather();
    await mw.init();
    weatherText = await _getWeather();
    print(weatherText);

    setState((){ });
  }

  /// 天気を取得する。
  ///
  /// 返り値は「<天気コード> <気温> <湿度>」または「<ポイント>」
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
    return MaterialApp(
        title: 'plant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
    home: Scaffold(
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
    )
    );
  }

}