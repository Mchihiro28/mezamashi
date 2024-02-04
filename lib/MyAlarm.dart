import 'package:alarm/alarm.dart';
import 'dart:math' as math;

class MyAlarm{
  //Alarm機能を実現するクラス。AlarmControllerによってインスタンスが生成される
  int id = -1; //alarmごとに固有のid
  int hour = 12;//鳴る時間
  int min = 0;//鳴る分
  String assetAudio = "assets/sounds/1_default.mp3";//音源へのパス
  String audioName ="アラーム1";
  double fadeDuration = 0;//音量をフェードする時間
  int audioNum = 0; //アラーム音の番号
  int isValid = 0; //1(false)or0(true)

  MyAlarm(int id, //constructor
          this.hour,
          this.min,
          this.audioNum,
          this.isValid){
    if(id < 1){ //idが-1なら新規に発行
      var random = math.Random();
      this.id = random.nextInt(1000000);
    }else{//そうでないならすでにあるものを適用
      id = this.id;
    }

    switch(audioNum) {
      case 1:
        assetAudio = 'assets/sounds/1_default.mp3';
        audioName = "アラーム1";
        break;
      case 2:
        assetAudio = 'assets/sounds/2_slow.mp3';
        audioName = "アラーム2";
        break;
      case 3:
        assetAudio = 'assets/sounds/3_classic.mp3';
        audioName = "アラーム3";
        break;
      default:
        audioName = "アラーム1";
        assetAudio = 'assets/sounds/1_default.mp3';
        break;
    }

  }


  DateTime formatDateTime(int h, int m){
    DateTime now = DateTime.now();
    DateTime res = DateTime(now.year, now.month, now.day, h, m);
    if(res.isBefore(now)){
      res.add(const Duration(days:1));
    }
    return res;
  }

  void createAlarm(){//アラームを作成する
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: formatDateTime(hour, min),
      assetAudioPath: assetAudio,
      loopAudio: true,
      vibrate: true,
      fadeDuration: fadeDuration,
      notificationTitle: 'アラーム',
      notificationBody: 'アラームが鳴りました！　起きてください！',
      enableNotificationOnKill: true,
    );
    Alarm.set(alarmSettings: alarmSettings);
  }

  void snooze(int snoozeValue){  //もう一度アラームを鳴らす
    int thisHour = hour;
    int thisMin = min;
    stopAlarm();
    int nextTime = hour*60 + min + snoozeValue;
    hour = nextTime~/60;
    min = nextTime % 60;
    createAlarm();
    hour = thisHour;
    min = thisMin;
  }

  void stopAlarm(){ //alarmを停止＆削除する
    Alarm.stop(id);
  }

  String exportSettings(){ //sharedprefarence用にlistでエクスポート
    List<String> res = [];
    res.add(id.toString());
    res.add(hour.toString());
    res.add(min.toString());
    res.add(audioNum.toString());
    res.add(isValid.toString());
    return res.toString();
  }
}
