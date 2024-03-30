import 'package:mezamashi/DatabaseHelper.dart';

class ManagePoint{
  // 朝顔の成長関連を処理するクラス
  int point = 0;

  static const int loginPoint = 1; //ログインボーナスでもらえるポイント数
  static const int magnification = 100; //applyPointで用いるポイント判定の倍率
  static const int postponement = 15; //アラームを止めるまでの猶予秒数
  static const int punishAndPrize = -10; //バツとして引くポイント＆成功したときの倍率
  static const int snoozePoint = -30; //スヌーズしたときに引くポイント

  static Future<ManagePoint> getInstance()async{ //singleton
    ManagePoint mp = ManagePoint();
    await mp._init();
    return mp;
  }

  Future<void> _init()async{
    var pointInfo = await DatabaseHelper.getPointDB();
    if(pointInfo[1] >= 3){
      if(pointInfo[0] > 100){
        point = 100;
      }else{
        point = 0;
      }
    }else{
      point = pointInfo[0];
    }
  }


  String applyPoint(){ //ポイント→ファイル名
    List<String> fileName = ["lv-2","lv-1","lv0","lv1no","lv2no","lv3no","lv4no","lv5no",];
    for(int i=4; i>=-2; i--){
      if(point >= i*magnification){
        return fileName[i+3];
      }
    }
    return fileName[0];
  }

  bool isNight(){ //現在時刻が昼かを返す関数　true:昼　false:夜
    DateTime now = DateTime.now();
    if((now.isBefore(DateTime(now.year, now.month, now.day, 18))) && (now.isAfter(DateTime(now.year, now.month, now.day, 6)))){
      return false;
    }
    return true;
  }

  void addPoint(int num){
    point += num;
    DatabaseHelper.setPointDB(point);
  }



}