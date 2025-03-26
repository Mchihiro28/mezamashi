import 'package:mezamashi/DatabaseHelper.dart';

/// ポイントを管理するクラス
///
/// ポイントの大小によって朝顔の成長度合いが決まる。
class ManagePoint{

  /// ポイント
  int point = 0;

  ///ログインボーナスでもらえるポイント数
  static const int loginPoint = 1;
  ///applyPointで用いるポイント判定の倍率
  static const int magnification = 100;
  ///アラームを止めるまでの猶予秒数
  static const int postponement = 15;
  ///バツとして引くポイント＆成功したときの倍率
  static const int punishAndPrize = -10;
  ///スヌーズしたときに引くポイント
  static const int snoozePoint = -30;

  /// [ManagePoint]のインスタンスを取得する関数
  static Future<ManagePoint> getInstance()async{
    ManagePoint mp = ManagePoint();
    await mp._init();
    return mp;
  }

  /// [ManagePoint]の初期化を行う。
  ///
  /// データベースからポイントを取得し、連続増加数に応じたボーナスを与える。
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


  /// ポイント数と朝顔の輪数を対応させる。
  ///
  /// 朝顔の輪数はレベルとしてファイル名に示されており、-2～5レベルまである。
  String applyPoint(){
    List<String> fileName = ["lv-2","lv-1","lv0","lv1no","lv2no","lv3no","lv4no","lv5no",];
    for(int i=4; i>=-2; i--){
      if(point >= i*magnification){
        return fileName[i+3];
      }
    }
    return fileName[0];
  }

  /// 現在時刻が昼かを返す関数
  ///
  /// 返り値は[True]（昼）または[False]（夜）
  bool isNight(){
    DateTime now = DateTime.now();
    if((now.isBefore(DateTime(now.year, now.month, now.day, 18))) && (now.isAfter(DateTime(now.year, now.month, now.day, 6)))){
      return false;
    }
    return true;
  }

  /// ポイントを加算する。
  ///
  /// [num]ポイント加算し、データベースに登録する。
  void addPoint(int num){
    point += num;
    DatabaseHelper.setPointDB(point);
  }



}