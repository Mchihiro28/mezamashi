import 'package:flutter/material.dart';
import 'package:mezamashi/ManagePoint.dart';

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

  late ManagePoint mp;
  String flowerImage = "background_day"; //花の画像を表示するパス
  String backImage = "lv0"; //背景の画像を表示するパス

  @override
  initState(){
    super.initState();
    _reBuild();
  }

  Future<void> _reBuild() async{
    mp = await ManagePoint.getInstance();
    if(mp.isNight()){
      backImage = "background_night";
    }else{
      backImage = "background_day";
    }
    flowerImage = mp.applyPoint();

    setState((){ });
  }

  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;
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
                    child: Text("☂　気温:20℃　湿度:60%",  //FIXME
                        style: TextStyle(fontSize: 16)),
                  )
              ),
            ]
        ),
      ),
    );
  }

}