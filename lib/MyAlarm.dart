import 'package:alarm/alarm.dart';
import 'dart:math' as math;

class MyAlarm{
  //Alarm機能を実現するクラス。AlarmControllerによってインスタンスが生成される
  int id = 0; //alarmごとに固有のid
  int hour = 0;//鳴る時間
  int min = 0;//鳴る分
  bool isSnooze = false;//スヌーズが有効か
  String assetAudio = "";//音源へのパス
  double fadeDuration = 0;//音量をフェードする時間

  MyAlarm(this.hour,  //constructor
          this.min,
          this.isSnooze,
          this.assetAudio){
    var random = math.Random();
    id = random.nextInt(100000000);

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
    Alarm.ringStream.stream.listen(
          (alarmSettings) => goToRingScreen(alarmSettings),
    );
  }

  void stopAlarm(){ //alarmを停止＆削除する
    Alarm.stop(id);
  }

  void goToRingScreen(AlarmSettings alarmSettings){//アラームを止める画面へと移動する処理を書く
  //TODO

  }

}
