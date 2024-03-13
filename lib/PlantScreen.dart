import 'package:flutter/material.dart';
import 'package:mezamashi/ManagePoint.dart';
import 'package:mezamashi/MyWeather.dart';

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
  String flowerImage = "background_day"; //花の画像を表示するパス
  String backImage = "lv0"; //背景の画像を表示するパス
  String weatherText = ""; //天気のテキスト
  String isSnackBar = "false"; //snackbarを表示するフラグ

  @override
  initState(){
    super.initState();
    _reBuild();
  }

  Future<void> _reBuild() async{
    mw  = MyWeather();
    mp = await ManagePoint.getInstance();
    if(mp.isNight()){
      backImage = "background_night";
    }else{
      backImage = "background_day";
    }
    flowerImage = mp.applyPoint();
    _getWeather();

    setState((){ });
  }

  Future<void> _getWeather() async{
    List<String> s = await mw.getWeather();
    if(s.first == 'ws is f'){
      weatherText = mp.point.toString();
    }else if((s.first == 'per err') || (s.first == 'loc err')){
      isSnackBar = s[1];
    }
    weatherText = '${s[1]}  気温:${s[2]}℃  湿度:${s[3]}%';
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
                  alignment: const Alignment(0.5, -0.9),
                  child: Container(
                    alignment: Alignment.center,
                    width: ss.width*0.4,
                    height: ss.height*0.08,
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