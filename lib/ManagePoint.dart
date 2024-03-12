import 'package:mezamashi/DatabaseHelper.dart';
import 'dart:math' as math;

class ManagePoint{
  // 朝顔の成長関連を処理するクラス
  int point = 0;

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
    var random = math.Random();
    int randomNum = random.nextInt(5) + 1;
    List<String> fileName = ["lv5no","lv4no","lv3no","lv2no","lv1no","lv0","lv-1","lv-2",];
    if(point >= 400){
      return fileName[0] + randomNum.toString();
    }else if(point >= 300){
      return fileName[1] + randomNum.toString();
    }else if(point >= 200){
      return fileName[2] + randomNum.toString();
    }else if(point >= 100){
      return fileName[3] + randomNum.toString();
    }else if(point >= 0){
      return fileName[4] + randomNum.toString();
    }else if(point >= -100){
      return fileName[5];
    }else if(point >= -200){
      return fileName[6];
    }else {
      return fileName[7];
    }
  }

  bool isNight(){ //現在時刻が昼かを返す関数　true:昼　false:夜
    DateTime now = DateTime.now();
    if(now.isBefore(DateTime(now.year, now.month, now.day, 18))){
      return true;
    }
    return false;
  }

  void addPoint(int num){
    point += num;
    DatabaseHelper.setPointDB(point);
  }



}