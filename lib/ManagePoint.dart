class ManagePoint{
  // 朝顔の成長関連を処理するクラス

  static ManagePoint mp = ManagePoint();
  int point = 0;

  static ManagePoint getInstance() => mp; //singleton

  String applyPoint(){ //ポイント→ファイル名
    List<String> fileName = ["lv5no","lv4no","lv3no","lv2no","lv1no","lv0","lv-1","lv-2",];
    if(point >= 400){
      return fileName[0];
    }else if(point >= 300){
      return fileName[1];
    }else if(point >= 200){
      return fileName[2];
    }else if(point >= 100){
      return fileName[3];
    }else if(point >= 0){
      return fileName[4];
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

  void addPoint(int num) => point += num;

}